import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/events/analytics.dart';
import 'platform/audio/bundled_audio_manager.dart';
import 'platform/billing/billing.dart';
import 'platform/billing/web_billing_stub.dart'
    if (dart.library.html) 'platform/billing/web_billing.dart';
import 'platform/device/device.dart';
import 'platform/images/word_image_resolver.dart';
import 'platform/speech/pronunciation_scorer.dart';
import 'platform/speech/speech.dart';
import 'platform/speech/web_speech_stub.dart'
    if (dart.library.html) 'platform/speech/web_speech_recognizer.dart';
import 'state/app_state.dart';
import 'state/progress_store.dart';
import 'state/storage_web_stub.dart'
    if (dart.library.html) 'state/storage_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[boot] binding ready');

  // Storage: web → localStorage; native → app-support file; else in-memory.
  StorageDriver? storage = createWebStorage();
  if (storage == null) {
    try {
      final dir = await getApplicationSupportDirectory();
      storage = FileStorage('${dir.path}/hq_progress.json');
    } catch (_) {
      storage = InMemoryStorage();
    }
  }
  final store = ProgressStore(storage);
  await store.load();
  debugPrint('[boot] storage ready');

  // Bundled audio (dev TTS placeholders now, studio recordings at release —
  // same slot ids). Falls back to silence per-slot if an asset is missing.
  final audio = BundledAudioManager();
  await audio.init();
  debugPrint('[boot] audio manifest ready');
  await WordImageResolver.instance.init();

  // Billing: web deploys use Lemon Squeezy checkout via /api (demo-mode
  // fallback when the deployment has no keys). Non-web dev builds use mock.
  final webBilling = createWebBillingGateway(
    getCustomerId: () => store.state.stripeCustomerId,
    saveCustomerId: (id) {
      store.state.stripeCustomerId = id;
      store.save();
    },
  );

  final AppServices services;
  if (kIsWeb && webBilling != null) {
    services = AppServices(
      billing: webBilling,
      // Web Speech API where the browser has it; unavailable (Firefox)
      // still degrades stage 4 gracefully (spec §6).
      speech: createWebSpeechRecognizer() ?? UnsupportedSpeechRecognizer(),
      scorer: const JamoSimilarityScorer(),
      audio: audio,
      haptics: NoopHaptics(),
      push: NoopPush(),
      analytics: LocalAnalytics(),
      channel: BuildChannel.web,
    );
  } else {
    services = AppServices.dev(audio: audio);
  }

  final state = AppState(services: services, store: store);
  await state.init();
  debugPrint('[boot] state ready — running app');

  runApp(HangulQuestApp(state: state));
}
