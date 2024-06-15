import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/utils/bloc_observer.dart';
import 'app/utils/context_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
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
