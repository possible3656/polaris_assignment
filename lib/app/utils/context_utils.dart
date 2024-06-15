import 'package:flutter/material.dart';
import 'extensions/theme_extensions.dart';

abstract class ContextUtils {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  static showLoadingOverlay() {
    navigationKey.currentState?.overlay?.insert(_loadingOverlay);
  }

  static hideLoadingOverlay() {
    _loadingOverlay.remove();
  }

  static final OverlayEntry _loadingOverlay = OverlayEntry(
    builder: (context) => Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withAlpha(175),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 100,
        width: 100,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    ),
  );

  static Future<Object?> showCustomDialog<Object>({
    required Widget child,
    bool dismissible = true,
  }) async {
    if (navigationKey.currentState?.context == null) {
      return null;
    }
    return showGeneralDialog<Object?>(
      barrierLabel: 'Loading',
      barrierDismissible: dismissible,
      context: navigationKey.currentState!.context,
      pageBuilder: (context, animation, secondaryAnimation) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface.withAlpha(175),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  static Future<Object?> showCustomModalBottomSheet({
    required Widget child,
    bool dismissible = true,
  }) async {
    if (navigationKey.currentState?.context == null) {
      return null;
    }

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const BeveledRectangleBorder(),
      context: navigationKey.currentState!.context,
      isDismissible: dismissible,
      barrierLabel: 'showCustomModalBottomSheet',
      builder: (context) => child,
    );
  }

  static MediaQueryData get mData =>
      MediaQuery.of(navigationKey.currentState!.context);

  static showToast(String? text) {
    if (text == null) return;
    scaffoldKey.currentState?.hideCurrentSnackBar();
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(color: theme.primaryTextColor, fontSize: 20),
        ),
      ),
    );
  }

  static Size get size => mData.size;

  static ThemeData get theme => Theme.of(navigationKey.currentState!.context);
}
