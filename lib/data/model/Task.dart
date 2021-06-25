import 'dart:convert';

import 'package:flutterapp/database/databaseHelper.dart';

List<Task> getToDoItemResponseFromJson(String str) => List<Task>.from(
    json.decode(str).map((x) => Task.fromJson(x)));

String getToDoItemResponseToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  int? id;
  String taskName;

  Task({ this.id, required this.taskName});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        taskName: json["taskName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taskName": taskName,
      };

  factory Task.fromDatabaseToJson(Map<String, dynamic> data) => Task(
      id: data[DatabaseHelper.columnId],
      taskName: data[DatabaseHelper.columnTask]);

  Map<String, dynamic> toDataBaseJson() => {
    DatabaseHelper.columnId: this.id,
    DatabaseHelper.columnTask: this.taskName
  };
}
