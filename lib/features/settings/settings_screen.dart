/// Settings + the two App Store review-required screens:
/// ManageSubscriptionScreen (cancel guidance) and PrivacyPolicyScreen
/// (in-app policy + external URL hook). Spec §8.
library;

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
        title: const Text('설정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          HqCard(
            child: Column(
              children: [
                _VolumeRow(
                  label: '배경음악',
                  value: audio.bgmVolume,
                  onChanged: (v) => setState(() => audio.bgmVolume = v),
                ),
                _VolumeRow(
                  label: '효과음',
                  value: audio.sfxVolume,
                  onChanged: (v) => setState(() => audio.sfxVolume = v),
                ),
                _VolumeRow(
                  label: '발음(음성)',
                  value: audio.voiceVolume,
                  onChanged: (v) => setState(() => audio.voiceVolume = v),
                ),
                SwitchListTile(
                  title: const Text('전체 음소거'),
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
                  title: Text(state.isPremium ? '프리미엄 이용 중' : '무료 플랜'),
                  subtitle: Text(state.isPremium
                      ? '결제 채널: ${state.services.billing.backendId}'
                      : '프리미엄으로 전체 스테이지를 열 수 있어요'),
                ),
                ListTile(
                  leading: const Icon(Icons.manage_accounts,
                      color: HqColors.inkSoft),
                  title: const Text('구독 관리 · 해지 안내'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                      HqPageRoute(page: const ManageSubscriptionScreen())),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.restore, color: HqColors.inkSoft),
                  title: const Text('구매 복원'),
                  onTap: () async {
                    final status =
                        await state.services.billing.restore();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(status.isActive
                            ? '구독이 복원되었어요'
                            : '복원할 구독이 없어요')));
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
              title: const Text('개인정보 처리방침'),
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
        title: const Text('구독 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('구독은 언제든 해지할 수 있어요',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            const Text(
              '· 구독은 기간 종료 24시간 전에 해지하지 않으면 자동으로 갱신돼요.\n\n'
              '· iPhone: 설정 → Apple ID → 구독 → HangulQuest → 구독 취소\n\n'
              '· 해지 후에도 남은 구독 기간까지는 프리미엄을 계속 이용할 수 있어요.\n\n'
              '· 무료 체험 중 해지하면 요금이 청구되지 않아요.',
            ),
            const Spacer(),
            HqButton(
              label: '기기 구독 설정 열기',
              expanded: true,
              onPressed: () {
                // TODO(ios): open itms-apps://apps.apple.com/account/subscriptions
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('스토어 빌드에서 OS 구독 설정으로 이동해요 '
                        '(현재 채널: dev)')));
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('결제 채널: ${state.services.billing.backendId}',
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
        title: const Text('개인정보 처리방침'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('요약', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            '· 학습 진도·오답 기록은 회원가입 없이 기기에만 저장돼요.\n\n'
            '· 발음 도전의 음성은 기기 안(온디바이스)에서만 분석되며, '
            '녹음이 저장되거나 서버로 전송되지 않아요.\n\n'
            '· 마이크 권한은 발음 채점에만 사용돼요. 거부해도 다른 기능은 '
            '모두 이용할 수 있어요.\n\n'
            '· 결제는 App Store 인앱 결제(웹은 Lemon Squeezy)로 처리되며, '
            '카드 정보는 앱이 접근할 수 없어요.',
          ),
          const SizedBox(height: 24),
          HqButton(
            label: '전문 보기 (웹)',
            color: HqColors.dancheongBlue,
            onPressed: () {
              // TODO(release): url_launcher로 policyUrl 열기.
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(policyUrl)));
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
        title: const Text('이용약관'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('요약', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            '· 한글퀘스트 이용에는 Apple 표준 최종 사용자 사용권 계약(EULA)이 '
            '적용돼요.\n\n'
            '· 프리미엄 구독은 기간이 끝나기 24시간 전까지 해지하지 않으면 '
            '같은 가격으로 자동 갱신돼요.\n\n'
            '· 무료 체험 중 해지하면 요금이 청구되지 않아요.',
          ),
          const SizedBox(height: 24),
          HqButton(
            label: '전문 보기 (웹)',
            color: HqColors.dancheongBlue,
            onPressed: () {
              // TODO(release): url_launcher로 termsUrl 열기.
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(termsUrl)));
            },
          ),
        ],
      ),
    );
  }
}
