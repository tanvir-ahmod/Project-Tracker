import 'package:todo/data/model/Task.dart';
import 'package:todo/data/model/response/base_response.dart';

abstract class TodoRepository {
  Future<BaseResponse> insertTask(Task task);

  Future<List<Task>> fetchAllTasks();

  Future<BaseResponse> deleteRowByID(int id);

}
