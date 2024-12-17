import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCUIbWuGvAx52YMoyoTcScBpoc2CB7TEiA',
    appId: '1:436163669484:android:d33d893cdcbcb1f26ee4c9',
    messagingSenderId: '436163669484',
    projectId: 'food-delivery-a9bae',
    storageBucket: 'food-delivery-a9bae.firebasestorage.app',
  )); // Initialize Firebase
  // const firebaseConfig = {
  //   apiKey: "AIzaSyDaT7mZYR02_egq3iaPxqt6FF5ReG1kE_I",
  //   authDomain: "food-delivery-a9bae.firebaseapp.com",
  //   projectId: "food-delivery-a9bae",
  //   storageBucket: "food-delivery-a9bae.firebasestorage.app",
  //   messagingSenderId: "436163669484",
  //   appId: "1:436163669484:web:c8d313381a0f38956ee4c9",
  //   measurementId: "G-7C8NJDS169"
  // };
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
