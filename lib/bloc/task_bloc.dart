import 'dart:async';

import 'package:flutterapp/model/Task.dart';
import 'package:flutterapp/repository/taskRepository.dart';

class TasksBlock {
  final TaskRepository _taskRepository = TaskRepository();
  final _tasksController = StreamController<List<Task>>();

  Stream<List<Task>> get tasks => _tasksController.stream;

  fetchAllTasks() async {
    _tasksController.sink.add(await (_taskRepository.fetchAllTasks() as FutureOr<List<Task>>));
  }

  insertTask(Task task) async {
    await _taskRepository.insertTask(task);
    fetchAllTasks();
  }

  deleteRowByID(int? id) async {
    await _taskRepository.deleteRowByID(id);
    fetchAllTasks();
  }

  void dispose() {
    _tasksController.close();
  }
}
