import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
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
import 'dart:developer' as test;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  String googleEmail = "";
  String googlePhoneNumber = "";
  String googlePhotoURL = "";

  bool isApiCalling = false;
  bool rememberMe = false;

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  login() async {
    setState(() {
      isApiCalling = true;
    });

    final response =
        await api.login(
            emailController.text,
            passwordController.text,
        );

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
  // Future<UserCredential?> signInWithTwitter() async {
  //   try {
  //     print("hello twitter login");
  //     // Create a TwitterLogin instance
  //     final twitterLogin = TwitterLogin(
  //       apiKey: 'NBDUoqQStGnsJdMBeN3z1ddGC',
  //       apiSecretKey: 'lSFMV8r3WmBZNyYCdrpTeAfdhZw4BEw5TOdUON9sUlQQCxXR4b',
  //       redirectURI:
  //           'https://food-delivery-a9bae.firebaseapp.com/__/auth/handler',
  //       // redirectURI: "https://getfooddelivery.com/login/twitter/callback",
  //     );
  //
  //     // Trigger the sign-in flow
  //     final authResult = await twitterLogin.login();
  //     print("twitter auth result: ${authResult}");
  //     // Check if the user canceled the login or authentication failed
  //     if (authResult == null ||
  //         authResult.authToken == null ||
  //         authResult.authTokenSecret == null) {
  //       print('Twitter login failed or was cancelled by the user.');
  //       return null; // Return null to indicate failure
  //     }
  //
  //     // Create a credential from the access token
  //     final twitterAuthCredential = TwitterAuthProvider.credential(
  //       accessToken: authResult.authToken!,
  //       secret: authResult.authTokenSecret!,
  //     );
  //
  //     // Once signed in, return the UserCredential
  //     final userCredential = await FirebaseAuth.instance
  //         .signInWithCredential(twitterAuthCredential);
  //
  //     print('Twitter sign-in successful: ${userCredential.user?.displayName}');
  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     // Handle Firebase specific errors
  //     print('Firebase Auth Error: ${e.message}');
  //     return null;
  //   } catch (e) {
  //     // Handle any other errors
  //     print('An unexpected error occurred: $e');
  //     return null;
  //   }
  // }

  // sign in with google
  // signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     if (googleUser == null) {
  //       return;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     UserCredential userCredential =
  //         await _firebaseAuth.signInWithCredential(credential);
  //
  //     print('user credentials: $userCredential');
  //
  //     if (userCredential.user != null) {
  //       setState(() {
  //         googleAccessToken = credential.accessToken ?? "";
  //         googleUserName = userCredential.user!.displayName ?? "";
  //         googleEmail = userCredential.user!.email ?? "";
  //         googlePhotoURL = userCredential.user!.photoURL ?? "";
  //         googlePhoneNumber = userCredential.user!.phoneNumber ?? "";
  //       });
  //
  //       print("User Details: ${userCredential.user}");
  //       print(
  //           "all details: gtoken: $googleAccessToken ,gname: $googleUserName, gemail: $googleEmail, gPhotoURL: $googlePhotoURL, gPhone: $googlePhoneNumber");
  //       var response;
  //       response = await api.loginWithGoogleOrTwitter(
  //           email: googleEmail,
  //           type: "google",
  //           name: googleUserName,
  //           phone: googlePhoneNumber,
  //           image: googlePhotoURL,
  //           token: googleAccessToken);
  //       if (response['status'] == true) {
  //         print("login screen token: ${response['token']}");
  //         print("login screen userId: ${response['user_id']}");
  //         loginController.accessToken = response['token'];
  //         loginController.userId = response['user_id'];
  //
  //         box.write('accessToken', response['token']);
  //         box.write('userId', response['user_id']);
  //
  //         print(" check read token : ${box.read("accessToken")}");
  //
  //         print('success message: ${response["message"]}');
  //         helper.successDialog(context, response["message"]);
  //         sideDrawerController.index.value = 0;
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const SideMenuDrawer()),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print("error in google sign in : ${e.toString()}");
  //     helper.errorDialog(context, "Login Failed");
  //   }
  // }

  signInWithGoogle() async {

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {

      setState(() {
        googleAccessToken = credential.accessToken ?? "";
        googleUserName = userCredential.user!.displayName ?? "";
        googleEmail = userCredential.user!.email ?? "";
        googlePhotoURL = userCredential.user!.photoURL ?? "";
        googlePhoneNumber = userCredential.user!.phoneNumber ?? "";
      });


      final response = await api.loginWithGoogleOrTwitter(
          email: googleEmail,
          type: "google",
          name: googleUserName,
          phone: googlePhoneNumber,
          image: googlePhotoURL,
          token: googleAccessToken);

      if(response["status"] == true) {
        loginController.accessToken = response['token'];
        loginController.userId = response['user_id'];

        box.write('accessToken', response['token']);
        box.write('userId', response['user_id']);

        helper.successDialog(context, response["message"]);
        sideDrawerController.index.value = 0;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SideMenuDrawer()),
        );
      }

    }

  }

  signInWithApple() async {

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    // return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    if (userCredential.user != null) {

      test.log("user credentials  :- $userCredential, and oauth credentials :-  ${oauthCredential.accessToken}");
      test.log("user credentials :- ${userCredential.user!.email}");

      setState(() {
        googleAccessToken = oauthCredential.accessToken ?? "";
        googleEmail = userCredential.user!.email ?? "";
      });

      test.log("google access token :- $googleAccessToken, google email :- $googleEmail");
      test.log("api called for registration ");
      final response = await api.loginWithGoogleOrTwitter(
          email: googleEmail,
          type: "apple",
          token: googleAccessToken);

      if(response["status"] == true) {
        loginController.accessToken = response['token'];
        loginController.userId = response['user_id'];

        box.write('accessToken', response['token']);
        box.write('userId', response['user_id']);

        helper.successDialog(context, response["message"]);
        sideDrawerController.index.value = 0;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SideMenuDrawer()),
        );
      }

    }

  }

  void saveRememberMe(bool value) {
    if (value) {
      box.write('email', emailController.text);
      box.write('remember_me', true);
    } else {
      box.remove('email');
      box.write('remember_me', false);
    }
  }

  @override
  void initState() {
    emailController.text = box.read('email') ?? '';
    rememberMe = box.read('remember_me') ?? false;
    super.initState();
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
                                value: rememberMe,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                  saveRememberMe(value!);
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
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
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
                      mainAxisAlignment: Platform.isIOS ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
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
                                  TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        // SizedBox(width: width * .080),
                        Platform.isIOS
                        ? GestureDetector(
                            onTap: () {
                              // signInWithTwitter();
                              signInWithApple();
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.05,
                                  child: Image.asset("assets/images/appleLogo.png"),
                                ),
                                SizedBox(
                                  height: size.height * 0.03,
                                  child: customText.kText(
                                      TextConstants.apple,
                                      14,
                                      FontWeight.w400,
                                      Colors.black,
                                      TextAlign.center),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
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
