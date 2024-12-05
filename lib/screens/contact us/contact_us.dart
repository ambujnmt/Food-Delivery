import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_footer.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  dynamic size;
  final customText = CustomText();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                height: size.height * 0.07,
                width: size.width,
                margin: EdgeInsets.only(bottom: size.height * 0.02),
                child: Center(
                  child: customText.kText(TextConstants.contactUs, 25, FontWeight.w900, ColorConstants.kPrimary, TextAlign.center),
                ),
              ),

              SizedBox(
                width: size.width * 0.5,
                child: customText.kText("Any question or remarks? Just write us a message!", 16, FontWeight.w500, ColorConstants.kDashGrey, TextAlign.start),
              ),

              Container(
                height: size.height * 0.52,
                width: size.width * 0.85,
                margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                decoration: BoxDecoration(
                  color: ColorConstants.kPrimary,
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                ),
                child: Center(
                  child: Column(
                    children: [
                      
                      customText.kText(TextConstants.contactInfo, 20, FontWeight.w700, Colors.white, TextAlign.center),

                      SizedBox(height: size.height * 0.03),
                      const Icon(Icons.call, size: 35, color: Colors.white,),
                      customText.kText("+1012 3456 789", 20, FontWeight.w700, Colors.white, TextAlign.center),

                      SizedBox(height: size.height * 0.03),
                      const Icon(Icons.email, size: 35, color: Colors.white,),
                      customText.kText("demo@gmail.com", 20, FontWeight.w700, Colors.white, TextAlign.center),

                      SizedBox(height: size.height * 0.03),
                      const Icon(Icons.location_on, size: 35, color: Colors.white,),
                      customText.kText("132 Dartmouth Street Boston, Massachusetts 02156 United States", 20, FontWeight.w700, Colors.white, TextAlign.center, TextOverflow.visible, 4),

                      const Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          SizedBox(
                            height: size.height * 0.04,
                            child: Image.asset("assets/images/google.png"),
                          ),

                          SizedBox(
                            height: size.height * 0.04,
                            child: Image.asset("assets/images/facebook.png"),
                          ),

                          SizedBox(
                            height: size.height * 0.04,
                            child: Image.asset("assets/images/twitter.png"),
                          ),

                        ],
                      )

                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  children: [

                    CustomFormField2(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      hintText: TextConstants.name,
                      prefixIcon: const Icon(Icons.person, color: ColorConstants.kPrimary, size: 35,),
                    ),

                    SizedBox(height: size.height * 0.02),

                    CustomFormField2(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      hintText: TextConstants.phoneNo,
                      prefixIcon: const Icon(Icons.call, color: ColorConstants.kPrimary, size: 35,),
                    ),

                    SizedBox(height: size.height * 0.02),

                    CustomFormField2(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email, color: ColorConstants.kPrimary, size: 35,),
                      hintText: TextConstants.email,
                    ),

                    SizedBox(height: size.height * 0.02),

                    CustomFormField2(
                      controller: addressController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.location_on, color: ColorConstants.kPrimary, size: 35,),
                      hintText: TextConstants.location,
                    ),

                    SizedBox(height: size.height * 0.02),

                    CustomFormField2(
                      controller: messageController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.multiline,
                      prefixIcon: const Icon(Icons.message, color: ColorConstants.kPrimary, size: 35,),
                      hintText: TextConstants.message,
                    ),

                    SizedBox(height: size.height * 0.03),

                    CustomButton(
                      fontSize: 18,
                      hintText: TextConstants.send,
                    ),

                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),

              CustomFooter(),

            ],
          ),
        )
      )
    );
  }
}
