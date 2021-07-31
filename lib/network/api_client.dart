import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project_tracker/data/model/response/base_response.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_tracker/ui/login_ui.dart';

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
        Fluttertoast.showToast(
            msg: "Authentication failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Get.offAll(() => LoginScreen());
      } else if (e.response?.statusCode == 400) {
        if (e.response != null) {
          BaseResponse response = BaseResponse.fromJson(e.response?.data);
          Fluttertoast.showToast(
              msg: response.responseMessage, toastLength: Toast.LENGTH_LONG);
        } else {
          Fluttertoast.showToast(
              msg: "Could not connect to server",
              toastLength: Toast.LENGTH_LONG);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Could not connect to server", toastLength: Toast.LENGTH_LONG);
      }
      return handler.next(e);
    }));
  }

  Dio getApiClient() {
    return _dio;
  }

  Dio getApiClientWithoutInterceptors() {
    _dio.interceptors.clear();
    return _dio;
  }
}
