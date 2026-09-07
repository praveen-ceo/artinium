import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum ArtiniumLogoSize { small, medium, large }

/// The ONE Artinium logo component. Every branded screen (splash, login,
/// header, AI, profile) must use this widget rather than inventing a new
/// mark. Swap the [_MarkPainter] for a real SVG asset
/// (flutter_svg + assets/icons/artinium_mark.svg) without touching call
/// sites — the API stays the same.
class ArtiniumLogo extends StatelessWidget {
  final ArtiniumLogoSize size;
  final bool showWordmark;
  final bool onDark;

  const ArtiniumLogo({
    super.key,
    this.size = ArtiniumLogoSize.medium,
    this.showWordmark = true,
    this.onDark = true,
  });

  double get _markSize {
    switch (size) {
      case ArtiniumLogoSize.small:
        return 28;
      case ArtiniumLogoSize.medium:
        return 56;
      case ArtiniumLogoSize.large:
        return 96;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = onDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final mark = SizedBox(
      width: _markSize,
      height: _markSize,
      child: CustomPaint(painter: _MarkPainter()),
    );

    if (!showWordmark) return mark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.goldLight, AppColors.gold],
          ).createShader(bounds),
          child: Text(
            'ARTINIUM',
            style: AppTextStyles.wordmark(Colors.white)
                .copyWith(fontSize: size == ArtiniumLogoSize.large ? 30 : 20),
          ),
        ),
        if (size != ArtiniumLogoSize.small) ...[
          const SizedBox(height: 6),
          Text(
            'SMART HOME. FUTURISTIC LIVING.',
            style: AppTextStyles.tagline(textColor.withOpacity(0.7)),
          ),
        ],
      ],
    );
  }
}

/// Draws the geometric "A" mark used everywhere in the app.
class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.goldLight, AppColors.gold],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    final outer = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h)
      ..lineTo(w * 0.78, h)
      ..lineTo(w * 0.5, h * 0.42)
      ..lineTo(w * 0.22, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(outer, paint);

    // Crossbar cutout for the classic "A" negative space.
    final barPaint = Paint()..blendMode = BlendMode.clear;
    canvas.saveLayer(Rect.fromLTWH(0, 0, w, h), Paint());
    canvas.drawPath(outer, paint);
    final bar = Path()
      ..moveTo(w * 0.36, h * 0.66)
      ..lineTo(w * 0.64, h * 0.66)
      ..lineTo(w * 0.58, h * 0.8)
      ..lineTo(w * 0.42, h * 0.8)
      ..close();
    canvas.drawPath(bar, barPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
