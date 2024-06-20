import 'dart:async';
import 'dart:developer';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../utils/context_utils.dart';
import 'get_storage_service.dart';

/// A service class for managing internet connection and uploading previous data.
class InternetConnectionService {

  /// Initializes the internet connection service.
  /// It starts a periodic timer to check for previous data and upload it.
  /// It also listens for changes in internet connection status and uploads previous data when connected.
  void init() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      checkForPreviousDataAndUploadIt(timer);
    });

    InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        log(
          'Internet connected\nuploading previous data',
          name: 'InternetConnectionService',
        );

        GetStorageService.checkAndUploadPreviousData();
      }
    });
  }

  /// Checks if the device is connected to the internet.
  /// Returns `true` if connected, `false` otherwise.
  static Future<bool> isConnected() async {
    return await InternetConnection().hasInternetAccess;
  }

  /// Checks for previous data and uploads it if the device is connected to the internet.
  Future<void> checkForPreviousDataAndUploadIt(Timer timer) async {
    if (await isConnected()) {
      GetStorageService.checkAndUploadPreviousData();
    }
  }
}
