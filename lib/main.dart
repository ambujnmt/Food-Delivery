import 'dart:io';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_delivery/screens/splash_screen.dart';
import 'package:food_delivery/services/LocalNotificationService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyBNcKFAsgziY3qUi0br3YlM-TPYgIyAnno',
      appId: '1:651739597057:android:55edac1d6ba6e7d676f300',
      messagingSenderId: '651739597057',
      projectId: 'getfooddelivery-37b38',
      storageBucket: 'getfooddelivery-37b38.firebasestorage.app',
    ));
  } else {
    await Firebase.initializeApp();
    // await Firebase.initializeApp(
    //     options: const FirebaseOptions(
    //   apiKey: 'AIzaSyBNcKFAsgziY3qUi0br3YlM-TPYgIyAnno',
    //   appId: '1:651739597057:ios:c868f790d6f5db7d76f300',
    //   messagingSenderId: '651739597057',
    //   projectId: 'getfooddelivery-37b38',
    //   storageBucket: 'getfooddelivery-37b38.firebasestorage.app',
    // ));
  }

  // String? apnToken = await FirebaseMessaging.instance.getAPNSToken();
  // log("apn token :- $apnToken");

  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print("fcm token :- $fcmToken");

  LocalNotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    const MyApp(),
  );
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  // NotificationController notificationController = Get.put( NotificationController() );

  print("my background message :- ${message.notification}");

  Map<String, String> data = {
    "title": message.notification!.title!,
    "body": message.notification!.body!,
  };

  // Map<String, String> data = {
  //   "title": message.notification!.title!,
  //   "body": message.notification!.body!.split(".")[0].toString(),
  //   "jobId": message.notification!.body!.split(".")[1].toString()
  // };

  // notificationController.notificationData = data;

  displayNotification(data);
}

void displayNotification(Map<String, dynamic> data) {
  // log("display notification called with data :- $data");

  var iOSPlatformChannelSpecifics;
  iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
