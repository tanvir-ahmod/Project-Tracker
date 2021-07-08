import 'dart:convert';

class AddTodoRequest {
  AddTodoRequest({
    required this.checkLists,
    required this.deadline,
    required this.description,
    this.parentId,
  });

  List<CheckList> checkLists;
  String deadline;
  String description;
  int? parentId;

  factory AddTodoRequest.fromRawJson(String str) =>
      AddTodoRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddTodoRequest.fromJson(Map<String, dynamic> json) => AddTodoRequest(
        checkLists: List<CheckList>.from(
            json["checkLists"].map((x) => CheckList.fromJson(x))),
        deadline: json["deadline"],
        description: json["description"],
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() => {
        "checkLists": List<dynamic>.from(checkLists.map((x) => x.toJson())),
        "deadline": deadline,
        "description": description,
        "parent_id": parentId,
      };
}

class CheckList {
  CheckList({
    required this.description,
    required this.done,
  });

  String description;
  bool done;

  factory CheckList.fromRawJson(String str) =>
      CheckList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckList.fromJson(Map<String, dynamic> json) => CheckList(
        description: json["description"],
        done: json["done"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "done": done,
      };
}
