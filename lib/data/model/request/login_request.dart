// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  LoginRequest({
    required this.name,
    required this.password,
  });

  String name;
  String password;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    name: json["name"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "password": password,
  };
}
