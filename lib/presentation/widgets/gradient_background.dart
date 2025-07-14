import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.deepTeal,
      width: double.infinity,
      height: double.infinity,
    );
  }
} 