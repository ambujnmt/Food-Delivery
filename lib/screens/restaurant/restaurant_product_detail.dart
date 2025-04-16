import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/deal_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marquee/marquee.dart';

class RestaurantProductDetail extends StatefulWidget {
  const RestaurantProductDetail({super.key});

  @override
  State<RestaurantProductDetail> createState() =>
      _RestaurantProductDetailState();
}

class _RestaurantProductDetailState extends State<RestaurantProductDetail> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  DealsController dealsController = Get.put(DealsController());
  final customText = CustomText();
  int quantity = 1;
  int calculatedPrice = 0;
  bool cartCalling = false;
  bool isApiCalling = false;
  bool detailCalling = false;
  final api = API();
  final helper = Helper(), box = GetStorage();

  List<dynamic> bestDealsList = [];
  Map<String, dynamic> resproductDetail = {};
  List<dynamic> extraFeatureList = [];
  List<dynamic> extraFeatureToCart = [];
  List<bool> isChecked = [false];

  // food details api integration
  foodDetail() async {
    print("restaurant product id: ${sideDrawerController.restaurantProductId}");
    setState(() {
      detailCalling = true;
    });
    final response = await api.foodDetails(
        foodId: sideDrawerController.restaurantProductId.toString());

    setState(() {
      detailCalling = false;
    });

    if (response["status"] == true) {
      setState(() {
        resproductDetail = response['data'];
        for (int i = 0; i < resproductDetail["extra_features"].length; i++) {
          extraFeatureList.add(resproductDetail["extra_features"][i]);
        }
        isChecked = List.generate(extraFeatureList.length, (index) => false);
      });

      print("res product food detail: $resproductDetail");
      print("ex fea: $extraFeatureList");
    } else {
      print('error message: ${response["message"]}');
    }
  }

  addRecent() async {
    final response = await api.addToRecent(
      type: "product",
      id: sideDrawerController.restaurantProductId,
    );
    if (response['success'] == true) {
      print("Added to the recent viewed");
    } else {
      print("Error in adding to the recent viewed");
    }
  }

  // best deals list
  bestDealsData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.bestDeals();
    setState(() {
      bestDealsList = response['data'];
      // print("best deals image: ${bestDealsList[0]["image"]}");
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' best deals success message: ${response["message"]}');
    } else {
      print('best deals error message: ${response["message"]}');
    }
  }

  void increaseQuantity() {
    print("Incrementing");

    quantity++;
    calculatedPrice =
        int.parse(resproductDetail['price'].toString().split('.')[0]) *
            quantity;
    setState(() {});
    print("Quantity: $quantity");
    print("price: ${calculatedPrice.toString()}");
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      calculatedPrice =
          int.parse(resproductDetail['price'].toString().split('.')[0]) *
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
      price: calculatedPrice == 0
          ? resproductDetail['price'].toString()
          : calculatedPrice.toString(),
      quantity: quantity.toString(),
      restaurantId: sideDrawerController.restaurantId.toString(),
      productId: sideDrawerController.restaurantProductId.toString(),
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

  @override
  void initState() {
    bestDealsData();
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
                  Container(
                    height: height * .060,
                    width: double.infinity,
                    child: bestDealsList.isEmpty
                        ? isApiCalling
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.kPrimary,
                                ),
                              )
                            : Center(
                                child: customText.kText(
                                    "No deals available at the moment",
                                    18,
                                    FontWeight.w400,
                                    Colors.black,
                                    TextAlign.center),
                              )
                        : GestureDetector(
                            onTap: () {
                              dealsController.comingFrom = "home";
                              sideDrawerController.index.value = 4;
                              sideDrawerController.pageController
                                  .jumpToPage(sideDrawerController.index.value);
                            },
                            child: Marquee(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: "Raleway",
                              ),
                              text: bestDealsList
                                  .map((deal) =>
                                      "Today's ${deal['title']} | \$${deal['price']}")
                                  .join("   ●   "),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 20.0,
                              velocity: 100.0,
                            ),
                          ),
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
                                  sideDrawerController.detailRestaurantName,
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
                                          text:
                                              " / ${TextConstants.foodDetail}",
                                          style: customText.kSatisfyTextStyle(
                                              24,
                                              FontWeight.w400,
                                              ColorConstants.kPrimary))
                                    ]),
                              ),
                              customText.kText(
                                  "${sideDrawerController.restaurantDistance.toString().substring(0, 5) ?? "0"} mls",
                                  28,
                                  FontWeight.w900,
                                  ColorConstants.kPrimary,
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
                            resproductDetail['image_url'].toString() ?? ""),
                      ),
                    ),
                  ),
                  SizedBox(height: height * .02),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: customText.kText(
                        resproductDetail['name'] ?? "",
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
                                  "\$${resproductDetail['price'] ?? ""}",
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
                            ? "Calculated Price \$ ${resproductDetail['price'].toString()}"
                            : "Calculated Price \$ ${calculatedPrice.toString()}",
                        16,
                        FontWeight.w800,
                        Colors.black,
                        TextAlign.start),
                  ),
                  SizedBox(height: height * .02),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: customText.kText(
                        resproductDetail['description'] ?? "",
                        16,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start,
                        TextOverflow.visible,
                        50),
                  ),
                  SizedBox(height: height * .01),

                  Container(
                    margin: EdgeInsets.only(left: 20),
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
                  SizedBox(height: height * .02),
                  GestureDetector(
                    onTap: () async {
                      if (sideDrawerController.cartListRestaurant.isEmpty ||
                          sideDrawerController.cartListRestaurant ==
                              sideDrawerController.restaurantId.toString()) {
                        await box.write("cartListRestaurant",
                            sideDrawerController.restaurantId.toString());
                        setState(() {
                          sideDrawerController.cartListRestaurant =
                              sideDrawerController.restaurantId.toString();
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
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
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
