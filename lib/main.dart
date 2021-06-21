import 'package:flutter/material.dart';
import 'package:flutterapp/ui/LoginScreen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}
