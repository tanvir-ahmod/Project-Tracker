import 'dart:async';

import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/repositories/todo/task_repository_impl.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository.dart';

class TasksBlock {
  final TodoRepository _taskRepository = TaskRepositoryImpl();
  final _tasksController = StreamController<List<Task>>();

  Stream<List<Task>> get tasks => _tasksController.stream;

  fetchAllTasks() async {
    _tasksController.sink.add(await (_taskRepository.fetchAllTasks() as FutureOr<List<Task>>));
  }

  insertTask(Task task) async {
    await _taskRepository.insertTask(task);
    fetchAllTasks();
  }

  deleteRowByID(int id) async {
    await _taskRepository.deleteRowByID(id);
    fetchAllTasks();
  }

  void dispose() {
    _tasksController.close();
  }
}
