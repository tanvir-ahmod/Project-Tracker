import 'package:flutterapp/dao/TaskDao.dart';
import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/response/base_response.dart';
import 'package:flutterapp/data/model/response/get_all_to_do_item_response.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository.dart';
import 'package:flutterapp/services/api_service.dart';
import 'package:flutterapp/services/remote_service_impl.dart';
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
