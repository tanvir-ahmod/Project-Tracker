import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_tracker/data/model/request/login_request.dart';
import 'package:project_tracker/data/model/request/registration_request.dart';
import 'package:project_tracker/data/repositories/auth/auth_repository.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:get/get.dart';
import 'package:project_tracker/ui/home_screen.dart';
import 'package:project_tracker/ui/login_ui.dart';
import 'package:project_tracker/ui/registration/resend_confirmation_email.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  AuthRepository authRepository = Get.find();

  void login(String email, String password) async {
    isLoading.value = true;
    var loginResponse = await authRepository
        .login(LoginRequest(email: email, password: password));

    isLoading.value = false;

    Fluttertoast.showToast(
        msg: loginResponse.responseMessage,
        toastLength: Toast.LENGTH_SHORT);

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
    Fluttertoast.showToast(
        msg: loginResponse.responseMessage, toastLength: Toast.LENGTH_LONG);
    if (loginResponse.responseCode == RESPONSE_OK) {
      Get.to(() => ResendConfirmationEmailScreen(email: email));
    }
  }

  void logout() {
    authRepository.logout();
    Fluttertoast.showToast(
        msg: "You have been logged out", toastLength: Toast.LENGTH_LONG);
    Get.offAll(() => LoginScreen());
  }
}
