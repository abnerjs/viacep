import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Back4App {
  final _dio = Dio();

  Dio get dio => _dio;

  Back4App() {
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes/";

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["X-Parse-Application-Id"] =
              dotenv.get("X-Parse-Application-Id");
          options.headers["X-Parse-REST-API-Key"] =
              dotenv.get("X-Parse-REST-API-Key");
          options.headers["Content-Type"] = "application/json";

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }
}
