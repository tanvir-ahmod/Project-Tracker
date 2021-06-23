import 'dart:convert';

import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/model/response/login_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const BASE_URL = "http://192.168.0.106:8080/";

  static Future<LoginResponse> login(LoginRequest loginRequest) async {
    final url = Uri.parse(BASE_URL + "login");
    final headers = {"Content-type": "application/json"};
    final json = jsonEncode(loginRequest.toJson());

    final response = await http.post(url, headers: headers, body: json);

    if (response.statusCode == 200) {
      return loginResponseFromJson(response.body);
    } else {
      return loginResponseFromJson("");
    }
  }
}
