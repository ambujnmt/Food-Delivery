import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic size;

  @override
  void initState() {
    super.initState();
    moveForward();
  }

  moveForward() async {
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorConstants.kPrimary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.15,
                width: size.width * 0.5,
                child: Image.asset("assets/images/delivery_logo.png"),
              ),
              SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.9,
                child: Image.asset("assets/images/name_logo.png"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
