import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project_tracker/data/repositories/auth/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final TextEditingController emailController = TextEditingController();

  var isLoading = false.obs;

  void resetPassword() async {
    isLoading.value = true;
    final response = await _authRepository.resetPassword(emailController.text);

    Fluttertoast.showToast(
        msg: response.responseMessage, toastLength: Toast.LENGTH_LONG);

    isLoading.value = false;
  }
}
