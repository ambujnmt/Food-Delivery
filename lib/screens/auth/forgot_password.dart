import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/screens/auth/otp_verify.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';
import 'package:food_delivery/utils/validation_rules.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  dynamic size;
  final customText = CustomText();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
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
                    vertical: size.height * 0.05,
                    horizontal: size.width * 0.03),
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
                    customText.kText(TextConstants.forgotPassword, 26,
                        FontWeight.w900, Colors.black, TextAlign.start),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    customText.kText(TextConstants.forgotDes, 16,
                        FontWeight.w600, Colors.black, TextAlign.start),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    CustomFormField2(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: ColorConstants.kTextFieldBorder,
                        size: 35,
                      ),
                      hintText: TextConstants.email,
                      validator: (value) => ValidationRules().email(value),
                    ),
                    const Spacer(),
                    CustomButton(
                      fontSize: 24,
                      hintText: TextConstants.continu,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPVerify(
                                email: emailController.text,
                                fromForgetPassword: "fromForgetPassword",
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
