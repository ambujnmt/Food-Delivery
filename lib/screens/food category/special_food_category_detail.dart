import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/controllers/deal_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marquee/marquee.dart';

import '../../special_food_model.dart';

class SpecificFoodCategoryDetail extends StatefulWidget {
  const SpecificFoodCategoryDetail({super.key});

  @override
  State<SpecificFoodCategoryDetail> createState() =>
      _SpecificFoodCategoryDetailState();
}

class _SpecificFoodCategoryDetailState
    extends State<SpecificFoodCategoryDetail> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  DealsController dealsController = Get.put(DealsController());

  final customText = CustomText();
  int quantity = 1;
  int calculatedPrice = 0;
  bool cartCalling = false;
  bool detailCalling = false;
  bool isApiCalling = false;
  List<SideItem> extraSideItemList = [];
  SideItem? _sideitemChoose;
  String? _errorSideItem;

  Question? _selectedQuestion;
  Option? _selectedOption;
  String? _errorQuestion;
  String? _errorOption;

  List<OftenBoughtWithGroup> extraOftenBoughtList = [];
  Map<int, OftenBoughtWithOption?> selectedOftenBoughtOptions = {};

  final api = API(), box = GetStorage();
  final helper = Helper();

  Map<String, dynamic> specialFoodDetail = {};
  List<dynamic> extraFeatureList = [];
  List<dynamic> extraFeatureToCart = [];
  List<dynamic> bestDealsList = [];
  List<bool> isChecked = [false];

  Position? _currentPosition;
  String _currentAddress = 'Unknown location';
  String? getLatitude;
  String? getLongitude;
  String calculatedDistance = "";

  // food details api integration
  // foodDetail() async {
  //   setState(() {
  //     detailCalling = true;
  //   });
  //   final response = await api.foodDetails(
  //       foodId: sideDrawerController.SpecificFoodProId.toString());
  //
  //   setState(() {
  //     detailCalling = false;
  //   });
  //
  //   if (response["status"] == true) {
  //     setState(() {
  //       specialFoodDetail = response['data'];
  //       for (int i = 0; i < specialFoodDetail["extra_features"].length; i++) {
  //         extraFeatureList.add(specialFoodDetail["extra_features"][i]);
  //       }
  //       isChecked = List.generate(extraFeatureList.length, (index) => false);
  //     });
  //
  //     print("special food detail: $specialFoodDetail");
  //     print("ex fea: $extraFeatureList");
  //   } else {
  //     print('cart list error message: ${response["message"]}');
  //   }
  // }
  foodDetail() async {
    setState(() {
      detailCalling = true;
    });
    final response = await api.foodDetails(
        foodId: sideDrawerController.SpecificFoodProId.toString());
    setState(() {
      detailCalling = false;
    });

    if (response["status"] == true) {
      print("special food detail");
      setState(() {
        specialFoodDetail = response['data'];
        for (int i = 0; i < specialFoodDetail["extra_features"].length; i++) {
          extraFeatureList.add(specialFoodDetail["extra_features"][i]);
        }
        isChecked = List.generate(extraFeatureList.length, (index) => false);
        extraSideItemList.clear();
        if (specialFoodDetail["side_items"] != null) {
          for (var itemJson in specialFoodDetail["side_items"]) {
            extraSideItemList.add(SideItem.fromJson(itemJson));
          }
        }
        extraOftenBoughtList.clear();
        selectedOftenBoughtOptions.clear();
        if (specialFoodDetail["often_bought_with"] != null) {
          for (var groupJson in specialFoodDetail["often_bought_with"]) {
            OftenBoughtWithGroup group =
                OftenBoughtWithGroup.fromJson(groupJson);
            extraOftenBoughtList.add(group);
            selectedOftenBoughtOptions[group.id] = null;
          }
        }
      });
      print("special food detail: $specialFoodDetail");
      print("ex fea: $extraFeatureList");
      print("extra side item list: $extraSideItemList");
      print("extra Often Bought   list: $extraOftenBoughtList");
    } else {
      print('error message: ${response["message"]}');
    }
  }

  void increaseQuantity() {
    print("Incrementing");

    quantity++;
    calculatedPrice =
        int.parse(specialFoodDetail['price'].toString().split('.')[0]) *
            quantity;
    setState(() {});
    print("Quantity: $quantity");
    print("price: ${calculatedPrice.toString()}");
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      calculatedPrice =
          int.parse(specialFoodDetail['price'].toString().split('.')[0]) *
              quantity;
      // price = (double.parse(price) * quantity).toStringAsFixed(2);
    }
    setState(() {});
    print("price: ${calculatedPrice.toString()}");
  }

  // addToCart(
  //     {String? sideOptionsId,
  //     String? sideItemId,
  //     String? sideQuestionId,
  //     String? sidePriceId,
  //     String? selectedOptionPrice,
  //     String? oftenBoughtOptionsId,
  //     String? optionGroupId,
  //     String? oftenBoughtOptionGroupPrice}) async {
  //   setState(() {
  //     cartCalling = true;
  //   });
  //
  //
  //   print("SideItem..........$sideItemId,$sideQuestionId,$sideOptionsId........Price..$sidePriceId..$selectedOptionPrice");
  //
  //   print("OftenItem....$optionGroupId,$oftenBoughtOptionsId..Price..$oftenBoughtOptionGroupPrice");
  //
  //
  //   // Parse and calculate the total price including side options and often bought items
  //   double basePrice = calculatedPrice == 0
  //       ? double.tryParse(specialFoodDetail['price'].toString()) ?? 0.0
  //       : calculatedPrice.toDouble();
  //
  //   double sideItemPrice = double.tryParse(sidePriceId ?? '0.0') ?? 0.0;
  //   double optionPrice = double.tryParse(selectedOptionPrice ?? '0.0') ?? 0.0;
  //   double oftenBoughtPrice = double.tryParse(oftenBoughtOptionGroupPrice ?? '0.0') ?? 0.0;
  //
  //   print("basePrice$basePrice,sideItemPrice$sideItemPrice,optionPrice$optionPrice,oftenBoughtPrice$oftenBoughtPrice");
  //
  //   double totalPrice = sideItemPrice + optionPrice + oftenBoughtPrice;
  //
  //   print("totalPrice$totalPrice");
  //
  //   final response = await api.addItemsToCart(
  //     ///old work by pardeep
  //     // userId: loginController.userId.toString(),
  //     // price: calculatedPrice == 0
  //     //     ? specialFoodDetail['price'].toString()
  //     //     : calculatedPrice.toString(),
  //     // quantity: quantity.toString(),
  //     // restaurantId: sideDrawerController.specificFoodResId.toString(),
  //     // productId: sideDrawerController.SpecificFoodProId.toString(),
  //     // extraFeature: extraFeatureToCart,
  //     ///new added
  //     userId: loginController.userId.toString(),
  //     price: calculatedPrice == 0
  //         ? specialFoodDetail['price'].toString()
  //         : calculatedPrice.toString() ,
  //     sidePrice: totalPrice.toString(),
  //     quantity: quantity.toString(),
  //     restaurantId: sideDrawerController.specialFoodResId.toString(),
  //     productId: sideDrawerController.specialFoodProdId.toString(),
  //     extraFeature: extraFeatureToCart,
  //     sideOptionsId:sideOptionsId,
  //     sideItemId: sideItemId,
  //     sideQuestionId: sideQuestionId,
  //     oftenBoughtOptionsId: oftenBoughtOptionsId,
  //     optionGroupId: optionGroupId,
  //   );
  //   setState(() {
  //     cartCalling = false;
  //   });
  //
  //   if (response["status"] == true) {
  //     print('success message: ${response["message"]}');
  //     helper.successDialog(context, response["message"]);
  //     // Navigator.pop(context);
  //   } else {
  //     helper.errorDialog(context, response["message"]);
  //     print('error message: ${response["message"]}');
  //   }
  // }
  addToCart(
      {String? sideOptionsId,
      String? sideItemId,
      String? sideQuestionId,
      String? sidePriceId,
      String? selectedOptionPrice,
      String? oftenBoughtOptionsId,
      String? optionGroupId,
      String? oftenBoughtOptionGroupPrice}) async {
    setState(() {
      cartCalling = true;
    });

    try {
      print(
          "SideItem..........$sideItemId,$sideQuestionId,$sideOptionsId........Price..$sidePriceId..$selectedOptionPrice");
      print(
          "OftenItem....$optionGroupId,$oftenBoughtOptionsId..Price..$oftenBoughtOptionGroupPrice");

      // Parse and calculate the total price including side options and often bought items
      double basePrice = calculatedPrice == 0
          ? double.tryParse(specialFoodDetail['price']?.toString() ?? '0') ??
              0.0
          : calculatedPrice.toDouble();

      double sideItemPrice = double.tryParse(sidePriceId ?? '0') ?? 0.0;
      double optionPrice = double.tryParse(selectedOptionPrice ?? '0') ?? 0.0;

      // Handle multiple often bought items (comma-separated prices)
      double oftenBoughtPrice = 0.0;
      if (oftenBoughtOptionGroupPrice != null &&
          oftenBoughtOptionGroupPrice.isNotEmpty) {
        List<String> prices = oftenBoughtOptionGroupPrice.split(',');
        for (String price in prices) {
          oftenBoughtPrice += double.tryParse(price.trim()) ?? 0.0;
        }
      }

      print(
          "basePrice: $basePrice, sideItemPrice: $sideItemPrice, optionPrice: $optionPrice, oftenBoughtPrice: $oftenBoughtPrice");

      double totalSidePrice = sideItemPrice + optionPrice + oftenBoughtPrice;

      // Calculate final total price including base price
      double finalTotalPrice = basePrice + totalSidePrice;

      print(
          "totalSidePrice: $totalSidePrice, finalTotalPrice: $finalTotalPrice");

      final response = await api.addItemsToCart(
        userId: loginController.userId.toString(),
        price: basePrice.toString(), // Base item price
        sidePrice: totalSidePrice.toString(), // Additional side items price
        quantity: quantity.toString(),
            restaurantId: sideDrawerController.specificFoodResId.toString(),
            productId: sideDrawerController.SpecificFoodProId.toString(),
        extraFeature: extraFeatureToCart ?? [],
        sideOptionsId: sideOptionsId ?? "",
        sideItemId: sideItemId ?? "",
        sideQuestionId: sideQuestionId ?? "",
        oftenBoughtOptionsId: oftenBoughtOptionsId ?? "",
        optionGroupId: optionGroupId ?? "",
      );
      print(".......$basePrice,$totalSidePrice,$quantity,${sideDrawerController.specificFoodResId.toString()},${sideDrawerController.SpecificFoodProId.toString()}");

      setState(() {
        cartCalling = false;
      });

      if (response != null && response["status"] == true) {
        print('Success message: ${response["message"]}');
        helper.successDialog(context, response["message"]);
        // Optionally navigate back or refresh cart
        // Navigator.pop(context);
      } else {
        String errorMessage =
            response?["error"] ?? "Failed to add item to cart";
        helper.errorDialog(context, errorMessage);
        print('Error message: $errorMessage');
      }
    } catch (e) {
      setState(() {
        cartCalling = false;
      });
      print('Exception in addToCart: $e');
      helper.errorDialog(
          context, "An error occurred while adding item to cart");
    }
  }

  addRecent() async {
    final response = await api.addToRecent(
      type: "product",
      id: sideDrawerController.SpecificFoodProId,
    );
    if (response['success'] == true) {
      print("Added to the recent viewed");
    } else {
      print("Error in adding to the recent viewed");
    }
  }

  getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _currentAddress =
          'Lat: ${position.latitude}, Long: ${position.longitude}';
      getLatitude = position.latitude.toString();
      getLongitude = position.longitude.toString();
    });
  }

  // Get Current Location
  String calculateDistance({String? restaurantLat, String? restaurantLong}) {
    getCurrentPosition();
    print("get lat: ${getLatitude}");
    print("get long: ${getLongitude}");
    try {
      // Calculate distance in meters
      double distanceInMeters = Geolocator.distanceBetween(
        double.parse(getLatitude.toString()),
        double.parse(getLongitude.toString()),
        double.parse(restaurantLat.toString()),
        double.parse(restaurantLong.toString()),
      );

      // Convert to miles
      double distanceInMiles = distanceInMeters / 1609.34;
      String formattedMiles = distanceInMiles.toStringAsFixed(2);

      print("Distance: ${distanceInMeters.toStringAsFixed(2)} meters");
      print("Distance in miles updated: $formattedMiles miles");

      return "$formattedMiles Mls";
    } catch (e) {
      print("Error retrieving location: $e");
      return "Loading...";
    }
  }

  bestDeals() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.bestDeals();
    setState(() {
      bestDealsList = response['data'];

      // for (int i = 0; i < bestDealsList.length; i++) {
      //   // productsList.add(allBestDealsList[i]['products']);
      //   int productLength = bestDealsList[i]["products"].length;
      //   for (int j = 0; j < productLength; j++) {
      //     bestDealsProductList.add(bestDealsList[i]["products"][j]);
      //   }
      //   // productsList = allBestDealsList[i]['products'];
      // }

      // print(' product list and length: ${bestDealsProductList.length} list: ${bestDealsProductList}');
      // print(
      // ' product list and length: ${bestDealsProductList.length} list: ${bestDealsProductList}');
      log("best deal list :- $bestDealsList, ${bestDealsList.length}");
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print('best deals success message: ${response["message"]}');
      // print('product list: ${bestDealsProductList}');
    } else {
      print('best deals error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // sideDrawerController.previousIndex.add(sideDrawerController.index.value);
    bestDeals();
    print(
        " list value of specific food detsil: ${sideDrawerController.previousIndex}");
    if (loginController.accessToken.isNotEmpty) {
      print("before recent call");
      addRecent();
      print("after recent call");
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
                  SizedBox(
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
                                  sideDrawerController.specificCatTitle.isEmpty
                                      ? TextConstants.foodCategory
                                      : sideDrawerController.specificCatTitle,
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
                                              " / ${TextConstants.foodCategory}",
                                          style: customText.kSatisfyTextStyle(
                                              24,
                                              FontWeight.w400,
                                              ColorConstants.kPrimary))
                                    ]),
                              ),
                              customText.kText(
                                  "${calculateDistance(restaurantLat: specialFoodDetail['latitude'], restaurantLong: specialFoodDetail['longitude'])}",
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
                            specialFoodDetail['image_url'].toString() ?? ""),
                      ),
                    ),
                  ),
                  SizedBox(height: height * .02),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: customText.kText(
                        specialFoodDetail['name'] ?? "",
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
                                  "-\$${specialFoodDetail['price'] ?? ""}",
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
                            ? "Calculated Price -\$ ${specialFoodDetail['price'].toString()}"
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
                        "${specialFoodDetail['description'] ?? ""}",
                        16,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start,
                        TextOverflow.visible,
                        50),
                  ),
                  SizedBox(height: height * .01),
                  // Container(
                  //   margin: EdgeInsets.only(left: 20),
                  //   child: customText.kText("Free Add Ons", 24, FontWeight.w800,
                  //       Colors.black, TextAlign.start),
                  // ),
                  // SizedBox(height: height * .01),
                  // extraFeatureList.isEmpty
                  //     ? Container(
                  //         margin: EdgeInsets.only(left: 20),
                  //         child: customText.kText("No Free Add Ons", 18,
                  //             FontWeight.w500, Colors.black, TextAlign.start),
                  //       )
                  //     : Container(
                  //         margin: const EdgeInsets.only(left: 20, right: 20),
                  //         width: double.infinity,
                  //         child: ListView.builder(
                  //           shrinkWrap: true,
                  //           itemCount: extraFeatureList.length,
                  //           itemBuilder: (BuildContext context, int index) =>
                  //               Container(
                  //             margin: const EdgeInsets.only(bottom: 5),
                  //             child: Row(
                  //               children: [
                  //                 SizedBox(
                  //                   height: 20,
                  //                   width: 20,
                  //                   child: Checkbox(
                  //                     checkColor: Colors.white,
                  //                     activeColor: ColorConstants.kPrimary,
                  //                     value: isChecked[index],
                  //                     onChanged: (bool? value) {
                  //                       log("value :- ${value!}");
                  //                       setState(() {
                  //                         isChecked[index] = value;
                  //                         if (isChecked[index] == true) {
                  //                           extraFeatureToCart
                  //                               .add(extraFeatureList[index]);
                  //                         } else if (isChecked[index] ==
                  //                             false) {
                  //                           extraFeatureToCart.removeAt(index);
                  //                         }
                  //                       });
                  //                       print(
                  //                           "extra feature to cart: ${extraFeatureToCart}");
                  //                       // saveRememberMe(value!);
                  //                     },
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   width: width * 0.01,
                  //                 ),
                  //                 customText.kText(
                  //                   extraFeatureList[index].toString(),
                  //                   16,
                  //                   FontWeight.w700,
                  //                   Colors.black,
                  //                   TextAlign.center,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //
                  // SizedBox(height: height * .01),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       customText.kText(
                  //         TextConstants.slideitem,
                  //         20,
                  //         FontWeight.w800,
                  //         Colors.black,
                  //         TextAlign.center,
                  //       ),
                  //       const SizedBox(height: 10),
                  //       Container(
                  //         margin: const EdgeInsets.symmetric(horizontal: 15),
                  //         child: FormField<SideItem>(
                  //           builder: (FormFieldState<SideItem> state) {
                  //             return InputDecorator(
                  //               decoration: InputDecoration(
                  //                 contentPadding:
                  //                     const EdgeInsets.fromLTRB(12, 10, 20, 20),
                  //                 errorText: _errorSideItem,
                  //                 errorStyle: const TextStyle(
                  //                     color: Colors.redAccent, fontSize: 16.0),
                  //                 border: OutlineInputBorder(
                  //                     borderRadius:
                  //                         BorderRadius.circular(10.0)),
                  //               ),
                  //               child: DropdownButtonHideUnderline(
                  //                 child: DropdownButton<SideItem>(
                  //                   style: const TextStyle(
                  //                       fontSize: 16, color: Colors.grey),
                  //                   hint: const Text(
                  //                     "Select Side Item",
                  //                     style: TextStyle(
                  //                         color: Colors.grey, fontSize: 16),
                  //                   ),
                  //                   value: _sideitemChoose,
                  //                   isExpanded: true,
                  //                   isDense: true,
                  //                   onChanged: (SideItem? newValue) {
                  //                     setState(() {
                  //                       _sideitemChoose = newValue;
                  //                       _errorSideItem = null;
                  //                       _selectedQuestion = null;
                  //                       _selectedOption = null;
                  //                       _errorQuestion = null;
                  //                       _errorOption = null;
                  //                     });
                  //                   },
                  //                   items: extraSideItemList
                  //                       .map<DropdownMenuItem<SideItem>>(
                  //                           (SideItem valueItem) {
                  //                     return DropdownMenuItem<SideItem>(
                  //                       value: valueItem,
                  //                       child: Row(
                  //                         children: [
                  //                           const SizedBox(width: 15),
                  //                           Expanded(
                  //                               child:
                  //                                   Text(valueItem.itemName)),
                  //                         ],
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //       const SizedBox(height: 20),
                  //       if (_sideitemChoose != null &&
                  //           _sideitemChoose!.questions.isNotEmpty)
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             customText.kText(
                  //               "Select Question",
                  //               20,
                  //               FontWeight.w800,
                  //               Colors.black,
                  //               TextAlign.center,
                  //             ),
                  //             const SizedBox(height: 10),
                  //             Container(
                  //               margin:
                  //                   const EdgeInsets.symmetric(horizontal: 15),
                  //               child: FormField<Question>(
                  //                 builder: (FormFieldState<Question> state) {
                  //                   return InputDecorator(
                  //                     decoration: InputDecoration(
                  //                       contentPadding:
                  //                           const EdgeInsets.fromLTRB(
                  //                               12, 10, 20, 20),
                  //                       errorText: _errorQuestion,
                  //                       errorStyle: const TextStyle(
                  //                           color: Colors.redAccent,
                  //                           fontSize: 16.0),
                  //                       border: OutlineInputBorder(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10.0)),
                  //                     ),
                  //                     child: DropdownButtonHideUnderline(
                  //                       child: DropdownButton<Question>(
                  //                         style: const TextStyle(
                  //                             fontSize: 16, color: Colors.grey),
                  //                         hint: const Text(
                  //                           "Select a Question",
                  //                           style: TextStyle(
                  //                               color: Colors.grey,
                  //                               fontSize: 16),
                  //                         ),
                  //                         value: _selectedQuestion,
                  //                         isExpanded: true,
                  //                         isDense: true,
                  //                         onChanged: (Question? newValue) {
                  //                           setState(() {
                  //                             _selectedQuestion = newValue;
                  //                             _errorQuestion = null;
                  //                             _selectedOption = null;
                  //                             _errorOption = null;
                  //                           });
                  //                         },
                  //                         items: _sideitemChoose!.questions
                  //                             .map<DropdownMenuItem<Question>>(
                  //                                 (Question valueItem) {
                  //                           return DropdownMenuItem<Question>(
                  //                             value: valueItem,
                  //                             child: Text(valueItem.question),
                  //                           );
                  //                         }).toList(),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       const SizedBox(height: 20), // Spacing
                  //       if (_selectedQuestion != null &&
                  //           _selectedQuestion!.options.isNotEmpty)
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             customText.kText(
                  //               "Select Option",
                  //               20,
                  //               FontWeight.w800,
                  //               Colors.black,
                  //               TextAlign.center,
                  //             ),
                  //             const SizedBox(height: 10),
                  //             Container(
                  //               margin:
                  //                   const EdgeInsets.symmetric(horizontal: 15),
                  //               child: FormField<Option>(
                  //                 builder: (FormFieldState<Option> state) {
                  //                   return InputDecorator(
                  //                     decoration: InputDecoration(
                  //                       contentPadding:
                  //                           const EdgeInsets.fromLTRB(
                  //                               12, 10, 20, 20),
                  //                       errorText: _errorOption,
                  //                       errorStyle: const TextStyle(
                  //                           color: Colors.redAccent,
                  //                           fontSize: 16.0),
                  //                       border: OutlineInputBorder(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10.0)),
                  //                     ),
                  //                     child: DropdownButtonHideUnderline(
                  //                       child: DropdownButton<Option>(
                  //                         style: const TextStyle(
                  //                             fontSize: 16, color: Colors.grey),
                  //                         hint: const Text(
                  //                           "Select an Option",
                  //                           style: TextStyle(
                  //                               color: Colors.grey,
                  //                               fontSize: 16),
                  //                         ),
                  //                         value: _selectedOption,
                  //                         isExpanded: true,
                  //                         isDense: true,
                  //                         onChanged: (Option? newValue) {
                  //                           setState(() {
                  //                             _selectedOption = newValue;
                  //                             _errorOption = null;
                  //                           });
                  //                         },
                  //                         items: _selectedQuestion!.options
                  //                             .map<DropdownMenuItem<Option>>(
                  //                                 (Option valueItem) {
                  //                           return DropdownMenuItem<Option>(
                  //                             value: valueItem,
                  //                             child: Row(
                  //                               children: [
                  //                                 const SizedBox(width: 15),
                  //                                 Expanded(
                  //                                     child: Text(
                  //                                         '${valueItem.name} (${valueItem.price})')),
                  //                               ],
                  //                             ),
                  //                           );
                  //                         }).toList(),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //     ],
                  //   ),
                  // ),
                  //
                  // if (extraOftenBoughtList.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const SizedBox(height: 20),
                  //         customText.kText(
                  //           "Often Bought With",
                  //           20,
                  //           FontWeight.w800,
                  //           Colors.black,
                  //           TextAlign.center,
                  //         ),
                  //         const SizedBox(height: 10),
                  //         ListView.builder(
                  //           shrinkWrap: true,
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           itemCount: extraOftenBoughtList.length,
                  //           itemBuilder: (context, groupIndex) {
                  //             final group = extraOftenBoughtList[groupIndex];
                  //             return Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       vertical: 8.0, horizontal: 15.0),
                  //                   child: customText.kText(
                  //                     group.name,
                  //                     18,
                  //                     FontWeight.w600,
                  //                     Colors.deepPurple,
                  //                     TextAlign.start,
                  //                   ),
                  //                 ),
                  //                 Column(
                  //                   children: group.options.map((option) {
                  //                     return Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: Container(
                  //                         decoration: BoxDecoration(
                  //                           border:
                  //                               Border.all(color: Colors.black),
                  //                           borderRadius:
                  //                               BorderRadius.circular(12),
                  //                         ),
                  //                         child: RadioListTile<
                  //                             OftenBoughtWithOption>(
                  //                           title: Row(
                  //                             children: [
                  //                               const SizedBox(width: 10),
                  //                               Expanded(
                  //                                 child: Column(
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment
                  //                                           .start,
                  //                                   children: [
                  //                                     Text(
                  //                                       option.name,
                  //                                       style: const TextStyle(
                  //                                           fontSize: 16),
                  //                                     ),
                  //                                     Text(
                  //                                       '\$${option.price}',
                  //                                       style: const TextStyle(
                  //                                           fontSize: 14,
                  //                                           color:
                  //                                               Colors.green),
                  //                                     ),
                  //                                     if (option
                  //                                         .size.isNotEmpty)
                  //                                       Text(
                  //                                         'Size: ${option.size}',
                  //                                         style:
                  //                                             const TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey),
                  //                                       ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                           value: option,
                  //                           groupValue:
                  //                               selectedOftenBoughtOptions[group
                  //                                   .id], // Group by group.id
                  //                           onChanged: (OftenBoughtWithOption?
                  //                               newValue) {
                  //                             setState(() {
                  //                               selectedOftenBoughtOptions[
                  //                                   group.id] = newValue;
                  //                             });
                  //                             print(
                  //                                 'Selected for ${group.name}: ${newValue?.name} - \$${newValue?.price} ${newValue?.id} ${newValue?.optionGroupId}');
                  //                           },
                  //                         ),
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //
                  // SizedBox(height: height * .02),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: customText.kText("Free Add Ons", 24, FontWeight.w800,
                        Colors.black, TextAlign.start),
                  ),
                  SizedBox(height: height * .01),
                  extraFeatureList.isEmpty
                      ? Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: customText.kText("No Free Add Ons", 18,
                        FontWeight.w500, Colors.black, TextAlign.start),
                  )
                      : Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(), // Added for better performance
                      itemCount: extraFeatureList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Better alignment
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: ColorConstants.kPrimary,
                                    value: isChecked[index],
                                    onChanged: (bool? value) {
                                      print("valueCheck :- $value");
                                      setState(() {
                                        isChecked[index] = value ?? false;

                                        // Fixed logic: remove/add by item, not by index
                                        if (isChecked[index]) {
                                          // Add item if not already present
                                          if (!extraFeatureToCart.contains(
                                              extraFeatureList[index])) {
                                            extraFeatureToCart
                                                .add(extraFeatureList[index]);
                                          }
                                        } else {
                                          // Remove the specific item, not by index
                                          extraFeatureToCart.remove(
                                              extraFeatureList[index]);
                                        }
                                      });

                                      print(
                                          "extra feature to cart: $extraFeatureToCart");
                                      print(
                                          "extra feature to cart length: ${extraFeatureToCart.length}");
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: width *
                                        0.02), // Slightly more spacing
                                Expanded(
                                  child: Row(
                                    children: [
                                      // Display image
                                      Container(
                                        width: 40,
                                        height: 40,
                                        margin:
                                        const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          child: Image.network(
                                            "https://getfooddelivery.com/${extraFeatureList[index]['image']}", // Replace with your actual base URL
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey.shade200,
                                                child: const Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              );
                                            },
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      // Display name and size
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              extraFeatureList[index]
                                              ['name'] ??
                                                  'No name',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "Size: ${extraFeatureList[index]['size'] ?? 'N/A'}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                  SizedBox(height: height * .01),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       customText.kText(
                  //         TextConstants.slideitem,
                  //         20,
                  //         FontWeight.w800,
                  //         Colors.black,
                  //         TextAlign.center,
                  //       ),
                  //       const SizedBox(height: 10),
                  //       Container(
                  //         margin: const EdgeInsets.symmetric(horizontal: 15),
                  //         child: FormField<SideItem>(
                  //           builder: (FormFieldState<SideItem> state) {
                  //             return InputDecorator(
                  //               decoration: InputDecoration(
                  //                 contentPadding:
                  //                     const EdgeInsets.fromLTRB(12, 10, 20, 20),
                  //                 errorText: _errorSideItem,
                  //                 errorStyle: const TextStyle(
                  //                     color: Colors.redAccent, fontSize: 16.0),
                  //                 border: OutlineInputBorder(
                  //                     borderRadius:
                  //                         BorderRadius.circular(10.0)),
                  //               ),
                  //               child: DropdownButtonHideUnderline(
                  //                 child: DropdownButton<SideItem>(
                  //                   style: const TextStyle(
                  //                       fontSize: 16, color: Colors.grey),
                  //                   hint: const Text(
                  //                     "Select Side Item",
                  //                     style: TextStyle(
                  //                         color: Colors.grey, fontSize: 16),
                  //                   ),
                  //                   value: _sideitemChoose,
                  //                   isExpanded: true,
                  //                   isDense: true,
                  //                   onChanged: (SideItem? newValue) {
                  //                     setState(() {
                  //                       _sideitemChoose = newValue;
                  //                       _errorSideItem = null;
                  //                       _selectedQuestion = null;
                  //                       _selectedOption = null;
                  //                       _errorQuestion = null;
                  //                       _errorOption = null;
                  //                     });
                  //                   },
                  //                   items: extraSideItemList
                  //                       .map<DropdownMenuItem<SideItem>>(
                  //                           (SideItem valueItem) {
                  //                     return DropdownMenuItem<SideItem>(
                  //                       value: valueItem,
                  //                       child: Row(
                  //                         children: [
                  //                           const SizedBox(width: 15),
                  //                           Expanded(
                  //                               child:
                  //                                   Text(valueItem.itemName)),
                  //                         ],
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //       const SizedBox(height: 20),
                  //       if (_sideitemChoose != null &&
                  //           _sideitemChoose!.questions.isNotEmpty)
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             customText.kText(
                  //               "Select Question",
                  //               20,
                  //               FontWeight.w800,
                  //               Colors.black,
                  //               TextAlign.center,
                  //             ),
                  //             const SizedBox(height: 10),
                  //             Container(
                  //               margin:
                  //                   const EdgeInsets.symmetric(horizontal: 15),
                  //               child: FormField<Question>(
                  //                 builder: (FormFieldState<Question> state) {
                  //                   return InputDecorator(
                  //                     decoration: InputDecoration(
                  //                       contentPadding:
                  //                           const EdgeInsets.fromLTRB(
                  //                               12, 10, 20, 20),
                  //                       errorText: _errorQuestion,
                  //                       errorStyle: const TextStyle(
                  //                           color: Colors.redAccent,
                  //                           fontSize: 16.0),
                  //                       border: OutlineInputBorder(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10.0)),
                  //                     ),
                  //                     child: DropdownButtonHideUnderline(
                  //                       child: DropdownButton<Question>(
                  //                         style: const TextStyle(
                  //                             fontSize: 16, color: Colors.grey),
                  //                         hint: const Text(
                  //                           "Select a Question",
                  //                           style: TextStyle(
                  //                               color: Colors.grey,
                  //                               fontSize: 16),
                  //                         ),
                  //                         value: _selectedQuestion,
                  //                         isExpanded: true,
                  //                         isDense: true,
                  //                         onChanged: (Question? newValue) {
                  //                           setState(() {
                  //                             _selectedQuestion = newValue;
                  //                             _errorQuestion = null;
                  //                             _selectedOption = null;
                  //                             _errorOption = null;
                  //                           });
                  //                         },
                  //                         items: _sideitemChoose!.questions
                  //                             .map<DropdownMenuItem<Question>>(
                  //                                 (Question valueItem) {
                  //                           return DropdownMenuItem<Question>(
                  //                             value: valueItem,
                  //                             child: Text(valueItem.question),
                  //                           );
                  //                         }).toList(),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       const SizedBox(height: 20), // Spacing
                  //       if (_selectedQuestion != null &&
                  //           _selectedQuestion!.options.isNotEmpty)
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             customText.kText(
                  //               "Select Option",
                  //               20,
                  //               FontWeight.w800,
                  //               Colors.black,
                  //               TextAlign.center,
                  //             ),
                  //             const SizedBox(height: 10),
                  //             Container(
                  //               margin:
                  //                   const EdgeInsets.symmetric(horizontal: 15),
                  //               child: FormField<Option>(
                  //                 builder: (FormFieldState<Option> state) {
                  //                   return InputDecorator(
                  //                     decoration: InputDecoration(
                  //                       contentPadding:
                  //                           const EdgeInsets.fromLTRB(
                  //                               12, 10, 20, 20),
                  //                       errorText: _errorOption,
                  //                       errorStyle: const TextStyle(
                  //                           color: Colors.redAccent,
                  //                           fontSize: 16.0),
                  //                       border: OutlineInputBorder(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10.0)),
                  //                     ),
                  //                     child: DropdownButtonHideUnderline(
                  //                       child: DropdownButton<Option>(
                  //                         style: const TextStyle(
                  //                             fontSize: 16, color: Colors.grey),
                  //                         hint: const Text(
                  //                           "Select an Option",
                  //                           style: TextStyle(
                  //                               color: Colors.grey,
                  //                               fontSize: 16),
                  //                         ),
                  //                         value: _selectedOption,
                  //                         isExpanded: true,
                  //                         isDense: true,
                  //                         onChanged: (Option? newValue) {
                  //                           setState(() {
                  //                             _selectedOption = newValue;
                  //                             _errorOption = null;
                  //                           });
                  //                         },
                  //                         items: _selectedQuestion!.options
                  //                             .map<DropdownMenuItem<Option>>(
                  //                                 (Option valueItem) {
                  //                           return DropdownMenuItem<Option>(
                  //                             value: valueItem,
                  //                             child: Row(
                  //                               children: [
                  //                                 const SizedBox(width: 15),
                  //                                 Expanded(
                  //                                     child: Text(
                  //                                         '${valueItem.name} (${valueItem.price})')),
                  //                               ],
                  //                             ),
                  //                           );
                  //                         }).toList(),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //     ],
                  //   ),
                  // ),
                  // if (_sideitemChoose != null)
                  //   Container(
                  //     margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //     alignment: Alignment.centerRight,
                  //     child: ElevatedButton.icon(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.redAccent,
                  //       ),
                  //       icon: const Icon(Icons.close, size: 18, color: Colors.white),
                  //       label: const Text(
                  //         'Remove Selection',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //       onPressed: () {
                  //         setState(() {
                  //           _sideitemChoose = null;
                  //           _selectedQuestion = null;
                  //           _selectedOption = null;
                  //           _errorSideItem = null;
                  //           _errorQuestion = null;
                  //           _errorOption = null;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText.kText(
                          TextConstants.slideitem,
                          20,
                          FontWeight.w800,
                          Colors.black,
                          TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        /// SIDE ITEM DROPDOWN
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: FormField<SideItem>(
                            builder: (FormFieldState<SideItem> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.fromLTRB(12, 10, 20, 20),
                                  errorText: _errorSideItem,
                                  errorStyle: const TextStyle(
                                      color: ColorConstants.kPrimary,
                                      fontSize: 16.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<SideItem>(
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    hint: const Text(
                                      "Select Side Item",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    value: _sideitemChoose,
                                    isExpanded: true,
                                    isDense: true,
                                    onChanged: (SideItem? newValue) {
                                      setState(() {
                                        _sideitemChoose = newValue;
                                        _errorSideItem = null;
                                        _selectedQuestion = null;
                                        _selectedOption = null;
                                        _errorQuestion = null;
                                        _errorOption = null;
                                      });
                                    },
                                    items: [
                                      const DropdownMenuItem<SideItem>(
                                        value: null,
                                        child: Text("Select Item"),
                                      ),
                                      ...extraSideItemList
                                          .map((SideItem valueItem) {
                                        return DropdownMenuItem<SideItem>(
                                          value: valueItem,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 15),
                                              Expanded(
                                                  child:
                                                  Text(valueItem.itemName)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        /// REMOVE BUTTON
                        if (_sideitemChoose != null)
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.kPrimary,
                              ),
                              icon: const Icon(Icons.close,
                                  size: 18, color: Colors.white),
                              label: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _sideitemChoose = null;
                                  _selectedQuestion = null;
                                  _selectedOption = null;
                                  _errorSideItem = null;
                                  _errorQuestion = null;
                                  _errorOption = null;
                                });
                              },
                            ),
                          ),
                        const SizedBox(height: 20),

                        /// QUESTION DROPDOWN
                        if (_sideitemChoose != null &&
                            _sideitemChoose!.questions.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText.kText(
                                "Select Question",
                                20,
                                FontWeight.w800,
                                Colors.black,
                                TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 15),
                                child: FormField<Question>(
                                  builder: (FormFieldState<Question> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            12, 10, 20, 20),
                                        errorText: _errorQuestion,
                                        errorStyle: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Question>(
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                          hint: const Text(
                                            "Select a Question",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          ),
                                          value: _selectedQuestion,
                                          isExpanded: true,
                                          isDense: true,
                                          onChanged: (Question? newValue) {
                                            setState(() {
                                              _selectedQuestion = newValue;
                                              _errorQuestion = null;
                                              _selectedOption = null;
                                              _errorOption = null;
                                            });
                                          },
                                          items: _sideitemChoose!.questions
                                              .map((Question valueItem) {
                                            return DropdownMenuItem<Question>(
                                              value: valueItem,
                                              child: Text(valueItem.question),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),

                        /// OPTION DROPDOWN
                        if (_selectedQuestion != null &&
                            _selectedQuestion!.options.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText.kText(
                                "Select Option",
                                20,
                                FontWeight.w800,
                                Colors.black,
                                TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 15),
                                child: FormField<Option>(
                                  builder: (FormFieldState<Option> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            12, 10, 20, 20),
                                        errorText: _errorOption,
                                        errorStyle: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Option>(
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                          hint: const Text(
                                            "Select an Option",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          ),
                                          value: _selectedOption,
                                          isExpanded: true,
                                          isDense: true,
                                          onChanged: (Option? newValue) {
                                            setState(() {
                                              _selectedOption = newValue;
                                              _errorOption = null;
                                            });
                                          },
                                          items: _selectedQuestion!.options
                                              .map((Option valueItem) {
                                            return DropdownMenuItem<Option>(
                                              value: valueItem,
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    child: Text(
                                                        '${valueItem.name} (${valueItem.price})'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  //
                  // if (extraOftenBoughtList.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const SizedBox(height: 20),
                  //         customText.kText(
                  //           "Often Bought With",
                  //           20,
                  //           FontWeight.w800,
                  //           Colors.black,
                  //           TextAlign.center,
                  //         ),
                  //         const SizedBox(height: 10),
                  //         ListView.builder(
                  //           shrinkWrap: true,
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           itemCount: extraOftenBoughtList.length,
                  //           itemBuilder: (context, groupIndex) {
                  //             final group = extraOftenBoughtList[groupIndex];
                  //             return Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       vertical: 8.0, horizontal: 15.0),
                  //                   child: customText.kText(
                  //                     group.name,
                  //                     18,
                  //                     FontWeight.w600,
                  //                     Colors.deepPurple,
                  //                     TextAlign.start,
                  //                   ),
                  //                 ),
                  //                 Column(
                  //                   children: group.options.map((option) {
                  //                     return Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: Container(
                  //                         decoration: BoxDecoration(
                  //                           border:
                  //                               Border.all(color: Colors.black),
                  //                           borderRadius:
                  //                               BorderRadius.circular(12),
                  //                         ),
                  //                         child: RadioListTile<
                  //                             OftenBoughtWithOption>(
                  //                           title: Row(
                  //                             children: [
                  //
                  //                               const SizedBox(width: 10),
                  //                               Expanded(
                  //                                 child: Column(
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment
                  //                                           .start,
                  //                                   children: [
                  //                                     Text(
                  //                                       option.name,
                  //                                       style: const TextStyle(
                  //                                           fontSize: 16),
                  //                                     ),
                  //                                     Text(
                  //                                       '\$${option.price}',
                  //                                       style: const TextStyle(
                  //                                           fontSize: 14,
                  //                                           color:
                  //                                               Colors.green),
                  //                                     ),
                  //                                     if (option
                  //                                         .size.isNotEmpty)
                  //                                       Text(
                  //                                         'Size: ${option.size}',
                  //                                         style:
                  //                                             const TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey),
                  //                                       ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                           value: option,
                  //                           groupValue:
                  //                               selectedOftenBoughtOptions[group.id], // Group by group.id
                  //                           onChanged: (OftenBoughtWithOption?
                  //                               newValue) {
                  //                             setState(() {
                  //                               selectedOftenBoughtOptions[group.id] = newValue;
                  //                             });
                  //                             print(
                  //                                 'Selected for ${group.name}: ${newValue?.name} - \$${newValue?.price} ${newValue?.id} ${newValue?.optionGroupId}');
                  //                           },
                  //                         ),
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  if (extraOftenBoughtList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          customText.kText(
                            "Often Bought With",
                            20,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: extraOftenBoughtList.length,
                            itemBuilder: (context, groupIndex) {
                              final group = extraOftenBoughtList[groupIndex];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Group title and the new "Clear Selection" (delete) button
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 15.0),
                                    child: Row(
                                      // Use a Row to place text and icon side-by-side
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        customText.kText(
                                          group.name,
                                          18,
                                          FontWeight.w600,
                                          Colors.deepPurple,
                                          TextAlign.start,
                                        ),
                                        if (selectedOftenBoughtOptions[
                                        group.id] !=
                                            null)
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: ColorConstants.kPrimary),
                                            onPressed: () {
                                              setState(() {
                                                selectedOftenBoughtOptions[
                                                group.id] =
                                                null; // Unselect the option for this group
                                              });
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: group.options.map((option) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                            Border.all(color: Colors.black),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: RadioListTile<
                                              OftenBoughtWithOption>(
                                            title: Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        option.name,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        '\$${option.price}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                            Colors.green),
                                                      ),
                                                      if (option
                                                          .size.isNotEmpty)
                                                        Text(
                                                          'Size: ${option.size}',
                                                          style:
                                                          const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            value: option,
                                            groupValue:
                                            selectedOftenBoughtOptions[
                                            group.id],
                                            onChanged: (OftenBoughtWithOption?
                                            newValue) {
                                              setState(() {
                                                selectedOftenBoughtOptions[
                                                group.id] = newValue;
                                              });
                                              print(
                                                  'Selected for ${group.name}: ${newValue?.name} - \$${newValue?.price} ${newValue?.id} ${newValue?.optionGroupId}');
                                            },
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: height * .02),


                  SizedBox(height: height * .02),
                  // GestureDetector(
                  //   onTap: () async {
                  //     if (sideDrawerController.cartListRestaurant.isEmpty ||
                  //         sideDrawerController.cartListRestaurant ==
                  //             sideDrawerController.specificFoodResId
                  //                 .toString()) {
                  //       await box.write("cartListRestaurant",
                  //           sideDrawerController.specificFoodResId.toString());
                  //       setState(() {
                  //         sideDrawerController.cartListRestaurant =
                  //             sideDrawerController.specificFoodResId.toString();
                  //       });
                  //       if (loginController.accessToken.isNotEmpty) {
                  //         String sideOptionsId = _selectedOption!.id.toString();
                  //         String sideItemId = _sideitemChoose!.id.toString();
                  //         String sideQuestionId = _selectedQuestion!.id.toString();
                  //         String sidePriceId = _sideitemChoose!.itemPrice.toString();
                  //         String selectedOptionPrice = _selectedOption!.price.toString();
                  //         // Collect all selected "Often Bought With" options
                  //         List<String> oftenBoughtOptionIds = [];
                  //         List<String> oftenBoughtOptionGroupIds = [];
                  //         List<String> oftenBoughtOptionGroupPrice = [];
                  //
                  //         selectedOftenBoughtOptions.forEach((groupId, option) {
                  //           if (option != null) {
                  //             oftenBoughtOptionIds.add(option.id.toString());
                  //             oftenBoughtOptionGroupIds.add(groupId.toString());
                  //             oftenBoughtOptionGroupPrice.add(option.price.toString());
                  //           }
                  //         });
                  //
                  //         addToCart(
                  //           sideOptionsId: sideOptionsId,
                  //           sideItemId: sideItemId,
                  //           sideQuestionId: sideQuestionId,
                  //           sidePriceId: sidePriceId,
                  //           selectedOptionPrice: selectedOptionPrice,
                  //           oftenBoughtOptionsId: oftenBoughtOptionIds.join(','),
                  //           optionGroupId: oftenBoughtOptionGroupIds.join(','),
                  //           oftenBoughtOptionGroupPrice: oftenBoughtOptionGroupPrice.join(','),
                  //         );
                  //       } else {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const LoginScreen()),
                  //         );
                  //       }
                  //     } else {
                  //       helper.errorDialog(context,
                  //           "Your cart is already have food from different restaurant");
                  //     }
                  //   },
                  //   child: Container(
                  //     margin: const EdgeInsets.only(
                  //         left: 20, right: 20, bottom: 20),
                  //     height: 50,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       // shape: BoxShape.circle,
                  //       color: ColorConstants.kPrimary,
                  //     ),
                  //     child: Center(
                  //       child: cartCalling
                  //           ? const CircularProgressIndicator(
                  //               color: Colors.white,
                  //             )
                  //           : customText.kText(
                  //               TextConstants.addToCart,
                  //               20,
                  //               FontWeight.w800,
                  //               Colors.white,
                  //               TextAlign.center,
                  //             ),
                  //     ),
                  //   ),
                  // ),

                  ///working fine
                  // GestureDetector(
                  //   onTap: () async {
                  //     if (sideDrawerController.cartListRestaurant.isEmpty ||
                  //         sideDrawerController.cartListRestaurant ==
                  //             sideDrawerController.specialFoodResId
                  //                 .toString()) {
                  //       await box.write("cartListRestaurant",
                  //           sideDrawerController.specialFoodResId.toString());
                  //       setState(() {
                  //         sideDrawerController.cartListRestaurant =
                  //             sideDrawerController.specialFoodResId.toString();
                  //       });
                  //       if (loginController.accessToken.isNotEmpty) {
                  //         // Use null-safe approach with default values
                  //         String sideOptionsId =
                  //             _selectedOption?.id?.toString() ?? "";
                  //         String sideItemId =
                  //             _sideitemChoose?.id?.toString() ?? "";
                  //         String sideQuestionId =
                  //             _selectedQuestion?.id?.toString() ?? "";
                  //         String sidePriceId =
                  //             _sideitemChoose?.itemPrice?.toString() ?? "0";
                  //         String selectedOptionPrice =
                  //             _selectedOption?.price?.toString() ?? "0";
                  //
                  //         // Collect all selected "Often Bought With" options
                  //         List<String> oftenBoughtOptionIds = [];
                  //         List<String> oftenBoughtOptionGroupIds = [];
                  //         List<String> oftenBoughtOptionGroupPrice = [];
                  //
                  //         selectedOftenBoughtOptions
                  //             ?.forEach((groupId, option) {
                  //           if (option != null) {
                  //             oftenBoughtOptionIds
                  //                 .add(option.id?.toString() ?? "");
                  //             oftenBoughtOptionGroupIds
                  //                 .add(groupId?.toString() ?? "");
                  //             oftenBoughtOptionGroupPrice
                  //                 .add(option.price?.toString() ?? "0");
                  //           }
                  //         });
                  //
                  //         addToCart(
                  //           sideOptionsId: sideOptionsId,
                  //           sideItemId: sideItemId,
                  //           sideQuestionId: sideQuestionId,
                  //           sidePriceId: sidePriceId,
                  //           selectedOptionPrice: selectedOptionPrice,
                  //           oftenBoughtOptionsId:
                  //               oftenBoughtOptionIds.join(','),
                  //           optionGroupId: oftenBoughtOptionGroupIds.join(','),
                  //           oftenBoughtOptionGroupPrice:
                  //               oftenBoughtOptionGroupPrice.join(','),
                  //         );
                  //       } else {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const LoginScreen()),
                  //         );
                  //       }
                  //     } else {
                  //       helper.errorDialog(context,
                  //           "Your cart is already have food from different restaurant");
                  //     }
                  //   },
                  //   child: Container(
                  //     margin: const EdgeInsets.only(
                  //         left: 20, right: 20, bottom: 20),
                  //     height: 50,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       color: ColorConstants.kPrimary,
                  //     ),
                  //     child: Center(
                  //       child: cartCalling
                  //           ? const CircularProgressIndicator(
                  //               color: Colors.white,
                  //             )
                  //           : customText.kText(
                  //               TextConstants.addToCart,
                  //               20,
                  //               FontWeight.w800,
                  //               Colors.white,
                  //               TextAlign.center,
                  //             ),
                  //     ),
                  //   ),
                  // )
                  GestureDetector(
                    onTap: () async {
                      // if (sideDrawerController.cartListRestaurant.isEmpty ||
                      //     sideDrawerController.cartListRestaurant ==
                      //         sideDrawerController.specialFoodResId.toString()) {

                        // Check if user has chosen a side item
                        bool hasSideItem = _sideitemChoose != null;

                        // Validate mandatory fields only if side item is chosen
                        if (hasSideItem) {
                          // Validate mandatory fields for side items
                          if (_selectedOption?.id == null) {
                            helper.errorDialog(context, "Please select a side option");
                            return;
                          }
                          if (_sideitemChoose?.id == null) {
                            helper.errorDialog(context, "Please select a side item");
                            return;
                          }
                          if (_selectedQuestion?.id == null) {
                            helper.errorDialog(context, "Please answer the required question");
                            return;
                          }
                          if (_sideitemChoose?.itemPrice == null) {
                            helper.errorDialog(context, "Side item price is required");
                            return;
                          }
                          if (_selectedOption?.price == null) {
                            helper.errorDialog(context, "Selected option price is required");
                            return;
                          }
                        }

                        await box.write("cartListRestaurant",
                            sideDrawerController.specialFoodResId.toString());
                        setState(() {
                          sideDrawerController.cartListRestaurant =
                              sideDrawerController.specialFoodResId.toString();
                        });

                        if (loginController.accessToken.isNotEmpty) {
                          // Use conditional approach based on side item selection
                          String sideOptionsId = hasSideItem
                              ? (_selectedOption?.id?.toString() ?? "")
                              : "";
                          String sideItemId = hasSideItem
                              ? (_sideitemChoose?.id?.toString() ?? "")
                              : "";
                          String sideQuestionId = hasSideItem
                              ? (_selectedQuestion?.id?.toString() ?? "")
                              : "";
                          String sidePriceId = hasSideItem
                              ? (_sideitemChoose?.itemPrice?.toString() ?? "0")
                              : "0";
                          String selectedOptionPrice = hasSideItem
                              ? (_selectedOption?.price?.toString() ?? "0")
                              : "0";

                          // Collect all selected "Often Bought With" options
                          List<String> oftenBoughtOptionIds = [];
                          List<String> oftenBoughtOptionGroupIds = [];
                          List<String> oftenBoughtOptionGroupPrice = [];

                          selectedOftenBoughtOptions?.forEach((groupId, option) {
                            if (option != null) {
                              oftenBoughtOptionIds.add(option.id?.toString() ?? "");
                              oftenBoughtOptionGroupIds.add(groupId?.toString() ?? "");
                              oftenBoughtOptionGroupPrice.add(option.price?.toString() ?? "0");
                            }
                          });

                          addToCart(
                            sideOptionsId: sideOptionsId,
                            sideItemId: sideItemId,
                            sideQuestionId: sideQuestionId,
                            sidePriceId: sidePriceId,
                            selectedOptionPrice: selectedOptionPrice,
                            oftenBoughtOptionsId: oftenBoughtOptionIds.join(','),
                            optionGroupId: oftenBoughtOptionGroupIds.join(','),
                            oftenBoughtOptionGroupPrice: oftenBoughtOptionGroupPrice.join(','),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        }
                      // } else {
                      //   helper.errorDialog(context,
                      //       "Your cart is already have food from different restaurant");
                      // }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                  )
                ],
              )),
            ),
    );
  }
}
