import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData appTheme = ThemeData(
    textTheme: _textTheme,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    appBarTheme: _appBarTheme,
    textButtonTheme: _textButtonTheme,
  );

  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  );

  static final _appBarTheme =
      AppBarTheme(titleTextStyle: _textTheme.titleMedium);

  static const _textTheme = TextTheme(
    titleMedium: TextStyle(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: AppColors.primaryText,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(
      color: AppColors.primaryText,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      color: AppColors.primaryText,
      fontSize: 14,
    ),
    labelMedium: TextStyle(
      color: AppColors.primaryText,
      fontSize: 14,
    ),
  );
}
