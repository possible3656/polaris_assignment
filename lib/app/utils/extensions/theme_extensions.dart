import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

extension CustomThemeData on ThemeData {
  Color get primaryTextColor => AppColors.primaryText;
  Color get secondaryTextColor => AppColors.secondaryText;
  Color get borderColor => AppColors.borderColor;
  Color get white => AppColors.white;
  Color get primaryBackground => AppColors.primaryBackground;
  Color get secondaryBackground => AppColors.secondaryBackground;
  

  TextStyle get buttonTextStyle => TextStyles.buttonTextStyle;
}
