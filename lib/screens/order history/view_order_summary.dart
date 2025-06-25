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

class ViewOrderSummary extends StatefulWidget {
  const ViewOrderSummary({super.key});

  @override
  State<ViewOrderSummary> createState() => _OrderHistoryState();
}
class _OrderHistoryState extends State<ViewOrderSummary> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  dynamic size;
  final customText = CustomText();
  final api = API();
  final helper = Helper();
  bool isApiCalling = false;
  List orderList = ["pending", "delivered"];
  List<dynamic> orderHistoryList = [];
  orderHistory() async {
    setState(() {
      isApiCalling = true;
    });
    try {
      final response = await api.orderViewDetails(
        orderId: sideDrawerController.orderId.toString()
      );
      print("orderId${sideDrawerController.orderId.toString()}");

      if (response["status"] == true) {
        setState(() {
          if (response['data'] is List) {
            orderHistoryList = response['data'];
          } else {
            orderHistoryList = [response['data']];
          }
          orderHistoryList = orderHistoryList.reversed.toList();
        });

        log("order history length: ${orderHistoryList.length}");
        log("order history data: $orderHistoryList");
      } else {
        print('Order list error message: ${response["message"] ?? "Unknown error"}');
        setState(() {
          orderHistoryList = [];
        });
      }
    } catch (e) {
      print('Error fetching order history: $e');
      setState(() {
        orderHistoryList = [];
      });
    } finally {
      setState(() {
        isApiCalling = false;
      });
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
                                      'Order Details',
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
                                                ColorConstants.kPrimary,
                                                TextAlign.center),
                                            Text(
                                              orderHistoryList[index]
                                                          ['order_id']
                                                      .toString() ??
                                                  '',
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  color:   ColorConstants.kPrimary,),
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
                                                children: [
                                                  SizedBox(
                                                      width: size.width * 0.5,
                                                      child: customText.kText(
                                                          orderHistoryList[index]["products"][i]['name'],
                                                          16,
                                                          FontWeight.bold,
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
                                                      child: customText.kText(
                                                          "\$ ${orderHistoryList[index]["products"][i]['price']}",
                                                          16,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          TextAlign.center)),
                                                ],
                                              ),
                                            ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              if ((orderHistoryList[index]['products']
                                              as List)
                                                  .isNotEmpty) ...[
                                                const Divider(),
                                                const SizedBox(height: 5),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                  const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                  orderHistoryList[index]['products']
                                                      .length,
                                                  itemBuilder: (context,
                                                      productIndex) {
                                                    var product = orderHistoryList[index][
                                                    'products']
                                                    [productIndex];
                                                    List<dynamic>
                                                    selectedOptions =
                                                        product['selected_options'] ??
                                                            [];
                                                    List<dynamic>
                                                    groupOptionDetails =
                                                        product['group_option_details'] ??
                                                            [];
                                                    log("Product: ${product['name']} - Selected Options: $selectedOptions - Group Options: $groupOptionDetails");
                                                    return Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 5),
                                                        if (selectedOptions
                                                            .isNotEmpty) ...[
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left:
                                                                15.0),
                                                            child:
                                                            customText
                                                                .kText(
                                                              'Side Items:',
                                                              14,
                                                              FontWeight
                                                                  .w700,
                                                              Colors
                                                                  .black87,
                                                              TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                            shrinkWrap:
                                                            true,
                                                            physics:
                                                            const NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                            selectedOptions
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                optionIndex) {
                                                              var sideItem =
                                                              selectedOptions[
                                                              optionIndex];
                                                              List<dynamic>
                                                              sideItemQuestions =
                                                                  sideItem[
                                                                  'side_item_questions'] ??
                                                                      [];

                                                              return Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    25.0),
                                                                child:
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    customText
                                                                        .kText(
                                                                      '- ${sideItem['item_name'] ?? 'N/A'} (\$${sideItem['item_price'].toString() ?? '0.00'})',
                                                                      14,
                                                                      FontWeight
                                                                          .w500,
                                                                      Colors
                                                                          .grey[800]!,
                                                                      TextAlign
                                                                          .start,
                                                                    ),
                                                                    if (sideItemQuestions
                                                                        .isNotEmpty)
                                                                      ListView
                                                                          .builder(
                                                                        shrinkWrap:
                                                                        true,
                                                                        physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                        itemCount:
                                                                        sideItemQuestions.length,
                                                                        itemBuilder:
                                                                            (context, questionIndex) {
                                                                          var question = sideItemQuestions[questionIndex];
                                                                          return Padding(
                                                                            padding: const EdgeInsets.only(left: 15.0),
                                                                            child: customText.kText(
                                                                              '> ${question['question'] ?? 'N/A'}: ${question['option'] ?? 'N/A'} (\$${question['option_price'].toString() ?? '0.00'})',
                                                                              13,
                                                                              FontWeight.w400,
                                                                              Colors.grey[700]!,
                                                                              TextAlign.start,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],

                                                        // Display group_option_details (Often Bought With)
                                                        if (groupOptionDetails
                                                            .isNotEmpty) ...[
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left:
                                                                15.0),
                                                            child:
                                                            customText
                                                                .kText(
                                                              'Often Bought With:',
                                                              14,
                                                              FontWeight
                                                                  .w700,
                                                              Colors
                                                                  .black87,
                                                              TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                            shrinkWrap:
                                                            true,
                                                            physics:
                                                            const NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                            groupOptionDetails
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                groupIndex) {
                                                              var group =
                                                              groupOptionDetails[
                                                              groupIndex];
                                                              List<dynamic>
                                                              options =
                                                                  group['options'] ??
                                                                      [];
                                                              return Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    25.0),
                                                                child:
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    customText
                                                                        .kText(
                                                                      '- ${group['group'] ?? 'N/A'}',
                                                                      14,
                                                                      FontWeight
                                                                          .w500,
                                                                      Colors
                                                                          .grey[800]!,
                                                                      TextAlign
                                                                          .start,
                                                                    ),
                                                                    if (options
                                                                        .isNotEmpty)
                                                                      ListView
                                                                          .builder(
                                                                        shrinkWrap:
                                                                        true,
                                                                        physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                        itemCount:
                                                                        options.length,
                                                                        itemBuilder:
                                                                            (context, optionIndex) {
                                                                          var option = options[optionIndex];
                                                                          return Padding(
                                                                            padding: const EdgeInsets.only(left: 15.0),
                                                                            child: customText.kText(
                                                                              '> ${option['name'] ?? 'N/A'} (\$${option['price'].toString() ?? '0.00'})',
                                                                              13,
                                                                              FontWeight.w400,
                                                                              Colors.grey[700]!,
                                                                              TextAlign.start,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                        const SizedBox(
                                                            height:
                                                            10), // Spacing between products
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                              const SizedBox(
                                                  height:
                                                  20), // Spacing between orders
                                              const Divider(
                                                  thickness:
                                                  2), // A thicker divider to separate orders
                                            ],
                                          ),
                                          for (int i = 0;
                                          i <
                                              orderHistoryList[index]
                                              ["products"]
                                                  .length;
                                          i++)
                                            Row(
                                              children: [
                                                customText.kText(
                                                    "Shipping Charge ",
                                                    20,
                                                    FontWeight.w900,
                                                    Colors.black,
                                                    TextAlign.center),
                                                customText.kText(
                                                    "\$${orderHistoryList[index]['shipping_charge'].toString()}",
                                                    20,
                                                    FontWeight.w900,
                                                    Colors.black,
                                                    TextAlign.center),
                                              ],
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
                                                    "\$${orderHistoryList[index]['total']}",
                                                    20,
                                                    FontWeight.w900,
                                                    Colors.black,
                                                    TextAlign.center),
                                              ],
                                            ),
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