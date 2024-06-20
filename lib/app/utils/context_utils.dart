import 'package:flutter/material.dart';

/// A utility class for managing context-related operations in a Flutter application.
abstract class ContextUtils {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Retrieves the [MediaQueryData] of the current screen.
  static MediaQueryData get mData =>
      MediaQuery.of(navigationKey.currentState!.context);

  /// Shows a toast message at the bottom of the screen.
  ///
  /// The [text] parameter specifies the text to be displayed in the toast message.
  static showToast(String? text) {
    if (text == null) return;
    scaffoldKey.currentState?.hideCurrentSnackBar();
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }

  /// Retrieves the size of the current screen.
  static Size get size => mData.size;

  /// Retrieves the theme data of the current screen.
  static ThemeData get theme => Theme.of(navigationKey.currentState!.context);
}
