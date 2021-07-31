import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_tracker/controller/resend_confirmation_code_controller.dart';
import 'package:project_tracker/ui/loading.dart';
import 'package:project_tracker/ui/login_ui.dart';

class ResendConfirmationEmailScreen extends StatelessWidget {
  final ResendConfirmationEmailController _resendEmailController = Get.find();
  final String email;

  ResendConfirmationEmailScreen({Key? key, required this.email})
      : super(key: key) {
    _resendEmailController.email = this.email;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _resendEmailController.isLoading.value
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Confirm email"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Please confirm your email to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive a code?"),
                      TextButton(
                          onPressed: () {
                            _resendEmailController.resendCode();
                          },
                          child: Text("Resend")),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Get.off(LoginScreen());
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                    ),
                    child: Text("Login"),
                  )
                ],
              ),
            ),
          ));
  }
}
