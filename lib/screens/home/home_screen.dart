import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/register_screen.dart';
import 'package:food_delivery/utils/custom_footer.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marquee/marquee.dart';
import 'package:geocoding/geocoding.dart' as geocode;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic size;
  String _currentAddress = 'Fetching Location';
  String? contactEmail, contactPhone, contactAddress;
  Position? _currentPosition;
  final customText = CustomText(),
      helper = Helper(),
      api = API(),
      box = GetStorage();
  bool isApiCalling = false;
  List<dynamic> getNearbyRestaurantList = [];
  List<dynamic> getFoodCategoryList = [];
  List<dynamic> homeBannerList = [];
  List<dynamic> bestDealsList = [];
  // List<dynamic> bestDealsProductList = [];
  List<dynamic> cityRestaurantList = [];
  List<dynamic> specialFoodList = [];
  Map<String, dynamic> homeInfoMap = {};
  int indexValue = 0,
      currentIndex = 0,
      nearByCurrentIndex = 0,
      foodCategoryCurrentIndex = 0,
      bestDealsCurrentIndex = 0,
      topRestaurantCurrentIndex = 0,
      specialFoodCurrentIndex = 0;
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    fetchManagedData();
    super.initState();
  }

  fetchManagedData() async {
    getCurrentLocation();
    getHomeBannerData();
    getFoodCategoryData();
    // bestDealsData();
    bestDeals();
    specialFoodData();
    contactInformation();
  }

  Future<void> getCurrentLocation() async {
    bool permissionGranted = await handlePermission();

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

      List<geocode.Placemark> placemarks = await geocode
          .placemarkFromCoordinates(position.latitude, position.longitude);

      log("placemarks :- $placemarks");

      setState(() {
        _currentPosition = position;
        // _currentAddress = 'Lat: ${position.latitude}, Long: ${position.longitude}';
        _currentAddress = placemarks[0].locality.toString();
        locationController.lat = position.latitude.toString();
        locationController.long = position.longitude.toString();
      });

      print("current location: {$_currentAddress}");
      print(
          "get lat: ${locationController.lat} --- get long ${locationController.long}");
      box.write('latOfUser', locationController.lat);
      box.write('longOfUser', locationController.long);

      if (locationController.lat.isNotEmpty &&
          locationController.long.isNotEmpty) {
        sendCurrentLocation();
        cityBasedRestaurantData();
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Error retrieving location: $e';
      });
    }
  }

  Future<bool> handlePermission() async {
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

  sendCurrentLocation() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.postCurrentLocation(
      latitude: locationController.lat,
      longitude: locationController.long,
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

  contactInformation() async {
    log("contact information called");

    setState(() {
      isApiCalling = true;
    });
    final response = await api.homeContactInfo();
    setState(() {
      homeInfoMap = response['data'];
      contactPhone = homeInfoMap['phone'];
      contactEmail = homeInfoMap['email'];
      contactAddress = homeInfoMap['address'];
      print("contact phone: $contactPhone, $contactEmail, $contactAddress");
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

  cityBasedRestaurantData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.topRestaurantCity(
      latitude: locationController.lat,
      longitude: locationController.long,
      radius: "12",
    );
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
                1,
              ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.kPrimary,
        onPressed: () {
          // navigation to the chat screen
          sideDrawerController.navigationToResFromChat = "resChat";
          sideDrawerController.index.value = 37;
          sideDrawerController.pageController.jumpToPage(sideDrawerController.index.value);
        },
        child: const Icon(
          Icons.chat,
          color: Colors.white,
          size: 28,
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // deals line
              SizedBox(
                height: size.height * .060,
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
                          // pauseAfterRound: const Duration(seconds: 1),
                        ),
                      ),
              ),

              // banner list
              homeBannerList.isEmpty
                  ? const CustomNoDataFound()
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
                                image: NetworkImage(
                                  homeBannerList[index]["image"].toString(),
                                ),
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
                                            sideDrawerController.index.value =
                                                3;
                                            sideDrawerController.pageController
                                                .jumpToPage(sideDrawerController
                                                    .index.value);
                                          } else if (index == 1) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterScreen()),
                                            );
                                          } else if (index == 2) {
                                            sideDrawerController.index.value =
                                                23;
                                            sideDrawerController.pageController
                                                .jumpToPage(sideDrawerController
                                                    .index.value);
                                          } else if (index == 3) {
                                            sideDrawerController.index.value =
                                                4;
                                            sideDrawerController.pageController
                                                .jumpToPage(sideDrawerController
                                                    .index.value);
                                          }
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
                        },
                      ),
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
                  vertical: size.height * 0.005,
                ),
                child: customText.kText(
                  "Welcome To Get Food Delivery.",
                  16,
                  FontWeight.w700,
                  ColorConstants.kPrimary,
                  TextAlign.start,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.005,
                ),
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
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.005,
                ),
                child: customText.kText(
                  "Check Our Newest & Popular Food From Restaurants Nearby.",
                  16,
                  FontWeight.w700,
                  ColorConstants.kPrimary,
                  TextAlign.start,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.005,
                ),
                child: customText.kText(
                  "Delivery On Your Time And Easy To Pickup.",
                  16,
                  FontWeight.w500,
                  Colors.black,
                  TextAlign.start,
                ),
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
                  ? const CustomNoDataFound()
                  : CarouselSlider.builder(
                      itemCount: getNearbyRestaurantList.length > 3
                          ? 3
                          : getNearbyRestaurantList.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        final restaurant = getNearbyRestaurantList[index];
                        return GestureDetector(
                          child: Container(
                            // color: Colors.deepPurple.shade50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.height * 0.18,
                                  // width: double.infinity,
                                  decoration: BoxDecoration(
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
                                  "${restaurant["business_name"]}",
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
                          onTap: () {
                            sideDrawerController.previousIndex
                                .add(sideDrawerController.index.value);
                            sideDrawerController.restaurantId =
                                restaurant["id"].toString();
                            sideDrawerController.detailRestaurantName =
                                restaurant["business_name"].toString();
                            sideDrawerController.restaurantlatitude =
                                restaurant["latitude"];
                            sideDrawerController.restaurantlongitude =
                                restaurant["longitude"];
                            sideDrawerController.restaurantAddress =
                                restaurant["business_address"];
                            sideDrawerController.restaurantImage =
                                restaurant['business_image'];

                            sideDrawerController.index.value = 16;
                            sideDrawerController.pageController
                                .jumpToPage(sideDrawerController.index.value);
                            log("restaurant details :- $restaurant");
                          },
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
                        height: size.height * 0.3,
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
                // sideDrawerController.previousIndex =
                //     sideDrawerController.index.value;
                sideDrawerController.previousIndex
                    .add(sideDrawerController.index.value);
                sideDrawerController.index.value = 2;
                sideDrawerController.pageController
                    .jumpToPage(sideDrawerController.index.value);
              }),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: customText.kText(TextConstants.foodCategoryDes, 14,
                    FontWeight.w500, Colors.black, TextAlign.start),
              ),
              SizedBox(height: size.height * 0.01),

              getFoodCategoryList.isEmpty
                  ? const CustomNoDataFound()
                  : CarouselSlider.builder(
                      itemCount: getFoodCategoryList.length > 3
                          ? 3
                          : getFoodCategoryList.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        final foodCategory = getFoodCategoryList[index];
                        return GestureDetector(
                          child: Container(
                            // color: Colors.yellow.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.height * 0.18,
                                  // width: size.width * 0.9,
                                  width: double.infinity,
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
                          onTap: () {
                            sideDrawerController.previousIndex
                                .add(sideDrawerController.index.value);
                            print(
                                "food category previous index: ${sideDrawerController.previousIndex}");
                            print(
                                "food category back press: ${sideDrawerController.index.value}");
                            sideDrawerController.foodCategoryId =
                                foodCategory["id"].toString();
                            sideDrawerController.foodCategoryTitle =
                                foodCategory["title"].toString();
                            sideDrawerController.index.value = 17;
                            sideDrawerController.pageController
                                .jumpToPage(sideDrawerController.index.value);
                            log("food category :- $foodCategory");
                          },
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
                        height: size.height * 0.27,
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

              SizedBox(height: size.height * 0.02),

              // Align(
              //   alignment: Alignment.center,
              //   child: customText.kText(TextConstants.getFoodDelivery, 20,
              //       FontWeight.w700, Colors.black, TextAlign.center),
              // ),
              // Best Deals
              customHeading(TextConstants.todayDeals, () {
                print("best deals view all pressed");
                // sideDrawerController.previousIndex =
                //     sideDrawerController.index.value;
                sideDrawerController.previousIndex.add(sideDrawerController.index.value);
                sideDrawerController.index.value = 4;
                sideDrawerController.pageController
                    .jumpToPage(sideDrawerController.index.value);
              }),
              SizedBox(height: size.height * 0.01),
              // bestDealsList.isEmpty
              //   ? const CustomNoDataFound()
              //   : CarouselSlider.builder(
              //       itemCount: bestDealsProductList.length > 4
              //           ? 4
              //           : bestDealsProductList.length,
              //       itemBuilder:
              //           (BuildContext context, int index, int realIndex) {
              //         final bestDeals = bestDealsProductList[index];
              //         return Container(
              //           // color: Colors.orange.shade200,
              //           // margin: EdgeInsets.only(right: size.width * 0.01),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               Container(
              //                 height: size.height * 0.18,
              //                 // width: size.width * 0.9,
              //                 width: double.infinity,
              //                 decoration: BoxDecoration(
              //                     color: Colors.grey,
              //                     borderRadius: BorderRadius.circular(
              //                         size.width * 0.02),
              //                     image: DecorationImage(
              //                       image: bestDeals["image"] == "null"
              //                           ? const AssetImage(
              //                               "assets/images/no_image.jpeg")
              //                           : NetworkImage(
              //                               bestDeals["image"]),
              //                       fit: BoxFit.cover,
              //                     )),
              //                 child: Stack(
              //                   alignment: Alignment.center,
              //                   children: [
              //                     Positioned(
              //                       child: Container(
              //                         height: size.height * .19,
              //                         width: size.width * .6,
              //                         decoration: BoxDecoration(
              //                             color: Colors.black
              //                                 .withOpacity(.4),
              //                             borderRadius:
              //                                 BorderRadius.circular(
              //                                     size.width * 0.02)),
              //                         child: Column(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.center,
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.center,
              //                           children: [
              //                             Container(
              //                               child: customText.kText(
              //                                   "${bestDeals['business_name']}",
              //                                   16,
              //                                   FontWeight.w800,
              //                                   Colors.white,
              //                                   TextAlign.center,
              //                                   TextOverflow.ellipsis,
              //                                   1),
              //                             ),
              //                             Container(
              //                               child: customText.kText(
              //                                   "${bestDeals['business_address']}",
              //                                   16,
              //                                   FontWeight.w800,
              //                                   Colors.white,
              //                                   TextAlign.center,
              //                                   TextOverflow.ellipsis,
              //                                   1),
              //                             ),
              //                             Container(
              //                               child: customText.kText(
              //                                   "${bestDealsList[index]['title']}",
              //                                   16,
              //                                   FontWeight.w800,
              //                                   Colors.white,
              //                                   TextAlign.center,
              //                                   TextOverflow.ellipsis,
              //                                   1),
              //                             ),
              //                             Container(
              //                               child: customText.kText(
              //                                   "${bestDeals['name']}",
              //                                   16,
              //                                   FontWeight.w800,
              //                                   Colors.white,
              //                                   TextAlign.center,
              //                                   TextOverflow.ellipsis,
              //                                   1),
              //                             ),
              //                             Container(
              //                               child: RatingBar.builder(
              //                                 ignoreGestures: true,
              //                                 initialRating: 3,
              //                                 minRating: 1,
              //                                 direction: Axis.horizontal,
              //                                 allowHalfRating: true,
              //                                 itemSize: 20,
              //                                 itemCount: 5,
              //                                 itemBuilder: (context, _) =>
              //                                     const Icon(
              //                                   Icons.star,
              //                                   color: Colors.amber,
              //                                 ),
              //                                 onRatingUpdate: (rating) {},
              //                               ),
              //                             ),
              //                             Container(
              //                               child: customText.kText(
              //                                   "\$${bestDeals['price']}",
              //                                   16,
              //                                   FontWeight.w800,
              //                                   Colors.white,
              //                                   TextAlign.center,
              //                                   TextOverflow.ellipsis,
              //                                   1),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //       options: CarouselOptions(
              //         enlargeCenterPage: true,
              //         autoPlay: true,
              //         autoPlayCurve: Curves.fastOutSlowIn,
              //         enableInfiniteScroll: true,
              //         autoPlayAnimationDuration:
              //             const Duration(milliseconds: 800),
              //         viewportFraction: 0.8,
              //         height: size.height * 0.22,
              //         onPageChanged: (index, reason) {
              //           setState(() {
              //             bestDealsCurrentIndex = index;
              //           });
              //         },
              //       ),
              //     ),
              // bestDealsProductList.isEmpty
              //   ? Container()
              //   : Center(
              //       child: DotsIndicator(
              //         dotsCount: bestDealsProductList.length > 4
              //             ? 4
              //             : bestDealsProductList.length,
              //         position: bestDealsCurrentIndex,
              //         decorator: const DotsDecorator(
              //           color: Colors.black, // Inactive color
              //           activeColor: ColorConstants.kPrimary,
              //         ),
              //       ),
              //     ),

              bestDealsList.isEmpty
                ? const CustomNoDataFound()
                : CarouselSlider.builder(
                    itemCount: bestDealsList.length > 3
                        ? 3
                        : bestDealsList.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      final bestDeals = bestDealsList[index]["products"][0];
                      return GestureDetector(
                        child: Container(
                          // color: Colors.orange.shade200,
                          // margin: EdgeInsets.only(right: size.width * 0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: size.height * 0.18,
                                // width: size.width * 0.9,
                                width: double.infinity,
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
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      child: Container(
                                        height: size.height * .19,
                                        width: size.width * .6,
                                        decoration: BoxDecoration(
                                            color: Colors.black
                                                .withOpacity(.4),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    size.width * 0.02)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: customText.kText(
                                                  "${bestDeals['business_name']}",
                                                  16,
                                                  FontWeight.w800,
                                                  Colors.white,
                                                  TextAlign.center,
                                                  TextOverflow.ellipsis,
                                                  1),
                                            ),
                                            Container(
                                              child: customText.kText(
                                                  "${bestDeals['business_address']}",
                                                  16,
                                                  FontWeight.w800,
                                                  Colors.white,
                                                  TextAlign.center,
                                                  TextOverflow.ellipsis,
                                                  1),
                                            ),
                                            Container(
                                              child: customText.kText(
                                                  "${bestDealsList[index]['title']}",
                                                  16,
                                                  FontWeight.w800,
                                                  Colors.white,
                                                  TextAlign.center,
                                                  TextOverflow.ellipsis,
                                                  1),
                                            ),
                                            Container(
                                              child: customText.kText(
                                                  "${bestDeals['name']}",
                                                  16,
                                                  FontWeight.w800,
                                                  Colors.white,
                                                  TextAlign.center,
                                                  TextOverflow.ellipsis,
                                                  1),
                                            ),
                                            Container(
                                              child: RatingBar.builder(
                                                ignoreGestures: true,
                                                initialRating: 3,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemSize: 20,
                                                itemCount: 5,
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              ),
                                            ),
                                            Container(
                                              child: customText.kText(
                                                  "\$${bestDeals['price']}",
                                                  16,
                                                  FontWeight.w800,
                                                  Colors.white,
                                                  TextAlign.center,
                                                  TextOverflow.ellipsis,
                                                  1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            sideDrawerController.dealData = bestDealsList[index]["products"];
                            sideDrawerController.dealTitle = bestDealsList[index]["title"];
                          });
                          sideDrawerController.previousIndex.add(sideDrawerController.index.value);
                          sideDrawerController.index.value = 36;
                          sideDrawerController.pageController.jumpToPage(sideDrawerController.index.value);
                        },
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
                      height: size.height * 0.22,
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
                child: customText.kText(_currentAddress, 20, FontWeight.w700,
                    Colors.black, TextAlign.center),
              ),
              customHeading(TextConstants.topRestaurants, () {
                log("top restaurants view all pressed");
                sideDrawerController.index.value = 1;
                sideDrawerController.pageController.jumpToPage(1);
                setState(() {});
              }),
              SizedBox(height: size.height * 0.01),
              cityRestaurantList.isEmpty
                  ? const CustomNoDataFound()
                  : CarouselSlider.builder(
                      itemCount: cityRestaurantList.length > 3
                          ? 3
                          : cityRestaurantList.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        final topRestaurants = cityRestaurantList[index];
                        return GestureDetector(
                          child: Container(
                            // color: Colors.orange.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // margin: EdgeInsets.only(right: 10),
                                  height: size.height * 0.18,
                                  width: double.infinity,
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

                                SizedBox(
                                    height: size.height *
                                        0.01), // Add spacing if needed
                                customText.kText(
                                  "${topRestaurants["business_name"]}",
                                  14,
                                  FontWeight.w700,
                                  ColorConstants.kPrimary,
                                  TextAlign.start,
                                ),
                                customText.kText(
                                  "${topRestaurants["distance"].toString().substring(0, 5)} Mls",
                                  12,
                                  FontWeight.w400,
                                  Colors.black,
                                  TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            sideDrawerController.previousIndex
                                .add(sideDrawerController.index.value);
                            sideDrawerController.restaurantId =
                                topRestaurants["id"].toString();
                            sideDrawerController.detailRestaurantName =
                                topRestaurants["business_name"].toString();
                            sideDrawerController.restaurantlatitude =
                                topRestaurants["latitude"];
                            sideDrawerController.restaurantlongitude =
                                topRestaurants["longitude"];
                            sideDrawerController.restaurantAddress =
                                topRestaurants["business_address"];
                            sideDrawerController.restaurantImage =
                                topRestaurants['business_image'];

                            sideDrawerController.index.value = 16;
                            sideDrawerController.pageController
                                .jumpToPage(sideDrawerController.index.value);
                            log("top restaurant details :- ${topRestaurants}");
                          },
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
                        height: size.height * 0.3,
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
                // sideDrawerController.previousIndex =
                //     sideDrawerController.index.value;
                sideDrawerController.previousIndex
                    .add(sideDrawerController.index.value);
                sideDrawerController.index.value = 3;
                sideDrawerController.pageController
                    .jumpToPage(sideDrawerController.index.value);
              }),
              SizedBox(height: size.height * 0.01),
              specialFoodList.isEmpty
                  ? const CustomNoDataFound()
                  : CarouselSlider.builder(
                      itemCount: specialFoodList.length > 3
                          ? 3
                          : specialFoodList.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        final specialFood = specialFoodList[index];
                        return GestureDetector(
                          child: Container(
                            // color: Colors.purple.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // margin: EdgeInsets.only(right: 10),
                                  height: size.height * 0.18,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(
                                        size.width * 0.02),
                                    image: DecorationImage(
                                      image: specialFood["image"] == "null"
                                          ? const AssetImage(
                                              "assets/images/no_image.jpeg")
                                          : NetworkImage(specialFood["image"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height: size.height *
                                        0.01), // Add spacing if needed
                                customText.kText(
                                  "${specialFood["name"]}",
                                  14,
                                  FontWeight.w700,
                                  ColorConstants.kPrimary,
                                  TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            sideDrawerController.specificCatTitle =
                                sideDrawerController.foodCategoryTitle;
                            sideDrawerController.specialFoodName =
                                specialFood['name'];
                            sideDrawerController.specialFoodImage =
                                specialFood['image'];
                            sideDrawerController.specialFoodPrice =
                                specialFood['price'];
                            sideDrawerController.specialFoodResId =
                                specialFood['user_id'].toString();
                            sideDrawerController.specialFoodProdId =
                                specialFood['id'].toString();
                            // sideDrawerController.specialFoodProdId = allSpecialFoodList[index]['id'].toString();
                            sideDrawerController.previousIndex
                                .add(sideDrawerController.index.value);
                            sideDrawerController.index.value = 34;
                            sideDrawerController.pageController
                                .jumpToPage(sideDrawerController.index.value);
                          },
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
                        height: size.height * 0.27,
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
        ),
      ),
    );
  }
}
