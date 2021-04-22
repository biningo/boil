import 'package:boil/utils.dart';
import 'package:dio/dio.dart';

class DioClient {
  Dio dio;
  DioClient() {
    BaseOptions options = BaseOptions(
        baseUrl: "http://121.196.169.248:9090", connectTimeout: 5000);
    dio = Dio(options);
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {
        options.headers.addAll({
          "Authorization": GlobalState["token"],
          "userId": GlobalState["isLogin"] ? GlobalState["userInfo"]["id"] : 0
        });
        return handler.next(options);
      }),
    );
  }
}

Dio dio = DioClient().dio;
