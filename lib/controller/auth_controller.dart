import 'package:todo/data/model/request/login_request.dart';
import 'package:todo/data/model/request/registration_request.dart';
import 'package:todo/data/repositories/auth/auth_repository.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:get/get.dart';
import 'package:todo/ui/home_screen.dart';
import 'package:todo/ui/registration/resend_confirmation_email.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  AuthRepository authRepository = Get.find();

  void login(String email, String password) async {
    isLoading.value = true;
    var loginResponse = await authRepository
        .login(LoginRequest(email: email, password: password));

    Get.snackbar("Authentication", loginResponse.responseMessage,
        snackPosition: SnackPosition.BOTTOM);
    isLoading.value = false;
    if (loginResponse.responseCode == 200 &&
        (loginResponse.token != null && loginResponse.token!.isNotEmpty)) {
      Get.offAll(() => HomeScreen());
    } else if (loginResponse.responseCode == 417) {
      Get.offAll(() => ResendConfirmationEmailScreen(email: email));
    }
  }

  void register(String email, String password, String confirmPassword) async {
    isLoading.value = true;
    var loginResponse = await authRepository.register(RegistrationRequest(
        email: email, password: password, confirmPassword: confirmPassword));
    isLoading.value = false;
    Get.snackbar("Authentication", loginResponse.responseMessage,
        snackPosition: SnackPosition.BOTTOM);

    if (loginResponse.responseCode == RESPONSE_OK) {
      Get.to(() => ResendConfirmationEmailScreen(email: email));
    }
  }

  void logout() {
    authRepository.logout();
    Get.snackbar("Logged out", "You have been logged out",
        snackPosition: SnackPosition.BOTTOM);
  }
}
