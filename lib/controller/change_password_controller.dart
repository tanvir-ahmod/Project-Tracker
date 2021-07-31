import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project_tracker/data/model/request/change_password_request.dart';
import 'package:project_tracker/data/repositories/profile/profile_repository.dart';
import 'package:project_tracker/ui/login_ui.dart';

class ChangePasswordController extends GetxController {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  var isLoading = false.obs;

  ProfileRepository _profileRepository = Get.find();

  void changePassword() async {
    final changePasswordRequest = ChangePasswordRequest(
      oldPassword: oldPassword.text,
      newPassword: newPassword.text,
      confirmPassword: confirmPassword.text,
    );
    isLoading.value = true;
    final response =
        await _profileRepository.changePassword(changePasswordRequest);
    isLoading.value = false;
    Fluttertoast.showToast(msg: response.responseMessage);
    Get.offAll(() => LoginScreen());
  }
}
