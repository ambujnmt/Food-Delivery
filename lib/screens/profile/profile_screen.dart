import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/change_password.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'dart:developer';

import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic size;
  final customText = CustomText();
  final api = API();
  bool isEditable = false;
  bool isApiCalling = false;
  List<dynamic> getUserProfileList = [];

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  getUserProfileData() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.getUserProfile(
      token: loginController.accessToken,
      userId: loginController.userId.toString(),
    );

    setState(() {
      getUserProfileList = response['data'];
    });

    setState(() {
      isApiCalling = false;
    });
    print("user profile list data: ${getUserProfileList}");
    if (response["status"] == true) {
    } else {
      print('error message: ${response["message"]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.01),
          customText.kText(TextConstants.userProfile, 30, FontWeight.w900,
              Colors.black, TextAlign.center),
          Container(
            height: size.height * 0.25,
            width: size.width,
            margin: EdgeInsets.only(top: size.height * 0.05),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "assets/images/angleRect.png",
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  top: -35,
                  child: Container(
                    height: size.height * 0.13,
                    width: size.width * 0.4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: ColorConstants.kPrimary,
                          image: DecorationImage(
                            image: AssetImage("assets/images/doll.png"),
                            fit: BoxFit.contain,
                          ),
                          shape: BoxShape.circle,
                        )),
                  ),
                ),
                Positioned(
                  top: size.height * 0.05,
                  left: size.width * 0.57,
                  child: GestureDetector(
                    child: Container(
                      height: size.height * 0.04,
                      width: size.width * 0.09,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: ColorConstants.kPrimary, width: 1.5),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.03)),
                      child: const Center(
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                    onTap: () {
                      log("edit button pressed");
                      setState(() {
                        isEditable = true;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.06,
                  width: size.width,
                  // color: Colors.white,
                  child: Center(
                    child: customText.kText(
                        isEditable ? usernameController.text : "Hanna",
                        25,
                        FontWeight.w900,
                        Colors.white,
                        TextAlign.center),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            height: size.height * 0.4,
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: customText.kText(TextConstants.about, 30,
                      FontWeight.w700, Colors.black, TextAlign.center),
                ),
                Visibility(
                  visible: isEditable,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.01),
                    child: CustomFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(
                        Icons.account_circle,
                        color: ColorConstants.kPrimary,
                        size: 35,
                      ),
                      hintText: TextConstants.username,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        setState(() {});
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: CustomFormField(
                    readOnly: true,
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: ColorConstants.kPrimary,
                      size: 35,
                    ),
                    hintText: TextConstants.email,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      setState(() {});
                      return null;
                    },
                  ),
                ),
                CustomButton(
                  fontSize: 24,
                  hintText: TextConstants.changePassword,
                  onTap: () {
                    // change password
                    // sideDrawerController.index.value = 24;
                    // sideDrawerController.pageController
                    //     .jumpToPage(sideDrawerController.index.value);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePassword()),
                    );
                  },
                ),
                const Spacer(),
                GestureDetector(
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    decoration: BoxDecoration(
                        color: ColorConstants.kPrimary,
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 9.9,
                              color: Colors.black54)
                        ]),
                    child: Row(
                      children: [
                        const ImageIcon(
                          AssetImage("assets/images/delete.png"),
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: size.width * 0.15,
                        ),
                        customText.kText(TextConstants.accountDelete, 24,
                            FontWeight.w600, Colors.white, TextAlign.center),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          )
        ],
      ),
    ));
  }
}


//  SingleChildScrollView(
//               physics: const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 height: size.height * 0.3,
//                 width: size.width * 2,
//                 margin: EdgeInsets.only(top: size.height * 0.05),
//                 color: Colors.grey.shade400,
//                 child: Stack(
//                   alignment: Alignment.topCenter,
//                   children: [
//
//                     Transform(
//                       transform: Matrix4.skew(-0.18, 0.01),
//                       child: Transform.rotate(
//                         angle: -math.pi / 10,
//                         child: SingleChildScrollView(
//                           child: Container(
//                             height: size.height * 0.15,
//                             width: 4500,
//                             color: ColorConstants.kPrimary,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Positioned(
//                       left: size.width/2,
//                       child: Container(
//                         height: size.height * 0.1,
//                         width: size.width * 0.18,
//                         decoration: const BoxDecoration(
//                           color: ColorConstants.kPrimaryDark,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Container(
//                             margin: const EdgeInsets.all(5),
//                             decoration: const BoxDecoration(
//                               color: Colors.black38,
//                               image: DecorationImage(
//                                 image: AssetImage("assets/images/delivery_logo.png"),
//                               ),
//                               shape: BoxShape.circle,
//                             )
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             )

