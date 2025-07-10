import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';

class SocialBtn extends StatelessWidget {
  final String label;
  final String asset;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialBtn({
    super.key,
    required this.label,
    required this.asset,
    this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  factory SocialBtn.google({VoidCallback? onTap}) => SocialBtn(
        label: 'Sign in with Google',
        asset: 'assets/svg/google_logo.svg',
        onTap: onTap,
        backgroundColor: AppColors.offWhite,
        textColor: AppColors.deepTeal,
      );

  factory SocialBtn.apple({VoidCallback? onTap}) => SocialBtn(
        label: 'Sign in with Apple',
        asset: 'assets/svg/apple_logo.svg',
        onTap: onTap,
        backgroundColor: AppColors.offWhite,
        textColor: AppColors.deepTeal,
      );

  factory SocialBtn.microsoft({VoidCallback? onTap}) => SocialBtn(
        label: 'Sign in with Microsoft',
        asset: 'assets/svg/ms_logo.svg',
        onTap: onTap,
        backgroundColor: AppColors.offWhite,
        textColor: AppColors.deepTeal,
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.offWhite,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepTeal80.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(asset, height: 28, width: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.deepTeal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 