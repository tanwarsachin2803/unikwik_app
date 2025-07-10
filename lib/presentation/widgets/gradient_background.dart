import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _WavePainter(),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    Paint makePaint(List<Color> colors) => Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    // Background fill (deepTeal → aqua)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      makePaint([AppColors.deepTeal, AppColors.aqua]),
    );

    // Upper surf curve (aqua → offWhite)
    final upperPath = Path()
      ..moveTo(0, height * 0.15)
      ..quadraticBezierTo(width * 0.25, height * 0.05, width * 0.55, height * 0.18)
      ..quadraticBezierTo(width * 0.85, height * 0.30, width, height * 0.20)
      ..lineTo(width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(
        upperPath,
        makePaint([
          AppColors.seafoam.withOpacity(.4),
          AppColors.offWhite.withOpacity(.6)
        ]));

    // Lower sand curve (peach → sand)
    final lowerPath = Path()
      ..moveTo(0, height)
      ..lineTo(0, height * 0.75)
      ..quadraticBezierTo(width * 0.30, height * 0.85, width * 0.65, height * 0.80)
      ..quadraticBezierTo(width * 0.90, height * 0.77, width, height * 0.85)
      ..lineTo(width, height)
      ..close();
    canvas.drawPath(lowerPath, makePaint([AppColors.peach, AppColors.sand]));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 