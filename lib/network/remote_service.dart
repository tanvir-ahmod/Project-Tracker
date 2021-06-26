import 'dart:convert';

import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/model/request/registration_request.dart';
import 'package:flutterapp/data/model/response/base_response.dart';
import 'package:flutterapp/data/model/response/login_response.dart';
import 'package:flutterapp/data/model/response/registration_response.dart';
import 'package:flutterapp/helpers/Constants.dart';
import 'package:flutterapp/network/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class RemoteService implements ApiService, AuthService {
  final BASE_URL = "http://192.168.0.100:8080/";

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final url = Uri.parse(BASE_URL + "login");
    final headers = {"Content-type": "application/json"};
    final json = jsonEncode(loginRequest.toJson());

    final response = await http.post(url, headers: headers, body: json);

    if (response.statusCode == Constants.RESPONSE_OK) {
      return loginResponseFromJson(response.body);
    } else {
      return loginResponseFromJson("");
    }
  }

  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest) async {
    final url = Uri.parse(BASE_URL + "register");
    final headers = {"Content-type": "application/json"};
    final json = registrationRequest.toRawJson();

    final response = await http.post(url, headers: headers, body: json);

    if (response.statusCode == Constants.RESPONSE_OK) {
      return registrationResponseFromJson(response.body);
    } else {
      return registrationResponseFromJson("");
    }
  }

  @override
  Future<List<Task>> fetchAllTasks() async {
    final url = Uri.parse(BASE_URL + "getAllTodoItems");

    final token = GetStorage().read(Constants.TOKEN);
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == Constants.RESPONSE_OK) {
      return getToDoItemResponseFromJson(response.body);
    }

    return getToDoItemResponseFromJson(response.body);
  }

  @override
  Future<int> deleteRowByID(int id) {
    // TODO: implement deleteRowByID
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse> insert(Task task) async {
    final url = Uri.parse(BASE_URL + "addTodo");
    final json = task.toRawJson();
    final token = GetStorage().read(Constants.TOKEN);
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.post(url, headers: headers, body: json);

    if (response.statusCode == Constants.RESPONSE_OK) {
      return baseResponseFromJson(response.body);
    } else {
      return baseResponseFromJson("");
    }
  }
}
