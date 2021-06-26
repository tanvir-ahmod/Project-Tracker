import 'package:dio/dio.dart';
import 'package:flutterapp/helpers/Constants.dart';
import 'package:get_storage/get_storage.dart';

class ApiClient {
  Dio _dio = Dio();

  ApiClient() {
    _initializeApiClient();
  }

  _initializeApiClient() {
    var options = BaseOptions(
      baseUrl: 'http://192.168.0.100:8080/',
      connectTimeout: 20000,
      receiveTimeout: 20000,
    );
    _dio.options = options;

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final token = GetStorage().read(Constants.TOKEN);
      options.headers["Authorization"] = "Bearer " + token;
      options.headers["Content-type"] = "application/json";
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      return handler.next(e);
    }));
  }

  Dio getApiClient() {
    return _dio;
  }
}
