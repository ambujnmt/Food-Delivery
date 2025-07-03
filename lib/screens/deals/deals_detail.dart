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
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marquee/marquee.dart';
import '../../special_food_model.dart';

class DealsDetail extends StatefulWidget {
  const DealsDetail({super.key});

  @override
  State<DealsDetail> createState() => _SpecialFoodDetailState();
}

class _SpecialFoodDetailState extends State<DealsDetail> {

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
  Map<String, dynamic> specialFoodDetail = {};
  List<dynamic> extraFeatureList = [];
  List<SideItem> extraSideItemList = [];
  SideItem? _sideitemChoose;
  String? _errorSideItem;

  Question? _selectedQuestion;
  Option? _selectedOption;
  String? _errorQuestion;
  String? _errorOption;
  List<OftenBoughtWithGroup> extraOftenBoughtList = [];
  Map<int, OftenBoughtWithOption?> selectedOftenBoughtOptions = {};
  List<dynamic> extraFeatureToCart = [];
  List<bool> isChecked = [false];
  Position? _currentPosition;
  String _currentAddress = 'Unknown location';
  String? getLatitude;
  String? getLongitude;
  String calculatedDistance = "";

  // foodDetail() async {
  //   setState(() {
  //     detailCalling = true;
  //   });
  //
  //   final response = await api.multiDealFoodDetails(
  //       dealId: sideDrawerController.bestDealsId.toString());
  //   setState(() {
  //     detailCalling = false;
  //   });
  //
  //   if (response["status"] == true) {
  //     print("special food detail");
  //     setState(() {
  //       specialFoodDetail = response['deal'];
  //       for (int i = 0; i < specialFoodDetail["products"]["extra_features"].length; i++) {
  //         extraFeatureList.add(specialFoodDetail["products"]["extra_features"][i]);
  //       }
  //       isChecked = List.generate(extraFeatureList.length, (index) => false);
  //       extraSideItemList.clear();
  //       if (specialFoodDetail["products"]["side_items"] != null) {
  //         for (var itemJson in specialFoodDetail["products"]["side_items"]) {
  //           extraSideItemList.add(SideItem.fromJson(itemJson));
  //         }
  //       }
  //       extraOftenBoughtList.clear();
  //       selectedOftenBoughtOptions.clear();
  //       if (specialFoodDetail["products"]["often_bought_with"] != null) {
  //         for (var groupJson in specialFoodDetail["products"]["often_bought_with"]) {
  //           OftenBoughtWithGroup group =
  //           OftenBoughtWithGroup.fromJson(groupJson);
  //           extraOftenBoughtList.add(group);
  //           selectedOftenBoughtOptions[group.id] = null;
  //         }
  //       }
  //     });
  //     print("special food detail: $specialFoodDetail");
  //     print("ex fea: $extraFeatureList");
  //     print("extra side item list: $extraSideItemList");
  //     print("extra Often Bought   list: $extraOftenBoughtList");
  //   } else {
  //     print('error message: ${response["message"]}');
  //   }
  // }

  foodDetail() async {
    setState(() {
      detailCalling = true;
    });

    final response = await api.multiDealFoodDetails(
        dealId: sideDrawerController.bestDealsId.toString());
    setState(() {
      detailCalling = false;
    });

    if (response["status"] == true) {
      print("special food detail");
      setState(() {
        specialFoodDetail = response['deal'];

        // Clear existing lists
        extraFeatureList.clear();
        extraSideItemList.clear();
        extraOftenBoughtList.clear();
        selectedOftenBoughtOptions.clear();

        // Get the first product from the deal's products array
        if (specialFoodDetail["products"] != null &&
            specialFoodDetail["products"].isNotEmpty) {

          var firstProduct = specialFoodDetail["products"][0];

          // Handle extra_features
          if (firstProduct["extra_features"] != null) {
            for (int i = 0; i < firstProduct["extra_features"].length; i++) {
              extraFeatureList.add(firstProduct["extra_features"][i]);
            }
          }

          // Initialize checkbox states
          isChecked = List.generate(extraFeatureList.length, (index) => false);

          // Handle side_items
          if (firstProduct["side_items"] != null) {
            for (var itemJson in firstProduct["side_items"]) {
              extraSideItemList.add(SideItem.fromJson(itemJson));
            }
          }

          // Handle often_bought_with
          if (firstProduct["often_bought_with"] != null) {
            for (var groupJson in firstProduct["often_bought_with"]) {
              OftenBoughtWithGroup group = OftenBoughtWithGroup.fromJson(groupJson);
              extraOftenBoughtList.add(group);
              selectedOftenBoughtOptions[group.id] = null;
            }
          }
        }
      });

      print("special food detail: $specialFoodDetail");
      print("ex fea: $extraFeatureList");
      print("extra side item list: $extraSideItemList");
      print("extra Often Bought list: $extraOftenBoughtList");
    } else {
      print('error message: ${response["message"]}');
    }
  }

