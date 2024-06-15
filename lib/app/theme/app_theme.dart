import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData appTheme = ThemeData(
    textTheme: _textTheme,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        fixedSize: const Size(double.maxFinite, 48),
        backgroundColor: AppColors.primaryTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
  static const _textTheme = TextTheme(
    titleSmall: TextStyle(
      color: AppColors.primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(
      color: AppColors.primaryTextColor,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      color: AppColors.primaryTextColor,
      fontSize: 14,
    ),
    labelMedium: TextStyle(
      color: AppColors.secondaryTextColor,
      fontSize: 14,
    ),
  );
}
