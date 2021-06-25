import 'dart:convert';

import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/model/request/registration_request.dart';
import 'package:flutterapp/data/model/response/get_all_to_do_item_response.dart';
import 'package:flutterapp/data/model/response/login_response.dart';
import 'package:flutterapp/data/model/response/registration_response.dart';
import 'package:flutterapp/helpers/Constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const BASE_URL = "http://192.168.0.100:8080/";

  static Future<LoginResponse> login(LoginRequest loginRequest) async {
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

  static Future<RegistrationResponse> register(
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

  static Future<List<GetToDoItemResponse>> getAllToDoItems() async {
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
}
