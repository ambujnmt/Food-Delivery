import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_footer.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'dart:developer';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic size;
  final customText = CustomText();

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  String networkImgUrl =
      "https://img.taste.com.au/A7GcvNbQ/taste/2016/11/spiced-potatoes-and-chickpeas-107848-1.jpeg";

  customHeading(String title, Function() onTap) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          size.width * 0.03, size.height * 0.01, size.width * 0.03, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText.kText(title, 20, FontWeight.w700, ColorConstants.kPrimary,
              TextAlign.center),
          GestureDetector(
            child: customText.kText(TextConstants.viewAll, 14, FontWeight.w700,
                Colors.black, TextAlign.center),
            onTap: onTap,
          )
        ],
      ),
    );
  }

  customFoodCategory(String image, String title) {
    return Container(
      height: size.height * 0.15,
      width: size.width * 0.3,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.02),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 1), blurRadius: 4, color: Colors.black26)
          ]),
      child: Column(
        children: [
          Container(
            height: size.height * 0.11,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.width * 0.02),
                  topRight: Radius.circular(size.width * 0.02),
                ),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
          SizedBox(
            height: size.height * 0.04,
            child: Center(
              child: customText.kText(
                  title,
                  14,
                  FontWeight.w700,
                  ColorConstants.kPrimary,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  1),
            ),
          )
        ],
      ),
    );
  }

  customBestDeal(String image, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * 0.15,
        width: size.width * 0.3,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(size.width * 0.02),
            image: DecorationImage(
              image: NetworkImage(networkImgUrl),
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  // customPagesTitle(String title, Function() onTap) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
  //       child: customText.kText(title, 14, FontWeight.w400, Colors.white, TextAlign.start),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size.height * 0.06,
                  width: size.width,
                  color: Colors.grey.shade300,
                ),

                Container(
                  height: size.height * 0.18,
                  width: size.width,
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
                          children: [
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            customText.kText(
                                TextConstants.getReady,
                                20,
                                FontWeight.w900,
                                Colors.white,
                                TextAlign.center),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            customText.kText(
                                TextConstants.toJoiWithUs,
                                24,
                                FontWeight.w900,
                                Colors.white,
                                TextAlign.center),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            GestureDetector(
                              child: Container(
                                height: size.height * 0.04,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(
                                        size.width * 0.03)),
                                child: Center(
                                    child: GestureDetector(
                                  onTap: () {
                                    // place your navigation for table booking
                                    sideDrawerController.index.value = 23;
                                    sideDrawerController.pageController
                                        .jumpToPage(
                                            sideDrawerController.index.value);
                                  },
                                  child: Container(
                                    child: customText.kText(
                                        TextConstants.bookTable,
                                        14,
                                        FontWeight.w700,
                                        Colors.white,
                                        TextAlign.center),
                                  ),
                                )),
                              ),
                              onTap: () {},
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.005),
                    child: customText.kText(
                        "Welcome To Get Food Delivery.",
                        16,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start)),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: RichText(
                      text: TextSpan(
                          text:
                              "The Only Place To Find Great Food Everyday In Your Neighbourhood. ",
                          style: customText.kTextStyle(
                              16, FontWeight.w500, Colors.black),
                          children: [
                        TextSpan(
                          text: "Get Discounts. Earn Point",
                          style: customText.kTextStyle(
                              16, FontWeight.w500, ColorConstants.kPrimary),
                        )
                      ])),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: customText.kText(
                      "Our Newest & Popular Food From Restaurant Near By.",
                      16,
                      FontWeight.w700,
                      ColorConstants.kPrimary,
                      TextAlign.start),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: customText.kText(
                      "Delivery On Your Time And Easy To Pickup.",
                      16,
                      FontWeight.w500,
                      Colors.black,
                      TextAlign.start),
                ),

                // Restaurants
                customHeading(TextConstants.restaurant, () {
                  log("restaurant view all pressed");
                  sideDrawerController.index.value = 1;
                  log("side drawer controller index values :- ${sideDrawerController.index}");
                  sideDrawerController.pageController.jumpToPage(1);
                  setState(() {});
                }),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.1,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02)),
                          ),
                          customText.kText("Restaurant 1", 14, FontWeight.w700,
                              ColorConstants.kPrimary, TextAlign.start),
                          customText.kText("0.7 Mls", 12, FontWeight.w400,
                              Colors.black, TextAlign.start)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.1,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02)),
                          ),
                          customText.kText("Restaurant 2", 14, FontWeight.w700,
                              ColorConstants.kPrimary, TextAlign.start),
                          customText.kText("0.9 Mls", 12, FontWeight.w400,
                              Colors.black, TextAlign.start)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.1,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02)),
                          ),
                          customText.kText("Restaurant 3", 14, FontWeight.w700,
                              ColorConstants.kPrimary, TextAlign.start),
                          customText.kText("1.2 Mls", 12, FontWeight.w400,
                              Colors.black, TextAlign.start)
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // Food Category
                customHeading(TextConstants.foodCategory, () {
                  log("food category view all pressed");
                }),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: Column(
                    children: [
                      customText.kText(TextConstants.foodCategoryDes, 14,
                          FontWeight.w500, Colors.black, TextAlign.start),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customFoodCategory(networkImgUrl, "African food"),
                          customFoodCategory(networkImgUrl, "American food"),
                          customFoodCategory(networkImgUrl, "Bakery"),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: size.height * 0.04,
                ),

                // Best Deals
                Align(
                  alignment: Alignment.center,
                  child: customText.kText(TextConstants.getFoodDelivery, 20,
                      FontWeight.w700, Colors.black, TextAlign.center),
                ),

                customHeading(TextConstants.bestDeals, () {
                  log("best deals view all pressed");
                }),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customBestDeal(networkImgUrl, () {}),
                          customBestDeal(networkImgUrl, () {}),
                          customBestDeal(networkImgUrl, () {}),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: size.height * 0.04,
                ),

                // Top Restaurants
                Align(
                  alignment: Alignment.center,
                  child: customText.kText("Atlantic City", 20, FontWeight.w700,
                      Colors.black, TextAlign.center),
                ),

                customHeading(TextConstants.topRestaurants, () {
                  log("top restaurants view all pressed");
                }),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customBestDeal(networkImgUrl, () {}),
                          customBestDeal(networkImgUrl, () {}),
                          customBestDeal(networkImgUrl, () {}),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                // Special foods
                customHeading(TextConstants.specialFood, () {
                  log("special foods view all pressed");
                }),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customBestDeal(networkImgUrl, () {}),
                          customBestDeal(networkImgUrl, () {}),
                          customBestDeal(networkImgUrl, () {}),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                // Footer
                CustomFooter(),
                // Container(
                //   height: size.height * 0.8,
                //   width: size.width,
                //   color: ColorConstants.kPrimary,
                //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                //   child: Column(
                //     children: [
                //
                //       Container(
                //         width: size.width * 0.8,
                //         margin: EdgeInsets.only(top: size.height * 0.01),
                //         child: Image.asset("assets/images/name_logo.png"),
                //       ),
                //
                //       const Divider(color: Colors.white),
                //
                //       SizedBox(height: size.height * 0.01),
                //
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //
                //               customText.kText(TextConstants.quickLinks, 16, FontWeight.w600, Colors.white, TextAlign.center),
                //
                //               customPagesTitle(TextConstants.home, () {}),
                //               customPagesTitle(TextConstants.aboutUs, () {}),
                //               customPagesTitle(TextConstants.specialFood, () {}),
                //               customPagesTitle(TextConstants.foodCategory, () {}),
                //               customPagesTitle(TextConstants.gallery, () {}),
                //               customPagesTitle(TextConstants.contactUs, () {}),
                //               customPagesTitle(TextConstants.termsConditions, () {}),
                //
                //             ],
                //           ),
                //
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //
                //               customText.kText(TextConstants.reachUs, 16, FontWeight.w600, Colors.white, TextAlign.center),
                //
                //               Padding(
                //                 padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                 child: const Icon(Icons.call, size: 20, color: Colors.white,),
                //               ),
                //
                //               GestureDetector(
                //                 onTap: () {},
                //                 child: Padding(
                //                   padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                   child: customText.kText("0123456789", 14, FontWeight.w400, Colors.white, TextAlign.start),
                //                 ),
                //               ),
                //
                //               Padding(
                //                 padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                 child: const Icon(Icons.email, size: 20, color: Colors.white,),
                //               ),
                //
                //               customPagesTitle("demo@gmail.com", () {}),
                //
                //               Padding(
                //                 padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                 child: const Icon(Icons.location_on, size: 20, color: Colors.white,),
                //               ),
                //
                //               GestureDetector(
                //                 onTap: () {},
                //                 child: Padding(
                //                   padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                   child: SizedBox(
                //                     width: size.width * 0.4,
                //                     height: size.height * 0.12,
                //                     child: customText.kText("132 Dartmouth Street Boston, Massachusetts 02156 United States", 14, FontWeight.w400, Colors.white, TextAlign.start, TextOverflow.ellipsis, 4),
                //                   )
                //                 ),
                //               ),
                //
                //             ],
                //           ),
                //
                //         ],
                //       ),
                //
                //       SizedBox(height: size.height * 0.01),
                //
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //
                //               customText.kText(TextConstants.legal, 16, FontWeight.w600, Colors.white, TextAlign.center),
                //
                //               customPagesTitle(TextConstants.privacyPolicy, () {}),
                //               customPagesTitle(TextConstants.termsConditions, () {}),
                //               customPagesTitle(TextConstants.refundPolicy, () {}),
                //
                //
                //             ],
                //           ),
                //         ],
                //       )
                //
                //     ],
                //   ),
                // ),

                SizedBox(height: size.height * 0.01),
              ],
            ),
          )),
    );
  }
}
