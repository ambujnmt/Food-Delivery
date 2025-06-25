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
  bool isLoadingMore = false;
  bool hasMoreData = true;
  List orderList = ["pending", "delivered"];
  List<dynamic> orderHistoryList = [];

  // Pagination variables
  int currentPage = 1;
  int itemsPerPage = 6;
  ScrollController _scrollController = ScrollController();

  orderHistory({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isLoadingMore || !hasMoreData) return;
      setState(() {
        isLoadingMore = true;
      });
    } else {
      setState(() {
        isApiCalling = true;
        currentPage = 1;
        orderHistoryList.clear();
        hasMoreData = true;
      });
    }

    final response = await api.orderList(
      page: currentPage,
      limit: itemsPerPage,
    );
    if (response["status"] == true) {
      List<dynamic> newOrders = response['data'] ?? [];

      setState(() {
        if (isLoadMore) {
          orderHistoryList.addAll(newOrders);
          isLoadingMore = false;
        } else {
          orderHistoryList = newOrders;
          isApiCalling = false;
        }

        // Check if there are more items to load
        hasMoreData = newOrders.length == itemsPerPage;

        if (hasMoreData) {
          currentPage++;
        }
      });

      log("order history length :- ${orderHistoryList.length}");
    } else {
      setState(() {
        if (isLoadMore) {
          isLoadingMore = false;
        } else {
          isApiCalling = false;
        }
      });
      print('order list error message: ${response["message"]}');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User has reached the bottom of the list
      if (hasMoreData && !isLoadingMore) {
        orderHistory(isLoadMore: true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    if (loginController.accessToken.isNotEmpty) {
      orderHistory();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
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
                Navigator.of(context).pop();
              },
              child: Container(
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
                Navigator.of(context).pop();
                print("cancel pending order : ${data["order_id"].toString()}");
                var response = await api.cancelPendingOrder(
                    orderId: data["order_id"].toString());

                if (response["success"] == true) {
                  print("success message : ${response['message']}");
                  orderHistory(); // Refresh the list
                } else {
                  helper.errorDialog(context, response["message"]);
                }
              },
              child: Container(
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

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Center(
        child: CircularProgressIndicator(
          color: ColorConstants.kPrimary,
        ),
      ),
    );
  }

  Widget _buildOrderItem(int index) {
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
        borderRadius: BorderRadius.circular(
            size.width * 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            customText.kText(
                "${TextConstants.orderId} : ",
                20,
                FontWeight.w900,
                ColorConstants.kPrimary,
                TextAlign.center),
            Text(
              orderHistoryList[index]['order_id'].toString() ?? '',
              style:  const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.kPrimary),
            ),
            const Spacer(),
            customText.kText(
              orderHistoryList[index]['order_status'] == "Pending"
                  ? TextConstants.pending
                  : orderHistoryList[index]['order_status'] == "Confirmed"
                  ? TextConstants.confirmed
                  : orderHistoryList[index]['order_status'] == "Packed"
                  ? TextConstants.packed
                  : orderHistoryList[index]['order_status'] == "OutForDelivery"
                  ? TextConstants.outForDelivery
                  : orderHistoryList[index]['order_status'] == "Delivered"
                  ? TextConstants.delivered
                  : TextConstants.cancelled,
              18,
              FontWeight.w700,
              ColorConstants.kPrimary,
              TextAlign.center,
            ),
            SizedBox(width: size.width * 0.02),
            orderHistoryList[index]['order_status'] == "Pending"
                ? const ImageIcon(
              AssetImage("assets/images/pending.png"),
              color: ColorConstants.kPrimary,
              size: 25,
            )
                : orderHistoryList[index]['order_status'] == "Confirmed"
                ? const ImageIcon(
              AssetImage("assets/images/confirmed.png"),
              color: ColorConstants.kPrimary,
              size: 25,
            )
                : orderHistoryList[index]['order_status'] == "Packed"
                ? const ImageIcon(
              AssetImage("assets/images/packed.png"),
              color: ColorConstants.kPrimary,
              size: 25,
            )
                : orderHistoryList[index]['order_status'] == "OutForDelivery"
                ? const ImageIcon(
              AssetImage("assets/images/outForDelivery.png"),
              color: ColorConstants.kPrimary,
              size: 25,
            )
                : orderHistoryList[index]['order_status'] == "Delivered"
                ? const ImageIcon(
              AssetImage("assets/images/delivered.png"),
              color: ColorConstants.kPrimary,
              size: 25,
            )
                : const ImageIcon(
              AssetImage("assets/images/cancel.png"),
              color: ColorConstants.kPrimary,
              size: 25,
            ),
          ]),

          // Business name and address
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
            child: Align(
              alignment: Alignment.centerLeft,
              child: customText.kText(
                  orderHistoryList[index]['business_name'] ?? '',
                  20,
                  FontWeight.w700,
                  Colors.black,
                  TextAlign.start),
            ),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
            child: Align(
              alignment: Alignment.centerLeft,
              child: customText.kText(
                  orderHistoryList[index]['business_address'] ?? '',
                  20,
                  FontWeight.w700,
                  Colors.black,
                  TextAlign.start),
            ),
          ),
          customText.kText(
              orderHistoryList[index]['created_at'] ?? '',
              16,
              FontWeight.w700,
              ColorConstants.kDashGrey,
              TextAlign.start),
          const Text(
            "...............................................................................................",
            overflow: TextOverflow.ellipsis,
          ),

          // Products list
          for (int i = 0; i < orderHistoryList[index]["products"].length; i++)
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
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
                      child: customText.kText(
                          orderHistoryList[index]["products"][i]['quantity'].toString(),
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
          // Product details section (your existing code for selected options and group options)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              if ((orderHistoryList[index]['products'] as List).isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 5),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderHistoryList[index]['products'].length,
                  itemBuilder: (context, productIndex) {
                    var product = orderHistoryList[index]['products'][productIndex];
                    List<dynamic> selectedOptions = product['selected_options'] ?? [];
                    List<dynamic> groupOptionDetails = product['group_option_details'] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        if (selectedOptions.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: customText.kText(
                              'Side Items:',
                              14,
                              FontWeight.w700,
                              Colors.black87,
                              TextAlign.start,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: selectedOptions.length,
                            itemBuilder: (context, optionIndex) {
                              var sideItem = selectedOptions[optionIndex];
                              List<dynamic> sideItemQuestions = sideItem['side_item_questions'] ?? [];

                              return Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText.kText(
                                      '- ${sideItem['item_name'] ?? 'N/A'} (\$${sideItem['item_price'].toString() ?? '0.00'})',
                                      14,
                                      FontWeight.w500,
                                      Colors.grey[800]!,
                                      TextAlign.start,
                                    ),
                                    if (sideItemQuestions.isNotEmpty)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: sideItemQuestions.length,
                                        itemBuilder: (context, questionIndex) {
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

                        if (groupOptionDetails.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: customText.kText(
                              'Often Bought With:',
                              14,
                              FontWeight.w700,
                              Colors.black87,
                              TextAlign.start,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupOptionDetails.length,
                            itemBuilder: (context, groupIndex) {
                              var group = groupOptionDetails[groupIndex];
                              List<dynamic> options = group['options'] ?? [];
                              return Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText.kText(
                                      '- ${group['group'] ?? 'N/A'}',
                                      14,
                                      FontWeight.w500,
                                      Colors.grey[800]!,
                                      TextAlign.start,
                                    ),
                                    if (options.isNotEmpty)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: options.length,
                                        itemBuilder: (context, optionIndex) {
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
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),
              const Divider(thickness: 2),
            ],
          ),
          // Shipping charges
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


          // Total
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

          // Action buttons
          orderHistoryList[index]['order_status'] == "Pending"
              ? Row(
                children: [
                  GestureDetector(
                              child: SizedBox(
                  width: size.width * 0.3,
                  child: CustomButton2(
                      fontSize: 20,
                      hintText: TextConstants.cancel),
                              ),
                              onTap: () {
                  print("cancel button pressed");
                  cancelOrderDialog(orderHistoryList[index]);
                              },
                            ),
                  const Spacer(),
                  GestureDetector(
                    child: SizedBox(
                      width: size.width * 0.4,
                      child: CustomButton2(
                          fontSize: 20,
                          hintText: 'View Details'),
                    ),
                    onTap: () {
                      print("view details button pressed");
                      sideDrawerController.orderId = orderHistoryList[index]['order_id'].toString() ?? '';
                      sideDrawerController.index.value = 42;
                      sideDrawerController.pageController
                          .jumpToPage(sideDrawerController.index.value);
                    },
                  )
                ],
              )
              : orderHistoryList[index]['order_status'] == "Delivered"
              ? Row(
            children: [
              SizedBox(width: size.width * 0.02),
              SizedBox(
                width: size.width * 0.3,
                child: CustomButton2(
                  onTap: () {
                    sideDrawerController.resIdFromHistory =
                    orderHistoryList[index]['restaurent_id'];
                    sideDrawerController.resNameFromHistory =
                        orderHistoryList[index]['business_name'].toString();
                    sideDrawerController.prodIdFromHistory =
                    orderHistoryList[index]['products'][0]['id'];
                    sideDrawerController.orderIdFromHistory = orderHistoryList[index]['order_id'];
                    sideDrawerController.previousIndex.add(sideDrawerController.index.value);
                    sideDrawerController.index.value = 21;
                    sideDrawerController.orderId = orderHistoryList[index]['order_id'].toString() ?? '';
                    sideDrawerController.pageController
                        .jumpToPage(sideDrawerController.index.value);
                  },
                  fontSize: 20,
                  hintText: TextConstants.rateOrder,
                ),
              )
            ],
          )
              : const SizedBox(),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: loginController.accessToken.isEmpty
          ? const Center(child: CustomNoDataFound())
          : Column(
        children: [
          // Header
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

          // Content
          Expanded(
            child: isApiCalling
                ? _buildLoadingIndicator()
                : orderHistoryList.isEmpty
                ? const CustomNoDataFound()
                : ListView.builder(
              controller: _scrollController,
              itemCount: orderHistoryList.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == orderHistoryList.length) {
                  // Show loading indicator at the bottom
                  return _buildLoadingIndicator();
                }
                return _buildOrderItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

