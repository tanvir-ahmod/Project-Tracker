import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project_tracker/data/repositories/auth/auth_repository.dart';

class ResendConfirmationEmailController extends GetxController {
  AuthRepository authRepository = Get.find();
  String email = "";
  var isLoading = false.obs;

  void resendCode() async {
    isLoading.value = true;
    final response = await authRepository.resendConfirmationLink(email);
    Fluttertoast.showToast(
        msg: response.responseMessage, toastLength: Toast.LENGTH_LONG);

    isLoading.value = false;
  }
}
