import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomFooter extends StatelessWidget {
  CustomFooter({
    super.key,
    this.phone = "0123456789",
    this.email = "info@getfood.com",
    this.address =
        "132 Dartmouth Street Boston, Massachusetts 02156 United States",
  });

  dynamic size;
  dynamic phone;
  dynamic email;
  dynamic address;
  final customText = CustomText();

  customPagesTitle(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: customText.kText(
            title, 14, FontWeight.w400, Colors.white, TextAlign.start),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      width: size.width,
      color: ColorConstants.kPrimary,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          Container(
            width: size.width * 0.8,
            margin: EdgeInsets.only(top: size.height * 0.01),
            child: Image.asset("assets/images/name_logo.png"),
          ),
          const Divider(color: Colors.white),
          SizedBox(height: size.height * 0.01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText.kText(TextConstants.quickLinks, 16,
                      FontWeight.w600, Colors.white, TextAlign.center),
                  customPagesTitle(TextConstants.home, () {}),
                  customPagesTitle(TextConstants.aboutUs, () {}),
                  customPagesTitle(TextConstants.specialFood, () {}),
                  customPagesTitle(TextConstants.foodCategory, () {}),
                  customPagesTitle(TextConstants.gallery, () {}),
                  customPagesTitle(TextConstants.contactUs, () {}),
                  customPagesTitle(TextConstants.termsConditions, () {}),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText.kText(TextConstants.reachUs, 16, FontWeight.w600,
                      Colors.white, TextAlign.center),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: const Icon(
                      Icons.call,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: customText.kText(phone, 14, FontWeight.w400,
                          Colors.white, TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: const Icon(
                      Icons.email,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  customPagesTitle(email, () {}),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: const Icon(
                      Icons.location_on,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: SizedBox(
                          width: size.width * 0.4,
                          height: size.height * 0.12,
                          child: customText.kText(
                              address,
                              14,
                              FontWeight.w400,
                              Colors.white,
                              TextAlign.start,
                              TextOverflow.ellipsis,
                              4),
                        )),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            // color: Colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      customText.kText(TextConstants.legal, 16, FontWeight.w600,
                          Colors.white, TextAlign.center),
                      customPagesTitle(TextConstants.privacyPolicy, () {}),
                      customPagesTitle(TextConstants.termsConditions, () {}),
                      customPagesTitle(TextConstants.refundPolicy, () {}),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText.kText(
                        TextConstants.findUs,
                        16,
                        FontWeight.w600,
                        Colors.white,
                        TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: height * .200,
                        width: width * .450,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'assets/images/map_image.jpg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
