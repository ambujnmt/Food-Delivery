import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DealsDetail extends StatefulWidget {
  const DealsDetail({super.key});

  @override
  State<DealsDetail> createState() => _DealsDetailState();
}

class _DealsDetailState extends State<DealsDetail> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  final customText = CustomText();
  int quantity = 1;
  int calculatedPrice = 0;
  bool cartCalling = false;
  bool detailCalling = false;
  final api = API(), box = GetStorage();
  final helper = Helper();

  Map<String, dynamic> dealFoodDetail = {};
  List<dynamic> extraFeatureList = [];
  List<dynamic> extraFeatureToCart = [];
  List<bool> isChecked = [false];

  // food details api integration
  foodDetail() async {
    print("prod id: ${sideDrawerController.bestDealsProdId}");
    print("deal id: ${sideDrawerController.bestDealsId}");
    setState(() {
      detailCalling = true;
    });
    final response = await api.dealfoodDetails(
      productId: sideDrawerController.bestDealsProdId.toString(),
      dealId: sideDrawerController.bestDealsId.toString(),
    );

    setState(() {
      detailCalling = false;
    });

    if (response["status"] == true) {
      setState(() {
        dealFoodDetail = response['data'];
        for (int i = 0; i < dealFoodDetail["extra_features"].length; i++) {
          extraFeatureList.add(dealFoodDetail["extra_features"][i]);
        }
        isChecked = List.generate(extraFeatureList.length, (index) => false);
      });

      print("deal food detail: $dealFoodDetail");
      print("ex fea: $extraFeatureList");
    } else {
      print('error message: ${response["message"]}');
    }
  }

  void increaseQuantity() {
    print("Incrementing");

    quantity++;
    calculatedPrice =
        int.parse(dealFoodDetail['price'].toString().split('.')[0]) * quantity;
    setState(() {});
    print("Quantity: $quantity");
    print("price: ${calculatedPrice.toString()}");
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      calculatedPrice =
          int.parse(dealFoodDetail['price'].toString().split('.')[0]) *
              quantity;
      // price = (double.parse(price) * quantity).toStringAsFixed(2);
    }
    setState(() {});
    print("price: ${calculatedPrice.toString()}");
  }

  addToCart() async {
    print("user id: ${loginController.userId}");
    print("calculated price: ${calculatedPrice}");
    print("quantity: ${quantity}");
    print("res id: ${sideDrawerController.bestDealsResId}");
    print("prod id : ${sideDrawerController.bestDealsProdId}");

    setState(() {
      cartCalling = true;
    });

    final response = await api.addItemsToCartByDealId(
      userId: loginController.userId.toString(),
      price: calculatedPrice == 0
          ? dealFoodDetail['price'].toString()
          : calculatedPrice.toString(),
      quantity: quantity.toString(),
      restaurantId: sideDrawerController.bestDealsResId.toString(),
      productId: sideDrawerController.bestDealsProdId.toString(),
      dealId: sideDrawerController.bestDealsId.toString(),
      extraFeature: extraFeatureToCart,
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

  addRecent() async {
    final response = await api.addToRecent(
      type: "product",
      id: sideDrawerController.bestDealsProdId,
    );
    if (response['success'] == true) {
      print("Added to the recent viewed");
    } else {
      print("Error in adding to the recent viewed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    calculatedPrice = int.parse(
        sideDrawerController.bestDealsProdPrice.toString().split('.')[0]);
    if (loginController.accessToken.isNotEmpty) {
      addRecent();
    }
    foodDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: detailCalling
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.kPrimary,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: height * .050,
                  // ),
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
                                  sideDrawerController
                                          .bestDealsRestaurantName.isEmpty
                                      ? TextConstants.bestDeals
                                      : sideDrawerController
                                              .bestDealsRestaurantName ??
                                          '',
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
                                          text: " / ${TextConstants.bestDeals}",
                                          style: customText.kSatisfyTextStyle(
                                              24,
                                              FontWeight.w400,
                                              ColorConstants.kPrimary))
                                    ]),
                              ),
                              customText.kText(
                                  "${sideDrawerController.distanceInMiles} ?? 0 Mls",
                                  24,
                                  FontWeight.w700,
                                  Colors.red,
                                  TextAlign.center),
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
                            dealFoodDetail['image_url'].toString() ?? ''),
                      ),
                    ),
                  ),
                  SizedBox(height: height * .02),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: customText.kText(
                        dealFoodDetail['name'] ?? "",
                        32,
                        FontWeight.w800,
                        ColorConstants.kPrimary,
                        TextAlign.start),
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
                                  "-\$${dealFoodDetail['price'] ?? ""}",
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
                            ? "Calculated Price -\$ ${dealFoodDetail['price'].toString()}"
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
                        dealFoodDetail['description'] ?? '',
                        16,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start,
                        TextOverflow.visible,
                        50),
                  ),
                  SizedBox(height: height * .01),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: customText.kText("Free ads on", 24, FontWeight.w800,
                        Colors.black, TextAlign.start),
                  ),
                  SizedBox(height: height * .01),
                  extraFeatureList.isEmpty
                      ? Container(
                    margin: EdgeInsets.only(left: 20),
                    child: customText.kText("No free ads on", 18, FontWeight.w500,
                        Colors.black, TextAlign.start),
                  )
                      : Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: extraFeatureList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: ColorConstants.kPrimary,
                                      value: isChecked[index],
                                      onChanged: (bool? value) {
                                        print("value :- ${value!}");
                                        setState(() {
                                          isChecked[index] = value;
                                          if (isChecked[index] == true) {
                                            extraFeatureToCart
                                                .add(extraFeatureList[index]);
                                          } else if (isChecked[index] ==
                                              false) {
                                            extraFeatureToCart.removeAt(index);
                                          }
                                        });
                                        print(
                                            "extra feature to cart: ${extraFeatureToCart}");
                                        // saveRememberMe(value!);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  customText.kText(
                                    extraFeatureList[index].toString(),
                                    16,
                                    FontWeight.w700,
                                    Colors.black,
                                    TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  SizedBox(width: width * 0.02),
                  GestureDetector(
                    onTap: () async {
                      if (loginController.accessToken.isNotEmpty) {
                        if (sideDrawerController.cartListRestaurant.isEmpty ||
                            sideDrawerController.cartListRestaurant ==
                                sideDrawerController.bestDealsResId
                                    .toString()) {
                          await box.write("cartListRestaurant",
                              sideDrawerController.bestDealsResId.toString());
                          setState(() {
                            sideDrawerController.cartListRestaurant =
                                sideDrawerController.bestDealsResId.toString();
                          });
                          if (loginController.accessToken.isNotEmpty) {
                            addToCart();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          }
                        } else {
                          helper.errorDialog(context,
                              "Your cart is already have food from different restaurant");
                        }

                        // addToCart();
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
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
                ],
              )),
            ),
    );
  }
}
