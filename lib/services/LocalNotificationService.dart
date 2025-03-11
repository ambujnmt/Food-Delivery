import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =

    InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings()
      /*iOS: IOSInitializationSettings(onDidReceiveLocalNotification: onDidRecieveLocalNotification)*/);
    _notificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {

    log("foreground notification local");

    try {
      // final id =  DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            'CHANNEL-ID',
            'CHANNEL-NAME',
            // 'Description',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: DefaultStyleInformation(true, true),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          )
      );
      await _notificationsPlugin.show(message.hashCode, message.notification!.title,
          message.notification!.body, notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }


}

