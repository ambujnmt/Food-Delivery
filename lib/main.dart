import 'dart:io';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/splash_screen.dart';
import 'package:food_delivery/services/LocalNotificationService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51K42bBK85ncznIeaQyiRwBGUPxbBKDZwh6H2vH7ealFYm59JaVBzLc0FetJOq1mEur8zoqAzVAOCxYWIBqwc1Xpz00NYC9SZGs"; // Get from Stripe Dashboard
  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyDK-kTQPkFXujG1cZHtM6osuh-tzW0WVhI',
      appId: '1:137257705773:android:b1616a041b673c2683f3a4',
      messagingSenderId: '137257705773',
      projectId: 'getfoodapp-5eaee',
      storageBucket: 'getfoodapp-5eaee.firebasestorage.app',
    ));
  } else if (Platform.isIOS) {
    log("ios firebase setup initialize");
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDK-kTQPkFXujG1cZHtM6osuh-tzW0WVhI',
          appId: '1:137257705773:android:b1616a041b673c2683f3a4',
          messagingSenderId: '137257705773',
          projectId: 'getfoodapp-5eaee',
          storageBucket: 'getfoodapp-5eaee.firebasestorage.app',
    ));
    log("ios firebase initialize done");
  }
  log("firebase setup complete");
  try {
    SideDrawerController sideDrawerController = Get.put(SideDrawerController());
    log("in try block");
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    sideDrawerController.fcmTokenForRegisterUser = fcmToken.toString();
    print("fcm token :- $fcmToken");
    print(
        "side controller fcm token value: ${sideDrawerController.fcmTokenForRegisterUser}");
  } catch (error) {
    log("error in fcm token :- $error");
  }
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // handle message here
    log("foreground notification message :- ${message.notification}");

    LocalNotificationService.display(message);
    // Map<String, String> data = {
    //   "title": message.notification!.title!,
    //   "body": message.notification!.body!,
    // };
    //
    // displayNotification(data);
  });
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
  log("display notification called with data :- $data");

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
