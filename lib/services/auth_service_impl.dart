import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project_tracker/data/model/request/login_request.dart';
import 'package:project_tracker/data/model/request/registration_request.dart';
import 'package:project_tracker/data/model/response/base_response.dart';
import 'package:project_tracker/data/model/response/login_response.dart';
import 'package:project_tracker/data/model/response/registration_response.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:project_tracker/network/api_client.dart';
import 'package:project_tracker/services/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final _apiClient = ApiClient().getApiClientWithoutInterceptors();

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
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

  @override
  Future<BaseResponse> resetPassword(String email) async {
    final response = await _apiClient
        .get("resetPassword", queryParameters: {'email': email});
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    }
    return baseResponseFromJson("");
  }
}
