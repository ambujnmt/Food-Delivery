import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/screens/auth/change_password_successfully.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_button2.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
            top: 200,
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
                    hintText: TextConstants.oldPassword,
                  ),
                  SizedBox(height: height * .020),
                  CustomFormField2(
                    hintText: TextConstants.newPassword,
                    suffixIcon: Icon(Icons.visibility),
                  ),
                  SizedBox(height: height * .020),
                  CustomFormField2(
                    hintText: TextConstants.confirmNewPassword,
                    suffixIcon: Icon(Icons.visibility),
                  ),
                  SizedBox(height: height * .2),
                  CustomButton(
                    fontSize: 20,
                    hintText: TextConstants.continu,
                    onTap: () {
                      // place to your continue navigation
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChangePasswordSuccessFully()),
                      );
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
