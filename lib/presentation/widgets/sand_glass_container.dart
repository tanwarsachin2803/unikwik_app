import 'package:flutter/material.dart';
import 'package:unikwik_app/core/theme/app_colors.dart';

class SandGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double? width;
  final double? height;

  const SandGlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.sand, AppColors.peach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius * 1.2),
          topRight: Radius.circular(borderRadius * 0.8),
          bottomLeft: Radius.circular(borderRadius * 0.8),
          bottomRight: Radius.circular(borderRadius * 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.sand.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
} 