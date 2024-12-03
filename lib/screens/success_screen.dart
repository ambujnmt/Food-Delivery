import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';

class SuccessScreen extends StatefulWidget {

  final String? msg;
  const SuccessScreen({super.key, this.msg});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {

  dynamic size;
  final customText = CustomText();

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
                            fit: BoxFit.cover
                        )
                    ),
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
              padding: EdgeInsets.symmetric(vertical: size.height * 0.03, horizontal: size.width * 0.03),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.08),
                  boxShadow: const  [
                    BoxShadow(
                        offset: Offset(10, 10),
                        blurRadius: 20,
                        color: Colors.black26
                    ),
                    BoxShadow(
                        offset: Offset(-10, -10),
                        blurRadius: 20,
                        color: Colors.black26
                    )
                  ]
              ),
              child: Column(
                children: [

                  Container(
                    height: size.height * 0.2,
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorConstants.kPrimary, width: 3),
                    ),
                    child: Center(
                      child: Container(
                        height: size.height * 0.075,
                        width: size.width * 0.17,
                        decoration: BoxDecoration(
                          color: ColorConstants.kPrimary,
                          borderRadius: BorderRadius.circular(size.width * 0.03)
                        ),
                        child: const Center(
                          child: Icon(Icons.check, color: Colors.white, size: 60,),
                        ),
                      ),
                    ),
                  ),

                  customText.kText(TextConstants.successful, 35, FontWeight.w900, Colors.black, TextAlign.center),
                  SizedBox(height: size.height * 0.01,),
                  customText.kText(TextConstants.passwordCreateSuccessDes, 16, FontWeight.w600, Colors.black, TextAlign.center),

                  const Spacer(),

                  CustomButton(
                    fontSize: 24,
                    hintText: TextConstants.backToLogin,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen() ));
                    },
                  )

                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
