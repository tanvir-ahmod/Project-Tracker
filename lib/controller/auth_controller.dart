import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository_impl.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLogin = false.obs;
  AuthRepository authRepository = AuthRepositoryImpl();

  Future<bool> login(String name, String password) async {
    var loginResponse = await authRepository
        .login(LoginRequest(name: name, password: password));

    Get.snackbar(
      "Authentication",
      loginResponse.responseMessage,
      snackPosition: SnackPosition.BOTTOM
    );

    return loginResponse.token.isNotEmpty;
  }
}
