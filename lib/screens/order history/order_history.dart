import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button2.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  dynamic size;
  final customText = CustomText();
  final api = API();
  final helper = Helper();
  bool isApiCalling = false;
  List orderList = ["pending", "delivered"];
  List<dynamic> orderHistoryList = [];
  List<dynamic> productItemsList = [];

  orderHistory() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.orderList();
    setState(() {
      orderHistoryList = response['data'];
    });

    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      for (int i = 0; i < orderHistoryList.length; i++) {
        int productLength = orderHistoryList[i]["products"].length;
        for (int j = 0; j < productLength; j++) {
          productItemsList.add(orderHistoryList[i]["products"][j]);
        }
      }

      print('order list success message: ${response["message"]}');
      print('product list : ${productItemsList}');
    } else {
      print('order list error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    if (loginController.accessToken.isNotEmpty) {
      orderHistory();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: loginController.accessToken.isEmpty
          ? const Center(
              child: CustomNoDataFound(),
            )
          : SingleChildScrollView(
              child: isApiCalling
                  ? Container(
                      margin: const EdgeInsets.only(top: 200),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary,
                        ),
                      ),
                    )
                  : orderHistoryList.isEmpty
                      ? const CustomNoDataFound()
                      : Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * 0.07,
                                width: size.width,
                                child: Center(
                                  child: customText.kText(
                                      TextConstants.orderHistory,
                                      25,
                                      FontWeight.w900,
                                      ColorConstants.kPrimary,
                                      TextAlign.center),
                                ),
                              ),
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: orderHistoryList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: size.width,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.03),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.02,
                                          vertical: size.height * 0.02),
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: ColorConstants.kPrimary, width: 1.5),
                                        borderRadius: BorderRadius.circular(
                                            size.width * 0.02),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            customText.kText(
                                                "${TextConstants.orderId} : ",
                                                20,
                                                FontWeight.w900,
                                                Colors.black,
                                                TextAlign.center),
                                            Text(
                                              orderHistoryList[index]
                                                      ['orderId '] ??
                                                  '',
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                            const Spacer(),
                                            orderHistoryList[index]
                                                        ['order_status'] ==
                                                    "Pending"
                                                ? customText.kText(
                                                    TextConstants.pending,
                                                    18,
                                                    FontWeight.w700,
                                                    ColorConstants.kPrimary,
                                                    TextAlign.center)
                                                : customText.kText(
                                                    TextConstants.delivered,
                                                    18,
                                                    FontWeight.w700,
                                                    ColorConstants.kPrimary,
                                                    TextAlign.center),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            orderList[index] == "pending"
                                                ? const ImageIcon(
                                                    AssetImage(
                                                        "assets/images/pending.png"),
                                                    color:
                                                        ColorConstants.kPrimary,
                                                    size: 25,
                                                  )
                                                : const ImageIcon(
                                                    AssetImage(
                                                        "assets/images/delivered.png"),
                                                    color:
                                                        ColorConstants.kPrimary,
                                                    size: 25,
                                                  )
                                          ]),
                                          Container(
                                            width: size.width,
                                            // color: Colors.grey.shade300,
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.005),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: customText.kText(
                                                  orderHistoryList[index]
                                                          ['business_name'] ??
                                                      '',
                                                  20,
                                                  FontWeight.w700,
                                                  Colors.black,
                                                  TextAlign.start),
                                            ),
                                          ),
                                          Container(
                                            width: size.width,
                                            // color: Colors.grey.shade400,
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.005),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: customText.kText(
                                                  orderHistoryList[index][
                                                          'business_address'] ??
                                                      '',
                                                  20,
                                                  FontWeight.w700,
                                                  Colors.black,
                                                  TextAlign.start),
                                            ),
                                          ),
                                          customText.kText(
                                              orderHistoryList[index]
                                                      ['created_at'] ??
                                                  '',
                                              16,
                                              FontWeight.w700,
                                              ColorConstants.kDashGrey,
                                              TextAlign.start),
                                          const Text(
                                            "...............................................................................................",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          for (int i = 0;
                                              i < productItemsList.length;
                                              i++)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: size.height * 0.01),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                      width: size.width * 0.5,
                                                      // color: Colors.grey,
                                                      child: customText.kText(
                                                          productItemsList[i]
                                                              ['name'],
                                                          16,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          TextAlign.center)),
                                                  SizedBox(
                                                      width: size.width * 0.15,
                                                      // color: Colors.grey.shade200,
                                                      child: customText.kText(
                                                          productItemsList[i]
                                                                  ['quantity']
                                                              .toString(),
                                                          16,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          TextAlign.center)),
                                                  SizedBox(
                                                      width: size.width * 0.2,
                                                      // color: Colors.grey,
                                                      child: customText.kText(
                                                          "\$ ${productItemsList[i]['price']}",
                                                          16,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          TextAlign.center)),
                                                ],
                                              ),
                                            ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.01),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                customText.kText(
                                                    TextConstants.total,
                                                    20,
                                                    FontWeight.w900,
                                                    Colors.black,
                                                    TextAlign.center),
                                                customText.kText(
                                                    "\$ ${orderHistoryList[index]['total']}",
                                                    20,
                                                    FontWeight.w900,
                                                    Colors.black,
                                                    TextAlign.center),
                                              ],
                                            ),
                                          ),
                                          orderHistoryList[index]
                                                      ['order_status'] ==
                                                  "Pending"
                                              ? SizedBox(
                                                  width: size.width * 0.3,
                                                  child: CustomButton2(
                                                      fontSize: 20,
                                                      hintText:
                                                          TextConstants.cancel),
                                                )
                                              : Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.3,
                                                      child: CustomButton2(
                                                          fontSize: 20,
                                                          hintText:
                                                              TextConstants
                                                                  .reorder),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.3,
                                                      child: CustomButton2(
                                                          onTap: () {
                                                            sideDrawerController
                                                                .index
                                                                .value = 21;
                                                            sideDrawerController
                                                                .pageController
                                                                .jumpToPage(
                                                                    sideDrawerController
                                                                        .index
                                                                        .value);
                                                            // sideDrawerController.index.value = 26;
                                                            // sideDrawerController.pageController
                                                            //     .jumpToPage(
                                                            //         sideDrawerController.index.value);
                                                          },
                                                          fontSize: 20,
                                                          hintText:
                                                              TextConstants
                                                                  .rateOrder),
                                                    )
                                                  ],
                                                ),
                                          const Divider(
                                            color: ColorConstants.kDashGrey,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
    );
  }
}
