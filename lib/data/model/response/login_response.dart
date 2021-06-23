// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({required this.responseCode, required this.responseMessage, required this.token});

  int responseCode;
  String responseMessage;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessages": responseMessage,
        "token": token,
      };
}
