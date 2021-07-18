import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controller/resend_confirmation_code_controller.dart';
import 'package:todo/ui/loading.dart';
import 'package:todo/ui/login_ui.dart';

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
                  Text(
                    "Please confirm your email to continue",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
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