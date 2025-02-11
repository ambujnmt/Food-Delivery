import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/screens/home/book_table.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

class RestaurantDetail extends StatefulWidget {
  const RestaurantDetail({super.key});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  final box = GetStorage();
  dynamic size;
  final customText = CustomText();
  final api = API();
  int tabSelected = 0;
  double distanceInMiles = 1.0;

  final List<String> items = [
    TextConstants.popularity,
    TextConstants.newNess,
    TextConstants.priceLowHigh,
    TextConstants.priceHighLow,
  ];
  bool isApiCalling = false;
  bool bannerApiCalling = false;
  bool productApiCalling = false;
  bool categoryApiCalling = false;
  bool overviewApiCalling = false;
  bool reviewApiCalling = false;

  List<String> itemName = [
    "Recommended(12)",
    "North Indian(18)",
    "West Indian(6)",
    "Fast Food(4)",
  ];
  List<dynamic> productsList = [];
  List<dynamic> categoryList = [];
  List<dynamic> categoryItemList = [];
  List<dynamic> reviewsList = [];
  List<dynamic> overviewList = [];
  List<dynamic> bannerList = [];
  List<dynamic> bestDealsList = [];
  Map<String, dynamic> daysData = {};
  // -------------//
  String? sundayOpen,
      sundayClose,
      mondayOpen,
      mondayClose,
      tuesdayOpen,
      tuesdayClose,
      webnesdayOpen,
      wednesdayClose,
      thursdayOpen,
      thursdayClose,
      fridayOpen,
      fridayClose,
      saturdayOpen,
      saturdayClose;
  //-------------//
  String? userLatitude;
  String? userLongitude;
  String? selectedValue;
  String searchValue = "";
  String networkImgUrl =
      "https://s3-alpha-sig.figma.com/img/2d0c/88be/5584e0af3dc9e87947fcb237a160d230?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N3MZ8MuVlPrlR8KTBVNhyEAX4fwc5fejCOUJwCEUpdBsy3cYwOOdTvBOBOcjpLdsE3WXcvCjY5tjvG8bofY3ivpKb5z~b3niF9jcICifVqw~jVvfx4x9WDa78afqPt0Jr4tm4t1J7CRF9BHcokNpg9dKNxuEBep~Odxmhc511KBkoNjApZHghatTA0LsaTexfSZXYvdykbhMuNUk5STsD5J4zS8mjCxVMRX7zuMXz85zYyfi7cAfX5Z6LVsoW0ngO7L6HKAcIgN4Rry9Lj2OFba445Mpd4Mx8t0fcsDPwQPbUDPHiBf3G~6HHcWjCBHKV0PiBZmt86HcvZntkFzWYg__";

  // String formatDateTime(DateTime dateTime,
  //     {String format = 'yyyy-MM-dd HH:mm:ss'}) {
  //   return DateFormat(format).format(dateTime);
  // }

  String formatDateTimeString(
    String dateTimeString, {
    String inputFormat = 'yyyy-MM-dd HH:mm:ss',
    String outputFormat = 'yyyy-MM-dd HH:mm:ss',
  }) {
    try {
      DateTime parsedDateTime = DateFormat(inputFormat).parse(dateTimeString);
      return DateFormat(outputFormat).format(parsedDateTime);
    } catch (e) {
      throw Exception('Invalid date format or input: $e');
    }
  }

  //detail products list for home page
  detailPageProducts({String orderby = ""}) async {
    setState(() {
      productApiCalling = true;
    });
    final response = await api.restaurantDetailProducts(
        restaurantId: sideDrawerController.restaurantId.toString(),
        orderBy: orderby);
    setState(() {
      productsList = response["data"];
    });
    setState(() {
      productApiCalling = false;
    });
    if (response["status"] == true) {
      print('detail products success message: ${response["message"]}');
    } else {
      print('detail products error message: ${response["message"]}');
    }
  }

