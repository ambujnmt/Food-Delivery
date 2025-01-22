import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_footer.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic size;
  String _currentAddress = 'Unknown location';
  String? getLatitude;

  String? getLongitude;
  Position? _currentPosition;

  final customText = CustomText();
  final helper = Helper();
  final api = API();
  bool isApiCalling = false;

  List<dynamic> getNearbyRestaurantList = [];
  List<dynamic> getFoodCategoryList = [];
  List<dynamic> homeBannerList = [];
  List<dynamic> bestDealsList = [];
  List<dynamic> cityRestaurantList = [];
  List<dynamic> specialFoodList = [];
  Map<String, dynamic> homeInfoMap = {};
  String? contactEmail;
  String? contactPhone;
  String? contactAddress;

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  int indexValue = 0;
  int currentIndex = 0;
  int nearByCurrentIndex = 0;
  int foodCategoryCurrentIndex = 0;
  int bestDealsCurrentIndex = 0;
  int topRestaurantCurrentIndex = 0;
  int specialFoodCurrentIndex = 0;

  // Check Permissions
  Future<bool> _handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return false;
    }

    return true;
  }

  // Get Current Location
  Future<void> _getCurrentLocation() async {
    bool permissionGranted = await _handlePermission();

    if (!permissionGranted) {
      setState(() {
        _currentAddress = 'Location permission denied.';
      });
      return;
    }

    try {
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
      print("current location: {$_currentAddress}");
      if (getLatitude != null && getLatitude != null) {
        sendCurrentLocation();
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Error retrieving location: $e';
      });
    }
  }

  // get restaurant by current location
  sendCurrentLocation() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.postCurrentLocation(
      latitude: getLatitude,
      longitude: getLongitude,
    );

    setState(() {
      getNearbyRestaurantList = response['restaurants'];
    });

    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('success message: ${response["message"]}');
    } else {
      print('error message: ${response["message"]}');
    }
  }

  // get food category list
  getFoodCategoryData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.getFood();
    setState(() {
      getFoodCategoryList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' food category success message: ${response["message"]}');
    } else {
      print('food category error message: ${response["message"]}');
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
      print("best deals image: ${bestDealsList[0]["image"]}");
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

  // city based top restaurants
  cityBasedRestaurantData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.topRestaurantCity();
    setState(() {
      cityRestaurantList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print('city restaurant success message: ${response["message"]}');
    } else {
      print('city restaurant error message: ${response["message"]}');
    }
  }

  // special food list
  specialFoodData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.specialFood();
    setState(() {
      specialFoodList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' special food success message: ${response["message"]}');
    } else {
      print('special food error message: ${response["message"]}');
    }
  }

  // contact information
  contactInformation() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.homeContactInfo();
    setState(() {
      homeInfoMap = response['data'];
      contactPhone = homeInfoMap['phone'];
      contactEmail = homeInfoMap['email'];
      contactAddress = homeInfoMap['address'];
      print("contact phone: $contactPhone");
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' special food success message: ${response["message"]}');
    } else {
      print('special food error message: ${response["message"]}');
    }
  }

  // get baaner list for home page
  getHomeBannerData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.getHomeBanner();
    setState(() {
      homeBannerList = response["data"];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print("banner image: ${homeBannerList[0]["image"]}");
      print(' home banner success message: ${response["message"]}');
    } else {
      print(' home error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    getHomeBannerData();
    getFoodCategoryData();
    bestDealsData();
    cityBasedRestaurantData();
    specialFoodData();
    contactInformation();
    super.initState();
  }

  customHeading(String title, Function() onTap) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          size.width * 0.03, size.height * 0.01, size.width * 0.03, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText.kText(title, 20, FontWeight.w700, ColorConstants.kPrimary,
              TextAlign.center),
          GestureDetector(
            child: customText.kText(TextConstants.viewAll, 14, FontWeight.w700,
                Colors.black, TextAlign.center),
            onTap: onTap,
          )
        ],
      ),
    );
  }

  customFoodCategory(String image, String title) {
    return Container(
      margin: EdgeInsets.only(right: size.width * .01),
      height: size.height * 0.15,
      width: size.width * 0.3,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.02),
          boxShadow: const [
            // BoxShadow(
            //     offset: Offset(0, 1), blurRadius: 4, color: Colors.black26)
          ]),
      child: Column(
        children: [
          Container(
            height: size.height * 0.11,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.width * 0.02),
                  topRight: Radius.circular(size.width * 0.02),
                ),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
          SizedBox(
            height: size.height * 0.04,
            child: Center(
              child: customText.kText(
                  title,
                  14,
                  FontWeight.w700,
                  ColorConstants.kPrimary,
                  TextAlign.center,
                  TextOverflow.ellipsis,
                  1),
            ),
          )
        ],
      ),
    );
  }

  customBestDeal(String image, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * 0.15,
        width: size.width * 0.3,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(size.width * 0.02),
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size.height * 0.06,
                  width: size.width,
                  color: Colors.grey.shade300,
                ),

                homeBannerList.isEmpty
                    ? CustomNoDataFound()
                    : CarouselSlider.builder(
                        itemCount: homeBannerList.length,
                        itemBuilder:
                            (BuildContext context, int index, realIndex) =>
                                Container(
                          height: size.height * 0.18,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              image: DecorationImage(
                                  image: NetworkImage(homeBannerList[index]
                                          ["image"]
                                      .toString()),
                                  fit: BoxFit.fill)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                color: Colors.black54,
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    customText.kText(
                                        TextConstants.getReady,
                                        20,
                                        FontWeight.w900,
                                        Colors.white,
                                        TextAlign.center),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    customText.kText(
                                        TextConstants.toJoiWithUs,
                                        24,
                                        FontWeight.w900,
                                        Colors.white,
                                        TextAlign.center),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        height: size.height * 0.04,
                                        width: size.width * 0.4,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.03)),
                                        child: Center(
                                            child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              print("banner index: $index");
                                            });
                                            // place your navigation for table booking

                                            if (index == 0) {
                                            } else if (index == 1) {
                                            } else if (index == 2) {
                                              sideDrawerController.index.value =
                                                  23;
                                              sideDrawerController
                                                  .pageController
                                                  .jumpToPage(
                                                      sideDrawerController
                                                          .index.value);
                                            } else if (index == 4) {}
                                          },
                                          child: Container(
                                            child: customText.kText(
                                                "${homeBannerList[index]['title'].toString().toUpperCase()}",
                                                14,
                                                FontWeight.w700,
                                                Colors.white,
                                                TextAlign.center),
                                          ),
                                        )),
                                      ),
                                      onTap: () {},
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        options: CarouselOptions(
                            height: 180.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            }),
                      ),
                homeBannerList.isEmpty
                    ? Container()
                    : Center(
                        child: DotsIndicator(
                          dotsCount: homeBannerList.length,
                          position: currentIndex,
                          decorator: const DotsDecorator(
                            color: Colors.black, // Inactive color
                            activeColor: ColorConstants.kPrimary,
                          ),
                        ),
                      ),

                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.005),
                    child: customText.kText(
                        "Welcome To Get Food Delivery.",
                        16,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.start)),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: RichText(
                      text: TextSpan(
                          text:
                              "The Only Place To Find Great Food Everyday In Your Neighbourhood. ",
                          style: customText.kTextStyle(
                              16, FontWeight.w500, Colors.black),
                          children: [
                        TextSpan(
                          text: "Get Discounts. Earn Point",
                          style: customText.kTextStyle(
                              16, FontWeight.w500, ColorConstants.kPrimary),
                        )
                      ])),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: customText.kText(
                      "Our Newest & Popular Food From Restaurant Near By.",
                      16,
                      FontWeight.w700,
                      ColorConstants.kPrimary,
                      TextAlign.start),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: customText.kText(
                      "Delivery On Your Time And Easy To Pickup.",
                      16,
                      FontWeight.w500,
                      Colors.black,
                      TextAlign.start),
                ),

                // Restaurants
                customHeading(TextConstants.restaurant, () {
                  print("restaurant view all pressed");
                  sideDrawerController.index.value = 1;
                  log("side drawer controller index values :- ${sideDrawerController.index}");
                  sideDrawerController.pageController.jumpToPage(1);
                  setState(() {});
                }),

                getNearbyRestaurantList.isEmpty
                    ? CustomNoDataFound()
                    : CarouselSlider.builder(
                        itemCount: getNearbyRestaurantList.length > 3
                            ? 3
                            : getNearbyRestaurantList.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          final restaurant = getNearbyRestaurantList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: Container(
                              margin: EdgeInsets.only(right: size.width * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: size.height * 0.2,
                                    width: size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.02),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          restaurant["business_image"],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: size.height *
                                          0.01), // Add spacing if needed
                                  customText.kText(
                                    "${restaurant["name"]}",
                                    14,
                                    FontWeight.w700,
                                    ColorConstants.kPrimary,
                                    TextAlign.start,
                                  ),
                                  customText.kText(
                                    "${restaurant["distance"].toString().substring(0, 5)} Mls",
                                    12,
                                    FontWeight.w400,
                                    Colors.black,
                                    TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() {
                              nearByCurrentIndex = index;
                            });
                          },
                        ),
                      ),

                getNearbyRestaurantList.isEmpty
                    ? Container()
                    : Center(
                        child: DotsIndicator(
                          dotsCount: getNearbyRestaurantList.length > 3
                              ? 3
                              : getNearbyRestaurantList.length,
                          position: nearByCurrentIndex,
                          decorator: const DotsDecorator(
                            color: Colors.black,
                            activeColor: ColorConstants.kPrimary,
                          ),
                        ),
                      ),

                SizedBox(height: size.height * 0.02),

                // Food Category
                customHeading(TextConstants.foodCategory, () {
                  print("food category view all pressed");
                  sideDrawerController.previousIndex =
                      sideDrawerController.index.value;
                  sideDrawerController.index.value = 2;
                  sideDrawerController.pageController
                      .jumpToPage(sideDrawerController.index.value);
                }),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: customText.kText(TextConstants.foodCategoryDes, 14,
                      FontWeight.w500, Colors.black, TextAlign.start),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),

                getFoodCategoryList.isEmpty
                    ? CustomNoDataFound()
                    : CarouselSlider.builder(
                        itemCount: getFoodCategoryList.length > 3
                            ? 3
                            : getFoodCategoryList.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          final foodCategory = getFoodCategoryList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: Container(
                              margin: EdgeInsets.only(right: size.width * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: size.height * 0.2,
                                    width: size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.02),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          foodCategory["image"],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: size.height *
                                          0.01), // Add spacing if needed
                                  customText.kText(
                                    foodCategory["title"],
                                    14,
                                    FontWeight.w700,
                                    ColorConstants.kPrimary,
                                    TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() {
                              foodCategoryCurrentIndex = index;
                            });
                          },
                        ),
                      ),
                getFoodCategoryList.isEmpty
                    ? Container()
                    : Center(
                        child: DotsIndicator(
                          dotsCount: getFoodCategoryList.length > 3
                              ? 3
                              : getNearbyRestaurantList.length,
                          position: foodCategoryCurrentIndex,
                          decorator: const DotsDecorator(
                            color: Colors.black, // Inactive color
                            activeColor: ColorConstants.kPrimary,
                          ),
                        ),
                      ),

                SizedBox(
                  height: size.height * 0.04,
                ),

                // Best Deals
                Align(
                  alignment: Alignment.center,
                  child: customText.kText(TextConstants.getFoodDelivery, 20,
                      FontWeight.w700, Colors.black, TextAlign.center),
                ),

                customHeading(TextConstants.bestDeals, () {
                  print("best deals view all pressed");
                  sideDrawerController.previousIndex =
                      sideDrawerController.index.value;
                  sideDrawerController.index.value = 4;
                  sideDrawerController.pageController
                      .jumpToPage(sideDrawerController.index.value);
                }),

                bestDealsList.isEmpty
                    ? CustomNoDataFound()
                    : CarouselSlider.builder(
                        itemCount:
                            bestDealsList.length > 3 ? 3 : bestDealsList.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          final bestDeals = bestDealsList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: Container(
                              margin: EdgeInsets.only(right: size.width * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(right: 10),
                                    height: size.height * 0.2,
                                    width: size.width * 0.6,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
                                            size.width * 0.02),
                                        image: DecorationImage(
                                          image: bestDeals["image"] == "null"
                                              ? const AssetImage(
                                                  "assets/images/no_image.jpeg")
                                              : NetworkImage(
                                                  bestDeals["image"]),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() {
                              bestDealsCurrentIndex = index;
                            });
                          },
                        ),
                      ),
                bestDealsList.isEmpty
                    ? Container()
                    : Center(
                        child: DotsIndicator(
                          dotsCount: bestDealsList.length > 3
                              ? 3
                              : bestDealsList.length,
                          position: bestDealsCurrentIndex,
                          decorator: const DotsDecorator(
                            color: Colors.black, // Inactive color
                            activeColor: ColorConstants.kPrimary,
                          ),
                        ),
                      ),

                SizedBox(
                  height: size.height * 0.04,
                ),

                // Top Restaurants
                Align(
                  alignment: Alignment.center,
                  child: customText.kText("Atlantic City", 20, FontWeight.w700,
                      Colors.black, TextAlign.center),
                ),

                customHeading(TextConstants.topRestaurants, () {
                  log("top restaurants view all pressed");
                }),

                cityRestaurantList.isEmpty
                    ? CustomNoDataFound()
                    : CarouselSlider.builder(
                        itemCount: cityRestaurantList.length > 3
                            ? 3
                            : cityRestaurantList.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          final topRestaurants = cityRestaurantList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: Container(
                              margin: EdgeInsets.only(right: size.width * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(right: 10),
                                    height: size.height * 0.2,
                                    width: size.width * 0.6,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
                                            size.width * 0.02),
                                        image: DecorationImage(
                                          image: topRestaurants[
                                                      "business_image"] ==
                                                  "null"
                                              ? const AssetImage(
                                                  "assets/images/no_image.jpeg")
                                              : NetworkImage(topRestaurants[
                                                  "business_image"]),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() {
                              topRestaurantCurrentIndex = index;
                            });
                          },
                        ),
                      ),
                cityRestaurantList.isEmpty
                    ? Container()
                    : Center(
                        child: DotsIndicator(
                          dotsCount: cityRestaurantList.length > 3
                              ? 3
                              : cityRestaurantList.length,
                          position: topRestaurantCurrentIndex,
                          decorator: const DotsDecorator(
                            color: Colors.black, // Inactive color
                            activeColor: ColorConstants.kPrimary,
                          ),
                        ),
                      ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                // Special foods
                customHeading(TextConstants.specialFood, () {
                  print("special foods view all pressed");
                  sideDrawerController.previousIndex =
                      sideDrawerController.index.value;
                  sideDrawerController.index.value = 3;
                  sideDrawerController.pageController
                      .jumpToPage(sideDrawerController.index.value);
                }),

                specialFoodList.isEmpty
                    ? CustomNoDataFound()
                    : CarouselSlider.builder(
                        itemCount: specialFoodList.length > 3
                            ? 3
                            : specialFoodList.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          final specialFood = specialFoodList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: Container(
                              margin: EdgeInsets.only(right: size.width * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(right: 10),
                                    height: size.height * 0.2,
                                    width: size.width * 0.6,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
                                            size.width * 0.02),
                                        image: DecorationImage(
                                          image: specialFood["image"] == "null"
                                              ? const AssetImage(
                                                  "assets/images/no_image.jpeg")
                                              : NetworkImage(
                                                  specialFood["image"]),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() {
                              specialFoodCurrentIndex = index;
                            });
                          },
                        ),
                      ),
                specialFoodList.isEmpty
                    ? Container()
                    : Center(
                        child: DotsIndicator(
                          dotsCount: specialFoodList.length > 3
                              ? 3
                              : specialFoodList.length,
                          position: specialFoodCurrentIndex,
                          decorator: const DotsDecorator(
                            color: Colors.black, // Inactive color
                            activeColor: ColorConstants.kPrimary,
                          ),
                        ),
                      ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                CustomFooter(
                  email: contactEmail,
                  phone: contactPhone,
                  address: contactAddress,
                ),

                SizedBox(height: size.height * 0.01),
              ],
            ),
          )),
    );
  }
}
