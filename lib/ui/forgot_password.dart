import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo/controller/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  final ForgotPasswordController _forgotPasswordController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Forgot Your Password?',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Enter the Email address associated with',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Text('your account', style: TextStyle(fontSize: 17)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.white24)),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      controller: _forgotPasswordController.emailController,
                      // ignore: missing_return
                    )),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 40,
                  width: 285,
                  child: MaterialButton(
                    child: Text('Reset Password'),
                    onPressed: () {
                      if (_forgotPasswordController
                          .emailController.text.isNotEmpty) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _forgotPasswordController.resetPassword();
                      } else {
                        Fluttertoast.showToast(msg: "Email can not be empty!");
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Colors.indigo.shade600,
                    textColor: Theme.of(context).primaryTextTheme.button!.color,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_forgotPasswordController.isLoading.value)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                SizedBox(
                  height: 90,
                ),
              ],
            ),
          ),
        ));
  }
}
