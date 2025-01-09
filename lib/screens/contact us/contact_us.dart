import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/side%20menu%20drawer/side_menu_drawer.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_footer.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:food_delivery/utils/validation_rules.dart';
import 'package:get/get.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  dynamic size;
  final customText = CustomText();
  final helper = Helper();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  String contactEmail = "";
  String contactPhone = "";
  String contactAddress = "";

  bool isApiCalling = false;
  bool postInformationCalling = false;
  final api = API();

  Map<String, dynamic> homeInfoMap = {};

  // contact information
  contactInformation() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.homeContactInfo();
    setState(() {
      homeInfoMap = response['data'];
      contactPhone = homeInfoMap['phone'];
      contactEmail = homeInfoMap['email'];
      contactAddress = homeInfoMap['address'];
      print("contact phone: $contactPhone");
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print('contact us success message: ${response["message"]}');
    } else {
      print('contact us  error message: ${response["message"]}');
    }
  }

  // post contact us information
  sendInformation() async {
    setState(() {
      postInformationCalling = true;
    });

    final response = await api.postContactInformation(
      name: nameController.text,
      phoneNumber: phoneController.text,
      email: emailController.text,
      address: addressController.text,
      message: messageController.text,
    );

    setState(() {
      postInformationCalling = false;
    });

    if (response["status"] == "success") {
      helper.successDialog(context, response['message']);

      print(' post information success message: ${response["message"]}');
      sideDrawerController.index.value = 0;
      sideDrawerController.pageController
          .jumpToPage(sideDrawerController.index.value);
    } else {
      helper.successDialog(context, response['message']);
      print('post infromation error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    contactInformation();
    super.initState();
  }

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
                  child: customText.kText(
                      TextConstants.contactUs,
                      25,
                      FontWeight.w900,
                      ColorConstants.kPrimary,
                      TextAlign.center),
                ),
              ),
              SizedBox(
                width: size.width * 0.5,
                child: customText.kText(
                    "Any question or remarks? Just write us a message!",
                    16,
                    FontWeight.w500,
                    ColorConstants.kDashGrey,
                    TextAlign.start),
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
                  child: isApiCalling
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Column(
                          children: [
                            customText.kText(
                                TextConstants.contactInfo,
                                20,
                                FontWeight.w700,
                                Colors.white,
                                TextAlign.center),
                            SizedBox(height: size.height * 0.03),
                            const Icon(
                              Icons.call,
                              size: 35,
                              color: Colors.white,
                            ),
                            customText.kText(
                                contactPhone.toString(),
                                20,
                                FontWeight.w700,
                                Colors.white,
                                TextAlign.center),
                            SizedBox(height: size.height * 0.03),
                            const Icon(
                              Icons.email,
                              size: 35,
                              color: Colors.white,
                            ),
                            customText.kText(
                                contactEmail.toString(),
                                20,
                                FontWeight.w700,
                                Colors.white,
                                TextAlign.center),
                            SizedBox(height: size.height * 0.03),
                            const Icon(
                              Icons.location_on,
                              size: 35,
                              color: Colors.white,
                            ),
                            customText.kText(
                                contactAddress.toString(),
                                20,
                                FontWeight.w700,
                                Colors.white,
                                TextAlign.center,
                                TextOverflow.visible,
                                4),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: size.height * 0.04,
                                  child:
                                      Image.asset("assets/images/google.png"),
                                ),
                                SizedBox(
                                  height: size.height * 0.04,
                                  child:
                                      Image.asset("assets/images/facebook.png"),
                                ),
                                SizedBox(
                                  height: size.height * 0.04,
                                  child:
                                      Image.asset("assets/images/twitter.png"),
                                ),
                              ],
                            )
                          ],
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomFormField2(
                        validator: (value) =>
                            ValidationRules().firstNameValidation(value),
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        hintText: TextConstants.name,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: ColorConstants.kPrimary,
                          size: 35,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      CustomFormField2(
                        validator: (value) =>
                            ValidationRules().phoneNumberValidation(value),
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        hintText: TextConstants.phoneNo,
                        prefixIcon: const Icon(
                          Icons.call,
                          color: ColorConstants.kPrimary,
                          size: 35,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      CustomFormField2(
                        validator: (value) => ValidationRules().email(value),
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: ColorConstants.kPrimary,
                          size: 35,
                        ),
                        hintText: TextConstants.email,
                      ),
                      SizedBox(height: size.height * 0.02),
                      CustomFormField2(
                        validator: (value) =>
                            ValidationRules().addressValidation1(value),
                        controller: addressController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: ColorConstants.kPrimary,
                          size: 35,
                        ),
                        hintText: TextConstants.location,
                      ),
                      SizedBox(height: size.height * 0.02),
                      CustomFormField2(
                        validator: (value) =>
                            ValidationRules().contactMessageValidation(value),
                        controller: messageController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        prefixIcon: const Icon(
                          Icons.message,
                          color: ColorConstants.kPrimary,
                          size: 35,
                        ),
                        hintText: TextConstants.message,
                      ),
                      SizedBox(height: size.height * 0.03),
                      CustomButton(
                        loader: postInformationCalling,
                        fontSize: 18,
                        hintText: TextConstants.send,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            sendInformation();
                          }
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              ),
              CustomFooter(
                phone: contactPhone,
                address: contactAddress,
                email: contactEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
