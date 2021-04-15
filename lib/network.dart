import 'package:dio/dio.dart';

class DioClient {
  Dio dio;
  DioClient() {
    BaseOptions options =
        BaseOptions(baseUrl: "http://192.168.0.23:8080", connectTimeout: 2000);
    dio = Dio(options);
  }
}

Dio dio = DioClient().dio;
