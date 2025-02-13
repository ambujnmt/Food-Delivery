import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_button2.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:slider_button/slider_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  TextEditingController cookingInstructionsController = TextEditingController();
  final api = API();
  final customText = CustomText();
  final helper = Helper();
  bool isApiCalling = false;
  bool isCookingVisible = false;
  List<dynamic> cartItemList = [];
  int totalAmount = 0;

  cartListData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.cartList();
    setState(() {
      cartItemList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('cart list success message: ${response["message"]}');
    } else {
      print('cart list error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    cartListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isApiCalling
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.kPrimary,
              ),
            )
          : cartItemList.isEmpty
              ? const CustomNoDataFound()
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height: height * .2,
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
                                  cartItemList[0]['restaurant_name'],
                                  16,
                                  FontWeight.w700,
                                  ColorConstants.kPrimary,
                                  TextAlign.start,
                                ),
                              ),
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  // itemCount: cartItemList.length,
                                  itemCount: 2,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: customText.kText(
                                          cartItemList[0]['name'],
                                          16,
                                          FontWeight.w700,
                                          ColorConstants.lightGreyColor,
                                          TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(height: height * .005),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final response = await api
                                                          .removeItemFromCart(
                                                              productId:
                                                                  cartItemList[
                                                                          index]
                                                                      ['id']);
                                                      if (response['status'] ==
                                                          true) {
                                                        helper.successDialog(
                                                            context,
                                                            response[
                                                                'message']);
                                                        cartListData();
                                                      }
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      height: 35,
                                                      width: width * .1,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.remove,
                                                          color: Colors.black,
                                                          size: 22,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    height: 35,
                                                    width: width * .15,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Center(
                                                      child: customText.kText(
                                                        cartItemList[index]
                                                                ['quantity']
                                                            .toString(),
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
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: customText.kText(
                                                        "-\$${cartItemList[index]['price']}",
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
                                      SizedBox(height: height * .010),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: ColorConstants.lightGreyColor,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: customText.kText(
                                        TextConstants.addMoreItems,
                                        16,
                                        FontWeight.w700,
                                        ColorConstants.lightGreyColor,
                                        TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8)),
                                    height: height * .040,
                                    width: width * .1,
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                color: ColorConstants.lightGreyColor,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, bottom: 10),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: customText.kText(
                                          TextConstants.typeCookingRequest,
                                          16,
                                          FontWeight.w700,
                                          ColorConstants.lightGreyColor,
                                          TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isCookingVisible = !isCookingVisible;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        height: height * .040,
                                        width: width * .1,
                                        child: const Center(
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isCookingVisible,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 10),
                                  child: TextFormField(
                                    controller: cookingInstructionsController,
                                    decoration: InputDecoration(
                                      suffixIcon: Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: customText.kText(
                                              "save",
                                              16,
                                              FontWeight.w500,
                                              ColorConstants.kPrimary,
                                              TextAlign.start),
                                        ),
                                      ),
                                      hintText:
                                          TextConstants.typeCookingRequest,
                                      alignLabelWithHint: true,
                                      hintStyle: customText.kTextStyle(
                                          16,
                                          FontWeight.w500,
                                          ColorConstants.lightGreyColor),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(10),
                          height: height * .12,
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
                                child: customText.kText(
                                  TextConstants.savingCorner,
                                  20,
                                  FontWeight.w700,
                                  ColorConstants.kPrimary,
                                  TextAlign.start,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      sideDrawerController.previousIndex.add(
                                          sideDrawerController.index.value);
                                      sideDrawerController.index.value = 22;
                                      sideDrawerController.pageController
                                          .jumpToPage(
                                              sideDrawerController.index.value);
                                    },
                                    child: Container(
                                      width: width * .5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: customText.kText(
                                              TextConstants.viewAllCoupons,
                                              14,
                                              FontWeight.w500,
                                              Colors.black,
                                              TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(width: width * .010),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                            color:
                                                ColorConstants.lightGreyColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                          height: height * .040,
                                          width: width * .25,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: ColorConstants.kPrimary,
                                                width: 1),
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
                              Container(
                                height: height * .040,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      "\$0",
                                      20,
                                      FontWeight.w700,
                                      Colors.black,
                                      TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      "\$0",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      "\$9.00",
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
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15),
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
                                    width: 230,
                                    radius: 36,
                                    buttonColor: Colors.white,
                                    backgroundColor: ColorConstants.kPrimary,
                                    highlightedColor: Colors.white,
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
