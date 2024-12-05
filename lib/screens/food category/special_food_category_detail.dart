import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class SpecificFoodCategoryDetail extends StatefulWidget {
  const SpecificFoodCategoryDetail({super.key});

  @override
  State<SpecificFoodCategoryDetail> createState() =>
      _SpecificFoodCategoryDetailState();
}

class _SpecificFoodCategoryDetailState
    extends State<SpecificFoodCategoryDetail> {
  final customText = CustomText();
  String networkImgUrl =
      "https://s3-alpha-sig.figma.com/img/2d0c/88be/5584e0af3dc9e87947fcb237a160d230?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N3MZ8MuVlPrlR8KTBVNhyEAX4fwc5fejCOUJwCEUpdBsy3cYwOOdTvBOBOcjpLdsE3WXcvCjY5tjvG8bofY3ivpKb5z~b3niF9jcICifVqw~jVvfx4x9WDa78afqPt0Jr4tm4t1J7CRF9BHcokNpg9dKNxuEBep~Odxmhc511KBkoNjApZHghatTA0LsaTexfSZXYvdykbhMuNUk5STsD5J4zS8mjCxVMRX7zuMXz85zYyfi7cAfX5Z6LVsoW0ngO7L6HKAcIgN4Rry9Lj2OFba445Mpd4Mx8t0fcsDPwQPbUDPHiBf3G~6HHcWjCBHKV0PiBZmt86HcvZntkFzWYg__";
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Container(
        height: 70,
        width: 120,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.kPrimary,
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * .050,
          ),
          Container(
            height: height * 0.18,
            width: width,
            margin: EdgeInsets.only(bottom: height * 0.01),
            decoration: const BoxDecoration(
                color: Colors.yellow,
                image: DecorationImage(
                    image: AssetImage("assets/images/banner.png"),
                    fit: BoxFit.fitHeight)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black54,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText.kText(TextConstants.foodCategory, 28,
                          FontWeight.w900, Colors.white, TextAlign.center),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      RichText(
                        text: TextSpan(
                            text: TextConstants.home,
                            style: customText.kSatisfyTextStyle(
                                24, FontWeight.w400, Colors.white),
                            children: [
                              TextSpan(
                                  text: " / ${TextConstants.foodCategory}",
                                  style: customText.kSatisfyTextStyle(24,
                                      FontWeight.w400, ColorConstants.kPrimary))
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * .02),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            height: height * .24,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(networkImgUrl),
              ),
            ),
          ),
          SizedBox(height: height * .02),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: customText.kText("Food At The Hotel", 32, FontWeight.w800,
                ColorConstants.kPrimary, TextAlign.start),
          ),
          SizedBox(height: height * .02),
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: customText.kText("-\$9.00", 32, FontWeight.w800,
                          Colors.black, TextAlign.start),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 35,
                            width: width * .1,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.remove,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 35,
                            width: width * .15,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: customText.kText(
                                "12",
                                16,
                                FontWeight.bold,
                                Colors.black,
                                TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: width * .1,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              )),
          SizedBox(height: height * .02),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: customText.kText(
              TextConstants.deliciousFood,
              16,
              FontWeight.w700,
              ColorConstants.kPrimary,
              TextAlign.start,
            ),
          ),
        ],
      )),
    );
  }
}
