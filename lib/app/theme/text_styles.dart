import 'package:flutter/material.dart';
import '../utils/context_utils.dart';
import '../utils/extensions/theme_extensions.dart';

abstract class TextStyles {
  static final theme = ContextUtils.theme;

  static TextStyle buttonTextStyle = TextStyle(
    color: theme.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
