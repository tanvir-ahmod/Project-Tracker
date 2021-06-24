import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository_impl.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  AuthRepository authRepository = AuthRepositoryImpl();

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    var loginResponse = await authRepository
        .login(LoginRequest(email: email, password: password));
    isLoading.value = false;
    Get.snackbar("Authentication", loginResponse.responseMessage,
        snackPosition: SnackPosition.BOTTOM);

    return loginResponse.token.isNotEmpty;
  }
}
