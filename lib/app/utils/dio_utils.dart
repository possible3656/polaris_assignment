import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';

abstract class DioUtils {
  static Dio? _instance;

  static Dio get sharedInstance => _instance ??= newInstance();

  static Dio newInstance() {
    final Dio dio = Dio();
    dio.interceptors.add(ChuckerDioInterceptor());
    return dio;
  }

  static void close() {
    _instance?.close();
    _instance = null;
  }
}
