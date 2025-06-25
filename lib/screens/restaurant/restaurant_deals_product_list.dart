import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/deal_controller.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/utils/custom_deals_restaurant.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_specific_food.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marquee/marquee.dart';

class RestaurantProductsList extends StatefulWidget {
  const RestaurantProductsList({super.key});

  @override
  State<RestaurantProductsList> createState() => _RestaurantProductsListState();
}

class _RestaurantProductsListState extends State<RestaurantProductsList> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  DealsController dealsController = Get.put(DealsController());

  final customText = CustomText();

  String? selectedValue;
  bool isApiCalling = false;
  final api = API(), helper = Helper(), box = GetStorage();
  List<dynamic> productList = [];

  List<dynamic> bestDealsList = [];

  // get special food list
  getAllSpecialFoodData() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.productListBasedOnRestaurant(
      dealId: sideDrawerController.dealsIdForProduct,
      restaurantId: sideDrawerController.resIdForProd,
    );

    setState(() {
      productList = response['data'];
    });

    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('deal products list message: ${response["message"]}');
    } else {
      print('deal product list error message: ${response["message"]}');
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

  @override
  void initState() {
    // TODO: implement initState
    getAllSpecialFoodData();
    bestDealsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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
                                  "Today's ${deal['title']} | ${deal["products"][0]["name"]} \$${deal['price']}")
                              .join("   ●   "),

                          scrollAxis: Axis.horizontal,
                          blankSpace: 20.0,
                          velocity: 100.0,
                          // pauseAfterRound: const Duration(seconds: 1),
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
                              sideDrawerController.detailTitleForDetail,
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
                                          " / ${sideDrawerController.detailTitleForDetail}",
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
              SizedBox(height: height * .01),
              isApiCalling
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.kPrimary,
                      ),
                    )
                  : productList.isEmpty
                      ? CustomNoDataFound()
                      : Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 1.0,
                                childAspectRatio: 1 / 1.2,
                              ),
                              itemCount: productList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: CustomDealsRestaurant(
                                    imagePress: () {
                                      //---------------//
                                      sideDrawerController.dealIdForDetail =
                                          productList[index]['deal_id']
                                              .toString();
                                      sideDrawerController.prodForDetail =
                                          productList[index]['product_id']
                                              .toString();
                                      sideDrawerController.resIdForDetail =
                                          productList[index]['restaurant_id']
                                              .toString();

                                      //-------------------//

                                      sideDrawerController.previousIndex.add(
                                          sideDrawerController.index.value);
                                      sideDrawerController.index.value = 41;
                                      sideDrawerController.pageController
                                          .jumpToPage(
                                              sideDrawerController.index.value);
                                    },
                                    addToCartPress: () async {
                                      if (loginController
                                          .accessToken.isNotEmpty) {
                                        if (sideDrawerController
                                                .cartListRestaurant.isEmpty ||
                                            sideDrawerController
                                                    .cartListRestaurant ==
                                                productList[index]
                                                        ["restaurant_id"]
                                                    .toString()) {
                                          await box.write(
                                              "cartListRestaurant",
                                              productList[index]
                                                      ["restaurant_id"]
                                                  .toString());

                                          setState(() {
                                            sideDrawerController
                                                    .cartListRestaurant =
                                                productList[index]
                                                        ["restaurant_id"]
                                                    .toString();
                                          });

                                          bottomSheet(
                                              productList[index]['image'],
                                              productList[index]['name'],
                                              productList[index]['price'],
                                              productList[index]['product_id']
                                                  .toString(),
                                              productList[index]
                                                      ['restaurant_id']
                                                  .toString(),
                                              productList[index]['deal_id']
                                                  .toString());
                                        } else {
                                          helper.errorDialog(context,
                                              "Your cart is already have food from different restaurant");
                                        }
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      }
                                    },
                                    imageURL: "${productList[index]['image']}",
                                    addTocart: TextConstants.addToCart,
                                    amount: "\$${productList[index]['price']}",
                                    foodItemName:
                                        "${productList[index]['name']}",
                                  ),
                                );
                              }),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  // bottom sheet for adding items to the cart
  void bottomSheet(String image, String name, String price, String productId,
      String restaurantId, String dealId) {
    int quantity = 1;
    int calculatedPrice = 0;
    bool cartCalling = false;
    final api = API();
    final helper = Helper();

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
            void increaseQuantity() {
              print("Incrementing");

              quantity++;
              calculatedPrice =
                  int.parse(price.toString().split('.')[0]) * quantity;
              update(() {});
              print("Quantity: $quantity");
              print("price: ${calculatedPrice.toString()}");
            }

            void decreaseQuantity() {
              if (quantity > 1) {
                quantity--;
                calculatedPrice =
                    int.parse(price.toString().split('.')[0]) * quantity;
                // price = (double.parse(price) * quantity).toStringAsFixed(2);
              }
              update(() {});
              print("price: ${calculatedPrice.toString()}");
            }

            addToCart() async {
              update(() {
                cartCalling = true;
              });

              final response = await api.addItemsToCartByDealId(
                userId: loginController.userId.toString(),
                price: calculatedPrice.toString(),
                quantity: quantity.toString(),
                restaurantId: sideDrawerController.restaurantId,
                // restaurantId: restaurantId.toString(),
                productId: productId.toString(),
                dealId: dealId.toString(),
              );

              update(() {
                cartCalling = false;
              });

              if (response["status"] == true) {
                print('success message: ${response["message"]}');
                helper.successDialog(context, response["message"]);
                Navigator.pop(context);
              } else {
                helper.errorDialog(context, response["error"]);
                print('error message: ${response["error"]}');
              }
            }

            return Container(
              margin: EdgeInsets.all(20),
              height: height * .25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: height * .050,
                        width: width * .1,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: NetworkImage(image),
                          ),
                        ),
                      ),
                      Container(
                        child: customText.kText(
                          name,
                          18,
                          FontWeight.w800,
                          Colors.black,
                          TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .010),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: customText.kText(
                              "\$$price",
                              20,
                              FontWeight.w800,
                              Colors.black,
                              TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Container(
                            child: customText.kText(
                              calculatedPrice == 0
                                  ? "Total amount: \$$price"
                                  : "Total amount: \$$calculatedPrice",
                              20,
                              FontWeight.w800,
                              Colors.black,
                              TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: height * .050,
                        width: width * .3,
                        decoration: BoxDecoration(
                          color: ColorConstants.kPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                decreaseQuantity();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: customText.kText(
                                quantity.toString(),
                                18,
                                FontWeight.w800,
                                Colors.white,
                                TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                increaseQuantity();
                              },
                              child: Container(
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .020),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        addToCart();
                      },
                      child: Container(
                        width: width * .2,
                        height: height * .050,
                        decoration: BoxDecoration(
                          color: ColorConstants.kPrimary,
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                        child: Center(
                          child: cartCalling
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : customText.kText(
                                  TextConstants.add,
                                  18,
                                  FontWeight.w900,
                                  Colors.white,
                                  TextAlign.center,
                                ),
                        ),
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
}
