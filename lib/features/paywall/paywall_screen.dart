/// Paywall (spec §5.3): value summary → plan picker (yearly preselected,
/// savings badge) → 7-day trial CTA → cancel guidance + legal links +
/// restore. No dark patterns: close button always visible.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../platform/billing/billing.dart';
import '../../theme/hq_theme.dart';
import '../settings/settings_screen.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key, required this.trigger});

  final String trigger;

  static void show(BuildContext context, {required String trigger}) {
    AppScope.of(context).logPaywallShown(trigger);
    Navigator.of(context)
        .push(HqPageRoute(page: PaywallScreen(trigger: trigger)));
  }

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  List<Product>? _products;
  Product? _selected;
  bool _busy = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_products != null) return;
    AppScope.of(context).services.billing.fetchProducts().then((products) {
      if (!mounted) return;
      setState(() {
        _products = products;
        // Yearly preselected (conversion optimization, spec §5.3).
        _selected = products.firstWhere(
            (p) => p.plan == SubscriptionPlan.yearly,
            orElse: () => products.first);
      });
    }).catchError((Object e) {
      if (mounted) setState(() => _error = '상품 정보를 불러오지 못했어요');
    });
  }

  Future<void> _buy() async {
    if (_selected == null || _busy) return;
    setState(() => _busy = true);
    try {
      final result = await AppScope.of(context).purchase(_selected!);
      if (!mounted) return;
      if (result.success) {
        Navigator.of(context).pop();
      } else {
        setState(() => _error = result.error ?? '결제가 완료되지 않았어요');
      }
    } catch (e) {
      if (mounted) setState(() => _error = '결제 오류: 잠시 후 다시 시도해 주세요');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final state = AppScope.of(context);
    final status = await state.services.billing.restore();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status.isActive ? '구독이 복원되었어요' : '복원할 구독이 없어요')));
    if (status.isActive) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: HqColors.inkSoft),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Text('한글, 끝까지 읽어내세요',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 30)),
              const SizedBox(height: 16),
              // Value summary: what competitors don't have (spec §5.3).
              const _ValueRow(emoji: '🎤', text: '내 발음을 채점해주는 유일한 한글 앱'),
              const _ValueRow(emoji: '🧠', text: '틀린 소리만 골라주는 개인화 복습'),
              const _ValueRow(emoji: '🧩', text: '글자 조립부터 단어 읽기까지 전체 스테이지'),
              const SizedBox(height: 20),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_error!,
                      style: const TextStyle(color: HqColors.dancheongRed)),
                ),
              if (_products == null)
                const Center(child: CircularProgressIndicator())
              else
                for (final p in _products!)
                  _PlanTile(
                    product: p,
                    selected: _selected?.id == p.id,
                    onTap: () => setState(() => _selected = p),
                  ),
              const Spacer(),
              HqButton(
                label: _busy
                    ? '처리 중…'
                    : '7일 무료로 시작하기',
                expanded: true,
                onPressed: _busy || _products == null ? null : _buy,
              ),
              const SizedBox(height: 10),
              Text(
                _selected == null
                    ? ''
                    : '무료 체험 후 ${_selected!.priceLabel} 자동 갱신 · 언제든 해지 가능',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (AppScope.of(context).services.billing.backendId == 'demo')
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '데모 결제 — 실제로 청구되지 않습니다',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: HqColors.dancheongRed),
                  ),
                ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _restore,
                    child: const Text('구매 복원',
                        style:
                            TextStyle(fontSize: 12, color: HqColors.inkSoft)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                        HqPageRoute(page: const ManageSubscriptionScreen())),
                    child: const Text('해지 안내',
                        style:
                            TextStyle(fontSize: 12, color: HqColors.inkSoft)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .push(HqPageRoute(page: const PrivacyPolicyScreen())),
                    child: const Text('개인정보 처리방침',
                        style:
                            TextStyle(fontSize: 12, color: HqColors.inkSoft)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.emoji, required this.text});

  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile(
      {required this.product, required this.selected, required this.onTap});

  final Product product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white70,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? HqColors.dancheongRed : HqColors.celadon,
            width: selected ? 2.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? HqColors.dancheongRed : HqColors.inkSoft,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                product.plan == SubscriptionPlan.yearly ? '연간 플랜' : '월간 플랜',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            if (product.savingsLabel != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: HqColors.obangYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(product.savingsLabel!,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ),
            Text(product.priceLabel,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
