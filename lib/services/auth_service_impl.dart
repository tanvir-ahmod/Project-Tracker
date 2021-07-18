import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:todo/data/model/request/login_request.dart';
import 'package:todo/data/model/request/registration_request.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/data/model/response/login_response.dart';
import 'package:todo/data/model/response/registration_response.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:todo/network/api_client.dart';
import 'package:todo/services/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final _apiClient = ApiClient().getApiClient();

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    _apiClient.interceptors.clear();
    final data = jsonEncode(loginRequest.toJson());
    var response;
    try {
      response = await _apiClient.post('login', data: data);
    } on DioError catch (e) {
      if (e.response?.data != null)
        return LoginResponse.fromJson(e.response!.data);
    }
    if (response.statusCode == RESPONSE_OK) {
      return LoginResponse.fromJson(response.data);
    } else {
      return loginResponseFromJson("");
    }
  }

  @override
  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest) async {
    _apiClient.interceptors.clear();
    final data = registrationRequest.toRawJson();
    try {
      final response = await _apiClient.post("register", data: data);
      return RegistrationResponse.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 400)
        return RegistrationResponse.fromJson(e.response!.data);
    }

    return registrationResponseFromJson("");
  }

  @override
  @override
  Future<BaseResponse> resendConfirmationLink(String email) async {
    final response =
        await _apiClient.get("resendToken", queryParameters: {'email': email});
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    }
    return baseResponseFromJson("");
  }
}
