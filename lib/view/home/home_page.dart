import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackermobile/controller/homepage_controller.dart';
import 'package:trackermobile/services/home_api.dart';
import 'package:trackermobile/shared/size_config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin fltrnoti;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  HomePageController homePageController = Get.put(HomePageController());
  Position _currentPosition;

  @override
  void initState() {
    super.initState();

    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrnoti = new FlutterLocalNotificationsPlugin();
    fltrnoti.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);

    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    homePageController.lat.value = homePageController.newlat.value;
    homePageController.long.value = homePageController.newlong.value;
    print("lat ${homePageController.lat.value}");
    print("long ${homePageController.long.value}");
    await Future.delayed(Duration(seconds: 5));
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      // _currentPosition = position;
      // print(_currentPosition);

      homePageController.newlat.value = position.latitude;
      homePageController.newlong.value = position.longitude;

      print("New lat ${homePageController.newlat.value}");
      print("New long ${homePageController.newlong.value}");
    }).catchError((e) {
      print(e);
    });
    await Future.delayed(Duration(seconds: 5));
  }

  Future _showNotification(String distance) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Akash More", "Tracker Mobile",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    await fltrnoti.show(
      0,
      "Location Uploaded",
      "Distance Cover : $distance KM",
      generalNotificationDetails,
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(minutes: 10), (timer) async {
      await _getCurrentLocation();
      String distance = await HomeApi().performUpload();
      if (distance != "") {
        _showNotification(distance);
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Location"),
        ),
        body: Obx(() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      "LAT: ${homePageController.newlat.value}, LNG: ${homePageController.newlong.value}"),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 50,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
