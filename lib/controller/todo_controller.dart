import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/model/request/registration_request.dart';
import 'package:flutterapp/data/model/response/get_all_to_do_item_response.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository_impl.dart';
import 'package:flutterapp/data/repositories/todo/task_repository_impl.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository.dart';
import 'package:flutterapp/helpers/Constants.dart';
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
}
