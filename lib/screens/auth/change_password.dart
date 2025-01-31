import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/change_password_successfully.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_button2.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:food_delivery/utils/validation_rules.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final customText = CustomText();
  final api = API();
  final helper = Helper();
  bool isApiCalling = false;

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  changePassword() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.changePasswordFn(
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
      confirmNewPassword: confirmNewPasswordController.text,
    );

    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
      // sideDrawerController.previousIndex = sideDrawerController.index.value;
      sideDrawerController.previousIndex.add(sideDrawerController.index.value);
      sideDrawerController.index.value = 25;
      sideDrawerController.pageController
          .jumpToPage(sideDrawerController.index.value);
    } else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
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
                        image: AssetImage(
                            'assets/images/password_background.png'))),
              ),
            ),
            Positioned(
              top: height * .1, //200
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
                    Container(
                      child: customText.kText(
                        "${TextConstants.changePassword}",
                        24,
                        FontWeight.w900,
                        Colors.black,
                        TextAlign.start,
                      ),
                    ),
                    SizedBox(height: height * .020),
                    CustomFormField2(
                      controller: oldPasswordController,
                      hintText: TextConstants.oldPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Old Password is Required";
                        }
                      },
                    ),
                    SizedBox(height: height * .020),
                    CustomFormField2(
                      controller: newPasswordController,
                      validator: (value) =>
                          ValidationRules().passwordValidation(value),
                      hintText: TextConstants.newPassword,
                      suffixIcon: Icon(Icons.visibility),
                    ),
                    SizedBox(height: height * .020),
                    CustomFormField2(
                      controller: confirmNewPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        } else if (value != newPasswordController.text) {
                          return "Confirm password does not match";
                        }
                      },
                      hintText: TextConstants.confirmNewPassword,
                      suffixIcon: Icon(Icons.visibility),
                    ),
                    SizedBox(height: height * .2),
                    CustomButton(
                      loader: isApiCalling,
                      fontSize: 20,
                      hintText: TextConstants.continu,
                      onTap: () {
                        // place to your continue navigation
                        if (_formKey.currentState!.validate()) {
                          changePassword();
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
