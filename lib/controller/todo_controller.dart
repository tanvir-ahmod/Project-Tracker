import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/repositories/todo/task_repository_impl.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  var isLoading = false.obs;
  TodoRepository _todoRepository = TaskRepositoryImpl();

  List<Task> totoItems = <Task>[].obs;

  @override
  void onReady() {
    super.onReady();
    getAllToDoItems();
  }

  void getAllToDoItems() async {
    isLoading.value = true;
    var response = await _todoRepository.fetchAllTasks();
    totoItems = response;
    update();
  }

  void insertTodo(String taskName) async {
    final response = await _todoRepository.insertTask(Task(taskName: taskName));
    Get.snackbar("Todo", response.responseMessage,
        snackPosition: SnackPosition.BOTTOM);
    getAllToDoItems();
    update();
  }

  void deleteTodoById(int id) async {
    final response = await _todoRepository.deleteRowByID(id);
    Get.snackbar("Todo", response.responseMessage,
        snackPosition: SnackPosition.BOTTOM);
    getAllToDoItems();
    update();
  }
}
