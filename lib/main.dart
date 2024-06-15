import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';

import 'app/routes/app_pages.dart';
import 'app/services/services.dart';
import 'app/theme/app_theme.dart';
import 'app/utils/context_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Services().initServices();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: ContextUtils.navigationKey,
      scaffoldMessengerKey: ContextUtils.scaffoldKey,
      theme: AppTheme.appTheme,
      onGenerateRoute: AppPages.onGenerateRoute,
      navigatorObservers: [
        ChuckerFlutter.navigatorObserver,
      ],
    );
  }
}
