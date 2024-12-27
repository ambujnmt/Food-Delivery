import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/create_password.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';

import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OTPVerify extends StatefulWidget {
  final String? email;
  final String? fromForgetPassword;
  const OTPVerify({
    super.key,
    this.email,
    this.fromForgetPassword,
  });

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  dynamic size;
  final customText = CustomText();
  final api = API();
  final helper = Helper();
  bool isApiCalling = false;
  bool isResetApiCalling = false;
  String inputPinValue = "";
  bool validOtpValidation = false;

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  // verify otp

  verifyOtp() async {
    if (inputPinValue.length != 4) {
      setState(() {
        validOtpValidation = true;
      });
    }
    setState(() {
      isApiCalling = true;
    });

    final response = await api.otpVerification(
      email: widget.email,
      otp: inputPinValue,
    );

    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
      widget.fromForgetPassword == "fromForgetPassword"
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePassword(
                  email: widget.email,
                ),
              ),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
    } else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
    }
  }

  // resend otp

  resendOtpVerification() async {
    setState(() {
      isResetApiCalling = true;
    });

    final response = await api.resendOtp(email: widget.email);

    setState(() {
      isResetApiCalling = false;
    });

    if (response["status"] == true) {
      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
    } else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("Email is: ${widget.email}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.35,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: ColorConstants.kPrimary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(size.width * 0.15),
                          bottomRight: Radius.circular(size.width * 0.15),
                        ),
                        image: const DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage("assets/images/foodsBGImg.png"),
                            fit: BoxFit.cover)),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: size.height * 0.6,
              width: size.width * 0.81,
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.05, horizontal: size.width * 0.03),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.08),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(10, 10),
                        blurRadius: 20,
                        color: Colors.black26),
                    BoxShadow(
                        offset: Offset(-10, -10),
                        blurRadius: 20,
                        color: Colors.black26)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText.kText(TextConstants.otpVerify, 26, FontWeight.bold,
                      Colors.black, TextAlign.start),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  customText.kText(TextConstants.otpDes, 16, FontWeight.w600,
                      Colors.black, TextAlign.start, TextOverflow.ellipsis, 3),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Container(
                    // width: size.width * .2,
                    margin: EdgeInsets.all(10),
                    child: OTPTextField(
                      keyboardType: TextInputType.number,
                      outlineBorderRadius: 36,
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 40,
                      style: TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      otpFieldStyle: OtpFieldStyle(
                        backgroundColor: Colors.grey.shade400,
                      ),
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                        inputPinValue = pin;
                        print("imput pin value: ${inputPinValue}");
                        setState(() {});
                      },
                      onChanged: (value) {
                        inputPinValue = value;
                      },
                    ),
                  ),
                  Visibility(
                    // visible: inputPinValue.length != 4,
                    visible: validOtpValidation,
                    child: Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: customText.kText(
                          "Please enter valid OTP",
                          12,
                          FontWeight.bold,
                          ColorConstants.errorColor,
                          TextAlign.start),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .050,
                  ),
                  Center(
                    child: customText.kText(TextConstants.didNotGetCode, 20,
                        FontWeight.bold, Colors.black, TextAlign.start),
                  ),
                  SizedBox(
                    height: size.height * .010,
                  ),
                  // Center(
                  //   child: customText.kText(TextConstants.resendCode, 14,
                  //       FontWeight.w800, Colors.black, TextAlign.start),
                  // ),
                  Center(
                    child: Container(
                      child: RichText(
                        text: const TextSpan(
                          text: '',
                          // style: DefaultTextStyle.of(context).style,
                          children: const <TextSpan>[
                            TextSpan(
                              text: TextConstants.resendCode,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: "Raleway",
                              ),
                            ),
                            TextSpan(
                              text: ' 55',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.blue,
                                fontFamily: "Raleway",
                              ),
                            ),
                            TextSpan(
                              text: ' s',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: "Raleway",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .005,
                  ),
                  isResetApiCalling
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary,
                        ))
                      : GestureDetector(
                          onTap: () {
                            resendOtpVerification();
                            print("resend tap");
                          },
                          child: Center(
                            child: customText.kText(TextConstants.resend, 20,
                                FontWeight.bold, Colors.black, TextAlign.start),
                          ),
                        ),
                  const Spacer(),
                  CustomButton(
                    loader: isApiCalling,
                    fontSize: 24,
                    hintText: TextConstants.confirm,
                    onTap: () {
                      if (inputPinValue.isEmpty) {
                        print("otp is empty");
                      } else if (inputPinValue.length != 4) {
                        print("length does not match");
                      }

                      verifyOtp();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
