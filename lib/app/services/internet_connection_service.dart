import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'get_storage_service.dart';

class InternetConnectionService {
  void init() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      checkForPreviousDataAndUploadIt(timer);
    });
  }

  static Future<bool> isConnected() async {
    return await InternetConnection().hasInternetAccess;
  }

  Future<void> checkForPreviousDataAndUploadIt(Timer timer) async {
    if (await isConnected()) {
      GetStorageService.checkAndUploadPreviousData();
    }
  }
}
