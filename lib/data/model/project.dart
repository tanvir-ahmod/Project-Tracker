import 'dart:convert';

class Project {
  Project(
      {required this.checkLists,
      required this.deadline,
      required this.description,
      this.progress,
      this.parentId,
      this.id,
      this.isActive});

  List<CheckList> checkLists;
  String? deadline;
  String description;
  int? parentId;
  double? progress;
  int? id;
  bool? isActive;

  factory Project.fromRawJson(String str) => Project.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        checkLists: List<CheckList>.from(
            json["checkLists"].map((x) => CheckList.fromJson(x))),
        deadline: json["deadline"],
        description: json["description"],
        progress: json["progress"],
        parentId: json["parent_id"],
        id: json["id"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "checkLists": List<dynamic>.from(checkLists.map((x) => x.toJson())),
        "deadline": deadline,
        "description": description,
        "parent_id": parentId,
        "id": id,
        "is_active": isActive
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
