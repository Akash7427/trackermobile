import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackermobile/controller/homepage_controller.dart';
import 'package:trackermobile/services/home_api.dart';
import 'package:trackermobile/shared/size_config.dart';
import 'package:workmanager/workmanager.dart';
import 'package:trackermobile/services/notification.dart' as notif;

const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        Geolocator geoLocator = Geolocator()
          ..forceAndroidLocationManager = true;
        Position userLocation = await geoLocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        notif.Notification notification = new notif.Notification();
        notification.showNotificationWithoutSound(userLocation);
        break;
    }
    return Future.value(true);
  });
}

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

    Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    Workmanager.registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: Duration(minutes: 15),
    );

    _getCurrentLocation();
    upload();
  }

  void upload() async {
    String distance = await HomeApi().performUpload();
    if (distance != "") {
      notif.Notification notification = new notif.Notification();
      notification.showDistanceNotificationWithoutSound(distance);
    }
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
    Timer.periodic(Duration(minutes: 15), (timer) async {
      await _getCurrentLocation();
      String distance = await HomeApi().performUpload();
      if (distance != "") {
        notif.Notification notification = new notif.Notification();
        notification.showDistanceNotificationWithoutSound(distance);
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
