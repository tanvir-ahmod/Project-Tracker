import 'package:flutterapp/dao/TaskDao.dart';
import 'package:flutterapp/data/model/Task.dart';

class TaskRepository {
  TaskDao _taskDao = TaskDao();

  Future insertTask(Task task) => _taskDao.insert(task);

  Future fetchAllTasks() => _taskDao.fetchAllTasks();

  Future deleteRowByID(int? id) => _taskDao.deleteRowByID(id);
}
