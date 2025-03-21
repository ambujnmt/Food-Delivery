import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_best_deals.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer';

import '../auth/login_screen.dart';

class DealsScreen extends StatefulWidget {
  String title;
  DealsScreen({super.key, required this.title});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  final customText = CustomText();
  final helper = Helper();
  bool isApiCalling = false;
  bool categoryApiCalling = false;
  bool dealsApiCalling = false;
  List<dynamic> allBestDealsList = [];
  List<dynamic> productsList = [];
  // filter list
  List<dynamic> shortByCategoryList = [];
  List<String> shortByCategoryNames = [];

  List<dynamic> shortByDealsList = [];
  List<String> shortByDealNames = [];

  Map<String, dynamic> pivot = {};
  final List<String> items = [
    TextConstants.newNess,
  ];

  final api = API();
  final box = GetStorage();
  double distanceInMiles = 1.0;
  String _currentAddress = 'Unknown location';
  String dealId = "";
  Position? _currentPosition;
  String? userLatitude;
  String? userLongitude;
  String? getLatitude;
  String? getLongitude;

  String? selectedCategoryName;
  String? selectedDealsName;

  // view all best deals
  viewAllBestDeals({String? search = ""}) async {
    productsList.clear();
    setState(() {
      isApiCalling = true;
    });

    final response = await api.viewAllBestDeals(search: search);

    setState(() {
      isApiCalling = false;
    });

    if (response['status'] == true) {
      setState(() {
        allBestDealsList = response['deals_data'];
      });
      for (int i = 0; i < allBestDealsList.length; i++) {
        // productsList.add(allBestDealsList[i]);

        String dealTitle = allBestDealsList[i]["title"];
        String businessName = allBestDealsList[i]["business_name"];
        String businessAddress = allBestDealsList[i]["business_address"];
        String businessLat = allBestDealsList[i]["latitude"];
        String businessLong = allBestDealsList[i]["longitude"];
        List tempProductsList = allBestDealsList[i]["products"];
        for (int j = 0; j < tempProductsList.length; j++) {
          tempProductsList[j]["dealTitle"] = dealTitle;
          tempProductsList[j]["businessName"] = businessName;
          tempProductsList[j]["businessAddress"] = businessAddress;
          tempProductsList[j]["businessLat"] = businessLat;
          tempProductsList[j]["businessLong"] = businessLong;
          productsList.add(tempProductsList[j]);
        }
      }
    }

    log("all best deal list :- $allBestDealsList");
    log("all product list :- $productsList");
  }

  // get category
  getCategory({String? search = ""}) async {
    setState(() {
      categoryApiCalling = true;
    });
    final response = await api.viewAllBestDeals(search: search);
    setState(() {
      categoryApiCalling = false;
    });
    if (response['status'] == true) {
      setState(() {
        shortByCategoryList = response['categories'];

        // get category names
        for (int i = 0; i < shortByCategoryList.length; i++) {
          shortByCategoryNames.add(shortByCategoryList[i]['title']);
        }
        shortByCategoryNames.sort((a, b) => a.compareTo(b));
      });
    }
  }

  // get deals
  getDeals({String? search = ""}) async {
    setState(() {
      dealsApiCalling = true;
    });
    final response = await api.viewAllBestDeals(search: search);
    setState(() {
      dealsApiCalling = false;
    });
    if (response['status'] == true) {
      setState(() {
        shortByDealsList = response['food_events'];

        // get deals names
        for (int i = 0; i < shortByDealsList.length; i++) {
          shortByDealNames.add(shortByDealsList[i]['title']);
        }
        shortByDealNames.sort((a, b) => a.compareTo(b));
      });
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
      print("Distance in miles: $formattedMiles miles");

      return "$formattedMiles Mls"; // Return distance as a formatted string
    } catch (e) {
      print("Error retrieving location: $e");
      return "Loading...";
    }
  }

