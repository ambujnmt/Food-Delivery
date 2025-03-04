import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/screens/home/home_screen.dart';
import 'package:food_delivery/screens/side%20menu%20drawer/side_menu_drawer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  dynamic size;
  LoginController loginController = Get.put(LoginController());

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
          builder: (context) => const SideMenuDrawer(), // LoginScreen
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
