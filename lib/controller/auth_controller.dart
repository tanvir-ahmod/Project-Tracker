import 'package:todo/data/model/request/login_request.dart';
import 'package:todo/data/model/request/registration_request.dart';
import 'package:todo/data/repositories/auth/auth_repository.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  AuthRepository authRepository = Get.find();

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    var loginResponse = await authRepository
        .login(LoginRequest(email: email, password: password));
    isLoading.value = false;
    Get.snackbar("Authentication", loginResponse.responseMessage,
        snackPosition: SnackPosition.BOTTOM);

    return loginResponse.token.isNotEmpty;
  }

  Future<bool> register(String email, String password, String confirmPassword) async {
    isLoading.value = true;
    var loginResponse = await authRepository
        .register(RegistrationRequest(email: email, password: password, confirmPassword: confirmPassword));
    isLoading.value = false;
    Get.snackbar("Authentication", loginResponse.responseMessage,
        snackPosition: SnackPosition.BOTTOM);

    return loginResponse.responseCode == Constants.RESPONSE_OK;
  }
}
