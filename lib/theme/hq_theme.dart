/// Hangul Bricks visual identity (docs/DESIGN_SPEC.md).
///
/// "Moon-jar minimal + dancheong accents": hanji warm-neutral ground,
/// restrained five-color accents, tactile ceramic jamo tiles. No stock
/// Material components in the visible UI — HqButton/HqCard/HqDialog only.
library;

import 'package:flutter/material.dart';

class HqColors {
  static const hanji = Color(0xFFF7F1E5);
  static const hanjiDark = Color(0xFF1C1A17);
  static const ink = Color(0xFF2B2622);
  static const inkSoft = Color(0xFF6B615A);
  static const dancheongRed = Color(0xFFC4463A);
  static const dancheongBlue = Color(0xFF2E5E8C);
  static const dancheongGreen = Color(0xFF4A7A5A);
  static const obangYellow = Color(0xFFE0A526);
  static const celadon = Color(0xFFA8C5B8);

  // Stage-2 block role colors (pastel derivatives).
  static const choseongBlock = Color(0xFFE8A49C);
  static const jungseongBlock = Color(0xFF9CB8D4);
  static const jongseongBlock = Color(0xFFA9C8B4);

  static Color blockColorFor(dynamic roleIndex) => switch (roleIndex) {
        0 => choseongBlock,
        1 => jungseongBlock,
        _ => jongseongBlock,
      };
}

class HqTheme {
  static ThemeData light() => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: HqColors.hanji,
        colorScheme: ColorScheme.fromSeed(
          seedColor: HqColors.dancheongRed,
          surface: HqColors.hanji,
        ),
        fontFamily: 'Pretendard', // custom typeface slot; falls back cleanly
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 64, fontWeight: FontWeight.w800, color: HqColors.ink),
          headlineMedium: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w700, color: HqColors.ink),
          titleMedium: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: HqColors.ink),
          bodyMedium: TextStyle(fontSize: 15, color: HqColors.ink),
          bodySmall: TextStyle(fontSize: 13, color: HqColors.inkSoft),
        ),
      );
}

/// Woodblock-print card: hard 2px offset shadow instead of soft elevation.
class HqCard extends StatelessWidget {
  const HqCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HqColors.ink.withValues(alpha: 0.08)),
        boxShadow: const [
          BoxShadow(color: Color(0x1A2B2622), offset: Offset(2, 3)),
        ],
      ),
      child: child,
    );
    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}

/// Glazed tile holding a rounded line icon — replaces emoji-as-icon so
/// glyphs render identically on every platform and stay on-palette.
class HqIconTile extends StatelessWidget {
  const HqIconTile({
    super.key,
    required this.icon,
    this.color = HqColors.ink,
    this.size = 48,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color == HqColors.ink
            ? HqColors.celadon.withValues(alpha: 0.35)
            : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, size: size * 0.55, color: color),
    );
  }
}

class HqButton extends StatefulWidget {
  const HqButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = HqColors.dancheongRed,
    this.textColor = Colors.white,
    this.expanded = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final bool expanded;
  final IconData? icon;

  @override
  State<HqButton> createState() => _HqButtonState();
}

class _HqButtonState extends State<HqButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final body = AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      transform: Matrix4.translationValues(0, _down ? 2 : 0, 0),
      decoration: BoxDecoration(
        color: disabled
            ? HqColors.celadon
            : widget.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _down || disabled
            ? const []
            : const [BoxShadow(color: Color(0x332B2622), offset: Offset(2, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 20, color: widget.textColor),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _down = true),
      onTapUp: disabled
          ? null
          : (_) {
              setState(() => _down = false);
              widget.onPressed?.call();
            },
      onTapCancel: () => setState(() => _down = false),
      child: widget.expanded ? SizedBox(width: double.infinity, child: body) : body,
    );
  }
}

/// Paper-texture page transition (250ms slide + fade).
class HqPageRoute<T> extends PageRouteBuilder<T> {
  HqPageRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                      begin: const Offset(0.06, 0), end: Offset.zero)
                  .animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          ),
        );
}
