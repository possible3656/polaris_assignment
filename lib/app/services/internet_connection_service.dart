import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionService {
  void init() {
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          // The internet is now connected
          checkForPreviousDataAndUploadIt();
          break;
        case InternetStatus.disconnected:
          // The internet is now disconnected
          break;
      }
    });
  }

  static Future<bool> isConnected() async {
    return await InternetConnection().hasInternetAccess;
  }

  void checkForPreviousDataAndUploadIt() {}
}
