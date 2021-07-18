import 'package:todo/controller/auth_controller.dart';
import 'package:todo/controller/resend_confirmation_code_controller.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/controller/view_projects_controller.dart';
import 'package:todo/data/repositories/auth/auth_repository.dart';
import 'package:todo/data/repositories/auth/auth_repository_impl.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';
import 'package:todo/data/repositories/todo/todo_repository_impl.dart';
import 'package:todo/services/api_service.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/auth_service_impl.dart';
import 'package:todo/services/remote_service_impl.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<TodoController>(() => TodoController(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<TodoRepository>(() => TodoRepositoryImpl(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthServiceImpl(), fenix: true);
    Get.lazyPut<ApiService>(() => RemoteServiceImpl(), fenix: true);
    Get.lazyPut<ViewProjectController>(() => ViewProjectController(),
        fenix: true);
    Get.lazyPut<ResendConfirmationEmailController>(
        () => ResendConfirmationEmailController(),
        fenix: true);
  }
}
