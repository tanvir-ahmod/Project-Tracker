import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/ui/sign_up_ui.dart';
import 'package:get/get.dart';

import 'home_page.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _email.text = "test@gmail.com";
    _pass.text = "password";
    return Obx(() {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Login Page"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        child: Image.asset('assets/images/password_setup.png')),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _email,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val != null && val.isEmpty)
                              return 'Field can not be empty';
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email address',
                              hintText: 'Enter email address'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _pass,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            if (val != null && val.isEmpty)
                              return 'Field can not be empty';
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Enter password'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      if (_form.currentState!.validate()) {
                        var isAuthenticated =
                            await authController.login(_email.text, _pass.text);
                        if (isAuthenticated) {
                          Future.delayed(const Duration(milliseconds: 1500),
                              () {
                            Get.offAll(() => MyHomePage());
                          });
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (authController.isLoading.value)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                    onTap: () {
                      Get.offAll(SignUpUI());
                    },
                    child: Text('New User? Create Account'))
              ],
            ),
          ));
    });
  }
}
