import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blur/blur.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';
import 'dart:async';
import 'package:unikwik_app/presentation/widgets/gradient_background.dart';
import 'package:unikwik_app/presentation/widgets/glass_container.dart';
import 'package:unikwik_app/presentation/widgets/social_btn.dart';
import 'package:unikwik_app/presentation/screens/auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GradientBackground(),
          const _SplashSpheres(),
          // Centered glassy card with 'uk'
          Center(
            child: SizedBox(
              width: 260,
              height: 320,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glassmorphism background
                  ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Blur(
                      blur: 18,
                      borderRadius: BorderRadius.circular(36),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.aqua.withOpacity(0.7),
                              AppColors.offWhite.withOpacity(0.7),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.7),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 32,
                              offset: const Offset(0, 16),
                            ),
                          ],
                          backgroundBlendMode: BlendMode.overlay,
                        ),
                        child: Stack(
                          children: [
                            // Glow in the center of the card
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.center,
                                    radius: 0.7,
                                    colors: [
                                      AppColors.peach.withOpacity(0.32),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Sharp, visible text
                  Text(
                    'uk',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w900,
                      fontSize: 72,
                      color: AppColors.steelBlue,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 16,
                          color: AppColors.deepBlue.withOpacity(0.18),
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashSpheres extends StatelessWidget {
  const _SplashSpheres();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top right peach sphere (bigger, more 3D)
        Positioned(
          top: 90,
          right: 60,
          child: _Sphere(
            diameter: 72,
            color: AppColors.peach,
            shadow: AppColors.peach.withOpacity(0.35),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFE0B2), Color(0xFFFABD8C)],
            ),
          ),
        ),
        // Top left small sand sphere
        Positioned(
          top: 180,
          left: 48,
          child: _Sphere(
            diameter: 36,
            color: AppColors.sand,
            shadow: AppColors.sand.withOpacity(0.35),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFDE8D0), Color(0xFFE9C8B6)],
            ),
          ),
        ),
        // Bottom left teal sphere
        Positioned(
          bottom: 120,
          left: 48,
          child: _Sphere(
            diameter: 64,
            color: AppColors.steelBlue,
            shadow: AppColors.steelBlue.withOpacity(0.35),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.skyBlue.withOpacity(0.8), AppColors.steelBlue],
            ),
          ),
        ),
        // Bottom right teal sphere
        Positioned(
          bottom: 100,
          right: 48,
          child: _Sphere(
            diameter: 56,
            color: AppColors.skyBlue,
            shadow: AppColors.skyBlue.withOpacity(0.35),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.aqua.withOpacity(0.8), AppColors.skyBlue],
            ),
          ),
        ),
      ],
    );
  }
}

class _Sphere extends StatelessWidget {
  final double diameter;
  final Color color;
  final Color shadow;
  final Gradient? gradient;
  const _Sphere({required this.diameter, required this.color, required this.shadow, this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
    );
  }
} 