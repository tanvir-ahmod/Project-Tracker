import 'package:project_tracker/controller/auth_controller.dart';
import 'package:project_tracker/controller/change_password_controller.dart';
import 'package:project_tracker/controller/forgot_password_controller.dart';
import 'package:project_tracker/controller/resend_confirmation_code_controller.dart';
import 'package:project_tracker/controller/project_controller.dart';
import 'package:project_tracker/controller/view_projects_controller.dart';
import 'package:project_tracker/data/repositories/auth/auth_repository.dart';
import 'package:project_tracker/data/repositories/auth/auth_repository_impl.dart';
import 'package:project_tracker/data/repositories/profile/profile_repository.dart';
import 'package:project_tracker/data/repositories/profile/profile_repository_impl.dart';
import 'package:project_tracker/data/repositories/project/project_repository.dart';
import 'package:project_tracker/data/repositories/project/project_repository_impl.dart';
import 'package:project_tracker/services/api_service.dart';
import 'package:project_tracker/services/auth_service.dart';
import 'package:project_tracker/services/auth_service_impl.dart';
import 'package:project_tracker/services/profile_service.dart';
import 'package:project_tracker/services/profile_service_impl.dart';
import 'package:project_tracker/services/remote_service_impl.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<ProjectController>(() => ProjectController(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<ProjectRepository>(() => ProjectRepositoryImpl(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthServiceImpl(), fenix: true);
    Get.lazyPut<ApiService>(() => RemoteServiceImpl(), fenix: true);
    Get.lazyPut<ViewProjectController>(() => ViewProjectController(),
        fenix: true);
    Get.lazyPut<ResendConfirmationEmailController>(
        () => ResendConfirmationEmailController(),
        fenix: true);
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController(),
        fenix: true);
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(), fenix: true);
    Get.lazyPut<ProfileService>(() => ProfileServiceImpl(), fenix: true);
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(), fenix: true);
  }
}
