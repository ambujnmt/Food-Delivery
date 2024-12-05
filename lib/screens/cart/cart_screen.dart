import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
                height: height * .5,
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
                    Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
