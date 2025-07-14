import 'package:flutter/material.dart';

class AppColors {
  static const deepBlue = Color(0xFF0A4C6A);
  static const steelBlue = Color(0xFF2384A9);
  static const skyBlue = Color(0xFF46A5C4);
  static const aqua = Color(0xFF6EC7D9);
  static const offWhite = Color(0xFFF1F0DE);
  static const peach = Color(0xFFFADBCA);
  static const sand = Color(0xFFE9C8B6);
  
  // Additional colors needed by the app
  static const deepTeal = Color(0xFF0A4C6A);
  static const seafoam = Color(0xFF6EC7D9);
  static const bgGradientStart = Color(0xFF0A4C6A);
  
  // Additional color variations
  static const white80 = Color(0xCCFFFFFF);
  static const deepTeal60 = Color(0x990A4C6A);
  static const deepTeal80 = Color(0xCC0A4C6A);

  // Modern palette
  static const bgLight = Color(0xFFEFF7F8);
  static const bgMid = Color(0xFFBBCED0);
  static const bgMid2 = Color(0xFF819B9E);
  static const accent1 = Color(0xFF739498);
  static const accent2 = Color(0xFF5E8085);
}

class AppTheme {
  static Color get background => AppColors.bgLight;
  static Color get dropdown => AppColors.bgMid;
  static Color get card => AppColors.bgMid2;
  static Color get accent => AppColors.accent1;
  static Color get accentDark => AppColors.accent2;
  static Color get textOnLight => Colors.black87;
  static Color get textOnDark => Colors.white;
} 