/// Settings + the two App Store review-required screens:
/// ManageSubscriptionScreen (cancel guidance) and PrivacyPolicyScreen
/// (in-app policy + external URL hook). Spec §8.
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../app.dart';
import '../../l10n/l10n.dart';
import '../../theme/hq_theme.dart';
import '../paywall/email_restore_dialog.dart';
import 'language_sheet.dart';

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
    final l = context.l;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text(l.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          HqCard(
            child: ListTile(
              leading: const Icon(Icons.language_rounded,
                  color: HqColors.inkSoft),
              title: Text(l.language),
              subtitle: Text(currentLanguageName(context)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  showLanguageSheet(context, includeFollowDevice: true),
            ),
          ),
          const SizedBox(height: 16),
          HqCard(
            child: Column(
              children: [
                _VolumeRow(
                  label: l.settingsMusic,
                  value: audio.bgmVolume,
                  onChanged: (v) => setState(() => audio.bgmVolume = v),
                ),
                _VolumeRow(
                  label: l.settingsSfx,
                  value: audio.sfxVolume,
                  onChanged: (v) => setState(() => audio.sfxVolume = v),
                ),
                _VolumeRow(
                  label: l.settingsVoice,
                  value: audio.voiceVolume,
                  onChanged: (v) => setState(() => audio.voiceVolume = v),
                ),
                SwitchListTile(
                  title: Text(l.settingsMuteAll),
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
                  title: Text(state.isPremium
                      ? l.settingsPremiumActive
                      : l.settingsFreePlan),
                  subtitle: Text(state.isPremium
                      ? l.settingsBilling(state.services.billing.backendId)
                      : l.settingsUnlockAll),
                ),
                ListTile(
                  leading: const Icon(Icons.manage_accounts,
                      color: HqColors.inkSoft),
                  title: Text(l.commonManageSubscription),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                      HqPageRoute(page: const ManageSubscriptionScreen())),
                ),
                ListTile(
                  leading: const Icon(Icons.restore, color: HqColors.inkSoft),
                  title: Text(l.commonRestorePurchase),
                  onTap: () async {
                    final status = await state.services.billing.restore();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(status.isActive
                            ? l.commonSubscriptionRestored
                            : l.commonNoSubscription)));
                  },
                ),
                if (emailRestoreOf(state.services.billing) case final restore?)
                  ListTile(
                    leading: const Icon(Icons.mail_outline,
                        color: HqColors.inkSoft),
                    title: Text(l.restoreEmailAction),
                    onTap: () async {
                      final restored =
                          await EmailRestoreDialog.show(context, restore);
                      if (!context.mounted || !restored) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(l.commonSubscriptionRestored)));
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          HqCard(
            child: ListTile(
              leading: const Icon(Icons.privacy_tip, color: HqColors.inkSoft),
              title: Text(l.commonPrivacyPolicy),
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
    final l = context.l;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text(l.commonManageSubscription),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.cancelTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(l.cancelBody),
            const Spacer(),
            HqButton(
              label: l.cancelOpenSettings,
              expanded: true,
              onPressed: () {
                // TODO(ios): open itms-apps://apps.apple.com/account/subscriptions
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l.cancelStoreNote('dev'))));
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(l.settingsBilling(state.services.billing.backendId),
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
    final l = context.l;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text(l.commonPrivacyPolicy),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l.commonSummary, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          // Web and iOS process speech and payments differently — each build
          // must describe its own behaviour truthfully.
          Text(kIsWeb ? l.privacyWeb : l.privacyApp),
          const SizedBox(height: 24),
          HqButton(
            label: l.commonReadFullText,
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
    final l = context.l;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text(l.commonTermsOfUse),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l.commonSummary, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l.termsBody),
          const SizedBox(height: 24),
          HqButton(
            label: l.commonReadFullText,
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
