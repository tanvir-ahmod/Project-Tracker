import 'package:flutterapp/dao/TaskDao.dart';
import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/response/get_all_to_do_item_response.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository.dart';
import 'package:flutterapp/network/api_service.dart';
import 'package:flutterapp/network/remote_service.dart';

class TaskRepositoryImpl extends TodoRepository {
  ApiService _taskDao = RemoteService();


  @override
  Future insertTask(Task task) => _taskDao.insert(task);

  @override
  Future<List<Task>> fetchAllTasks() => _taskDao.fetchAllTasks();

  @override
  Future deleteRowByID(int id) => _taskDao.deleteRowByID(id);

}
