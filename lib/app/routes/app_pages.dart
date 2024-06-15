import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/home/cubit/home_cubit.dart';
import '../modules/home/view/home_view.dart';

part 'app_routes.dart';

abstract class AppPages {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HomeCubit(),
            child: const HomeView(),
          ),
          settings: routeSettings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HomeCubit(),
            child: const HomeView(),
          ),
          settings: routeSettings,
        );
    }
  }
}