  addRecent() async {
    final response = await api.addToRecent(
      type: "product",
      id: sideDrawerController.specialFoodProdId,
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
        int.parse(specialFoodDetail['products'][0]['price'].toString().split('.')[0]) *
            quantity;
    setState(() {});
    print("Quantity: $quantity");
    print("price: ${calculatedPrice.toString()}");
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      calculatedPrice =
          int.parse(specialFoodDetail['products'][0]['price'].toString().split('.')[0]) *
              quantity;
      // price = (double.parse(price) * quantity).toStringAsFixed(2);
    }
    setState(() {});
    print("price: ${calculatedPrice.toString()}");
  }

  addToCart({
    String? restaurantId,
    String? productId,
    String? sideOptionsId,
    String? sideItemId,
    String? sideQuestionId,
    String? sidePriceId,
    String? selectedOptionPrice,
    String? oftenBoughtOptionsId,
    String? optionGroupId,
    String? oftenBoughtOptionGroupPrice,
  }) async {

    setState(() {
      cartCalling = true;
    });
    // print("SideItem..........$sideItemId,$sideQuestionId,$sideOptionsId........Price..$sidePriceId..$selectedOptionPrice");
    //
    // print("OftenItem....$optionGroupId,$oftenBoughtOptionsId..Price..$oftenBoughtOptionGroupPrice");
    //
    //
    // // Parse and calculate the total price including side options and often bought items
    // double basePrice = calculatedPrice == 0
    //     ? double.tryParse(specialFoodDetail['price'].toString()) ?? 0.0
    //     : calculatedPrice.toDouble();
    //
    // double sideItemPrice = double.tryParse(sidePriceId ?? '0.0') ?? 0.0;
    // double optionPrice = double.tryParse(selectedOptionPrice ?? '0.0') ?? 0.0;
    // double oftenBoughtPrice = double.tryParse(oftenBoughtOptionGroupPrice ?? '0.0') ?? 0.0;
    //
    // print("basePrice$basePrice,sideItemPrice$sideItemPrice,optionPrice$optionPrice,oftenBoughtPrice$oftenBoughtPrice");
    //
    // double totalPrice = sideItemPrice + optionPrice + oftenBoughtPrice;
    //
    // print("totalPrice$totalPrice");
    print(
        "SideItem..........$sideItemId,$sideQuestionId,$sideOptionsId........Price..$sidePriceId..$selectedOptionPrice");
    print(
        "OftenItem....$optionGroupId,$oftenBoughtOptionsId..Price..$oftenBoughtOptionGroupPrice");

    // Parse and calculate the total price including side options and often bought items
    double basePrice = calculatedPrice == 0
        ? double.tryParse(specialFoodDetail['products'][0]['price']?.toString() ?? '0') ?? 0.0
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

    print("totalSidePrice: $totalSidePrice, finalTotalPrice: $finalTotalPrice");

    final response = await api.addItemsSpecialToCart(
      userId: loginController.userId.toString(),
      // price: calculatedPrice == 0
      //     ? specialFoodDetail['price'].toString()
      //     : calculatedPrice.toString() ,
      // sidePrice: totalPrice.toString(),
      price: basePrice.toString(), // Base item price
      sidePrice: totalSidePrice.toString(),
      quantity: quantity.toString(),
      restaurantId: restaurantId,
      productId: productId,
      extraFeature: extraFeatureToCart ?? [],
      sideOptionsId: sideOptionsId ?? "",
      sideItemId: sideItemId ?? "",
      sideQuestionId: sideQuestionId ?? "",
      oftenBoughtOptionsId: oftenBoughtOptionsId ?? "",
      optionGroupId: optionGroupId ?? "",
    );
    setState(() {
      cartCalling = false;
    });

    if (response["status"] == true) {
      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
      // Navigator.pop(context);
    } else {
      helper.errorDialog(context, response["error"]);
      print('error message: ${response["error"]}');
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
    print("get lat: $getLatitude");
    print("get long: $getLongitude");
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
      return "$formattedMiles MLs";
    } catch (e) {
      print("Error retrieving location: $e");
      return "Loading...";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
          : Stack(
        children: [
          SingleChildScrollView(
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
                // Container(
                //   height: height * 0.19,
                //   width: width,
                //   margin: EdgeInsets.only(bottom: height * 0.01),
                //   decoration: const BoxDecoration(
                //       color: Colors.yellow,
                //       image: DecorationImage(
                //           image: AssetImage("assets/images/banner.png"),
                //           fit: BoxFit.fitHeight)),
                //   child: Stack(
                //     alignment: Alignment.center,
                //     children: [
                //       Container(
                //         color: Colors.black54,
                //       ),
                //       Center(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             // customText.kText(
                //             //     sideDrawerController.specialFoodName.isEmpty
                //             //         ? TextConstants.favourite
                //             //         : sideDrawerController.specialFoodName,
                //             //     28,
                //             //     FontWeight.w900,
                //             //     Colors.white,
                //             //     TextAlign.center),
                //             // SizedBox(
                //             //   height: height * 0.01,
                //             // ),
                //             customText.kText(specialFoodDetail['products'][0]['restaurant_name'], 24, FontWeight.w800, Colors.white, TextAlign.center),
                //             RichText(
                //               text: TextSpan(
                //                   text: TextConstants.home,
                //                   style: customText.kSatisfyTextStyle(
                //                       24, FontWeight.w400, Colors.white),
                //                   children: [
                //                     TextSpan(
                //                         text:
                //                         " / ${TextConstants.bestDeals}",
                //                         style: customText.kSatisfyTextStyle(
                //                             24,
                //                             FontWeight.w400,
                //                             ColorConstants.kPrimary))
                //                   ]),
                //             ),
                //             customText.kText(
                //                 calculateDistance(restaurantLat: specialFoodDetail['products'][0]['latitude'], restaurantLong: specialFoodDetail['products'][0]['longitude']),
                //                 24,
                //                 FontWeight.w700,
                //                 Colors.red,
                //                 TextAlign.center),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  width: width,
                  height: height * 0.23,
                  margin: EdgeInsets.only(bottom: height * 0.01),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.75),
                            BlendMode.darken,
                          ),
                          child: specialFoodDetail['products'][0][
                          "restaurant_business_image"] !=
                              null &&
                              specialFoodDetail['products'][0][
                              "restaurant_business_image"]
                                  .toString()
                                  .isNotEmpty
                              ? Image.network(
                            specialFoodDetail['products'][0][
                            "restaurant_business_image"],
                            width: width,
                            height: height * 0.23,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                width: width,
                                height: height * 0.23,
                                color: Colors.grey[300],
                                child: const Center(
                                    child:
                                    CircularProgressIndicator()),
                              );
                            },
                            loadingBuilder:
                                (context, child, loadingProgress) {
                              if (loadingProgress == null)
                                return child;
                              return Container(
                                width: width,
                                height: height * 0.23,
                                color: Colors.grey[300],
                                child: const Center(
                                    child:
                                    CircularProgressIndicator()),
                              );
                            },
                          )
                              : Container(
                            width: width,
                            height: height * 0.23,
                            color: Colors.grey[300],
                            child: const Center(
                                child:
                                CircularProgressIndicator()),
                          )
                      ),
                      // Foreground content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText.kText(
                            specialFoodDetail['products'][0]['restaurant_name'] ?? "",
                            28,
                            FontWeight.w900,
                            Colors.white,
                            TextAlign.center,
                          ),
                          SizedBox(height: height * 0.01),
                          RichText(
                            text: TextSpan(
                              text: TextConstants.home,
                              style: customText.kSatisfyTextStyle(
                                24,
                                FontWeight.w400,
                                Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                  " / ${TextConstants.foodDetail}",
                                  style: customText.kSatisfyTextStyle(
                                    24,
                                    FontWeight.w400,
                                    ColorConstants.kPrimary,
                                  ),
                                )
                              ],
                            ),
                          ),

                          SizedBox(height: height * 0.01),
                          customText.kText(
                            calculateDistance(
                              restaurantLat:
                              specialFoodDetail['products'][0]['latitude'],
                              restaurantLong:
                              specialFoodDetail['products'][0]['longitude'],
                            ),
                            18,
                            FontWeight.w700,
                            Colors.white,
                            TextAlign.center,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: customText.kText(
                              specialFoodDetail['products'][0]['business_address'] ?? '',
                              14,
                              FontWeight.w900,
                              Colors.white,
                              TextAlign.center,
                              TextOverflow.ellipsis,
                              2,
                            ),
                          ),
                        ],
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
                          specialFoodDetail['products'][0]['image_url'].toString() ?? ""),
                    ),
                  ),
                ),
                SizedBox(height: height * .02),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: customText.kText(
                      specialFoodDetail['products'][0]['name'] ?? "",
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
                                "\$${specialFoodDetail['products'][0]['price'] ?? ""}",
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
                                    margin: const EdgeInsets.only(right: 10),
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
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 35,
                                  width: width * .15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: customText.kText(
                                      quantity.toString(),
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
                  margin: const EdgeInsets.only(left: 20),
                  child: customText.kText(
                      calculatedPrice == 0
                          ? "Calculated Price \$ ${specialFoodDetail['products'][0]['price'].toString()}"
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
                      specialFoodDetail['description'] ?? "",
                      16,
                      FontWeight.w700,
                      ColorConstants.kPrimary,
                      TextAlign.start,
                      TextOverflow.visible,
                      50),
                ),
                SizedBox(height: height * .01),

                extraFeatureList.isNotEmpty
                    ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Zomato-style title and "FREE" badge
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32), // Green for "free"
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Free Add Ons",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "FREE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          "Select your complimentary items",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Add-ons list
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: extraFeatureList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final feature = extraFeatureList[index];
                            final isSelected = isChecked[index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setState(() {
                                  isChecked[index] = !isChecked[index];

                                  if (isChecked[index]) {
                                    if (!extraFeatureToCart.contains(feature)) {
                                      extraFeatureToCart.add(feature);
                                    }
                                  } else {
                                    extraFeatureToCart.remove(feature);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2E7D32).withOpacity(0.05)
                                      : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF2E7D32)
                                        : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Custom checkbox with Zomato styling
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF2E7D32)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF2E7D32)
                                              : Colors.grey[400]!,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),

                                    // Product image
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          feature['image'] ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: Colors.grey[100],
                                            child: Icon(
                                              Icons.restaurant,
                                              color: Colors.grey[400],
                                              size: 24,
                                            ),
                                          ),
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              color: Colors.grey[100],
                                              child: const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF2E7D32),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Product details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            feature['name'] ?? 'No name',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 6),
                                          if (feature['size'] != null && feature['size'].toString().isNotEmpty)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                "Size: ${feature['size']}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // "FREE" indicator
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2E7D32).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "FREE",
                                        style: TextStyle(
                                          color: Color(0xFF2E7D32),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
                    : const SizedBox.shrink(),



                SizedBox(height: height * .01),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // MAIN TITLE WITH ZOMATO STYLING
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [ColorConstants.kPrimary, ColorConstants.kPrimary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: ColorConstants.kPrimary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.restaurant_menu,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                TextConstants.slideitem,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// SIDE ITEM DROPDOWN - ZOMATO STYLE
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE23744).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Color(0xFFE23744),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Choose Add-ons",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2D3436),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              FormField<SideItem>(
                                builder: (FormFieldState<SideItem> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      errorText: _errorSideItem,
                                      errorStyle: const TextStyle(
                                        color: Color(0xFFE23744),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFFE23744), width: 2),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<SideItem>(
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF2D3436),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        hint: Row(
                                          children: [
                                            Icon(
                                              Icons.restaurant,
                                              color: Colors.grey[600],
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Select Side Item",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        value: _sideitemChoose,
                                        isExpanded: true,
                                        isDense: false,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Color(0xFF636E72),
                                          size: 24,
                                        ),
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
                                          DropdownMenuItem<SideItem>(
                                            enabled: false,
                                            value: null,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.fastfood,
                                                    color: Color(0xFFE23744),
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Available Items",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const DropdownMenuItem<SideItem>(
                                            enabled: false,
                                            value: null,
                                            child: Divider(height: 1),
                                          ),
                                          ...extraSideItemList.map((SideItem valueItem) {
                                            return DropdownMenuItem<SideItem>(
                                              value: valueItem,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                child: Row(
                                                  children: [
                                                    // Food Image
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.1),
                                                            blurRadius: 8,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: Image.network(
                                                          valueItem.itemImage,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    const Color(0xFFE23744).withOpacity(0.2),
                                                                    const Color(0xFFE23744).withOpacity(0.1),
                                                                  ],
                                                                ),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: const Icon(
                                                                Icons.fastfood_rounded,
                                                                color: Color(0xFFE23744),
                                                                size: 28,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    // Item Details
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            valueItem.itemName,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: Color(0xFF2D3436),
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          // const SizedBox(height: 4),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 5,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(0xFFE23744).withOpacity(0.1),
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                child: const Text(
                                                                  "Add-on",
                                                                  style: TextStyle(
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Color(0xFFE23744),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Add Icon
                                                    Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFE23744).withOpacity(0.15),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Color(0xFFE23744),
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// REMOVE BUTTON - ZOMATO STYLE
                      if (_sideitemChoose != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFE23744),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Color(0xFFE23744), width: 1.5),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            label: const Text(
                              'Remove Item',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
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
                      ],

                      const SizedBox(height: 24),

                      /// QUESTION DROPDOWN - ZOMATO STYLE
                      if (_sideitemChoose != null && _sideitemChoose!.questions.isNotEmpty) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.help_outline,
                                        color: Colors.orange,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Customization",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2D3436),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                FormField<Question>(
                                  builder: (FormFieldState<Question> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        errorText: _errorQuestion,
                                        errorStyle: const TextStyle(
                                          color: Colors.orange,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        filled: true,
                                        fillColor: Colors.orange[50],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.orange.shade200, width: 1.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.orange.shade200, width: 1.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.orange, width: 2),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Question>(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF2D3436),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          hint: Row(
                                            children: [
                                              Icon(
                                                Icons.quiz,
                                                color: Colors.grey[600],
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Select a Question",
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: _selectedQuestion,
                                          isExpanded: true,
                                          isDense: false,
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.orange,
                                            size: 24,
                                          ),
                                          onChanged: (Question? newValue) {
                                            setState(() {
                                              _selectedQuestion = newValue;
                                              _errorQuestion = null;
                                              _selectedOption = null;
                                              _errorOption = null;
                                            });
                                          },
                                          items: _sideitemChoose!.questions.map((Question valueItem) {
                                            return DropdownMenuItem<Question>(
                                              value: valueItem,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: const Icon(
                                                        Icons.question_mark,
                                                        color: Colors.orange,
                                                        size: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        valueItem.question,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xFF2D3436),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      /// OPTION DROPDOWN - ZOMATO STYLE
                      if (_selectedQuestion != null && _selectedQuestion!.options.isNotEmpty) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.tune,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Choose Option",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2D3436),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                FormField<Option>(
                                  builder: (FormFieldState<Option> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        errorText: _errorOption,
                                        errorStyle: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        filled: true,
                                        fillColor: Colors.green[50],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.green.shade200, width: 1.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.green.shade200, width: 1.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.green, width: 2),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Option>(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF2D3436),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          hint: Row(
                                            children: [
                                              Icon(
                                                Icons.radio_button_unchecked,
                                                color: Colors.grey[600],
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Select an Option",
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: _selectedOption,
                                          isExpanded: true,
                                          isDense: false,
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.green,
                                            size: 24,
                                          ),
                                          onChanged: (Option? newValue) {
                                            setState(() {
                                              _selectedOption = newValue;
                                              _errorOption = null;
                                            });
                                          },
                                          items: _selectedQuestion!.options.map((Option valueItem) {
                                            return DropdownMenuItem<Option>(
                                              value: valueItem,
                                              child: Container(
                                                // padding: const EdgeInsets.symmetric(vertical: 5),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: const Icon(
                                                        Icons.check_circle_outline,
                                                        color: Colors.green,
                                                        size: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            valueItem.name,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: Color(0xFF2D3436),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: Colors.green.withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            child: Text(
                                                              valueItem.price,
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w700,
                                                                color: Colors.green,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (extraOftenBoughtList.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with Zomato-style title
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE23744), // Zomato red
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Often Bought With",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Groups list
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: extraOftenBoughtList.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, groupIndex) {
                              final group = extraOftenBoughtList[groupIndex];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Group header with Zomato styling
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        border: Border(
                                          bottom: BorderSide(color: Colors.grey[200]!),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              group.name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                          if (selectedOftenBoughtOptions[group.id] != null)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE23744).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Color(0xFFE23744),
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedOftenBoughtOptions[group.id] = null;
                                                  });
                                                },
                                                tooltip: 'Clear Selection',
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // Options list
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: group.options.map((option) {
                                          final isSelected = selectedOftenBoughtOptions[group.id] == option;

                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFFE23744).withOpacity(0.05)
                                                  : Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected
                                                    ? const Color(0xFFE23744)
                                                    : Colors.grey[300]!,
                                                width: isSelected ? 2 : 1,
                                              ),
                                            ),
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(12),
                                              onTap: () {
                                                setState(() {
                                                  selectedOftenBoughtOptions[group.id] = option;
                                                });
                                                print(
                                                  'Selected for ${group.name}: ${option.name} - \$${option.price} ${option.id} ${option.optionGroupId}',
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: Row(
                                                  children: [
                                                    // Custom radio button with Zomato styling
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: isSelected
                                                              ? const Color(0xFFE23744)
                                                              : Colors.grey[400]!,
                                                          width: 2,
                                                        ),
                                                        color: isSelected
                                                            ? const Color(0xFFE23744)
                                                            : Colors.transparent,
                                                      ),
                                                      child: isSelected
                                                          ? const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 14,
                                                      )
                                                          : null,
                                                    ),
                                                    const SizedBox(width: 16),

                                                    // Option details
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            option.name,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey[800],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            '\$${option.price}',
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w700,
                                                              color: Color(0xFF2E7D32), // Green for price
                                                            ),
                                                          ),
                                                          if (option.size.isNotEmpty) ...[
                                                            const SizedBox(height: 4),
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 4,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[200],
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Text(
                                                                'Size: ${option.size}',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey[600],
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: height * .02),
                SizedBox(height: 50),
              ],
            ),
          ),
          Column(
          crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  // if (sideDrawerController.cartListRestaurant.isEmpty ||
                  //     sideDrawerController.cartListRestaurant ==
                  //         sideDrawerController.specialFoodResId
                  //             .toString()) {
                  // Check if user has chosen a side item
                  bool hasSideItem = _sideitemChoose != null;

                  // Validate mandatory fields only if side item is chosen
                  if (hasSideItem) {
                    // Validate mandatory fields for side items
                    if (_selectedOption?.id == null) {
                      helper.errorDialog(
                          context, "Please select a side option");
                      return;
                    }
                    if (_sideitemChoose?.id == null) {
                      helper.errorDialog(
                          context, "Please select a side item");
                      return;
                    }
                    if (_selectedQuestion?.id == null) {
                      helper.errorDialog(
                          context, "Please answer the required question");
                      return;
                    }
                    if (_sideitemChoose?.itemPrice == null) {
                      helper.errorDialog(
                          context, "Side item price is required");
                      return;
                    }
                    if (_selectedOption?.price == null) {
                      helper.errorDialog(
                          context, "Selected option price is required");
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

                    selectedOftenBoughtOptions
                        ?.forEach((groupId, option) {
                      if (option != null) {
                        oftenBoughtOptionIds
                            .add(option.id?.toString() ?? "");
                        oftenBoughtOptionGroupIds
                            .add(groupId?.toString() ?? "");
                        oftenBoughtOptionGroupPrice
                            .add(option.price?.toString() ?? "0");
                      }
                    });

                    addToCart(
                        sideOptionsId: sideOptionsId,
                        sideItemId: sideItemId,
                        sideQuestionId: sideQuestionId,
                        sidePriceId: sidePriceId,
                        selectedOptionPrice: selectedOptionPrice,
                        oftenBoughtOptionsId:
                        oftenBoughtOptionIds.join(','),
                        optionGroupId: oftenBoughtOptionGroupIds.join(','),
                        oftenBoughtOptionGroupPrice:
                        oftenBoughtOptionGroupPrice.join(','),
                        productId: specialFoodDetail['products'][0]['id'].toString(),
                        restaurantId: specialFoodDetail['products'][0]['restaurant_id'].toString()
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }
                  // } else {
                  //   helper.errorDialog(context,
                  //       "Your cart is already have food from different restaurant");
                  // }
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
              )
            ],
          )
        ],
      )
    );
  }
}
