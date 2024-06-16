import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/bloc_observer.dart';
import 'get_storage_service.dart';
import 'internet_connection_service.dart';

class Services {
  Future<void> initServices() async {
    await GetStorageService().init();
    InternetConnectionService().init();

    Bloc.observer = AppBlocObserver();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }
}
