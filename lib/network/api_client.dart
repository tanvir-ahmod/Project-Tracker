import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/ui/login_ui.dart';

class ApiClient {
  Dio _dio = Dio();

  ApiClient() {
    _initializeApiClient();
  }

  _initializeApiClient() {
    var options = BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: 60000,
      receiveTimeout: 60000,
    );
    _dio.options = options;

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final token = GetStorage().read(TOKEN);
      options.headers["Authorization"] = "Bearer " + token;
      options.headers["Content-type"] = "application/json";
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        Get.snackbar("Authentication", "Authentication failed",
            snackPosition: SnackPosition.BOTTOM);

        Future.delayed(const Duration(milliseconds: 2000), () {
          Get.offAll(() => LoginScreen());
        });
      } else if (e.response?.statusCode == 400) {
        if (e.response != null) {
          BaseResponse response = BaseResponse.fromJson(e.response?.data);
          Get.snackbar("Error", response.responseMessage,
              snackPosition: SnackPosition.BOTTOM);
        } else
          Get.snackbar("Error", "Could not connect to server",
              snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "Could not connect to server",
            snackPosition: SnackPosition.BOTTOM);
      }
      return handler.next(e);
    }));
  }

  Dio getApiClient() {
    return _dio;
  }
}
