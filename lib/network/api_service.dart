import 'package:flutterapp/data/model/Task.dart';

abstract class ApiService {
  Future<int> insert(Task task);

  Future<List<Task>> fetchAllTasks();

  Future<int> deleteRowByID(int id);

}
