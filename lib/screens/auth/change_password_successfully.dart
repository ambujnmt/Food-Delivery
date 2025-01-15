import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/home/home_screen.dart';
import 'package:food_delivery/screens/profile/profile_screen.dart';
import 'package:food_delivery/screens/side%20menu%20drawer/side_menu_drawer.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:get/get.dart';

class ChangePasswordSuccessFully extends StatefulWidget {
  const ChangePasswordSuccessFully({super.key});

  @override
  State<ChangePasswordSuccessFully> createState() =>
      _ChangePasswordSuccessFullyState();
}

class _ChangePasswordSuccessFullyState
    extends State<ChangePasswordSuccessFully> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  final customText = CustomText();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height * .40,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          AssetImage('assets/images/password_background.png'))),
            ),
          ),
          Positioned(
            top: height * .050, //200
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(20),
              height: height * .7,
              width: width * .5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstants.lightGreyColor,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ColorConstants.kPrimary, width: 5)),
                      child:
                          Center(child: Image.asset("assets/images/done.png")),
                    ),
                  ),
                  SizedBox(height: height * .020),
                  Center(
                    child: Container(
                      child: customText.kText(TextConstants.successfull, 20,
                          FontWeight.bold, Colors.black, TextAlign.center),
                    ),
                  ),
                  SizedBox(height: height * .020),
                  Center(
                    child: Container(
                      child: customText.kText(TextConstants.successMessage, 20,
                          FontWeight.bold, Colors.black, TextAlign.center),
                    ),
                  ),
                  SizedBox(height: height * .04),
                  CustomButton(
                    fontSize: 20,
                    hintText: TextConstants.goToHome,
                    onTap: () {
                      // place to your continue navigation
                      sideDrawerController.index.value = 13;
                      sideDrawerController.pageController
                          .jumpToPage(sideDrawerController.index.value);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
