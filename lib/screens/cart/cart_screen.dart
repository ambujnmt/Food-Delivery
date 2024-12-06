import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_button2.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:get/get.dart';
import 'package:slider_button/slider_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  final customText = CustomText();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * .2,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: customText.kText(
                        "Food At The Hotel",
                        16,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: customText.kText(
                        "Regular(Serve 1)",
                        16,
                        FontWeight.w700,
                        ColorConstants.lightGreyColor,
                        TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: customText.kText(
                                      "-\$9.00",
                                      20,
                                      FontWeight.w800,
                                      Colors.black,
                                      TextAlign.start),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: ColorConstants.lightGreyColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: Center(
                        child: customText.kText(
                          TextConstants.addMoreItems,
                          16,
                          FontWeight.w700,
                          ColorConstants.lightGreyColor,
                          TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * .020),
              Container(
                height: height * .24,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText.kText(
                        TextConstants.completeYourMeal,
                        16,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: height * .17,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height * .080,
                                  width: width * .2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: const DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyGBq5j6yWJ4WzlFoNy7x4VORqcwZ9iuSqDg&s"))),
                                ),
                                SizedBox(height: height * .005),
                                customText.kText(
                                    "Africanfood",
                                    16,
                                    FontWeight.w700,
                                    ColorConstants.kPrimary,
                                    TextAlign.start),
                                SizedBox(height: height * .005),
                                customText.kText("-\$4.00", 16, FontWeight.w700,
                                    Colors.black, TextAlign.start)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * .020),
              Container(
                padding: EdgeInsets.all(10),
                height: height * .4,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: customText.kText(
                        TextConstants.billDetails,
                        16,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: customText.kText(
                            TextConstants.itemTotal,
                            14,
                            FontWeight.w500,
                            ColorConstants.lightGreyColor,
                            TextAlign.start,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: customText.kText(
                            "\$9.00",
                            20,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: customText.kText(
                                "${TextConstants.itemTotal} | 4.2 miles",
                                14,
                                FontWeight.w500,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                            Container(
                              child: customText.kText(
                                "-----------------------",
                                14,
                                FontWeight.w500,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: customText.kText(
                            "\$9.00",
                            20,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: width * .6,
                      margin: EdgeInsets.only(bottom: 10),
                      child: customText.kText(
                          TextConstants.paymentDescription,
                          14,
                          FontWeight.w500,
                          ColorConstants.lightGreyColor,
                          TextAlign.start),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: customText.kText(
                                "${TextConstants.platformFee}",
                                14,
                                FontWeight.w500,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                            Container(
                              child: customText.kText(
                                "-----------------------",
                                14,
                                FontWeight.w500,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: customText.kText(
                            "\$0.75",
                            20,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: customText.kText(
                                "${TextConstants.gstAndRestaurantCharges}",
                                14,
                                FontWeight.w500,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                            Container(
                              child: customText.kText(
                                "-----------------------",
                                14,
                                FontWeight.w500,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: customText.kText(
                            "\$0.75",
                            20,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * .020),
                    Container(
                      child: const Text(
                        "--------------------------------------------------------------",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorConstants.lightGreyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: customText.kText(
                            TextConstants.toPay,
                            20,
                            FontWeight.w700,
                            ColorConstants.kPrimary,
                            TextAlign.start,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: customText.kText(
                            "\$50.00",
                            20,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(10),
                height: height * .2,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: customText.kText(
                        TextConstants.savingCorner,
                        20,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: customText.kText(
                        "${TextConstants.saveOnThisOrder} \$2.5 ${TextConstants.thisOrder}",
                        14,
                        FontWeight.w500,
                        Colors.black,
                        TextAlign.start,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: customText.kText(
                            TextConstants.viewAll,
                            14,
                            FontWeight.w500,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            sideDrawerController.index.value = 22;
                            sideDrawerController.pageController
                                .jumpToPage(sideDrawerController.index.value);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Container(
                                height: height * .050,
                                width: width * .25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: ColorConstants.kPrimary, width: 1),
                                ),
                                child: Center(
                                  child: customText.kText(
                                      TextConstants.applyNow,
                                      14,
                                      FontWeight.w700,
                                      ColorConstants.kPrimary,
                                      TextAlign.center),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(10),
                height: height * .15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: customText.kText(
                          "HDFC Rapay Debit Card",
                          20,
                          FontWeight.w800,
                          Colors.black,
                          TextAlign.start,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const OrderConfirmationScreen(),
                        //   ),
                        // );
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const OrderTrackingScreen(),
                        //   ),
                        // );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        height: height * .060,
                        width: double.infinity,
                        child: SliderButton(
                          action: () async {
                            return true;
                          },

                          label: customText.kText(
                              "${TextConstants.sliderToPay} 50 ",
                              20,
                              FontWeight.w700,
                              Colors.white,
                              TextAlign.start),
                          icon: const Center(
                              child: Icon(
                            Icons.keyboard_double_arrow_right,
                            color: ColorConstants.kPrimary,
                            size: 40.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          )),

                          ///Change All the color and size from here.
                          width: 230,
                          radius: 36,
                          buttonColor: Colors.white,
                          backgroundColor: ColorConstants.kPrimary,
                          highlightedColor: Colors.white,
                          // baseColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
