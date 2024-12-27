import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_footer.dart';
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
  List<dynamic> specialFoodList = [];
  Map<String, dynamic> homeInfoMap = {};
  String? contactEmail;
  String? contactPhone;
  String? contactAddress;

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  int indexValue = 0;
  int currentIndex = 0;

  String networkImgUrl =
      "https://img.taste.com.au/A7GcvNbQ/taste/2016/11/spiced-potatoes-and-chickpeas-107848-1.jpeg";
  String img1 =
      "https://imgmediagumlet.lbb.in/media/2024/12/676d402b9557945ed6a3a816_1735213099450.jpg";
  String img2 =
      "https://dr7f10k1l6bnm.cloudfront.net/wp-content/uploads/2024/01/ryu-rooftop-1-min-1600x900-1.webp";
  String img3 =
      "https://frequip.com/wp-content/uploads/2024/11/Best-Restaurants-In-Noida.jpg";

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
                    ? Container(
                        height: size.height * 0.25,
                        width: size.width,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8)),
                            height: 50,
                            width: size.width * .400,
                            child: Center(
                              child: customText.kText(
                                  "No data found",
                                  15,
                                  FontWeight.w700,
                                  Colors.black,
                                  TextAlign.center),
                            ),
                          ),
                        ),
                      )
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
                                        width: size.width * 0.3,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.03)),
                                        child: Center(
                                            child: GestureDetector(
                                          onTap: () {
                                            // place your navigation for table booking
                                            sideDrawerController.index.value =
                                                23;
                                            sideDrawerController.pageController
                                                .jumpToPage(sideDrawerController
                                                    .index.value);
                                          },
                                          child: Container(
                                            child: customText.kText(
                                                TextConstants.bookTable,
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
                  log("restaurant view all pressed");
                  sideDrawerController.index.value = 1;
                  log("side drawer controller index values :- ${sideDrawerController.index}");
                  sideDrawerController.pageController.jumpToPage(1);
                  setState(() {});
                }),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Row(
                    children: [
                      for (int i = 0;
                          i <
                              (getNearbyRestaurantList.length > 2
                                  ? 3
                                  : getNearbyRestaurantList.length);
                          i++)

                        // Your logic here

                        Container(
                          margin: EdgeInsets.only(right: size.width * .01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: size.height * 0.1,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.02),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      getNearbyRestaurantList[i]
                                          ["business_image"],
                                    ),
                                  ),
                                ),
                              ),
                              customText.kText(
                                  "${getNearbyRestaurantList[i]["name"]}",
                                  14,
                                  FontWeight.w700,
                                  ColorConstants.kPrimary,
                                  TextAlign.start),
                              customText.kText(
                                  "${getNearbyRestaurantList[i]["distance"].toString().substring(0, 5)} Mls",
                                  12,
                                  FontWeight.w400,
                                  Colors.black,
                                  TextAlign.start)
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // Food Category
                customHeading(TextConstants.foodCategory, () {
                  log("food category view all pressed");
                }),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: Column(
                    children: [
                      customText.kText(TextConstants.foodCategoryDes, 14,
                          FontWeight.w500, Colors.black, TextAlign.start),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          for (int i = 0;
                              i <
                                  (getFoodCategoryList.length > 2
                                      ? 3
                                      : getFoodCategoryList.length);
                              i++)
                            customFoodCategory(getFoodCategoryList[i]["image"],
                                getFoodCategoryList[i]["title"]),
                        ],
                      ),
                    ],
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
                  log("best deals view all pressed");
                }),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0;
                              i <
                                  (bestDealsList.length > 2
                                      ? 3
                                      : bestDealsList.length);
                              i++)
                            // customBestDeal(bestDealsList[i]["image"], () {}),
                            Container(
                              height: size.height * 0.15,
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.02),
                                  image: DecorationImage(
                                    image: bestDealsList[i]["image"] == "null"
                                        ? const AssetImage(
                                            "assets/images/no_image.jpeg")
                                        : NetworkImage(
                                            bestDealsList[i]["image"]),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                        ],
                      ),
                    ],
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

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customBestDeal(img1, () {}),
                          customBestDeal(img2, () {}),
                          customBestDeal(img3, () {}),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                // Special foods
                customHeading(TextConstants.specialFood, () {
                  log("special foods view all pressed");
                }),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.005),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0;
                              i <
                                  (specialFoodList.length > 2
                                      ? 3
                                      : specialFoodList.length);
                              i++)
                            specialFoodList[i]['image'] == "null"
                                ? Container(
                                    height: size.height * 0.15,
                                    width: size.width * 0.3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
                                            size.width * 0.02),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/no_image.jpeg"),
                                          fit: BoxFit.cover,
                                        )),
                                  )
                                : customBestDeal(
                                    specialFoodList[i]['image'], () {}),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                // Footer
                CustomFooter(
                  email: contactEmail,
                  phone: contactPhone,
                  address: contactAddress,
                ),
                // Container(
                //   height: size.height * 0.8,
                //   width: size.width,
                //   color: ColorConstants.kPrimary,
                //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                //   child: Column(
                //     children: [
                //
                //       Container(
                //         width: size.width * 0.8,
                //         margin: EdgeInsets.only(top: size.height * 0.01),
                //         child: Image.asset("assets/images/name_logo.png"),
                //       ),
                //
                //       const Divider(color: Colors.white),
                //
                //       SizedBox(height: size.height * 0.01),
                //
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //
                //               customText.kText(TextConstants.quickLinks, 16, FontWeight.w600, Colors.white, TextAlign.center),
                //
                //               customPagesTitle(TextConstants.home, () {}),
                //               customPagesTitle(TextConstants.aboutUs, () {}),
                //               customPagesTitle(TextConstants.specialFood, () {}),
                //               customPagesTitle(TextConstants.foodCategory, () {}),
                //               customPagesTitle(TextConstants.gallery, () {}),
                //               customPagesTitle(TextConstants.contactUs, () {}),
                //               customPagesTitle(TextConstants.termsConditions, () {}),
                //
                //             ],
                //           ),
                //
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //
                //               customText.kText(TextConstants.reachUs, 16, FontWeight.w600, Colors.white, TextAlign.center),
                //
                //               Padding(
                //                 padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                 child: const Icon(Icons.call, size: 20, color: Colors.white,),
                //               ),
                //
                //               GestureDetector(
                //                 onTap: () {},
                //                 child: Padding(
                //                   padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                   child: customText.kText("0123456789", 14, FontWeight.w400, Colors.white, TextAlign.start),
                //                 ),
                //               ),
                //
                //               Padding(
                //                 padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                 child: const Icon(Icons.email, size: 20, color: Colors.white,),
                //               ),
                //
                //               customPagesTitle("demo@gmail.com", () {}),
                //
                //               Padding(
                //                 padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                 child: const Icon(Icons.location_on, size: 20, color: Colors.white,),
                //               ),
                //
                //               GestureDetector(
                //                 onTap: () {},
                //                 child: Padding(
                //                   padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //                   child: SizedBox(
                //                     width: size.width * 0.4,
                //                     height: size.height * 0.12,
                //                     child: customText.kText("132 Dartmouth Street Boston, Massachusetts 02156 United States", 14, FontWeight.w400, Colors.white, TextAlign.start, TextOverflow.ellipsis, 4),
                //                   )
                //                 ),
                //               ),
                //
                //             ],
                //           ),
                //
                //         ],
                //       ),
                //
                //       SizedBox(height: size.height * 0.01),
                //
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //
                //               customText.kText(TextConstants.legal, 16, FontWeight.w600, Colors.white, TextAlign.center),
                //
                //               customPagesTitle(TextConstants.privacyPolicy, () {}),
                //               customPagesTitle(TextConstants.termsConditions, () {}),
                //               customPagesTitle(TextConstants.refundPolicy, () {}),
                //
                //
                //             ],
                //           ),
                //         ],
                //       )
                //
                //     ],
                //   ),
                // ),

                SizedBox(height: size.height * 0.01),
              ],
            ),
          )),
    );
  }
}
