import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';

class RateYourMeal extends StatefulWidget {
  const RateYourMeal({super.key});

  @override
  State<RateYourMeal> createState() => _RateYourMealState();
}

class _RateYourMealState extends State<RateYourMeal> {
  final customText = CustomText();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child: customText.kText(TextConstants.rateYourMeal, 20,
                    FontWeight.w700, ColorConstants.kPrimary, TextAlign.start),
              ),
            ),
            SizedBox(height: height * .020),
            Center(
              child: Container(
                height: height * .2,
                width: width * .5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'assets/images/rate_meal.png',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * .020),
            Container(
              child: Center(
                child: customText.kText(TextConstants.foodFromTheHotel, 20,
                    FontWeight.w700, ColorConstants.kPrimary, TextAlign.start),
              ),
            ),
            SizedBox(height: height * .020),
            Center(
              child: Container(
                height: height * .040,
                width: width * .5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'assets/images/rate_star.png',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * .020),
            Container(
              height: height * .15,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstants.kPrimary,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: customText.kText(TextConstants.rateYourOrderedDish,
                        20, FontWeight.w700, Colors.black, TextAlign.start),
                  ),
                  Divider(color: ColorConstants.lightGreyColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: customText.kText(
                          TextConstants.foodFromTheHotel,
                          14,
                          FontWeight.w500,
                          ColorConstants.lightGreyColor,
                          TextAlign.start,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 9,
                              backgroundColor: ColorConstants.kLike,
                              child: Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 9,
                              backgroundColor: ColorConstants.kDisLike,
                              child: Icon(
                                Icons.thumb_down,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: height * .020),
            Container(
                height: height * .17,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorConstants.kPrimary,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: customText.kText(
                      TextConstants.leaveMessage,
                      16,
                      FontWeight.w500,
                      ColorConstants.lightGreyColor,
                      TextAlign.start),
                )),
            SizedBox(height: height * .020),
            CustomButton(fontSize: 20, hintText: TextConstants.submit)
          ],
        ),
      ),
    ));
  }
}
