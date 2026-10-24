/// Settings + the two App Store review-required screens:
/// ManageSubscriptionScreen (cancel guidance) and PrivacyPolicyScreen
/// (in-app policy + external URL hook). Spec §8.
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../app.dart';
import '../../theme/hq_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final audio = state.services.audio;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          HqCard(
            child: Column(
              children: [
                _VolumeRow(
                  label: 'Music',
                  value: audio.bgmVolume,
                  onChanged: (v) => setState(() => audio.bgmVolume = v),
                ),
                _VolumeRow(
                  label: 'Sound effects',
                  value: audio.sfxVolume,
                  onChanged: (v) => setState(() => audio.sfxVolume = v),
                ),
                _VolumeRow(
                  label: 'Voice',
                  value: audio.voiceVolume,
                  onChanged: (v) => setState(() => audio.voiceVolume = v),
                ),
                SwitchListTile(
                  title: const Text('Mute all'),
                  value: audio.muted,
                  activeColor: HqColors.dancheongRed,
                  onChanged: (v) => setState(() => audio.muted = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          HqCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.workspace_premium,
                      color: HqColors.obangYellow),
                  title: Text(state.isPremium ? 'Premium active' : 'Free plan'),
                  subtitle: Text(state.isPremium
                      ? 'Billing: ${state.services.billing.backendId}'
                      : 'Unlock every stage with Premium'),
                ),
                ListTile(
                  leading: const Icon(Icons.manage_accounts,
                      color: HqColors.inkSoft),
                  title: const Text('Manage subscription'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                      HqPageRoute(page: const ManageSubscriptionScreen())),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.restore, color: HqColors.inkSoft),
                  title: const Text('Restore purchase'),
                  onTap: () async {
                    final status = await state.services.billing.restore();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(status.isActive
                            ? 'Subscription restored'
                            : 'No subscription to restore')));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          HqCard(
            child: ListTile(
              leading:
                  const Icon(Icons.privacy_tip, color: HqColors.inkSoft),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context)
                  .push(HqPageRoute(page: const PrivacyPolicyScreen())),
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeRow extends StatelessWidget {
  const _VolumeRow(
      {required this.label, required this.value, required this.onChanged});

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            activeColor: HqColors.dancheongBlue,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// App Store guideline 3.1.2: explain auto-renewal + how to cancel.
/// Store builds deep-link to the OS subscription page; NO external payment
/// links appear anywhere in store builds (guideline 3.1.1 / spec §5.2).
class ManageSubscriptionScreen extends StatelessWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: const Text('Manage subscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You can cancel anytime',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            const Text(
              '· Subscriptions renew automatically unless cancelled at least 24 hours before the period ends.\n\n'
              '· iPhone: Settings → Apple ID → Subscriptions → Hangul Bricks → Cancel\n· Web: use the link in your Lemon Squeezy receipt email\n\n'
              '· After cancelling, Premium stays active until the paid period ends.\n\n'
              '· Cancel during the free trial and you will not be charged.',
            ),
            const Spacer(),
            HqButton(
              label: 'Open subscription settings',
              expanded: true,
              onPressed: () {
                // TODO(ios): open itms-apps://apps.apple.com/account/subscriptions
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Store builds open the OS subscription settings '
                        '(current channel: dev)')));
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('Billing: ${state.services.billing.backendId}',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}

/// In-app privacy policy + the external URL connection point (spec §8).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  /// Hosted policy URL — surfaced in App Store Connect metadata too.
  static const policyUrl = 'https://hangulquest-phi.vercel.app/privacy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          // Web and iOS process speech and payments differently — each build
          // must describe its own behaviour truthfully.
          const Text(kIsWeb
              ? '· Your progress and mistakes are saved only in this browser. No account needed.

'
                  '· For pronunciation scoring, your voice is sent to the browser's speech '
                  'service (Google in Chrome, Apple in Safari) to be turned into text. It never '
                  'reaches Hangul Bricks servers and recordings are not stored.

'
                  '· The microphone is used only for pronunciation scoring. If you deny it, '
                  'everything else still works.

'
                  '· Payments are handled by our reseller Lemon Squeezy, and the app never '
                  'sees your card details.'
              : '· Your progress and mistakes are saved only on this device. No account needed.

'
                  '· Pronunciation audio is analyzed on-device only, and '
                  'recordings are never stored or uploaded.

'
                  '· The microphone is used only for pronunciation scoring. If you deny it, '
                  'everything else still works.

'
                  '· Payments go through App Store in-app purchase, and '
                  'the app never sees your card details.'),
          const SizedBox(height: 24),
          HqButton(
            label: 'Read the full text',
            color: HqColors.dancheongBlue,
            onPressed: () {
              // TODO(release): url_launcher로 policyUrl 열기.
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text(policyUrl)));
            },
          ),
        ],
      ),
    );
  }
}

/// Terms of Use (EULA) — required next to subscription offers (guideline
/// 3.1.2). Uses Apple's standard EULA until a custom one exists; keep this
/// URL in sync with App Store Connect metadata.
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  static const termsUrl =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: const Text('Terms of Use'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            '· Use of Hangul Bricks is covered by the Apple standard EULA '
            'and our web Terms of Service.\n\n'
            '· Premium renews automatically at the same price unless cancelled '
            'at least 24 hours before the period ends.\n\n'
            '· Cancel during the free trial and you will not be charged.',
          ),
          const SizedBox(height: 24),
          HqButton(
            label: 'Read the full text',
            color: HqColors.dancheongBlue,
            onPressed: () {
              // TODO(release): url_launcher로 termsUrl 열기.
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text(termsUrl)));
            },
          ),
        ],
      ),
    );
  }
}
