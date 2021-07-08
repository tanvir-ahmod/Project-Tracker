import 'package:todo/data/model/Task.dart';
import 'package:todo/data/model/request/add_todo_request.dart';
import 'package:todo/data/model/response/base_response.dart';

abstract class ApiService {
  Future<BaseResponse> insert(AddTodoRequest addTodoRequest);

  Future<List<Task>> fetchAllTasks();

  Future<BaseResponse> deleteRowByID(int id);

}
