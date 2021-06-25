import 'package:flutterapp/data/model/Task.dart';

abstract class TodoRepository {
  Future insertTask(Task task);

  Future<List<Task>> fetchAllTasks();

  Future deleteRowByID(int id);

}
