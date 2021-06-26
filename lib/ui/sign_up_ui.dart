import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/controller/auth_controller.dart';
import 'package:flutterapp/ui/login_ui.dart';
import 'package:get/get.dart';

class SignUpUI extends StatelessWidget {
  final AuthController authController = Get.find();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Registration"),
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
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
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
                          textInputAction: TextInputAction.next,
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
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _confirmPass,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            if (val!.isEmpty) return 'Field can not be empty';
                            if (val != _pass.text)
                              return 'Password does not match';
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Password',
                              hintText: 'Enter password again'),
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
                        var isRegistered = await authController.register(
                            _email.text, _pass.text, _confirmPass.text);
                        if (isRegistered) {
                          Get.offAll(() => LoginScreen());
                        }
                      }
                    },
                    child: Text(
                      'Register',
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
                      Get.offAll(() => SignUpUI());
                    },
                    child: Text('New User? Create Account'))
              ],
            ),
          ));
    });
  }
}