  // detail categories of restaurant
  detailPageCategoryProducts() async {
    setState(() {
      categoryApiCalling = true;
    });
    final response = await api.restaurantDetailCategoryProducts(
      restaurantId: sideDrawerController.restaurantId.toString(),
    );
    setState(() {
      categoryList = response["data"];
    });
    setState(() {
      categoryApiCalling = false;
    });
    if (response["status"] == true) {
      for (int i = 0; i < categoryList.length; i++) {
        int productLength = categoryList[i]["products"].length;
        for (int j = 0; j < productLength; j++) {
          categoryItemList.add(categoryList[i]["products"][j]);
        }
      }
      print("category item list: ${categoryItemList}");
      print('category products success message: ${response["message"]}');
    } else {
      print('category products error message: ${response["message"]}');
    }
  }

  //restaurant reviews list for detail page
  detailPageReviews() async {
    setState(() {
      reviewApiCalling = true;
    });
    final response = await api.restaurantDetailReviews(
        restaurantId: sideDrawerController.restaurantId.toString());
    setState(() {
      reviewsList = response["data"];
    });
    setState(() {
      reviewApiCalling = false;
    });
    if (response["status"] == true) {
      print('reviews success message: ${response["message"]}');
    } else {
      print('reviews error message: ${response["message"]}');
    }
  }

  //restaurant overview
  detailPageResOverview() async {
    setState(() {
      overviewApiCalling = true;
    });
    final response = await api.restaurantDetailOverview(
        restaurantId: sideDrawerController.restaurantId.toString());
    setState(() {
      overviewList = response["data"]['overview'];
      daysData = response['data'];
      sundayOpen = daysData['sunday_open'];
      sundayClose = daysData['sunday_close'];
      mondayOpen = daysData['day_monday_open'];
      mondayClose = daysData['mondayclose'];
      tuesdayOpen = daysData['day_tuesday_open'];
      tuesdayClose = daysData['tuesdayclose'];
      webnesdayOpen = daysData['day_wednesday_open'];
      wednesdayClose = daysData['wednesday_clos'];
      thursdayOpen = daysData['thursday_open_day'];
      thursdayClose = daysData['thursdayclose'];
      fridayOpen = daysData['day_friday_open'];
      fridayClose = daysData['friday_close'];
      saturdayOpen = daysData['day_saturday_open'];
      saturdayClose = daysData['saturday_close'];
    });
    setState(() {
      overviewApiCalling = false;
    });
    if (response["status"] == true) {
      print('overivew success message: ${response["message"]}');
    } else {
      print('overview error message: ${response["message"]}');
    }
  }

