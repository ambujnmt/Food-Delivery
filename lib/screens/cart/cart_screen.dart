import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:slider_button/slider_button.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();

}

class _CartScreenState extends State<CartScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  CartController cartController = Get.put(CartController());
  TextEditingController cookingInstructionsController = TextEditingController();
  String selectedDeliveryAddress = "";
  String selectedRestauntId = "";
  String selectedPaymentOption = "stripe";
  String displayPaymentMethod = "Stripe";
  String selectedRadioValue = 'delivery';

  String cartItemsJson = "";
  final api = API();
  final customText = CustomText();
  final helper = Helper();
  bool isApiCalling = false;
  bool isCookingVisible = false;
  bool isProcessing = false;
  List<dynamic> cartItemList = [];
  List<dynamic> addressList = [];
  List<double> allPriceList = [];
  List<double> sidePriceList = [];
  List<double> shippingChargeList = [];
  List<int> quantityList = [];
  List<int> productIdList = [];
  List<dynamic> selectedOptionsList = [];
  List<dynamic> groupOptionList = [];

  List<Map<String, dynamic>> sendCartItems = [];
  double totalAmount = 0;
  double sidePrice = 0;
  double shippingPrice = 0;
  int quantity = 1;
  int calculatedPrice = 0;
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
      print("CartResponse$response");
      setState(() {
        cartController.cartItemCount = cartItemList.length.obs;
      });
      for (int i = 0; i < cartItemList.length; i++) {
        allPriceList.add(double.parse(cartItemList[i]['price'].toString()));
        totalAmount = allPriceList.fold(0, (sum, element) => sum + element);
      }
      for (int i = 0; i < cartItemList.length; i++) {
        quantityList.add(cartItemList[i]['quantity']);
        productIdList.add(cartItemList[i]['id']);
        sidePriceList.add(double.parse(cartItemList[i]['side_price'].toString()));
        sidePrice= sidePriceList.fold(0,(sum, element) => sum + element);


        shippingChargeList.add(double.parse(cartItemList[i]['shipping_charge'].toString()));
        shippingPrice = shippingChargeList.fold(0,(sum, element) => sum + element);


        selectedOptionsList.add(cartItemList[i]['selected_options']);
        groupOptionList.add(cartItemList[i]['group_option_details']);
      }
      if (productIdList.isNotEmpty) {
        sendCartItems = List.generate(
          productIdList.length,
          (index) => {
            'product_id': productIdList[index],
            'quantity': quantityList[index],
            'price': allPriceList[index],
            'selected_options': selectedOptionsList[index],
            'group_option_details': groupOptionList[index],
          },
        );
        cartItemsJson = jsonEncode(sendCartItems);
      }

      if (sideDrawerController.couponId.isNotEmpty) {
        appliedCouponAmount();
      }
      setState(() {});
      print("total amount: $totalAmount");
      print("quantity list: $quantityList");
      print("cart items list: $sendCartItems");
      print('cart list success message: ${response["message"]}');
    } else {
      print('cart list error message: ${response["message"]}');
    }
  }
  void increaseQuantity({quantity, String? price, int index = 0}) {
    print("Incrementing");
    print(" before price: $price");
    print(" before quantity: $quantity");
    quantity++;
    quantityList[index] = quantityList[index] + 1;
    allPriceList[index] =
        (double.parse(price.toString().split('.')[0]) * quantityList[index]);
    totalAmount = allPriceList.fold(0, (sum, element) => sum + element);
    if (productIdList.isNotEmpty) {
      sendCartItems = List.generate(
        productIdList.length,
        (index) => {
          'product_id': productIdList[index],
          'quantity': quantityList[index],
          'price': allPriceList[index],
          'selected_options': selectedOptionsList[index],
          'group_option_details': groupOptionList[index]
        },
      );
      cartItemsJson = jsonEncode(sendCartItems);
    }
    setState(() {});
    print("Quantity: ${quantityList[index]}");
    print("price: ${allPriceList[index]}");
  }


  void decreaseQuantity(
      {quantity, String? price, int index = 0, String? productId}) {
    if (quantity > 1) {
      quantityList[index] = quantityList[index] - 1;
      allPriceList[index] =
          (double.parse(price.toString().split('.')[0]) * quantityList[index]);
      totalAmount = allPriceList.fold(0, (sum, element) => sum + element);
    } else if (quantity == 1) {
      removeItemFromCart(productId: productId);
      sideDrawerController.cartListRestaurant = "";
      setState(() {});
    }
    if (productIdList.isNotEmpty) {
      sendCartItems = List.generate(
        productIdList.length,
        (index) => {
          'product_id': productIdList[index],
          'quantity': quantityList[index],
          'price': allPriceList[index],
        },
      );
      cartItemsJson = jsonEncode(sendCartItems);
    }
    setState(() {});
    print("Quantity: ${quantityList[index]}");
    print("price: ${allPriceList[index]}");
  }

  removeItemFromCart({String? productId}) async {
    print("remove item : $productId");
    final response = await api.removeItemFromCart(productId: productId);
    if (response['status'] == true) {
      helper.successDialog(context, response['message']);
      cartListData();
    } else {
      helper.errorDialog(context, response['message']);
    }
  }
  addressData() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.getUserAddress();

    setState(() {
      addressList = response['data'];
      print("address list length: ${addressList.length}");
    });

    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      selectedDeliveryAddress =
          "${addressList[0]['area']} ${addressList[0]['house_no']} ${addressList[0]['city']} ${addressList[0]['zip_code']} ${addressList[0]['state']} ${addressList[0]['country']}";
    } else {
      print('error message: ${response["message"]}');
    }
  }
  appliedCouponAmount() {
    print("total amount app -- ${totalAmount}");
    print("total coupon app -- ${sideDrawerController.couponAmount}");

    if (sideDrawerController.couponType == "fixed") {
      totalAmount = totalAmount - sideDrawerController.couponAmount;

      setState(() {});
      print("to amt: ${totalAmount}");
    } else {
      double tempAmt = (totalAmount * sideDrawerController.couponAmount) / 100;
      totalAmount = totalAmount - tempAmt;
      setState(() {});
      print("to amt: ${totalAmount}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    cartListData();
    addressData();
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          color: Colors.white,
                          height: 2,
                          thickness: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            bottomSheet();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: height * .050,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: ColorConstants.kPrimary,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.only(top: 8),
                                      width: width * .7,
                                      child: customText.kText(
                                          addressList.isEmpty
                                              ? "No address found"
                                              : selectedDeliveryAddress,
                                          16,
                                          FontWeight.w500,
                                          Colors.white,
                                          TextAlign.start,
                                          TextOverflow.ellipsis,
                                          1),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 20, top: 4),
                                  child: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
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
                                padding: const EdgeInsets.all(10),
                                child: customText.kText(
                                  cartItemList[0]['restaurant_name'],
                                  20,
                                  FontWeight.w700,
                                  ColorConstants.kPrimary,
                                  TextAlign.start,
                                ),
                              ),
                              Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: cartItemList.length,
                                    // itemCount: 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      selectedRestauntId = cartItemList[0]
                                              ['restaurant_id']
                                          .toString();

                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: customText.kText(
                                              cartItemList[index]['name'],
                                              16,
                                              FontWeight.w700,
                                              ColorConstants.lightGreyColor,
                                              TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(height: height * .005),
                                          Container(
                                            margin:
                                            const EdgeInsets.only(left: 10),
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
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          decreaseQuantity(
                                                            price: cartItemList[
                                                            index][
                                                            'products_price']
                                                                .toString(),
                                                            quantity:
                                                            quantityList[
                                                            index],
                                                            index: index,
                                                            productId:
                                                            cartItemList[
                                                            index]
                                                            ['id']
                                                                .toString(),
                                                          );
                                                        },
                                                        child: Container(
                                                          margin:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 10),
                                                          height: 35,
                                                          width: width * .1,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                12),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                              Colors.black,
                                                              size: 22,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        height: 35,
                                                        width: width * .15,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: Colors
                                                              .grey.shade300,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(12),
                                                        ),
                                                        child: Center(
                                                          child:
                                                          customText.kText(
                                                            quantityList[index]
                                                                .toString(),
                                                            16,
                                                            FontWeight.bold,
                                                            Colors.black,
                                                            TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          increaseQuantity(
                                                            price: cartItemList[
                                                            index][
                                                            'products_price']
                                                                .toString(),
                                                            quantity:
                                                            quantityList[
                                                            index],
                                                            index: index,
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: width * .1,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                12),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                              Colors.black,
                                                              size: 22,
                                                            ),
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
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        child: customText.kText(
                                                            "\$${totalAmount + sidePrice}",
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
                                      );
                                    }),
                                  ),
                                ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cartItemList.length,
                                itemBuilder: (context, index) {
                                  var item = cartItemList[index];
                                  List<dynamic> selectedOptions = item['selected_options'] ?? [];
                                  List<dynamic> groupOptionDetails = item['group_option_details'] ?? [];

                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          customText.kText(
                                            item['name'] ?? 'N/A',
                                            20,
                                            FontWeight.w800,
                                            ColorConstants.kPrimary,
                                            TextAlign.start,
                                          ),
                                          SizedBox(height: height * 0.01),
                                          if (selectedOptions.isNotEmpty) ...[
                                            const Divider(),
                                            customText.kText(
                                              'Selected Side Items:',
                                              16,
                                              FontWeight.w700,
                                              Colors.black,
                                              TextAlign.start,
                                            ),
                                            const SizedBox(height: 5),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: selectedOptions.length,
                                              itemBuilder: (context, optionIndex) {
                                                var sideItem = selectedOptions[optionIndex];
                                                List<dynamic> sideItemQuestions = sideItem['side_item_questions'] ?? [];

                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    customText.kText(
                                                      ' - ${sideItem['item_name'] ?? 'N/A'} (\$${sideItem['item_price'] ?? '0.00'})',
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
                                                              '   > ${question['question'] ?? 'N/A'}: ${question['option'] ?? 'N/A'} (\$${question['option_price'] ?? '0.00'})',
                                                              13,
                                                              FontWeight.w400,
                                                              Colors.grey[700]!,
                                                              TextAlign.start,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],

                                          // Display group_option_details (Often Bought With)
                                          if (groupOptionDetails.isNotEmpty) ...[
                                            const Divider(),
                                            customText.kText(
                                              'Often Bought With:',
                                              16,
                                              FontWeight.w700,
                                              Colors.black,
                                              TextAlign.start,
                                            ),
                                            const SizedBox(height: 5),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: groupOptionDetails.length,
                                              itemBuilder: (context, groupIndex) {
                                                var group = groupOptionDetails[groupIndex];
                                                List<dynamic> options = group['options'] ?? [];
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    customText.kText(
                                                      ' - ${group['group'] ?? 'N/A'}',
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
                                                              '   > ${option['name'] ?? 'N/A'} (\$${option['price'] ?? '0.00'})',
                                                              13,
                                                              FontWeight.w400,
                                                              Colors.grey[700]!,
                                                              TextAlign.start,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                          const SizedBox(height: 20,),
                                          // Row(
                                          //   children: [
                                          //     customText.kText('Total item price', 18, FontWeight.bold, Colors.black, TextAlign.start),
                                          //     const Spacer(),
                                          //     customText.kText("\$${totalAmount + sidePrice}", 18, FontWeight.bold, Colors.green, TextAlign.start)
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                                        margin: const EdgeInsets.only(top: 5),
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
                          margin: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          padding: const EdgeInsets.all(10),
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
                                      sideDrawerController
                                              .couponListRestaurantId =
                                          selectedRestauntId.toString();
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
                                            margin: const EdgeInsets.only(bottom: 10),
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
                                                sideDrawerController
                                                        .couponId.isEmpty
                                                    ? TextConstants.applyNow
                                                    : TextConstants
                                                        .couponApplied,
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
                        // delivery type
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          padding: const EdgeInsets.only(
                              left: 10, right: 40, top: 10, bottom: 10),
                          height: height * .13,
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
                                  TextConstants.deliveryType,
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
                                  Row(
                                    children: [
                                      Radio(
                                        fillColor: MaterialStateProperty.all(
                                            ColorConstants.kPrimary),
                                        value: 'pickup',
                                        groupValue: selectedRadioValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRadioValue =
                                                value.toString();
                                          });
                                          print(
                                              "selected radio value: $selectedRadioValue");
                                        },
                                      ),
                                      customText.kText(
                                        "Pick-up",
                                        16,
                                        FontWeight.w500,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Row(
                                    children: [
                                      Radio(
                                        fillColor: MaterialStateProperty.all(
                                            ColorConstants.kPrimary),
                                        value: 'delivery',
                                        groupValue: selectedRadioValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRadioValue =
                                                value.toString();
                                          });
                                          print(
                                              "selected radio value: $selectedRadioValue");
                                        },
                                      ),
                                      customText.kText(
                                        "Delivery",
                                        16,
                                        FontWeight.w500,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * .020),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          padding: const EdgeInsets.all(10),
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
                                margin: const EdgeInsets.only(bottom: 10),
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
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: customText.kText(
                                        TextConstants.itemTotal,
                                        14,
                                        FontWeight.w500,
                                        ColorConstants.lightGreyColor,
                                        TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: customText.kText(
                                        // "\$${totalAmount}",
                                        "\$${totalAmount + sidePrice}",
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
                                margin: const EdgeInsets.only(bottom: 10),
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
                                    margin: const EdgeInsets.only(bottom: 10),
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
                                          TextConstants.gstAndRestaurantCharges,
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
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: customText.kText(
                                      selectedRadioValue == "pickup"
                                          ? "\$0"
                                          : "\$$shippingPrice",
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
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: customText.kText(
                                      TextConstants.toPay,
                                      20,
                                      FontWeight.w700,
                                      ColorConstants.kPrimary,
                                      TextAlign.start,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: customText.kText(
                                      selectedRadioValue == "pickup"
                                          ? "\$${totalAmount}"
                                          : "\$${totalAmount + shippingPrice + sidePrice}",
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
                          margin: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          padding: const EdgeInsets.all(10),
                          height: height * .200,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        selectPaymentMethod();
                                      },
                                      child: Row(
                                        children: [
                                          customText.kText(
                                            TextConstants.change,
                                            20,
                                            FontWeight.w800,
                                            ColorConstants.kPrimary,
                                            TextAlign.start,
                                          ),
                                          SizedBox(width: width * .005),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: ColorConstants.kPrimary,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(30),
                                      height: height * .050,
                                      width: width * .050,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                ColorConstants.lightGreyColor,
                                            width: 3),
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: width * .020),
                                    Container(
                                      child: customText.kText(
                                        displayPaymentMethod,
                                        18,
                                        FontWeight.w800,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * .020),
                              Center(
                                child: SizedBox(
                                  height: height * 0.05,
                                  child: SliderButton(
                                    action: () async {
                                      print("slide to action button");
                                      if (selectedDeliveryAddress.isEmpty) {
                                        helper.errorDialog(context,
                                            "Please add your delivery address first");
                                      } else {
                                        if (selectedPaymentOption == "paypal") {
                                          payPalPaymentIntegration();
                                        } else if (selectedPaymentOption ==
                                            "stripe") {
                                          stripePaymentIntegration();
                                        } else {
                                          print(
                                              "selected payment value: ${selectedPaymentOption}");
                                          var response = await api.placeOrder(
                                            shippingPrice: shippingPrice.toString(),
                                            address: selectedDeliveryAddress,
                                            couponId: sideDrawerController
                                                .couponId
                                                .toString(),
                                            paymentMethod:
                                                selectedPaymentOption,
                                            totalPrice:
                                                selectedRadioValue == "pickup"
                                                    ? totalAmount
                                                    : totalAmount + shippingPrice + sidePrice,
                                            userId: loginController.userId
                                                .toString(),
                                            cartItems: sendCartItems,
                                            restaurantId: selectedRestauntId,
                                            cookingRequest:
                                                cookingInstructionsController
                                                    .text,
                                            deliveryType: selectedRadioValue,
                                            profileName: sideDrawerController
                                                .userProfileName
                                                .toString(),
                                          );
                                          if (response['success'] == true) {
                                            sideDrawerController
                                                .cartListRestaurant = "";
                                            helper.successDialog(
                                                context, response['message']);
                                            sideDrawerController.index.value =
                                                0;
                                            sideDrawerController.pageController
                                                .jumpToPage(sideDrawerController
                                                    .index.value);
                                          } else {
                                            helper.errorDialog(
                                                context, response['message']);
                                          }
                                        }
                                      }

                                      return false;
                                    },
                                    label: selectedPaymentOption == "cod"
                                        ? customText.kText(
                                            "Slide to place order",
                                            20,
                                            FontWeight.w700,
                                            Colors.white,
                                            TextAlign.start)
                                        : customText.kText(
                                            selectedRadioValue == "pickup"
                                                ? "${TextConstants.sliderToPay} \$$totalAmount"
                                                : "${TextConstants.sliderToPay} \$${totalAmount + shippingPrice + sidePrice}",
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
                                    // width: 230,
                                    // radius: 36,
                                    buttonColor: Colors.white,
                                    backgroundColor: ColorConstants.kPrimary,
                                    highlightedColor: Colors.white,
                                  ),
                                ),
                              )
                              // GestureDetector(
                              //   onTap: () {
                              //     // Navigator.pushReplacement(
                              //     //   context,
                              //     //   MaterialPageRoute(
                              //     //     builder: (context) => const OrderConfirmationScreen(),
                              //     //   ),
                              //     // );
                              //     // Navigator.pushReplacement(
                              //     //   context,
                              //     //   MaterialPageRoute(
                              //     //     builder: (context) => const OrderTrackingScreen(),
                              //     //   ),
                              //     // );
                              //   },
                              //   child: GestureDetector(
                              //     onTap: () async {},
                              //     child: Container(
                              //       margin: const EdgeInsets.only(
                              //           left: 15, right: 15),
                              //       height: height * .045,
                              //       width: double.infinity,
                              //       child: SliderButton(
                              //         action: () async {
                              //           print("slide to action button");
                              //           if (selectedPaymentOption == "paypal") {
                              //             payPalPaymentIntegration();
                              //           } else if (selectedPaymentOption ==
                              //               "stripe") {
                              //             stripePaymentIntegration();
                              //           } else {
                              //             print(
                              //                 "selected payment value: ${selectedPaymentOption}");
                              //             var response = await api.placeOrder(
                              //               address: selectedDeliveryAddress,
                              //               couponId: sideDrawerController
                              //                   .couponId
                              //                   .toString(),
                              //               paymentMethod:
                              //                   selectedPaymentOption,
                              //               totalPrice: totalAmount,
                              //               userId: loginController.userId
                              //                   .toString(),
                              //               cartItems: sendCartItems,
                              //               restaurantId: selectedRestauntId,
                              //               cookingRequest:
                              //                   cookingInstructionsController
                              //                       .text,
                              //             );
                              //
                              //             if (response['success'] == true) {
                              //               sideDrawerController
                              //                   .cartListRestaurant = "";
                              //               helper.successDialog(
                              //                   context, response['message']);
                              //               sideDrawerController.index.value =
                              //                   0;
                              //               sideDrawerController.pageController
                              //                   .jumpToPage(sideDrawerController
                              //                       .index.value);
                              //             } else {
                              //               helper.errorDialog(
                              //                   context, response['message']);
                              //             }
                              //           }
                              //
                              //           return true;
                              //         },
                              //         label: selectedPaymentOption == "cod"
                              //             ? customText.kText(
                              //                 "Slide to place order",
                              //                 20,
                              //                 FontWeight.w700,
                              //                 Colors.white,
                              //                 TextAlign.start)
                              //             : customText.kText(
                              //                 "${TextConstants.sliderToPay} \$$totalAmount",
                              //                 20,
                              //                 FontWeight.w700,
                              //                 Colors.white,
                              //                 TextAlign.start),
                              //         icon: const Center(
                              //             child: Icon(
                              //           Icons.keyboard_double_arrow_right,
                              //           color: ColorConstants.kPrimary,
                              //           size: 40.0,
                              //           semanticLabel:
                              //               'Text to announce in accessibility modes',
                              //         )),
                              //         width: 230,
                              //         radius: 36,
                              //         buttonColor: Colors.white,
                              //         backgroundColor: ColorConstants.kPrimary,
                              //         highlightedColor: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * .020),
                      ],
                    ),
                  ),
                ),
    );
  }

  void bottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
        final double width = MediaQuery.of(context).size.width;
        return StatefulBuilder(
          builder: (context, StateSetter update) {
            return Container(
              margin: const EdgeInsets.all(20),
              height: (addressList.isEmpty || addressList.length == 1)
                  ? height * .25
                  : height * .35,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: customText.kText(
                            TextConstants.chooseDeliveryAddress,
                            18,
                            FontWeight.bold,
                            Colors.black,
                            TextAlign.start),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: height * .080,
                          width: width * .080,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: addressList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDeliveryAddress =
                                  "${addressList[index]['area']} ${addressList[index]['house_no']} ${addressList[index]['city']} ${addressList[index]['zip_code']} ${addressList[index]['state']} ${addressList[index]['country']}";
                              print(
                                  "selected address: $selectedDeliveryAddress");
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: ColorConstants.lightGreyColor)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height * .050,
                                  width: width * .12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: ColorConstants.lightGreyColor,
                                      )),
                                  child: Center(
                                    child:
                                        addressList[index]['location'] == "home"
                                            ? const Icon(Icons.home,
                                                size: 20, color: Colors.black)
                                            : addressList[index]['location'] ==
                                                    "office"
                                                ? const Icon(
                                                    Icons.local_post_office,
                                                    size: 20,
                                                    color: Colors.black,
                                                  )
                                                : const Icon(Icons.location_on,
                                                    size: 20,
                                                    color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: width * .020),
                                Expanded(
                                  child: Container(
                                    child: customText.kText(
                                      "${addressList[index]['area']} ${addressList[index]['house_no']} ${addressList[index]['city']} ${addressList[index]['zip_code']} ${addressList[index]['state']} ${addressList[index]['country']}",
                                      16,
                                      FontWeight.w500,
                                      ColorConstants.lightGreyColor,
                                      TextAlign.start,
                                      TextOverflow.ellipsis,
                                      2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void selectPaymentMethod() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
        final double width = MediaQuery.of(context).size.width;
        return StatefulBuilder(
          builder: (context, StateSetter update) {
            return Container(
              margin: const EdgeInsets.all(20),
              height: height * .3,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: customText.kText(
                            TextConstants.chooseYourPaymentMethod,
                            18,
                            FontWeight.bold,
                            Colors.black,
                            TextAlign.start),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: height * .080,
                          width: width * .080,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .020),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        var value = "stripe";
                        selectedPaymentOption = value;
                        displayPaymentMethod = "Stripe";
                      });
                      print("value: $selectedPaymentOption");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Radio<String>(
                            activeColor: Colors.green,
                            value: 'stripe',
                            groupValue: selectedPaymentOption,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentOption = value!;
                                displayPaymentMethod = "Stripe";
                              });
                              print("value: $selectedPaymentOption");
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: width * .010),
                          customText.kText("Stripe", 18, FontWeight.w500,
                              Colors.black, TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * .010),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        var value = "paypal";
                        selectedPaymentOption = value;
                        displayPaymentMethod = "Paypal";
                      });
                      print("value: $selectedPaymentOption");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Radio<String>(
                            activeColor: Colors.green,
                            value: 'paypal',
                            groupValue: selectedPaymentOption,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentOption = value!;
                                displayPaymentMethod = "Paypal";
                              });

                              print("value: $selectedPaymentOption");
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: width * .010),
                          customText.kText("Paypal", 18, FontWeight.w500,
                              Colors.black, TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * .010),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        var value = "cod";
                        selectedPaymentOption = value!;
                        displayPaymentMethod = "Cash On Delivery";
                      });
                      print("value: $selectedPaymentOption");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Radio<String>(
                            activeColor: Colors.green,
                            value: 'cod',
                            groupValue: selectedPaymentOption,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentOption = value!;
                                displayPaymentMethod = "Cash On Delivery";
                              });
                              print("value: $selectedPaymentOption");
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: width * .010),
                          customText.kText("Cash On Delivery", 18,
                              FontWeight.w500, Colors.black, TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  paymentDoneNext() async {
    print("Hello paypal you are back now");
    var response;
    response = await api.placeOrder(
      address: selectedDeliveryAddress,
      couponId: sideDrawerController.couponId.toString(),
      paymentMethod: selectedPaymentOption,
      totalPrice:
          selectedRadioValue == "pickup" ? totalAmount : totalAmount + shippingPrice,
      userId: loginController.userId.toString(),
      cartItems: sendCartItems,
      restaurantId: selectedRestauntId,
      cookingRequest: cookingInstructionsController.text,
      deliveryType: selectedRadioValue,
      profileName: sideDrawerController.userProfileName.toString(),
    );
    if (response['success'] == true) {
      print("order placed successfully");
      sideDrawerController.cartListRestaurant = "";
      helper.successDialog(context, "order placed successfully");
      print("order placed successfully 11");

      helper.successDialog(context, response['message']);
      sideDrawerController.index.value = 0;
      sideDrawerController.pageController
          .jumpToPage(sideDrawerController.index.value);
    } else {
      helper.errorDialog(context, response['message']);
    }
  }

  // paypal payment ingteration
  payPalPaymentIntegration() {
    print("total amount in payal integration : ${totalAmount}");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: true,
          // clientId: "Aa_DDfHDzjtRDt79p5CHPk8LuXdaO-v7zENnTgVoRaFZRJlCBHB3VENT27ZBuvjK3Xt2_dfAKn7tbMq5", // test mode
          // secretKey: "EHNIRF-dASM4ZxEhAJ0LEoJhhO6ExoG3hSu0xdIWiaE8Y8i54Ge2SMzLJv2ffVOmN32keHuxjmarA0F6", // test mode
          clientId: "AY9hs_QItlsAqyE7SwyG0dq_0kR3_xsyi2C1g9AfXvLv21xlF7R9KLzqLgvKvJszQUQu-X__0JKFp8qT",  // production mode
          secretKey: "EJjtR2jCqEJYbKZcTrnhtuJCOb2hvcQqplbXXPld6i8jmIXEEjL3s2EBo8JV7AljTiUgTeSAVAoJvE9H",  // production mode
          returnURL: "https://getfooddelivery.com/return",
          cancelURL: "https://getfooddelivery.com/cancel",
          transactions: [
            {
              "amount": {
                "total": selectedRadioValue == "pickup"
                    ? '${totalAmount.toString()}'
                    : '${(totalAmount + shippingPrice).toString()}',
                "currency": "USD",
                "details": {
                  "subtotal": selectedRadioValue == "pickup"
                      ? '${totalAmount.toString()}'
                      : '${(totalAmount + shippingPrice).toString()}',
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              // "payment_options": {
              //   "allowed_payment_method":
              //       "INSTANT_FUNDING_SOURCE"
              // },
              "item_list": {
                "items": [
                  {
                    "name": "Food Items",
                    "quantity": 1,
                    "price": selectedRadioValue == "pickup"
                        ? '${totalAmount.toString()}'
                        : '${(totalAmount + shippingPrice).toString()}',
                    "currency": "USD"
                  }
                ],

                // shipping address is not required though
                "shipping_address": const {
                  "recipient_name": "Jane Foster",
                  "line1": "Travis County",
                  "line2": "",
                  "city": "Austin",
                  "country_code": "US",
                  "postal_code": "73301",
                  "phone": "+00000000",
                  "state": "Texas"
                },
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            print("paypal onSuccess: $params");
            paymentDoneNext();
          },
          onError: (error) {
            print("onError: $error");
          },
          onCancel: (params) {
            print('cancelled: $params');
          },
        ),
      ),
    );
  }

  // stripe payment functinality implementation

  Map<String, dynamic>? paymentIntent;
  Future<void> stripePaymentIntegration() async {
    print("total amount stripe: ${totalAmount.toString().split(".")[0]}");
    try {
      // 1️⃣ Create Payment Intent (Backend Required)
      paymentIntent = await createPaymentIntent(
        selectedRadioValue == "pickup"
            ? '${totalAmount.toString().split(".")[0]}'
            : '${(totalAmount + shippingPrice).toString().split(".")[0]}',
        'USD',
      );

      // 2️⃣ Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],


          // ✅ Correct way to enable Google Pay
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: "US", // Replace with your country code
            currencyCode: "USD", // Replace with your currency
            testEnv: true, // Set to false for production
          ),
          style: ThemeMode.dark,
          merchantDisplayName: 'Get Food Delivery',
        ),
      );

      // 3️⃣ Show Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      setState(() {
        paymentIntent = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment Successful!"),
        ),
      );

      var response;
      response = await api.placeOrder(
        address: selectedDeliveryAddress,
        couponId: sideDrawerController.couponId.toString(),
        paymentMethod: selectedPaymentOption,
        totalPrice:
            selectedRadioValue == "pickup" ? totalAmount : totalAmount + shippingPrice,
        userId: loginController.userId.toString(),
        cartItems: sendCartItems,
        restaurantId: selectedRestauntId,
        cookingRequest: cookingInstructionsController.text,
        deliveryType: selectedRadioValue,
        profileName: sideDrawerController.userProfileName.toString(),
      );
      if (response['success'] == true) {
        sideDrawerController.cartListRestaurant = "";
        helper.successDialog(context, response['message']);
        sideDrawerController.index.value = 0;
        sideDrawerController.pageController
            .jumpToPage(sideDrawerController.index.value);
      } else {
        helper.errorDialog(context, response['message']);
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment Failed!"),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String? currency) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (int.parse(amount) * 100).toString(), // Convert to cents
          'currency': "USD",
        },
      );
      print("response : ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception("Error creating payment intent: $e");
    }
  }
}