  @override
  void initState() {
    super.initState();
    viewAllBestDeals();
    getCategory();
    getDeals();
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
              // category filter
              Container(
                // width: width * .6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // short by category
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      height: height * 0.05,
                      width: width * 0.45,
                      decoration: BoxDecoration(
                        color: ColorConstants.kSortButton,
                        borderRadius: BorderRadius.circular(width * 0.02),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          iconStyleData: IconStyleData(
                            icon: selectedCategoryName == null
                                ? const Icon(Icons.arrow_drop_down,
                                    color: Colors.black, size: 24)
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategoryName = null;
                                        viewAllBestDeals();
                                      });
                                    },
                                    child: const Icon(Icons.clear),
                                  ),
                            iconSize: 24,
                          ),
                          isExpanded: true,
                          hint: Text(TextConstants.shortByCategory,
                              style: customText.kTextStyle(
                                  12, FontWeight.w500, Colors.black)),
                          items: shortByCategoryNames
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedCategoryName,
                          onChanged: (String? value) {
                            setState(() {
                              selectedDealsName = null;
                              selectedCategoryName = value;
                              viewAllBestDeals(search: selectedCategoryName);
                            });
                            print(
                                "selected category value: ${selectedCategoryName}");
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            isOverButton: false,
                            elevation: 8,
                            maxHeight: height * .4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: width * .010),
                    // short by event
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, top: 5, bottom: 5, right: 10),
                      height: height * 0.05,
                      width: width * 0.45,
                      decoration: BoxDecoration(
                        color: ColorConstants.kSortButton,
                        borderRadius: BorderRadius.circular(width * 0.02),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          iconStyleData: IconStyleData(
                            icon: selectedDealsName == null
                                ? const Icon(Icons.arrow_drop_down,
                                    color: Colors.black, size: 24)
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDealsName = null;
                                        viewAllBestDeals();
                                      });
                                    },
                                    child: const Icon(Icons.clear),
                                  ),
                            iconSize: 24,
                          ),
                          isExpanded: true,
                          hint: Text(TextConstants.shortByEvent,
                              style: customText.kTextStyle(
                                  12, FontWeight.w500, Colors.black)),
                          items: shortByDealNames
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedDealsName,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCategoryName = null;
                              selectedDealsName = value;
                              viewAllBestDeals(search: selectedDealsName);
                            });
                            print("selected deal name: ${selectedDealsName}");
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            isOverButton: false,
                            elevation: 8,
                            maxHeight: height * .4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // banner
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
                          customText.kText(TextConstants.bestDeals, 28,
                              FontWeight.w900, Colors.white, TextAlign.center),
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
                          color: ColorConstants.kPrimary),
                    )
                  : productsList.isEmpty
                      ? const CustomNoDataFound()
                      : Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 1.0,
                              childAspectRatio: 1 / 1.6,
                            ),
                            itemCount: productsList.length,
                            itemBuilder: (context, index) {
                              return CustomBestDeals(
                                subscriptionStatus: productsList[index]
                                    ['subscribe_status'],
                                dealtitle: productsList[index]['dealTitle'],
                                resAddress: productsList[index]
                                    ['businessAddress'],
                                distance: calculateDistance(
                                  restaurantLat: productsList[index]
                                      ['businessLat'],
                                  restaurantLong: productsList[index]
                                      ['businessLong'],
                                ),
                                amount: productsList[index]['price'],
                                restaurantName: productsList[index]
                                    ['businessName'],
                                foodItemName: productsList[index]['name'],
                                imageURL: productsList[index]['image'],
                                addTocart: TextConstants.addToCart,
                                addToCartTap: () async {
                                  // print("add to cart");
                                  if (loginController.accessToken.isNotEmpty) {
                                    if (sideDrawerController
                                            .cartListRestaurant.isEmpty ||
                                        sideDrawerController
                                                .cartListRestaurant ==
                                            productsList[index]["user_id"]
                                                .toString()) {
                                      await box.write(
                                          "cartListRestaurant",
                                          productsList[index]["user_id"]
                                              .toString());

                                      setState(() {
                                        sideDrawerController
                                                .cartListRestaurant =
                                            productsList[index]["user_id"]
                                                .toString();
                                      });

                                      bottomSheet(
                                        productsList[index]['image'],
                                        productsList[index]['name'],
                                        productsList[index]['price'],
                                        productsList[index]['id'].toString(),
                                        productsList[index]['user_id']
                                            .toString(),
                                      );
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
                                subscribeTap: () async {
                                  if (loginController.accessToken.isNotEmpty) {
                                    pivot = productsList[index]["pivot"];
                                    dealId = pivot['deal_id'].toString();
                                    print("deal id: $dealId");
                                    var response;
                                    if (productsList[index]
                                            ['subscribe_status'] ==
                                        0) {
                                      response = await api.subscribeDeal(
                                        dealId,
                                        productsList[index]['id'].toString(),
                                      );
                                      viewAllBestDeals();
                                    } else {
                                      response = await api.unSubscribeDeal(
                                        dealId,
                                        productsList[index]['id'].toString(),
                                      );
                                      viewAllBestDeals();
                                    }

                                    if (response['status'] == true) {
                                      helper.successDialog(
                                          context, response['message']);
                                    } else {
                                      helper.errorDialog(
                                          context, response['message']);
                                    }
                                  } else {
                                    helper.errorDialog(
                                        context, "Login is required");
                                  }
                                },
                                onTap: () {
                                  // ================//
                                  sideDrawerController.bestDealsProdName =
                                      productsList[index]['name'];
                                  sideDrawerController.bestDealsProdImage =
                                      productsList[index]['image'];
                                  sideDrawerController.bestDealsRestaurantName =
                                      productsList[index]['businessName'];
                                  sideDrawerController.bestDealsProdPrice =
                                      productsList[index]['price'];
                                  sideDrawerController.bestDealsProdId =
                                      productsList[index]['id'].toString();
                                  sideDrawerController.bestDealsResId =
                                      productsList[index]['user_id'].toString();
                                  // ================//
                                  sideDrawerController.previousIndex
                                      .add(sideDrawerController.index.value);
                                  sideDrawerController.index.value = 35;
                                  sideDrawerController.pageController
                                      .jumpToPage(
                                          sideDrawerController.index.value);
                                },
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

  // bottom sheet for adding items to the cart
  void bottomSheet(String image, String name, String price, String productId,
      String restaurantId) {
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

              final response = await api.addItemsToCart(
                userId: loginController.userId.toString(),
                price: calculatedPrice.toString(),
                quantity: quantity.toString(),
                // restaurantId: sideDrawerController.restaurantId,
                restaurantId: restaurantId.toString(),
                productId: productId.toString(),
              );

              update(() {
                cartCalling = false;
              });

              if (response["status"] == true) {
                print('success message: ${response["message"]}');
                helper.successDialog(context, response["message"]);
                Navigator.pop(context);
              } else {
                helper.errorDialog(context, response["message"]);
                print('error message: ${response["message"]}');
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
