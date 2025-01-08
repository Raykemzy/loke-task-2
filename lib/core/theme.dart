import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/gen/fonts.gen.dart';

class AppTheme {
  // 🎨 Color Definitions
  static const Color _primaryColor = Color(0xFF8B88EF);
  static const Color _secondaryColor = Color(0xFFCBC9FF);
  static const Color _badgeColor = Color(0xFFBFBDFF);
  static const Color _borderColor = Color(0xFFF5F5F5);
  static const Color _errorColor = Color(0xFFBE2020);
  static const Color _errorColor2 = Color(0xFFFF2929);
  static const Color _waveformColor = Color(0xFF36393E);
  static const Color activeIndicatorColor = Color(0xFFD2D2D2);
  static const Color inActiveIndicatorColor = Color(0xFF878787);
  static const Color _defaultRegularTextColor = Color(0xFFC4C4C4);

  // 🅰️ Font Sizes
  static final double _titleLargeFontSize = 34.sp;
  static final double _titleMediumFontSize = 20.sp;
  static final double _titleSmallFontSize = 11.sp;
  static final double _bodyLargeFontSize = 14.sp;
  static final double _bodyMediumFontSize = 12.sp;

  // 🅱️ Default Font Family
  static const String _defaultFontFamily = FontFamily.proximaNova;

  // 🌟 Theme Configuration
  static final ThemeData themeData = ThemeData(
    primaryColor: _primaryColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _primaryColor,
      onPrimary: _waveformColor,
      secondary: _secondaryColor,
      onSecondary: _badgeColor,
      error: _errorColor,
      onError: _errorColor2,
      surface: _borderColor,
      onSurface: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: _defaultFontFamily,
        fontSize: _titleLargeFontSize,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontFamily: _defaultFontFamily,
        fontSize: _titleMediumFontSize,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        fontFamily: _defaultFontFamily,
        fontSize: _titleSmallFontSize,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: _defaultFontFamily,
        fontSize: _bodyMediumFontSize,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontFamily: _defaultFontFamily,
        fontSize: _bodyLargeFontSize,
        fontWeight: FontWeight.w400,
        color: _defaultRegularTextColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: _defaultFontFamily,
        fontSize: _bodyMediumFontSize,
        fontWeight: FontWeight.w500,
        color: _defaultRegularTextColor,
      ),
    ),
  );
}
