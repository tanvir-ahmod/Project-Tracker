import 'package:todo/data/model/Task.dart';
import 'package:todo/data/model/request/add_todo_request.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';
import 'package:todo/services/api_service.dart';
import 'package:get/get.dart';

class TodoRepositoryImpl extends TodoRepository {
  ApiService _service = Get.find();

  @override
  Future<BaseResponse> insertTask(AddTodoRequest addTodoRequest) =>
      _service.insert(addTodoRequest);

  @override
  Future<List<Task>> fetchAllTasks() => _service.fetchAllTasks();

  @override
  Future<BaseResponse> deleteRowByID(int id) => _service.deleteRowByID(id);
}
