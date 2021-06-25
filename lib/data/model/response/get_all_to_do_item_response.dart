// To parse this JSON data, do
//
//     final getToDoItemResponse = getToDoItemResponseFromJson(jsonString);

import 'dart:convert';

import '../Task.dart';

List<Task> getToDoItemResponseFromJson(String str) => List<Task>.from(json.decode(str).map((x) => GetToDoItemResponse.fromJson(x)));

String getToDoItemResponseToJson(List<GetToDoItemResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetToDoItemResponse {
  GetToDoItemResponse({
    required this.id,
    required this.message,
  });

  int id;
  String message;

  factory GetToDoItemResponse.fromJson(Map<String, dynamic> json) => GetToDoItemResponse(
    id: json["id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
  };
}
