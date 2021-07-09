import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackermobile/controller/login_controller.dart';
import 'package:trackermobile/services/login_api.dart';
import 'package:trackermobile/shared/size_config.dart';
import 'package:trackermobile/view/home/home_page.dart';

class LoginPage extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 60,
                      left: SizeConfig.safeBlockHorizontal * 25,
                    ),
                    child: Text(
                      "Username",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.safeBlockVertical * 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 15,
                      left: SizeConfig.safeBlockHorizontal * 25,
                      right: SizeConfig.safeBlockHorizontal * 25,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: username,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Username",
                          contentPadding: EdgeInsets.only(
                            left: SizeConfig.safeBlockHorizontal * 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 60,
                      left: SizeConfig.safeBlockHorizontal * 25,
                    ),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.safeBlockVertical * 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 15,
                      left: SizeConfig.safeBlockHorizontal * 25,
                      right: SizeConfig.safeBlockHorizontal * 25,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Password",
                          contentPadding: EdgeInsets.only(
                            left: SizeConfig.safeBlockHorizontal * 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 60,
                      left: SizeConfig.safeBlockHorizontal * 25,
                      right: SizeConfig.safeBlockHorizontal * 25,
                    ),
                    child: InkWell(
                      onTap: () async {
                        // List characterlist = [
                        //   'a',
                        //   'b',
                        //   'c',
                        //   'd',
                        //   'e',
                        //   'f',
                        //   'g',
                        //   'h',
                        //   'i',
                        //   'j',
                        //   'k',
                        //   'l',
                        //   'm',
                        //   'n',
                        //   'o',
                        //   'p',
                        //   'q',
                        //   'r',
                        //   's',
                        //   't',
                        //   'u',
                        //   'v',
                        //   'w',
                        //   'x',
                        //   'y',
                        //   'z',
                        //   'A',
                        //   'B',
                        //   'C',
                        //   'D',
                        //   'E',
                        //   'F',
                        //   'G',
                        //   'H',
                        //   'I',
                        //   'J',
                        //   'K',
                        //   'L',
                        //   'M',
                        //   'N',
                        //   'O',
                        //   'P',
                        //   'Q',
                        //   'R',
                        //   'S',
                        //   'T',
                        //   'U',
                        //   'V',
                        //   'W',
                        //   'X',
                        //   'Y',
                        //   'Z'
                        // ];

                        String deviceID = "7e891d1931ba0cbf";
                        String mobileToken = getRandomString(10);
                        //  rng.nextInt(9).toString() +
                        //     characterlist[rng.nextInt(characterlist.length)] +
                        //     (rng.nextInt(899) + 100).toString() +
                        //     characterlist[rng.nextInt(characterlist.length)] +
                        //     (rng.nextInt(8999) + 1000).toString() +
                        //     characterlist[rng.nextInt(characterlist.length)] +
                        //     characterlist[rng.nextInt(characterlist.length)] +
                        //     rng.nextInt(9).toString() +
                        //     characterlist[rng.nextInt(characterlist.length)] +
                        //     characterlist[rng.nextInt(characterlist.length)] +
                        //     characterlist[rng.nextInt(characterlist.length)];
                        //7e891d1931ba0cbf
                        if (username.text != "" && password.text != "") {
                          print("Clicked");
                          loginController.username.value = username.text;
                          loginController.password.value = password.text;
                          loginController.deviceId.value = deviceID;
                          loginController.mobileToken.value = mobileToken;
                          print(loginController.deviceId.value);
                          bool loginvalue = await LoginApi().performLogin();
                          if (loginvalue) {
                            Get.off(() => HomePage());
                            print("Done");
                          } else {
                            Get.snackbar("Error", "Credentials Are Invalid");
                            print("Error");
                          }
                        }
                      },
                      child: Container(
                        height: SizeConfig.safeBlockVertical * 45,
                        width: SizeConfig.safeBlockHorizontal * 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockVertical * 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              loginController.loginLoader.value
                  ? Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: Colors.black87,
                      child: Center(child: CircularProgressIndicator()))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
