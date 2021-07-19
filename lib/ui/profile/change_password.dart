import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordController _changePasswordController = Get.find();
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _changePasswordController.form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text("Old Password"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: _changePasswordController.oldPassword,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) return 'Field can not be empty';
                      return null;
                    },
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(focusNode1),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("New Password"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: TextFormField(
                    focusNode: focusNode1,
                    controller: _changePasswordController.newPassword,
                    validator: (val) {
                      if (val!.isEmpty) return 'Field can not be empty';
                      return null;
                    },
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(focusNode2),
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Confirm Password"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: _changePasswordController.confirmPassword,
                    focusNode: focusNode2,
                    validator: (val) {
                      if (val!.isEmpty) return 'Field can not be empty';
                      if (val != _changePasswordController.newPassword.text)
                        return 'Password does not match';
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity,
                          40), // double.infinity is the width and 30 is the height
                    ),
                    onPressed: () {
                      if (_changePasswordController.form.currentState!
                          .validate()) {
                        _changePasswordController.changePassword();
                      }
                    },
                    child: Text("Change password"),
                  ),
                ),
                Obx(() => _changePasswordController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
