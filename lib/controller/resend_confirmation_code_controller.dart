import 'package:get/get.dart';
import 'package:todo/data/repositories/auth/auth_repository.dart';

class ResendConfirmationEmailController extends GetxController {
  AuthRepository authRepository = Get.find();
  String email = "";
  var isLoading = false.obs;

  void resendCode() async {
    isLoading.value = true;
    final response = await authRepository.resendConfirmationLink(email);
    Get.snackbar("Resent Code", response.responseMessage,
        snackPosition: SnackPosition.BOTTOM);
    isLoading.value = false;
  }
}
