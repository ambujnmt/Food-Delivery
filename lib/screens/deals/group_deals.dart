import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_best_deals.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_text.dart';

class GroupDeals extends StatefulWidget {
  const GroupDeals({super.key});

  @override
  State<GroupDeals> createState() => _GroupDealsState();
}

class _GroupDealsState extends State<GroupDeals> {

  final customText = CustomText(), api = API(), helper = Helper();
  String? selectedCategoryName, selectedDealsName, getLatitude, getLongitude;
  String _currentAddress = 'Unknown location';
  Position? _currentPosition;
  List<String> shortByCategoryNames = [], shortByDealNames = [];
  List<dynamic> allBestDealsList = [], shortByCategoryList = [], shortByDealsList = [];
  bool isApiCalling = false, categoryApiCalling = false, dealsApiCalling = false;
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  @override
  void initState() {
    super.initState();
    log("sideDrawerController groupDeal :- ${sideDrawerController.dealData}, ${sideDrawerController.dealData.length}");
    getCategory();
    getDeals();
  }

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

  viewAllBestDeals({String? search = ""}) async {
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
    }
  }

  String calculateDistance({String? restaurantLat, String? restaurantLong}) {
    getCurrentPosition();
    // print("get lat: ${getLatitude}");
    // print("get long: ${getLongitude}");
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

      return "$formattedMiles MLs"; // Return distance as a formatted string
    } catch (e) {
      print("Error retrieving location: $e");
      return "Loading...";
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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

            Container(
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
                itemCount: sideDrawerController.dealData.length,
                itemBuilder: (context, index) {
                  return CustomBestDeals(
                    dealtitle: sideDrawerController.dealTitle,
                    resAddress: sideDrawerController.dealData[index]['business_address'],
                    distance: calculateDistance(
                      restaurantLat: sideDrawerController.dealData[index]['latitude'],
                      restaurantLong: sideDrawerController.dealData[index]['longitude'],
                    ),
                    amount: sideDrawerController.dealData[index]["price"],
                    restaurantName: sideDrawerController.dealData[index]['business_name'],
                    foodItemName: sideDrawerController.dealData[index]['name'],
                    imageURL: sideDrawerController.dealData[index]['image'],
                    addTocart: TextConstants.addToCart,
                    addToCartTap: () {
                    },
                    onTap: () {
                      // ================//
                      sideDrawerController.bestDealsProdName = sideDrawerController.dealData[index]['name'];
                      sideDrawerController.bestDealsProdImage = sideDrawerController.dealData[index]['image'];
                      sideDrawerController.bestDealsRestaurantName = sideDrawerController.dealData[index]['business_name'];
                      sideDrawerController.bestDealsProdPrice = sideDrawerController.dealData[index]['price'];
                      sideDrawerController.bestDealsProdId = sideDrawerController.dealData[index]['product_id'].toString();
                      sideDrawerController.bestDealsResId = sideDrawerController.dealData[index]['resturant_id'].toString();
                      // ================//
                      sideDrawerController.previousIndex.add(sideDrawerController.index.value);
                      sideDrawerController.index.value = 35;
                      sideDrawerController.pageController.jumpToPage(sideDrawerController.index.value);
                    },
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
