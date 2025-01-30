import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';

class SpecialFoodDetail extends StatefulWidget {
  const SpecialFoodDetail({super.key});

  @override
  State<SpecialFoodDetail> createState() => _SpecialFoodDetailState();
}

class _SpecialFoodDetailState extends State<SpecialFoodDetail> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  final customText = CustomText();
  int quantity = 1;
  int calculatedPrice = 0;
  bool cartCalling = false;
  final api = API();
  final helper = Helper();

  void increaseQuantity() {
    print("Incrementing");

    quantity++;
    calculatedPrice = int.parse(
            sideDrawerController.specialFoodPrice.toString().split('.')[0]) *
        quantity;
    setState(() {});
    print("Quantity: $quantity");
    print("price: ${calculatedPrice.toString()}");
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      calculatedPrice = int.parse(
              sideDrawerController.specialFoodPrice.toString().split('.')[0]) *
          quantity;
      // price = (double.parse(price) * quantity).toStringAsFixed(2);
    }
    setState(() {});
    print("price: ${calculatedPrice.toString()}");
  }

  addToCart() async {
    setState(() {
      cartCalling = true;
    });

    final response = await api.addItemsToCart(
      userId: loginController.userId.toString(),
      price: calculatedPrice.toString(),
      quantity: quantity.toString(),
      restaurantId: sideDrawerController.specialFoodResId.toString(),
      productId: sideDrawerController.specialFoodProdId.toString(),
    );

    setState(() {
      cartCalling = false;
    });

    if (response["status"] == true) {
      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
      // Navigator.pop(context);
    } else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          // add to cart
          addToCart();
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // shape: BoxShape.circle,
            color: ColorConstants.kPrimary,
          ),
          child: Center(
            child: cartCalling
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : customText.kText(
                    TextConstants.addToCart,
                    20,
                    FontWeight.w800,
                    Colors.white,
                    TextAlign.center,
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                        customText.kText(
                            sideDrawerController.specialFoodName.isEmpty
                                ? TextConstants.favourite
                                : sideDrawerController.specialFoodName,
                            28,
                            FontWeight.w900,
                            Colors.white,
                            TextAlign.center),
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
                                    text: " / ${TextConstants.specialFood}",
                                    style: customText.kSatisfyTextStyle(
                                        24,
                                        FontWeight.w400,
                                        ColorConstants.kPrimary))
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
                color: Colors.grey.shade200,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      sideDrawerController.specialFoodImage.toString()),
                ),
              ),
            ),
            SizedBox(height: height * .02),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: customText.kText(sideDrawerController.specialFoodName, 32,
                  FontWeight.w800, ColorConstants.kPrimary, TextAlign.start),
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
                        child: customText.kText(
                            "-\$${sideDrawerController.specialFoodPrice}",
                            32,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.start),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                decreaseQuantity();
                              },
                              child: Container(
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
                                  "${quantity.toString()}",
                                  16,
                                  FontWeight.bold,
                                  Colors.black,
                                  TextAlign.center,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                increaseQuantity();
                              },
                              child: Container(
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
                            ),
                          ],
                        )),
                  ],
                )),
            SizedBox(height: height * .01),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: customText.kText(
                  calculatedPrice == 0
                      ? "Calculated Price -\$ ${sideDrawerController.specialFoodPrice.toString()}"
                      : "Calculated Price -\$ ${calculatedPrice.toString()}",
                  16,
                  FontWeight.w800,
                  Colors.black,
                  TextAlign.start),
            ),
            SizedBox(height: height * .02),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: customText.kText(
                sideDrawerController.specialFoodName,
                16,
                FontWeight.w700,
                ColorConstants.kPrimary,
                TextAlign.start,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
