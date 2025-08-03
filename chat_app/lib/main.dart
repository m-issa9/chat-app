import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';

void main() {
  runApp(GetMaterialApp(
    title: 'Chat App',
    initialRoute: AppRoutes.selector,
    getPages: AppRoutes.routes,
  ));
}
