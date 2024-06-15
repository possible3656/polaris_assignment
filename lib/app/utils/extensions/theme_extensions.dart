import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

extension CustomThemeData on ThemeData {
  Color get primaryTextColor => AppColors.primaryTextColor;
  Color get secondaryTextColor => AppColors.secondaryTextColor;
  Color get borderColor => AppColors.borderColor;
  Color get white => AppColors.white;

  TextStyle get buttonTextStyle => TextStyles.buttonTextStyle;
}
