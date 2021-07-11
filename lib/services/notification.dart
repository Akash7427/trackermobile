import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class Notification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future showNotificationWithoutSound(Position position) async {
    print(position.toString());
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '1', 'location-bg', 'fetch location in background',
        playSound: true, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Location fetched',
      position.toString(),
      platformChannelSpecifics,
      payload: '',
    );
  }

  Future showDistanceNotificationWithoutSound(String distance) async {
    print(distance.toString());
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '1', 'location-bg', 'fetch location in background',
        playSound: true, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Distance Covered',
      distance.toString(),
      platformChannelSpecifics,
      payload: '',
    );
  }

  Notification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}
