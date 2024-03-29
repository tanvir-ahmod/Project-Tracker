import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_tracker/controller/auth_controller.dart';
import 'package:project_tracker/ui/login_ui.dart';
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
                        child: Image.asset('assets/images/login.png')),
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
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: TextFormField(
                            controller: _email,
                            validator: (val) {
                              if (val != null && val.isEmpty)
                                return 'Field can not be empty';
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(color: Colors.white24)),
                              labelText: 'Email',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w500),
                            ),
                            // ignore: missing_return
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                              contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(color: Colors.white24)),
                              labelText: 'Password',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w500),
                            ),
                            // ignore: missing_return
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                              contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(color: Colors.white24)),
                              labelText: 'Confirm Password',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w500),
                            ),
                            // ignore: missing_return
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      authController.register(
                          _email.text, _pass.text, _confirmPass.text);
                    }
                  },
                  child: Text(
                    'Register',
                    // style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 60.0, vertical: 8.0),
                  color: Colors.blue[600],
                  textColor: Theme.of(context).primaryTextTheme.button!.color,
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
                      Get.offAll(() => LoginScreen());
                    },
                    child: Text('Already have account? Sign in'))
              ],
            ),
          ));
    });
  }
}
