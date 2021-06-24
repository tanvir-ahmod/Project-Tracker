import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/components/form_input_field_with_icon.dart';
import 'package:flutterapp/components/form_vertical_spacing.dart';
import 'package:flutterapp/components/label_button.dart';
import 'package:flutterapp/components/logo_graphic_header.dart';
import 'package:flutterapp/components/primary_button.dart';
import 'package:flutterapp/helpers/validator.dart';
import 'package:flutterapp/ui/LoginScreen.dart';
import 'package:get/get.dart';

class SignUpUI extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LogoGraphicHeader(),
                  SizedBox(height: 48.0),
                  FormInputFieldWithIcon(
                    controller: emailController,
                    iconPrefix: Icons.person,
                    labelText: 'Name',
                    validator: Validator().name,
                    onChanged: (value) => null,
                    onSaved: (value) => {},
                  ),
                  FormVerticalSpace(),
                  FormInputFieldWithIcon(
                    controller: emailController,
                    iconPrefix: Icons.email,
                    labelText: 'Email',
                    validator: Validator().email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => null,
                    onSaved: (value) => {},
                  ),
                  FormVerticalSpace(),
                  FormInputFieldWithIcon(
                    controller: emailController,
                    iconPrefix: Icons.lock,
                    labelText: 'Password',
                    validator: Validator().password,
                    obscureText: true,
                    onChanged: (value) => null,
                    onSaved: (value) => {},
                    maxLines: 1,
                  ),
                  FormVerticalSpace(),
                  PrimaryButton(
                      labelText: 'Sign Up',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput.invokeMethod(
                              'TextInput.hide'); //to hide the keyboard - if any
                        }
                      }),
                  FormVerticalSpace(),
                  LabelButton(
                    labelText: 'Already have account? Sign IN',
                    onPressed: () => Get.offAll(() => LoginScreen()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
