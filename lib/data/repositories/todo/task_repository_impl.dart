import 'package:flutterapp/dao/TaskDao.dart';
import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/response/base_response.dart';
import 'package:flutterapp/data/model/response/get_all_to_do_item_response.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository.dart';
import 'package:flutterapp/services/api_service.dart';
import 'package:flutterapp/services/remote_service.dart';

class TaskRepositoryImpl extends TodoRepository {
  ApiService _service = RemoteService();


  @override
  Future<BaseResponse> insertTask(Task task) => _service.insert(task);

  @override
  Future<List<Task>> fetchAllTasks() => _service.fetchAllTasks();

  @override
  Future deleteRowByID(int id) => _service.deleteRowByID(id);

}
