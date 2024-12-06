import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class TestimonialScreen extends StatefulWidget {
  const TestimonialScreen({super.key});

  @override
  State<TestimonialScreen> createState() => _TestimonialScreenState();
}

class _TestimonialScreenState extends State<TestimonialScreen> {
  final customText = CustomText();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * .020),
            Center(
              child: Container(
                height: height * 0.05,
                width: width * 0.6,
                margin: EdgeInsets.symmetric(vertical: width * 0.03),
                decoration: BoxDecoration(
                    color: ColorConstants.kPrimary,
                    borderRadius: BorderRadius.circular(width * 0.05)),
                child: Center(
                  child: customText.kText(TextConstants.testimonial, 20,
                      FontWeight.w900, Colors.white, TextAlign.center),
                ),
              ),
            ),
            SizedBox(height: height * .030),
            Expanded(
              child: Container(
                color: ColorConstants.kPrimary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * .030),
                    Container(
                      child: Center(
                        child: customText.kText(
                          TextConstants.whatDoTheySay,
                          22,
                          FontWeight.bold,
                          Colors.white,
                          TextAlign.start,
                        ),
                      ),
                    ),
                    SizedBox(height: height * .050),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: customText.kText(
                          "DR. JOHN SMITH",
                          22,
                          FontWeight.bold,
                          ColorConstants.yellowColor,
                          TextAlign.start,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: customText.kText(
                          "CEO Agency",
                          16,
                          FontWeight.bold,
                          Colors.white,
                          TextAlign.start,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                      child: Center(
                        child: customText.kText(
                          "“Lorem ipsum dolor sit amet consectetur adipisicing elit. Atque cupiditate cum provident at! Dolorum fuga, deserunt est atque excepturi voluptas architecto exercitationem cumque delectus iste facilis quaerat in minima totam.”",
                          16,
                          FontWeight.bold,
                          Colors.white,
                          TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
