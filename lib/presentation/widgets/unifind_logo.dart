import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class UniFindLogo extends StatelessWidget {
  final double size;
  const UniFindLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Location pin base
          Positioned(
            bottom: 0,
            child: Icon(
              Icons.location_on,
              size: size * 0.9,
              color: AppColors.steelBlue.withOpacity(0.18),
            ),
          ),
          // Graduation cap
          Positioned(
            top: size * 0.18,
            child: Icon(
              Icons.school,
              size: size * 0.45,
              color: AppColors.deepBlue,
            ),
          ),
          // UF initials
          Positioned(
            bottom: size * 0.18,
            child: Text(
              'UF',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size * 0.32,
                color: AppColors.skyBlue,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 