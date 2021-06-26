// To parse this JSON data, do
//
//     final baseResponse = baseResponseFromJson(jsonString);

import 'dart:convert';

BaseResponse baseResponseFromJson(String str) => BaseResponse.fromJson(json.decode(str));

String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

class BaseResponse {
  BaseResponse({
    required this.responseCode,
    required this.responseMessage,
  });

  int responseCode;
  String responseMessage;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    responseCode: json["responseCode"],
    responseMessage: json["responseMessage"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "responseMessage": responseMessage,
  };
}
