import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateYourMeal extends StatefulWidget {
  const RateYourMeal({super.key});

  @override
  State<RateYourMeal> createState() => _RateYourMealState();
}

class _RateYourMealState extends State<RateYourMeal> {
  bool isApiCalling = false;
  final customText = CustomText(), api = API(), helper = Helper();
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  TextEditingController reviewController = TextEditingController();
  double? ratingByUser;

  rateOrder({double? ratingByUser, String? reviewMessage}) async {
    if (ratingByUser != null) {
      if (reviewController.text.isNotEmpty) {
        setState(() {
          isApiCalling = true;
        });
        var response;
        response = await api.rateOrder(
          orderId: sideDrawerController.orderIdFromHistory,
          productId: sideDrawerController.prodIdFromHistory,
          restaurantId: sideDrawerController.resIdFromHistory,
          rating: ratingByUser.toString(),
          review: reviewController.text,
        );
        setState(() {
          isApiCalling = false;
        });
        if (response['status'] == true) {
          helper.successDialog(context, response['message']);
          sideDrawerController.index.value = 0;
          sideDrawerController.pageController
              .jumpToPage(sideDrawerController.index.value);
        } else {
          helper.errorDialog(context, response['message']);
        }
      } else {
        helper.errorDialog(context, "Please write a review");
      }
    } else {
      helper.errorDialog(context, "Please give your rating");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("prod id from his: ${sideDrawerController.prodIdFromHistory}");
    print("res id from his: ${sideDrawerController.resIdFromHistory}");
    print("res name from his: ${sideDrawerController.resNameFromHistory}");
    print("order id from his: ${sideDrawerController.orderIdFromHistory}");

    super.initState();
  }

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
                child: customText.kText(
                    TextConstants.foodFromTheHotel +
                        sideDrawerController.resNameFromHistory,
                    20,
                    FontWeight.w700,
                    ColorConstants.kPrimary,
                    TextAlign.start),
              ),
            ),
            SizedBox(height: height * .020),
            Center(
              child: RatingBar.builder(
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 40,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  ratingByUser = rating;
                },
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
                  const Divider(color: ColorConstants.lightGreyColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: customText.kText(
                          TextConstants.foodFromTheHotel +
                              sideDrawerController.resNameFromHistory,
                          14,
                          FontWeight.w500,
                          ColorConstants.lightGreyColor,
                          TextAlign.start,
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
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      hintText: TextConstants.leaveMessage,
                      hintStyle: customText.kTextStyle(
                        16,
                        FontWeight.w500,
                        ColorConstants.lightGreyColor,
                      ),
                      border: InputBorder.none,
                    ),
                  )),
            ),
            SizedBox(height: height * .020),
            CustomButton(
              loader: isApiCalling,
              fontSize: 20,
              hintText: TextConstants.submit,
              onTap: () async {
                // place your submit navigation
                rateOrder(
                  ratingByUser: ratingByUser,
                  reviewMessage: reviewController.text,
                );
              },
            )
          ],
        ),
      ),
    ));
  }
}
