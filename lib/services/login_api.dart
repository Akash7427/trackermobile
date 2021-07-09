import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:trackermobile/controller/login_controller.dart';

class LoginApi {
  static const String baseUrl = "http://13.127.61.250:8080";
  final userdata = GetStorage();

  Future<bool> performLogin() async {
    LoginController loginController = Get.find<LoginController>();
    loginController.loginLoader.value = true;
    var uri;
    Map data = {
      "deviceId": loginController.deviceId.value,
      "mobileToken": loginController.mobileToken.value,
      "username": loginController.username.value,
      "password": loginController.password.value,
    };
    var body1 = jsonEncode(data);
    uri = Uri.parse(
      "$baseUrl/auth/login",
    );
    try {
      http.Response response = await http.post(uri,
          headers: {
            "Content-Type": "text/plain",
          },
          body: body1);
      if (response.statusCode == 200) {
        loginController.loginLoader.value = false;
        var token = jsonDecode(response.body)["token"];
        print(token);
        userdata.write('token', token);
        return true;
      } else {
        loginController.loginLoader.value = false;
        return false;
      }
    } catch (e) {
      loginController.loginLoader.value = false;
      print(e);
      return false;
    }
  }
}
