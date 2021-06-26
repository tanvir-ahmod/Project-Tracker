import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/response/base_response.dart';

abstract class TodoRepository {
  Future<BaseResponse> insertTask(Task task);

  Future<List<Task>> fetchAllTasks();

  Future deleteRowByID(int id);

}