  //restaurant banner
  detailPageResBanner() async {
    setState(() {
      bannerApiCalling = true;
    });
    final response = await api.restaurantDetailBanner(
        restaurantId: sideDrawerController.restaurantId.toString());
    setState(() {
      bannerList = response["data"];
    });
    setState(() {
      bannerApiCalling = false;
    });
    if (response["status"] == true) {
      print('banner success message: ${response["message"]}');
    } else {
      print('banner error message: ${response["message"]}');
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

  // Get Current Location
  Future<void> calculateDistance() async {
    double? distanceInMeters;
    userLatitude = box.read("latOfUser");
    userLongitude = box.read("longOfUser");
    print("lat of user : $userLatitude --- long of user: $userLongitude");
    print(
        "lat of res : ${sideDrawerController.restaurantlatitude} --- long of res: ${sideDrawerController.restaurantlongitude}");
    try {
      // Calculate distance
      double distance = Geolocator.distanceBetween(
        double.parse(userLatitude.toString()),
        double.parse(userLongitude.toString()),
        double.parse(sideDrawerController.restaurantlatitude),
        double.parse(sideDrawerController.restaurantlongitude),
      );

      setState(() {
        distanceInMeters = distance;
        distanceInMiles = distanceInMeters! / 1609.34;
      });

      print("Distance: ${distance.toStringAsFixed(2)} meters");
      print("Distance in miles: ${distanceInMiles.toStringAsFixed(2)} miles");
    } catch (e) {
      setState(() {
        // _currentAddress = 'Error retrieving location: $e';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("page value: ${sideDrawerController.index.value}");
    calculateDistance();
    detailPageProducts();
    detailPageCategoryProducts(); //3
    detailPageReviews();
    detailPageResOverview();
    detailPageResBanner(); //2
    bestDealsData(); //1
    print("access token: ${loginController.accessToken}");

    print(
        "res id and name: ${sideDrawerController.restaurantId}  ${sideDrawerController.detailRestaurantName}");
    if (loginController.accessToken.isNotEmpty) {
      addRecent();
    }
    super.initState();
  }

  addRecent() async {
    final response = await api.addToRecent(
      type: "restaurant",
      id: sideDrawerController.restaurantId,
    );
    if (response['success'] == true) {
      print("Added to the recent viewed");
    } else {
      print("Error in adding to the recent viewed");
    }
  }

  getProductAccCategory(Map<String, dynamic> data) {
    categoryItemList.clear();
    for (int i = 0; i < data["products"].length; i++) {
      categoryItemList.add(data["products"][i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: size.height * .060,
                    width: double.infinity,
                    child: bestDealsList.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.kPrimary,
                            ),
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
                  Container(
                    // height: size.height * 0.18,
                    height: size.height * 0.22,
                    width: size.width,
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
                                  "${sideDrawerController.detailRestaurantName}",
                                  20, //28
                                  FontWeight.w900,
                                  Colors.white,
                                  TextAlign.center),
                              customText.kText(
                                  "Distance - ${distanceInMiles.toStringAsFixed(2)} Mls",
                                  20, //28
                                  FontWeight.w900,
                                  Colors.white,
                                  TextAlign.center),
                              customText.kText(
                                  "Address - ${sideDrawerController.restaurantAddress}",
                                  20, //28
                                  FontWeight.w900,
                                  Colors.white,
                                  TextAlign.center,
                                  TextOverflow.ellipsis,
                                  2),
                              RichText(
                                text: TextSpan(
                                    text: TextConstants.home,
                                    style: customText.kSatisfyTextStyle(
                                        24, FontWeight.w400, Colors.white),
                                    children: [
                                      TextSpan(
                                          text:
                                              " / ${TextConstants.restaurant}",
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
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: bannerApiCalling
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary),
                    )
                  : bannerList.isEmpty
                      ? CustomNoDataFound()
                      : Container(
                          // color: Colors.yellow.shade300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: size.height * 0.15,
                                width: size.width * 0.45,
                                margin: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    left: size.width * 0.02,
                                    bottom: size.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.02),
                                  image: DecorationImage(
                                    image: bannerList[0]['image_url'] == null
                                        ? const AssetImage(
                                            'assets/images/no_image.png')
                                        : NetworkImage(
                                            bannerList[0]['image_url'],
                                          ),
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: size.width * 0.45,
                                margin: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    right: size.width * 0.02,
                                    bottom: size.height * 0.01),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 4.0,
                                          childAspectRatio: 1 / 0.73),
                                  itemCount: bannerList.length > 4
                                      ? 4
                                      : bannerList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(
                                            size.width * 0.02),
                                        image: DecorationImage(
                                          image: bannerList[index]
                                                      ['image_url'] ==
                                                  null
                                              ? const AssetImage(
                                                  'assets/images/no_image.png')
                                              : NetworkImage(
                                                  bannerList[index]
                                                      ['image_url'],
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
            ),
            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  height: size.height * 0.05,
                  width: size.width,
                  // color: Colors.lightGreen,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.01),
                              decoration: BoxDecoration(
                                  color: tabSelected == 0
                                      ? ColorConstants.kPrimary
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.02)),
                              child: Center(
                                child: customText.kText(
                                    TextConstants.orderOnline,
                                    16,
                                    FontWeight.w700,
                                    tabSelected == 0
                                        ? Colors.white
                                        : Colors.black,
                                    TextAlign.center),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                tabSelected = 0;
                              });
                            },
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.01),
                              decoration: BoxDecoration(
                                  color: tabSelected == 1
                                      ? ColorConstants.kPrimary
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.02)),
                              child: Center(
                                child: customText.kText(
                                    TextConstants.overview,
                                    16,
                                    FontWeight.w700,
                                    tabSelected == 1
                                        ? Colors.white
                                        : Colors.black,
                                    TextAlign.center),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                tabSelected = 1;
                              });
                            },
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.01),
                              decoration: BoxDecoration(
                                  color: tabSelected == 2
                                      ? ColorConstants.kPrimary
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.02)),
                              child: Center(
                                child: customText.kText(
                                    TextConstants.reviews,
                                    16,
                                    FontWeight.w700,
                                    tabSelected == 2
                                        ? Colors.white
                                        : Colors.black,
                                    TextAlign.center),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                tabSelected = 2;
                              });
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.01),
                              decoration: BoxDecoration(
                                  color: tabSelected == 3
                                      ? ColorConstants.kPrimary
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.02)),
                              child: Center(
                                child: customText.kText(
                                    TextConstants.bookATable,
                                    16,
                                    FontWeight.w700,
                                    tabSelected == 3
                                        ? Colors.white
                                        : Colors.black,
                                    TextAlign.center),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                tabSelected = 3;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Divider(
                  color: ColorConstants.kPrimary,
                  thickness: 2,
                  height: 0,
                ),

                // Container(
                //   height: size.height * 0.05,
                //   width: size.width,
                //   margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //
                //       Container(
                //         height: size.height * 0.05,
                //         width: size.width * 0.65,
                //         decoration: BoxDecoration(
                //           color: ColorConstants.kSortButton,
                //           borderRadius: BorderRadius.circular(size.width * 0.02),
                //           boxShadow: const [
                //             BoxShadow(
                //               offset: Offset(0,1),
                //               blurRadius: 4,
                //               color: Colors.black26
                //             )
                //           ]
                //         ),
                //         child: DropdownButtonHideUnderline(
                //           child: DropdownButton2<String>(
                //             isExpanded: true,
                //             hint: Text(
                //               TextConstants.sortBy,
                //               style: customText.kTextStyle(16, FontWeight.w500, Colors.black)
                //             ),
                //             items: items
                //                 .map((String item) => DropdownMenuItem<String>(
                //               value: item,
                //               child: Text(
                //                 item,
                //                 style: const TextStyle(
                //                   fontSize: 14,
                //                 ),
                //               ),
                //             ))
                //                 .toList(),
                //             value: selectedValue,
                //             onChanged: (String? value) {
                //               setState(() {
                //                 selectedValue = value;
                //               });
                //             },
                //             buttonStyleData: const ButtonStyleData(
                //               padding: EdgeInsets.symmetric(horizontal: 16),
                //               height: 40,
                //               width: 140,
                //             ),
                //             menuItemStyleData: const MenuItemStyleData(
                //               height: 40,
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //       SizedBox(
                //         width: size.width * 0.28,
                //         child: CustomButton(
                //           fontSize: 16,
                //           hintText: TextConstants.applyNow),
                //       ),
                //
                //     ],
                //   ),
                // )
              ],
            )),
            if (tabSelected == 0)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // sort by
                    Container(
                      height: size.height * 0.05,
                      width: size.width,
                      margin:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.width * 0.65,
                            decoration: BoxDecoration(
                                color: ColorConstants.kSortButton,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02),
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                      color: Colors.black26)
                                ]),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(TextConstants.sortBy,
                                    style: customText.kTextStyle(
                                        16, FontWeight.w500, Colors.black)),
                                items: items
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value;
                                    if (selectedValue == items[0]) {
                                      searchValue = "popularity";
                                    } else if (selectedValue == items[1]) {
                                      searchValue = "latest";
                                    } else if (selectedValue == items[2]) {
                                      searchValue = "price-low";
                                    } else {
                                      searchValue = "price-high";
                                    }
                                  });
                                  print("search value: $searchValue");
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 40,
                                  width: 140,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.28,
                            child: CustomButton(
                                loader: productApiCalling,
                                onTap: () {
                                  // apply filter
                                  detailPageProducts(
                                      orderby: searchValue.toString());
                                },
                                fontSize: 16,
                                hintText: TextConstants.applyNow),
                          ),
                        ],
                      ),
                    ),

                    // title
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.01),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: customText.kText(TextConstants.topPicks, 20,
                            FontWeight.w700, Colors.black, TextAlign.center),
                      ),
                    ),

                    // best selling
                    SizedBox(
                      height: size.height * 0.25,
                      child: productApiCalling
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorConstants.kPrimary,
                              ),
                            )
                          : productsList.isEmpty
                              ? CustomNoDataFound()
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productsList.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: size.height * 0.25,
                                          width: size.width * 0.75,
                                          margin: EdgeInsets.only(
                                              left: size.width * 0.02),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      productsList[index]
                                                          ['image']),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.05)),
                                        ),
                                        Container(
                                          height: size.height * 0.25,
                                          width: size.width * 0.75,
                                          margin: EdgeInsets.only(
                                              left: size.width * 0.02),
                                          decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.05)),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.25,
                                          width: size.width * 0.75,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: size.height * 0.15,
                                                width: size.width * 0.4,
                                                margin: EdgeInsets.only(
                                                    left: size.width * 0.02),
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        size.height * 0.01),
                                                decoration: BoxDecoration(
                                                    // color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    size.width *
                                                                        0.05))),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    size.width *
                                                                        0.03),
                                                        child: customText
                                                            .kSatisfyText(
                                                                TextConstants
                                                                    .bestSelling,
                                                                18,
                                                                FontWeight.w900,
                                                                Colors.white,
                                                                TextAlign
                                                                    .center)),
                                                    const Divider(
                                                      color: ColorConstants
                                                          .kPrimary,
                                                      thickness: 2,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    size.width *
                                                                        0.03),
                                                        child: customText.kText(
                                                            "${productsList[index]['name']}",
                                                            22,
                                                            FontWeight.w700,
                                                            Colors.white,
                                                            TextAlign.start)),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.01),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  size.width *
                                                                      0.04),
                                                      child: customText.kText(
                                                          "\$${productsList[index]['price']}",
                                                          22,
                                                          FontWeight.w700,
                                                          Colors.white,
                                                          TextAlign.center),
                                                    ),
                                                    Container(
                                                      // color: Colors.green,
                                                      height:
                                                          size.height * .050,
                                                      width: size.width * .2,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // add to cart
                                                          if (loginController
                                                              .accessToken
                                                              .isNotEmpty) {
                                                            bottomSheet(
                                                                productsList[
                                                                        index]
                                                                    ['image'],
                                                                productsList[
                                                                        index]
                                                                    ['name'],
                                                                productsList[
                                                                        index]
                                                                    ['price'],
                                                                productsList[
                                                                            index]
                                                                        ['id']
                                                                    .toString());
                                                          } else {
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            LoginScreen()));
                                                          }
                                                        },
                                                        child: Container(
                                                            width: size.width *
                                                                .15,
                                                            height:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    ColorConstants
                                                                        .kPrimary,
                                                                borderRadius: BorderRadius
                                                                    .circular(size
                                                                            .width *
                                                                        0.02)),
                                                            child: Center(
                                                              child: customText
                                                                  .kText(
                                                                TextConstants
                                                                    .add,
                                                                18,
                                                                FontWeight.w900,
                                                                Colors.white,
                                                                TextAlign
                                                                    .center,
                                                              ),
                                                            )),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.01)
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                    ),
                  ],
                ),
              ),
            if (tabSelected == 1)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.01),
                  child: overviewApiCalling
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.kPrimary,
                          ),
                        )
                      : overviewList.isEmpty
                          ? CustomNoDataFound()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: size.height * .2,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: overviewList[0]['image_url'] ==
                                                null
                                            ? const AssetImage(
                                                'assets/images/no_image.png')
                                            : NetworkImage(
                                                overviewList[0]['image_url'],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * .005),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: customText.kText(
                                      "${overviewList[0]['title']}",
                                      20,
                                      FontWeight.w900,
                                      ColorConstants.kPrimary,
                                      TextAlign.center),
                                ),
                                SizedBox(
                                  width: size.width,
                                  child: customText.kText(
                                      "${overviewList[0]['description']}",
                                      16,
                                      FontWeight.w700,
                                      Colors.black,
                                      TextAlign.start,
                                      TextOverflow.visible,
                                      150),
                                ),
                                SizedBox(height: size.height * .010),
                                SizedBox(
                                  width: size.width,
                                  child: customText.kText(
                                      TextConstants.openingAndClosingTimming,
                                      22,
                                      FontWeight.w900,
                                      Colors.black,
                                      TextAlign.start,
                                      TextOverflow.visible,
                                      150),
                                ),
                                SizedBox(height: size.height * .010),
                                Container(
                                  height: size.height * .040,
                                  width: size.width * .2,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: customText.kText(
                                        TextConstants.sunday,
                                        18,
                                        FontWeight.w700,
                                        Colors.white,
                                        TextAlign.start,
                                        TextOverflow.visible,
                                        150),
                                  ),
                                ),
                                SizedBox(height: size.height * .005),
                                Container(
                                  width: size.width * .5,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText.kText(
                                        "${TextConstants.open}: ${sundayOpen}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                      const SizedBox(width: 10),
                                      customText.kText(
                                        "${TextConstants.close}: ${sundayClose}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * .010),
                                Container(
                                  height: size.height * .040,
                                  width: size.width * .2,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: customText.kText(
                                        TextConstants.monday,
                                        18,
                                        FontWeight.w700,
                                        Colors.white,
                                        TextAlign.start,
                                        TextOverflow.visible,
                                        150),
                                  ),
                                ),
                                SizedBox(height: size.height * .005),
                                Container(
                                  width: size.width * .5,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText.kText(
                                        "${TextConstants.open}: ${mondayOpen}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                      const SizedBox(width: 10),
                                      customText.kText(
                                        "${TextConstants.close}: ${mondayClose}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * .010),
                                Container(
                                  height: size.height * .040,
                                  width: size.width * .22,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: customText.kText(
                                        TextConstants.tuesday,
                                        18,
                                        FontWeight.w700,
                                        Colors.white,
                                        TextAlign.start,
                                        TextOverflow.visible,
                                        150),
                                  ),
                                ),
                                SizedBox(height: size.height * .005),
                                Container(
                                  width: size.width * .5,
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText.kText(
                                        "${TextConstants.open}: ${tuesdayOpen}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                      const SizedBox(width: 10),
                                      customText.kText(
                                        "${TextConstants.close}: ${tuesdayClose}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * .010),
                                Container(
                                  height: size.height * .040,
                                  width: size.width * .3,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: customText.kText(
                                        TextConstants.wednesday,
                                        18,
                                        FontWeight.w700,
                                        Colors.white,
                                        TextAlign.start,
                                        TextOverflow.visible,
                                        150),
                                  ),
                                ),
                                SizedBox(height: size.height * .005),
                                Container(
                                  width: size.width * .5,
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText.kText(
                                        "${TextConstants.open}: ${webnesdayOpen}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                      const SizedBox(width: 10),
                                      customText.kText(
                                        "${TextConstants.close}: ${wednesdayClose}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * .010),
                                Container(
                                  height: size.height * .040,
                                  width: size.width * .24,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: customText.kText(
                                        TextConstants.thursday,
                                        18,
                                        FontWeight.w700,
                                        Colors.white,
                                        TextAlign.start,
                                        TextOverflow.visible,
                                        150),
                                  ),
                                ),
                                SizedBox(height: size.height * .005),
                                Container(
                                  width: size.width * .5,
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText.kText(
                                        "${TextConstants.open}: ${thursdayOpen}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                      const SizedBox(width: 10),
                                      customText.kText(
                                        "${TextConstants.close}: ${thursdayClose}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * .010),
                                Container(
                                  height: size.height * .040,
                                  width: size.width * .2,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: customText.kText(
                                        TextConstants.friday,
                                        18,
                                        FontWeight.w700,
                                        Colors.white,
                                        TextAlign.start,
                                        TextOverflow.visible,
                                        150),
                                  ),
                                ),
                                SizedBox(height: size.height * .005),
                                Container(
                                  width: size.width * .5,
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText.kText(
                                        "${TextConstants.open}: ${fridayOpen}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                      const SizedBox(width: 10),
                                      customText.kText(
                                        "${TextConstants.close}: ${fridayClose}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * .010),
                                Container(
                                  height: size.height * .040,
                                  width: size.width * .22,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: customText.kText(
                                        TextConstants.saturday,
                                        18,
                                        FontWeight.w700,
                                        Colors.white,
                                        TextAlign.start,
                                        TextOverflow.visible,
                                        150),
                                  ),
                                ),
                                SizedBox(height: size.height * .005),
                                Container(
                                  width: size.width * .5,
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText.kText(
                                        "${TextConstants.open}: ${saturdayOpen}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                      const SizedBox(width: 10),
                                      customText.kText(
                                        "${TextConstants.close}: ${saturdayClose}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.05,
                                )
                              ],
                            ),
                ),
              ),
            if (tabSelected == 0)
              SliverList(
                // itemExtent: 70.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // print("silver child index :$index");
                    getProductAccCategory(categoryList[index]);
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Container(
                        child: customText.kText(
                          "${categoryList[index]['title'] ?? ""} (${categoryList[index]['products_count'] ?? ""})",
                          16,
                          FontWeight.bold,
                          Colors.black,
                          TextAlign.start,
                        ),
                      ),
                      children: [
                        categoryApiCalling
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.kPrimary,
                                ),
                              )
                            : categoryList.isEmpty
                                ? CustomNoDataFound()
                                : Padding(
                                    // color: Colors.red,
                                    // height: 150,
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      // physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        for (int i = 0;
                                            i < categoryItemList.length;
                                            i++)
                                          Container(
                                            height: size.height * .200,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: size.width * .5,
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: customText.kText(
                                                            categoryItemList[i]
                                                                ["name"],
                                                            16,
                                                            FontWeight.w700,
                                                            Colors.black,
                                                            TextAlign.start,
                                                            TextOverflow
                                                                .ellipsis,
                                                            1),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: customText.kText(
                                                          "-\$${categoryItemList[i]['price']}",
                                                          14,
                                                          FontWeight.w500,
                                                          Colors.black,
                                                          TextAlign.center,
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   width: size.width * .5,
                                                      //   margin:
                                                      //       EdgeInsets.only(bottom: 10),
                                                      //   child: customText.kText(
                                                      //     "Lorem Ipsum is simply dummy text of the printing and type setting industry. Lorem Ipsum is simply dummy text of the printing and type setting industry....................... more",
                                                      //     14,
                                                      //     FontWeight.w500,
                                                      //     Colors.black,
                                                      //     TextAlign.start,
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20,
                                                              bottom: 10),
                                                      height: size.height * .12,
                                                      width: size.width * .3,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade200,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              '${categoryItemList[i]['image']}'),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        bottom: 0,
                                                        left: 20,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (loginController
                                                                .accessToken
                                                                .isNotEmpty) {
                                                              bottomSheet(
                                                                  categoryItemList[
                                                                          i]
                                                                      ['image'],
                                                                  categoryItemList[
                                                                          i]
                                                                      ['name'],
                                                                  categoryItemList[
                                                                          i]
                                                                      ['price'],
                                                                  categoryItemList[
                                                                              i]
                                                                          ['id']
                                                                      .toString());
                                                            } else {
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              LoginScreen()));
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            width:
                                                                size.width * .2,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    ColorConstants
                                                                        .kPrimary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: const Center(
                                                                child: Text(
                                                              "Add",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontFamily:
                                                                      "Raleway",
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                      ],
                    );
                  },
                  childCount: categoryList.length,
                ),
              ),
            if (tabSelected == 2)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    width: size.width,
                    margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.01),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size.width * 0.02),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 4,
                              color: Colors.black26)
                        ]),
                    child: reviewApiCalling
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.kPrimary,
                            ),
                          )
                        : reviewsList.isEmpty
                            ? Container(
                                height: 100,
                                child: CustomNoDataFound(),
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: size.height * 0.13,
                                        width: size.width * 0.3,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                            margin: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              image: DecorationImage(
                                                image: reviewsList[index]
                                                            ['avatar'] ==
                                                        null
                                                    ? const AssetImage(
                                                        'assets/images/profile_image.jpg')
                                                    : NetworkImage(
                                                        reviewsList[index]
                                                            ['avatar']),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: BoxShape.circle,
                                            )),
                                      ),
                                      Container(
                                        height: size.height * 0.13,
                                        width: size.width * 0.6,
                                        decoration: BoxDecoration(
                                          // color: Colors.lightGreen.shade100,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  size.width * 0.02),
                                              bottomRight: Radius.circular(
                                                  size.width * 0.02)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText.kText(
                                                "${reviewsList[index]['name']}",
                                                22,
                                                FontWeight.w900,
                                                ColorConstants.kPrimary,
                                                TextAlign.start),
                                            customText.kText(
                                                "${formatDateTimeString(reviewsList[index]['created_at'], inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd/MM/yyyy HH:mm a")}",
                                                18,
                                                FontWeight.w700,
                                                Colors.black,
                                                TextAlign.start),
                                            SizedBox(
                                              width: size.width * 0.55,
                                              child: RatingBar.builder(
                                                ignoreGestures: true,
                                                initialRating: double.parse(
                                                    reviewsList[index]
                                                        ['rating']),
                                                minRating: double.parse(
                                                    reviewsList[index]
                                                        ['rating']),
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
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: size.width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.02,
                                        vertical: size.height * 0.01),
                                    child: customText.kText(
                                        "${reviewsList[index]['review']}",
                                        16,
                                        FontWeight.w700,
                                        Colors.black,
                                        TextAlign.start,
                                        TextOverflow.visible,
                                        150),
                                  ),
                                ],
                              ),
                  );
                }, childCount: reviewsList.length),
              ),
            if (tabSelected == 3)
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) => Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: size.height * .4,
                  width: double.infinity,
                  child: BookTable(),
                ),
              ))
          ],
        ),
      ),
    );
  }

  void bottomSheet(String image, String name, String price, String productId) {
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
                  restaurantId: sideDrawerController.restaurantId,
                  productId: productId.toString());

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
              height: size.height * .25,
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
                        height: size.height * .050,
                        width: size.width * .1,
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
                  SizedBox(height: size.height * .010),
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
                            height: size.height * .01,
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
                        height: size.height * .050,
                        width: size.width * .3,
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
                  SizedBox(height: size.height * .020),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        addToCart();
                      },
                      child: Container(
                        width: size.width * .2,
                        height: size.height * .050,
                        decoration: BoxDecoration(
                          color: ColorConstants.kPrimary,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
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
