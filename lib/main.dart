import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trackermobile/view/home/home_page.dart';
import 'package:trackermobile/view/login/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final userdata = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tracker Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: userdata.read('token') == null ? LoginPage() : HomePage(),
    );
  }
}
