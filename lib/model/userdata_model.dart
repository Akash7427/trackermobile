// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.token = "",
  });

  String token;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
