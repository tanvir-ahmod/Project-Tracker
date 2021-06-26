import 'package:flutterapp/controller/auth_controller.dart';
import 'package:flutterapp/controller/todo_controller.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository_impl.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository.dart';
import 'package:flutterapp/data/repositories/todo/todo_repository_impl.dart';
import 'package:flutterapp/services/api_service.dart';
import 'package:flutterapp/services/auth_service.dart';
import 'package:flutterapp/services/remote_service_impl.dart';
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
