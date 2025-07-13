import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:unikwik_app/presentation/widgets/glass_container.dart';

class UniversityFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const UniversityFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.8) : Colors.white.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.white.withOpacity(0.7),
                size: 18,
              ).animate(target: isSelected ? 1 : 0)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
                .then()
                .shake(duration: 200.ms),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.check_circle_rounded,
                  color: color,
                  size: 16,
                ).animate()
                  .scale(begin: const Offset(0, 0), end: const Offset(1, 1))
                  .then()
                  .shake(duration: 300.ms),
              ],
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 400.ms)
      .slideX(begin: 0.3);
  }
}
