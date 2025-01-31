import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
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
      apiKey: 'AIzaSyAsesfyoKszcGw3EtOK_H9Dyrm9ZfrcSFI',
      appId: '1:834775487947:android:4b222ff7550329fd36124e',
      messagingSenderId: '834775487947',
      projectId: 'get-food-4b4a4',
      storageBucket: 'get-food-4b4a4.firebasestorage.app',
    ));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyAsesfyoKszcGw3EtOK_H9Dyrm9ZfrcSFI',
      appId: '1:834775487947:ios:39766ea5a1034fa336124e',
      messagingSenderId: '834775487947',
      projectId: 'get-food-4b4a4',
      storageBucket: 'get-food-4b4a4.firebasestorage.app',
    ));
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
