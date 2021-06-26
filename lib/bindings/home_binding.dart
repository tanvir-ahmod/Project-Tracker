import 'package:todo/controller/auth_controller.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/data/repositories/auth/auth_repository.dart';
import 'package:todo/data/repositories/auth/auth_repository_impl.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';
import 'package:todo/data/repositories/todo/todo_repository_impl.dart';
import 'package:todo/services/api_service.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/remote_service_impl.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<TodoController>(() => TodoController());
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    Get.lazyPut<TodoRepository>(() => TodoRepositoryImpl());
    Get.lazyPut<AuthService>(() => RemoteServiceImpl());
    Get.lazyPut<ApiService>(() => RemoteServiceImpl());
  }
}
