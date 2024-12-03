import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/screens/auth/forgot_password.dart';
import 'package:food_delivery/screens/auth/register_screen.dart';
import 'package:food_delivery/screens/side%20menu%20drawer/side_menu_drawer.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:food_delivery/utils/validation_rules.dart';
import 'dart:developer';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final customText = CustomText();
  dynamic size;
  bool isPassHidden = true, isRemindMe = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [

            SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/login_img.png"),
                ],
              ),
            ),

            Positioned(
              top: size.height * 0.26,
              child: Container(
                height: size.height * 0.7,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.05),
                    topRight: Radius.circular(size.width * 0.05),
                  )
                ),
                child: ListView(
                  children: [

                    customText.kText(TextConstants.kLogin, 32, FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
                    customText.kText(TextConstants.loginDes, 16, FontWeight.w400, ColorConstants.kPrimary, TextAlign.center),

                    SizedBox(height: size.height * 0.02,),
                    CustomFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => ValidationRules().email(value),
                      prefixIcon: const Icon(Icons.email, color: ColorConstants.kPrimary, size: 35,),
                      hintText: TextConstants.email,
                    ),

                    SizedBox(height: size.height * 0.02,),
                    CustomFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      validator: (value) => ValidationRules().password(value),
                      prefixIcon: const Icon(Icons.lock, color: ColorConstants.kPrimary, size: 35,),
                      hintText: TextConstants.password,
                      obsecure: isPassHidden,
                      suffixIcon: GestureDetector(
                        child: isPassHidden
                          ? const Icon(Icons.visibility_off, color: ColorConstants.kPrimary, size: 35,)
                          : const Icon(Icons.visibility, color: ColorConstants.kPrimary, size: 35,),
                        onTap: () {
                          setState(() {
                            isPassHidden = !isPassHidden;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: size.height * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: ColorConstants.kPrimary,
                                value: isRemindMe,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isRemindMe = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: size.width * 0.01,),
                            customText.kText(TextConstants.rememberMe, 16, FontWeight.w700, Colors.black, TextAlign.center),
                          ],
                        ),
                        GestureDetector(
                          child: customText.kText(TextConstants.forgotPassword, 16, FontWeight.w700, Colors.black, TextAlign.center),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword() ));
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.05,),
                    CustomButton(
                      fontSize: 24,
                      hintText: TextConstants.kLogin,
                      onTap: () {
                        log("login button pressed");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SideMenuDrawer() ));
                      },
                    ),

                    SizedBox(height: size.height * 0.02,),
                    CustomButton(
                      fontSize: 24,
                      hintText: TextConstants.register,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen() ));
                        log("register button pressed");
                      },
                    ),

                    SizedBox(height: size.height * 0.05,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.5,
                            color: ColorConstants.kPrimary,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                          child: customText.kText(TextConstants.loginWith, 20, FontWeight.w700, Colors.black, TextAlign.center),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.5,
                            color: ColorConstants.kPrimary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        
                        Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.05,
                              child: Image.asset("assets/images/google.png"),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                              child: customText.kText(TextConstants.google, 14, FontWeight.w400, Colors.black, TextAlign.center),
                            )
                          ],
                        ),

                        Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.05,
                              child: Image.asset("assets/images/facebook.png"),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                              child: customText.kText(TextConstants.facebook, 14, FontWeight.w400, Colors.black, TextAlign.center),
                            )
                          ],
                        ),

                        Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.05,
                              child: Image.asset("assets/images/twitter.png"),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                              child: customText.kText(TextConstants.twitter, 14, FontWeight.w400, Colors.black, TextAlign.center),
                            )
                          ],
                        ),

                      ],
                    )

                  ],
                ),
              ),
            ),

          ],
        )
      ),
    );
  }
}
