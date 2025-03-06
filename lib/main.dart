import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
// AIzaSyAsesfyoKszcGw3EtOK_H9Dyrm9ZfrcSFI
// AIzaSyCUIbWuGvAx52YMoyoTcScBpoc2CB7TEiA
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyBNcKFAsgziY3qUi0br3YlM-TPYgIyAnno',
      appId: '1:651739597057:android:55edac1d6ba6e7d676f300',
      messagingSenderId: '651739597057',
      projectId: 'getfooddelivery-37b38',
      storageBucket: 'getfooddelivery-37b38.firebasestorage.app',
    ));
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm token : $fcmToken");
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyBNcKFAsgziY3qUi0br3YlM-TPYgIyAnno',
      appId: '1:651739597057:ios:c868f790d6f5db7d76f300',
      messagingSenderId: '651739597057',
      projectId: 'getfooddelivery-37b38',
      storageBucket: 'getfooddelivery-37b38.firebasestorage.app',
    ));
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm token : $fcmToken");
  }

  runApp(
    const MyApp(),
  );
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
