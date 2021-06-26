import 'dart:convert';

import 'package:todo/data/model/Task.dart';
import 'package:todo/data/model/request/login_request.dart';
import 'package:todo/data/model/request/registration_request.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/data/model/response/login_response.dart';
import 'package:todo/data/model/response/registration_response.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:todo/services/api_service.dart';

import '../network/api_client.dart';
import 'auth_service.dart';

class RemoteServiceImpl implements ApiService, AuthService {
  final _apiClient = ApiClient().getApiClient();

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    _apiClient.interceptors.clear();
    final data = jsonEncode(loginRequest.toJson());
    final response = await _apiClient.post('login', data: data);
    if (response.statusCode == Constants.RESPONSE_OK) {
      return LoginResponse.fromJson(response.data);
    } else {
      return loginResponseFromJson("");
    }
  }

  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest) async {
    final data = registrationRequest.toRawJson();
    final response = await _apiClient.post("register", data: data);

    if (response.statusCode == Constants.RESPONSE_OK) {
      return RegistrationResponse.fromJson(response.data);
    } else {
      return registrationResponseFromJson("");
    }
  }

  @override
  Future<List<Task>> fetchAllTasks() async {
    final response = await _apiClient.get("getAllTodoItems");
    if (response.statusCode == Constants.RESPONSE_OK) {
      return List<Task>.from(response.data.map((x) => Task.fromJson(x)));
    }
    return getToDoItemResponseFromJson("");
  }

  @override
  Future<BaseResponse> deleteRowByID(int id) async {
    final response = await _apiClient.delete("deleteTodoById/$id");
    if (response.statusCode == Constants.RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    } else {
      return baseResponseFromJson("");
    }
  }

  @override
  Future<BaseResponse> insert(Task task) async {
    final data = task.toRawJson();
    final response = await _apiClient.post("addTodo", data: data);
    if (response.statusCode == Constants.RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    } else {
      return baseResponseFromJson("");
    }
  }
}
