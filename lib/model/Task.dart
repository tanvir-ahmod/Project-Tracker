import 'file:///D:/Projects/Personal/ToDoApp/flutter_app/lib/database/databaseHelper.dart';

class Task {
  int id;
  String taskName;

  Task({this.id, this.taskName});

  factory Task.fromDatabaseToJson(Map<String, dynamic> data) => Task(
      id: data[DatabaseHelper.columnId],
      taskName: data[DatabaseHelper.columnTask]);

  Map<String, dynamic> toDataBaseJson() => {
        DatabaseHelper.columnId: this.id,
        DatabaseHelper.columnTask: this.taskName
      };
}
