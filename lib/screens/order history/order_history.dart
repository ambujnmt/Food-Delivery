import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button2.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'dart:developer';

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
  // List<dynamic> productItemsList = [];

  orderHistory() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.orderList();
    setState(() {
      orderHistoryList = response['data'];
      orderHistoryList = orderHistoryList.reversed.toList();
    });

    log("order history length :- ${orderHistoryList}");

    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      // for (int i = 0; i < orderHistoryList.length; i++) {
      //   int productLength = orderHistoryList[i]["products"].length;
      //   for (int j = 0; j < productLength; j++) {
      //     productItemsList.add(orderHistoryList[i]["products"][j]);
      //   }
      // }

      // print('order list success message: ${response["message"]}');
      // print('product list : ${productItemsList}');
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

  cancelOrderDialog(Map<String, dynamic> data) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              'Are you sure want to cancel this order ?',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print("cancel pending order : ${data["order_id"].toString()}");
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                // height: h * .030,
                // width: w * .2,
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorConstants.kPrimary),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Perform any action here, then close the dialog
                Navigator.of(context).pop();
                // deleteItem();
                print("cancel pending order : ${data["order_id"].toString()}");
                var response = await api.cancelPendingOrder(
                    orderId: data["order_id"].toString());

                if (response["success"] == true) {
                  print("success message : ${response['message']}");
                  // helper.successDialog(context, response["message"]);
                  orderHistory();
                } else {
                  helper.errorDialog(context, response["message"]);
                }
              },
              child: Container(
                // height: h * .030,
                // width: w * .2,
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: loginController.accessToken.isEmpty || orderHistoryList.isEmpty
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
                                          horizontal: size.width * 0.03,
                                          vertical: 5),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.02,
                                          vertical: size.height * 0.02),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorConstants.kPrimary,
                                            width: 1.5),
                                        // color: Colors.yellow.shade200,
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
                                                          ['order_id']
                                                      .toString() ??
                                                  '',
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                            const Spacer(),
                                            customText.kText(
                                              orderHistoryList[index][
                                                          'order_status'] ==
                                                      "Pending"
                                                  ? TextConstants.pending
                                                  : orderHistoryList[
                                                                  index][
                                                              'order_status'] ==
                                                          "Confirmed"
                                                      ? TextConstants.confirmed
                                                      : orderHistoryList[
                                                                      index][
                                                                  'order_status'] ==
                                                              "Packed"
                                                          ? TextConstants.packed
                                                          : orderHistoryList[
                                                                          index]
                                                                      [
                                                                      'order_status'] ==
                                                                  "OutForDelivery"
                                                              ? TextConstants
                                                                  .outForDelivery
                                                              : orderHistoryList[
                                                                              index]
                                                                          [
                                                                          'order_status'] ==
                                                                      "Delivered"
                                                                  ? TextConstants
                                                                      .delivered
                                                                  : TextConstants
                                                                      .cancelled,
                                              18,
                                              FontWeight.w700,
                                              ColorConstants.kPrimary,
                                              TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            orderHistoryList[index]
                                                        ['order_status'] ==
                                                    "Pending"
                                                ? const ImageIcon(
                                                    AssetImage(
                                                        "assets/images/pending.png"),
                                                    color:
                                                        ColorConstants.kPrimary,
                                                    size: 25,
                                                  )
                                                : orderHistoryList[index]
                                                            ['order_status'] ==
                                                        "Confirmed"
                                                    ? const ImageIcon(
                                                        AssetImage(
                                                            "assets/images/confirmed.png"),
                                                        color: ColorConstants
                                                            .kPrimary,
                                                        size: 25,
                                                      )
                                                    : orderHistoryList[index][
                                                                'order_status'] ==
                                                            "Packed"
                                                        ? const ImageIcon(
                                                            AssetImage(
                                                                "assets/images/packed.png"),
                                                            color:
                                                                ColorConstants
                                                                    .kPrimary,
                                                            size: 25,
                                                          )
                                                        : orderHistoryList[
                                                                        index][
                                                                    'order_status'] ==
                                                                "OutForDelivery"
                                                            ? const ImageIcon(
                                                                AssetImage(
                                                                    "assets/images/outForDelivery.png"),
                                                                color:
                                                                    ColorConstants
                                                                        .kPrimary,
                                                                size: 25,
                                                              )
                                                            : orderHistoryList[
                                                                            index]
                                                                        [
                                                                        'order_status'] ==
                                                                    "Delivered"
                                                                ? const ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/delivered.png"),
                                                                    color: ColorConstants
                                                                        .kPrimary,
                                                                    size: 25,
                                                                  )
                                                                : const ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/cancel.png"),
                                                                    color: ColorConstants
                                                                        .kPrimary,
                                                                    size: 25,
                                                                  ),
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
                                              i <
                                                  orderHistoryList[index]
                                                          ["products"]
                                                      .length;
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
                                                          orderHistoryList[
                                                                      index]
                                                                  ["products"]
                                                              [i]['name'],
                                                          16,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          TextAlign.center)),
                                                  SizedBox(
                                                      width: size.width * 0.15,
                                                      // color: Colors.grey.shade200,
                                                      child: customText.kText(
                                                          orderHistoryList[
                                                                          index]
                                                                      [
                                                                      "products"]
                                                                  [
                                                                  i]['quantity']
                                                              .toString(),
                                                          16,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          TextAlign.center)),
                                                  SizedBox(
                                                      width: size.width * 0.2,
                                                      // color: Colors.grey,
                                                      child: customText.kText(
                                                          "\$ ${orderHistoryList[index]["products"][i]['price']}",
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
                                              ? GestureDetector(
                                                  child: SizedBox(
                                                    width: size.width * 0.3,
                                                    child: CustomButton2(
                                                        fontSize: 20,
                                                        hintText: TextConstants
                                                            .cancel),
                                                  ),
                                                  onTap: () {
                                                    print(
                                                        "cancel button pressed");
                                                    cancelOrderDialog(
                                                        orderHistoryList[
                                                            index]);
                                                  },
                                                )
                                              : orderHistoryList[index]
                                                          ['order_status'] ==
                                                      "Delivered"
                                                  ? Row(
                                                      children: [
                                                        // SizedBox(
                                                        //   width:
                                                        //       size.width * 0.3,
                                                        //   child: CustomButton2(
                                                        //       fontSize: 20,
                                                        //       hintText:
                                                        //           TextConstants
                                                        //               .reorder),
                                                        // ),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.02,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.3,
                                                          child: CustomButton2(
                                                            onTap: () {
                                                              sideDrawerController
                                                                      .resIdFromHistory =
                                                                  orderHistoryList[
                                                                          index]
                                                                      [
                                                                      'restaurent_id'];
                                                              sideDrawerController
                                                                      .resNameFromHistory =
                                                                  orderHistoryList[
                                                                              index]
                                                                          [
                                                                          'business_name']
                                                                      .toString();
                                                              sideDrawerController
                                                                      .prodIdFromHistory =
                                                                  orderHistoryList[
                                                                              index]
                                                                          [
                                                                          'products']
                                                                      [0]['id'];
                                                              sideDrawerController
                                                                      .orderIdFromHistory =
                                                                  orderHistoryList[
                                                                          index]
                                                                      [
                                                                      'order_id'];

                                                              sideDrawerController
                                                                  .previousIndex
                                                                  .add(sideDrawerController
                                                                      .index
                                                                      .value);
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
                                                                    .rateOrder,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                          // const Divider(
                                          //   color: ColorConstants.kDashGrey,
                                          //   thickness: 3,
                                          // ),
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







// orderList[index] == "pending"
//     ? const ImageIcon(
//         AssetImage(
//             "assets/images/pending.png"),
//         color:
//             ColorConstants.kPrimary,
//         size: 25,
//       )
//     : const ImageIcon(
//         AssetImage(
//             "assets/images/delivered.png"),
//         color:
//             ColorConstants.kPrimary,
//         size: 25,
//       )