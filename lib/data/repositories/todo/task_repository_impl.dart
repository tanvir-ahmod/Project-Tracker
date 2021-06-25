import 'package:flutterapp/dao/TaskDao.dart';
import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/response/get_all_to_do_item_response.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository.dart';
import 'package:flutterapp/network/ApiService.dart';

class TaskRepositoryImpl extends TodoRepository {
  TaskDao _taskDao = TaskDao();

  @override
  Future insertTask(Task task) => _taskDao.insert(task);

  @override
  Future fetchAllTasks() => _taskDao.fetchAllTasks();

  @override
  Future deleteRowByID(int? id) => _taskDao.deleteRowByID(id);

  @override
  Future<List<GetToDoItemResponse>> getAllToDoItems() =>
      ApiService.getAllToDoItems();
}
