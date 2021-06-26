import 'package:todo/dao/TaskDao.dart';
import 'package:todo/data/model/Task.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/data/model/response/get_all_to_do_item_response.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';
import 'package:todo/services/api_service.dart';
import 'package:todo/services/remote_service_impl.dart';
import 'package:get/get.dart';

class TodoRepositoryImpl extends TodoRepository {
  ApiService _service = Get.find();


  @override
  Future<BaseResponse> insertTask(Task task) => _service.insert(task);

  @override
  Future<List<Task>> fetchAllTasks() => _service.fetchAllTasks();

  @override
  Future<BaseResponse> deleteRowByID(int id) => _service.deleteRowByID(id);

}
