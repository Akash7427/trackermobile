import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:trackermobile/controller/homepage_controller.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:trackermobile/view/home/home_page.dart';

class HomeApi {
  static const String baseUrl = "http://13.127.61.250:8080";
  final userdata = GetStorage();

  Future<String> performUpload() async {
    HomePageController homePageController = Get.find<HomePageController>();

    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    DateTime date = DateTime.now();
    String time = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString() +
        "T" +
        date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString() +
        "." +
        date.millisecond.toString();

    // print("lat ${homePageController.lat.value}");
    // print("long ${homePageController.long.value}");
    // print("New lat ${homePageController.newlat.value}");
    // print("New long ${homePageController.newlong.value}");
    print("Distance : " +
        calculateDistance(
                homePageController.lat.value,
                homePageController.long.value,
                homePageController.newlat.value,
                homePageController.newlong.value)
            .toString());
    String distance = calculateDistance(
            homePageController.lat.value,
            homePageController.long.value,
            homePageController.newlat.value,
            homePageController.newlong.value)
        .toString();

    var uri;
    Map data = {
      "list": [
        {
          "longitude": homePageController.newlong.value,
          "latitude": homePageController.newlat.value,
          "eventDateTime": time,
          "distanceTravelledMtr": distance
        }
      ],
    };
    var body1 = jsonEncode(data);
    uri = Uri.parse(
      "$baseUrl/tracker/captureLocationLogs",
    );
    try {
      http.Response response = await http.post(uri,
          headers: {
            "Content-Type": "text/plain",
            'Authorization': 'Bearer ${userdata.read('token')}',
          },
          body: body1);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var message = jsonDecode(response.body)["message"];
        print(message);
        Get.snackbar("Message", message, snackPosition: SnackPosition.BOTTOM);
        return distance;
      } else {
        Get.snackbar("Error", "Not Uploaded",
            snackPosition: SnackPosition.BOTTOM);
        return "";
      }
    } catch (e) {
      Get.snackbar("Error", "Not Uploaded",
          snackPosition: SnackPosition.BOTTOM);

      print(e);
      return "";
    }
  }
}
