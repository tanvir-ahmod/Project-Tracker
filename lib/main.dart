import 'package:flutter/material.dart';
import 'package:todo/bindings/global_binding.dart';
import 'package:todo/ui/login_ui.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  GlobalBinding().dependencies();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen()
  ));
}
