import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/forgot_password.dart';
import 'package:food_delivery/screens/auth/register_screen.dart';
import 'package:food_delivery/screens/side%20menu%20drawer/side_menu_drawer.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:food_delivery/utils/validation_rules.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final customText = CustomText();
  dynamic size;
  bool isPassHidden = true, isRemindMe = false;
  final helper = Helper();
  final api = API();
  final box = GetStorage();
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String googleUserName = "";
  String googleAccessToken = "";
  bool isApiCalling = false;

  login() async {
    setState(() {
      isApiCalling = true;
    });

    final response =
        await api.login(emailController.text, passwordController.text);

    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print("login screen token: ${response['token']} ");
      print("login screen userId: ${response['user_id']} ");
      loginController.accessToken = response['token'];
      loginController.userId = response['user_id'];

      box.write('accessToken', response['token']);
      box.write('userId', response['user_id']);

      print(" check read token : ${box.read("accessToken")}");

      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
      sideDrawerController.index.value = 0;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SideMenuDrawer()),
      );
    } else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
    }
  }

  // sign in with twitter login
  // var twitterLogin = TwitterLogin(
  //   apiKey: "NBDUoqQStGnsJdMBeN3z1ddGC",
  //   apiSecretKey: "lSFMV8r3WmBZNyYCdrpTeAfdhZw4BEw5TOdUON9sUlQQCxXR4b",
  //   redirectURI: "https://getfooddelivery.com/login/twitter/callback",
  // );

  // Future<UserCredential> signInWithTwitter() async {
  //   try {
  //     // Create a TwitterLogin instance
  //     final twitterLogin = new TwitterLogin(
  //         apiKey: 'NBDUoqQStGnsJdMBeN3z1ddGC',
  //         apiSecretKey: 'lSFMV8r3WmBZNyYCdrpTeAfdhZw4BEw5TOdUON9sUlQQCxXR4b',
  //         redirectURI: 'https://getfooddelivery.com/login/twitter/callback');

  //     // Trigger the sign-in flow
  //     final authResult = await twitterLogin.login();

  //     // Create a credential from the access token
  //     final twitterAuthCredential = TwitterAuthProvider.credential(
  //       accessToken: authResult.authToken!,
  //       secret: authResult.authTokenSecret!,
  //     );

  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance
  //         .signInWithCredential(twitterAuthCredential);
  //   } catch (e) {
  //     print("error in twitter login : ${e.toString()}");
  //   }
  //   return UserCredential();
  // }

  // latest code

  Future<UserCredential?> signInWithTwitter() async {
    try {
      // Create a TwitterLogin instance
      final twitterLogin = TwitterLogin(
        apiKey: 'NBDUoqQStGnsJdMBeN3z1ddGC',
        apiSecretKey: 'lSFMV8r3WmBZNyYCdrpTeAfdhZw4BEw5TOdUON9sUlQQCxXR4b',
        redirectURI:
            'https://food-delivery-a9bae.firebaseapp.com/__/auth/handler',
      );

      // Trigger the sign-in flow
      final authResult = await twitterLogin.login();
      print("twitter auth result: ${authResult}");

      // Check if the user canceled the login or authentication failed
      if (authResult == null ||
          authResult.authToken == null ||
          authResult.authTokenSecret == null) {
        print('Twitter login failed or was cancelled by the user.');
        return null; // Return null to indicate failure
      }

      // Create a credential from the access token
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      // Once signed in, return the UserCredential
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);

      print('Twitter sign-in successful: ${userCredential.user?.displayName}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific errors
      print('Firebase Auth Error: ${e.message}');
      return null;
    } catch (e) {
      // Handle any other errors
      print('An unexpected error occurred: $e');
      return null;
    }
  }

  // sign in with google
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        setState(() {
          googleAccessToken = credential.accessToken ?? "";
          googleUserName = userCredential.user!.displayName ?? "";
        });

        print("access token: $googleAccessToken");
        print("User Details: ${userCredential.user}");

        helper.successDialog(context, "User Logged in successfully");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SideMenuDrawer()));
      }
    } catch (e) {
      print("error in google sign in : ${e.toString()}");
      helper.errorDialog(context, "Login Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SafeArea(
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
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * 0.05),
                      topRight: Radius.circular(size.width * 0.05),
                    )),
                child: ListView(
                  children: [
                    customText.kText(TextConstants.kLogin, 32, FontWeight.w700,
                        ColorConstants.kPrimary, TextAlign.center),
                    customText.kText(
                        TextConstants.loginDes,
                        16,
                        FontWeight.w400,
                        ColorConstants.kPrimary,
                        TextAlign.center),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => ValidationRules().email(value),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: ColorConstants.kPrimary,
                        size: 35,
                      ),
                      hintText: TextConstants.email,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          ValidationRules().passwordValidation(value),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: ColorConstants.kPrimary,
                        size: 35,
                      ),
                      hintText: TextConstants.password,
                      obsecure: isPassHidden,
                      suffixIcon: GestureDetector(
                        child: isPassHidden
                            ? const Icon(
                                Icons.visibility_off,
                                color: ColorConstants.kPrimary,
                                size: 35,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: ColorConstants.kPrimary,
                                size: 35,
                              ),
                        onTap: () {
                          setState(() {
                            isPassHidden = !isPassHidden;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
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
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            customText.kText(
                                TextConstants.rememberMe,
                                16,
                                FontWeight.w700,
                                Colors.black,
                                TextAlign.center),
                          ],
                        ),
                        GestureDetector(
                          child: customText.kText(
                              TextConstants.forgotPassword,
                              16,
                              FontWeight.w700,
                              Colors.black,
                              TextAlign.center),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()));
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    CustomButton(
                      loader: isApiCalling,
                      fontSize: 24,
                      hintText: TextConstants.kLogin,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          print("hello");
                          login();
                        }
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomButton(
                      fontSize: 24,
                      hintText: TextConstants.register,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                        log("register button pressed");
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.5,
                            color: ColorConstants.kPrimary,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02),
                          child: customText.kText(TextConstants.loginWith, 20,
                              FontWeight.w700, Colors.black, TextAlign.center),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.5,
                            color: ColorConstants.kPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          // place your google sign in
                          onTap: () {
                            signInWithGoogle();
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                                child: Image.asset("assets/images/google.png"),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                                child: customText.kText(
                                    TextConstants.google,
                                    14,
                                    FontWeight.w400,
                                    Colors.black,
                                    TextAlign.center),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: width * .080),
                        // GestureDetector(
                        //   onTap: () {
                        //     // login with the twiiter
                        //   },
                        //   child: Column(
                        //     children: [
                        //       SizedBox(
                        //         height: size.height * 0.05,
                        //         child:
                        //             Image.asset("assets/images/facebook.png"),
                        //       ),
                        //       SizedBox(
                        //         height: size.height * 0.03,
                        //         child: customText.kText(
                        //             TextConstants.facebook,
                        //             14,
                        //             FontWeight.w400,
                        //             Colors.black,
                        //             TextAlign.center),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            // signInWithTwitter();
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                                child: Image.asset("assets/images/twitter.png"),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                                child: customText.kText(
                                    TextConstants.twitter,
                                    14,
                                    FontWeight.w400,
                                    Colors.black,
                                    TextAlign.center),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
