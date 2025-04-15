import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/controllers/deal_controller.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:food_delivery/utils/validation_rules.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'dart:developer';

class RestaurantDetail extends StatefulWidget {
  const RestaurantDetail({super.key});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  DealsController dealsController = Get.put(DealsController());
  final box = GetStorage();
  dynamic size;
  final _formKey = GlobalKey<FormState>();
  final customText = CustomText();
  final api = API(), helper = Helper();
  int tabSelected = 0;
  double distanceInMiles = 1.0;
  TimeOfDay selectedTime = TimeOfDay.now();
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
  List<dynamic> restaurantDeals = [];
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

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberOfPeopleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
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

  // best deals by restaurant
  bestDealsRestaurant() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.ourDealsRestaurant(
        restaurantId: sideDrawerController.restaurantId);
    setState(() {
      restaurantDeals = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' restaurant deals message: ${response["message"]}');
    } else {
      print('restaurant deals message: ${response["message"]}');
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

  datePicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        dateController.text =
            formattedDate; //set output date to TextField value.
        print("date controller: ${dateController.text}");
      });
    } else {}
  }

  timePicker() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
        timeController.text =
            _formatTime24Hour(selectedTime); // Update TextField
        print("time controller: ${timeController.text}");
      });
    }
  }

  String _formatTime24Hour(TimeOfDay time) {
    final hour =
        time.hour.toString().padLeft(2, '0'); // Ensures 2 digits for the hour
    final minute = time.minute
        .toString()
        .padLeft(2, '0'); // Ensures 2 digits for the minute
    return "$hour:$minute"; // Example: "14:30"
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
    bestDealsRestaurant();
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    numberOfPeopleController.clear();
    dateController.clear();
    timeController.clear();
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

  bookTable() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.bookATable(
      restaurantName: sideDrawerController.restaurantId,
      fullName: nameController.text,
      phoneNumber: phoneController.text,
      emailAdress: emailController.text,
      numberOfPeople: numberOfPeopleController.text,
      date: dateController.text,
      time: timeController.text,
    );

    setState(() {
      isApiCalling = false;
    });

    if (response["success"] == true) {
      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
      sideDrawerController.index.value = 0;
      sideDrawerController.pageController
          .jumpToPage(sideDrawerController.index.value);
    } else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
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
                              // pauseAfterRound: const Duration(seconds: 1),
                            ),
                          ),
                  ),
                  Container(
                    // height: size.height * 0.18,
                    height: size.height * 0.22,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        image: DecorationImage(
                            image: sideDrawerController.restaurantImage.isEmpty
                                ? const AssetImage("assets/images/banner.png")
                                : NetworkImage(
                                    sideDrawerController.restaurantImage),
                            fit: BoxFit.fill)),
                  ),
                  // content below the image
                  SizedBox(height: size.height * .010),
                  Container(
                    height: size.height * .16,
                    width: size.width * .6,
                    child: Column(
                      children: [
                        customText.kText(
                            "${sideDrawerController.detailRestaurantName}",
                            17, //28
                            FontWeight.w900,
                            ColorConstants.kPrimary,
                            TextAlign.center),
                        customText.kText(
                            "${distanceInMiles.toStringAsFixed(2)} Mls",
                            17, //28
                            FontWeight.w900,
                            ColorConstants.kPrimary,
                            TextAlign.center),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: customText.kText(
                              "${sideDrawerController.restaurantAddress}",
                              17, //28
                              FontWeight.w900,
                              ColorConstants.kPrimary,
                              TextAlign.center,
                              TextOverflow.ellipsis,
                              2),
                        ),
                        RichText(
                          text: TextSpan(
                              text: TextConstants.home,
                              style: customText.kSatisfyTextStyle(
                                  24, FontWeight.w400, Colors.black),
                              children: [
                                TextSpan(
                                    text: " / ${TextConstants.restaurant}",
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
                  // color: Colors.red,
                  height: size.height * 0.05,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: size.width * 0.02),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02),
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
                        const SizedBox(width: 10),
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
                        const SizedBox(width: 10),
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
                        const SizedBox(width: 10),
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
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: ColorConstants.kPrimary,
                  thickness: 2,
                  height: 0,
                ),
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

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.01),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: customText.kText(TextConstants.todaysDeals, 20,
                            FontWeight.w700, Colors.black, TextAlign.center),
                      ),
                    ),

                    Container(
                        height: size.height * 0.27,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        width: double.infinity,
                        child: restaurantDeals.isEmpty
                            ? CustomNoDataFound()
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: restaurantDeals.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        GestureDetector(
                                  onTap: () {
                                    print("Deals product");
                                    sideDrawerController.detailTitleForDetail =
                                        restaurantDeals[index]['title']
                                            .toString();
                                    sideDrawerController.dealsIdForProduct =
                                        restaurantDeals[index]['id'].toString();
                                    sideDrawerController.resIdForProd =
                                        sideDrawerController.restaurantId
                                            .toString();
                                    sideDrawerController.previousIndex
                                        .add(sideDrawerController.index.value);
                                    sideDrawerController.index.value = 40;
                                    sideDrawerController.pageController
                                        .jumpToPage(
                                            sideDrawerController.index.value);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        height: size.height * 0.2,
                                        width: size.width * 0.75,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    '${restaurantDeals[index]['image']}'))),
                                      ),
                                      SizedBox(height: size.height * .020),
                                      Container(
                                          width: size.width * 0.75,
                                          child: Center(
                                            child: customText.kText(
                                                "${restaurantDeals[index]['title']}",
                                                20,
                                                FontWeight.w800,
                                                Colors.black,
                                                TextAlign.center,
                                                TextOverflow.ellipsis,
                                                1),
                                          ))
                                    ],
                                  ),
                                ),
                              )),
                    SizedBox(height: size.height * .020),
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
                    Container(
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
                                        GestureDetector(
                                          onTap: () {
                                            print("Hello product");
                                            sideDrawerController
                                                    .restaurantProductId =
                                                productsList[index]['id']
                                                    .toString();
                                            sideDrawerController.previousIndex
                                                .add(sideDrawerController
                                                    .index.value);
                                            sideDrawerController.index.value =
                                                39;
                                            sideDrawerController.pageController
                                                .jumpToPage(sideDrawerController
                                                    .index.value);
                                          },
                                          child: Container(
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
                                                              topLeft: Radius
                                                                  .circular(size
                                                                          .width *
                                                                      0.05))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                  FontWeight
                                                                      .w900,
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
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                                                          onTap: () async {
                                                            // add to cart
                                                            if (loginController
                                                                .accessToken
                                                                .isNotEmpty) {
                                                              if (sideDrawerController
                                                                      .cartListRestaurant
                                                                      .isEmpty ||
                                                                  sideDrawerController
                                                                          .cartListRestaurant ==
                                                                      sideDrawerController
                                                                          .restaurantId) {
                                                                await box.write(
                                                                    "cartListRestaurant",
                                                                    sideDrawerController
                                                                        .restaurantId);
                                                                setState(() {
                                                                  sideDrawerController
                                                                          .cartListRestaurant =
                                                                      sideDrawerController
                                                                          .restaurantId;
                                                                });

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
                                                                      .toString(),
                                                                );
                                                              } else {
                                                                helper.errorDialog(
                                                                    context,
                                                                    "Your cart is already have food from different restaurant");
                                                              }
                                                            } else {
                                                              Navigator
                                                                  .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          LoginScreen(),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                              width:
                                                                  size.width *
                                                                      .15,
                                                              height: double
                                                                  .infinity,
                                                              decoration: BoxDecoration(
                                                                  color: ColorConstants
                                                                      .kPrimary,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          size.width *
                                                                              0.02)),
                                                              child: Center(
                                                                child:
                                                                    customText
                                                                        .kText(
                                                                  TextConstants
                                                                      .add,
                                                                  18,
                                                                  FontWeight
                                                                      .w900,
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
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                    ),
                    SizedBox(height: size.height * .020),
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
                                  width: size.width * .55,
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
                                  width: size.width * .55,
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
                                  width: size.width * .55,
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
                                  width: size.width * .55,
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
                                  width: size.width * .55,
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
                                  width: size.width * .55,
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
                                  width: size.width * .55,
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
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ExpansionTile(
                      initiallyExpanded: true,
                      key: Key(categoryList[index]['id']
                          .toString()), // Ensure unique key for each category
                      title: customText.kText(
                        "${categoryList[index]['title'] ?? ""} (${categoryList[index]['products_count'] ?? ""})",
                        16,
                        FontWeight.bold,
                        Colors.black,
                        TextAlign.start,
                      ),
                      children: [
                        categoryApiCalling
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.kPrimary,
                                ),
                              )
                            : (categoryList[index]['products'] == null ||
                                    categoryList[index]['products'].isEmpty)
                                ? CustomNoDataFound()
                                : Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      children: List.generate(
                                        categoryList[index]['products'].length,
                                        (i) {
                                          var product = categoryList[index]
                                                  ['products'][
                                              i]; // Ensure correct product data

                                          return GestureDetector(
                                            onTap: () {
                                              print(
                                                  "Selected Product: ${product}");

                                              print("hello category");
                                              sideDrawerController
                                                      .restaurantProductId =
                                                  product['id'].toString();
                                              sideDrawerController.previousIndex
                                                  .add(sideDrawerController
                                                      .index.value);
                                              sideDrawerController.index.value =
                                                  39;
                                              sideDrawerController
                                                  .pageController
                                                  .jumpToPage(
                                                      sideDrawerController
                                                          .index.value);
                                            },
                                            child: Container(
                                              height: size.height * .200,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              size.width * .5,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10),
                                                          child:
                                                              customText.kText(
                                                            product["name"],
                                                            16,
                                                            FontWeight.w700,
                                                            Colors.black,
                                                            TextAlign.start,
                                                            TextOverflow
                                                                .ellipsis,
                                                            1,
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            print(
                                                                "Price: ${product['price']}");
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 10),
                                                            child: customText
                                                                .kText(
                                                              "-\$${product['price']}",
                                                              14,
                                                              FontWeight.w500,
                                                              Colors.black,
                                                              TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              "Image URL: ${product['image']}");
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 20,
                                                                  bottom: 10),
                                                          height:
                                                              size.height * .12,
                                                          width:
                                                              size.width * .3,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade200,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  '${product['image']}'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 20,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            log("Selected Product: ${product}");

                                                            if (loginController
                                                                .accessToken
                                                                .isNotEmpty) {
                                                              if (sideDrawerController
                                                                      .cartListRestaurant
                                                                      .isEmpty ||
                                                                  sideDrawerController
                                                                          .cartListRestaurant ==
                                                                      sideDrawerController
                                                                          .restaurantId) {
                                                                await box.write(
                                                                    "cartListRestaurant",
                                                                    sideDrawerController
                                                                        .restaurantId);
                                                                setState(() {
                                                                  sideDrawerController
                                                                          .cartListRestaurant =
                                                                      sideDrawerController
                                                                          .restaurantId;
                                                                });

                                                                bottomSheet(
                                                                  product[
                                                                      'image'],
                                                                  product[
                                                                      'name'],
                                                                  product[
                                                                      'price'],
                                                                  product['id']
                                                                      .toString(),
                                                                );
                                                              } else {
                                                                helper
                                                                    .errorDialog(
                                                                  context,
                                                                  "Your cart already has food from a different restaurant",
                                                                );
                                                              }
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
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  ColorConstants
                                                                      .kPrimary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                "Add",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontFamily:
                                                                      "Raleway",
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
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
                (BuildContext context, int index) {
                  return Form(
                    key: _formKey,
                    child: SizedBox(
                      height: size.height * 0.55,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: CustomFormField2(
                                controller: nameController,
                                validator: (value) => ValidationRules()
                                    .firstNameValidation(value),
                                hintText: TextConstants.fullName,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: CustomFormField2(
                                keyboardType: TextInputType.number,
                                controller: phoneController,
                                validator: (value) => ValidationRules()
                                    .phoneNumberValidation(value),
                                hintText: TextConstants.phone,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: CustomFormField2(
                                controller: emailController,
                                validator: (value) =>
                                    ValidationRules().email(value),
                                hintText: TextConstants.emailAddress,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: CustomFormField2(
                                keyboardType: TextInputType.number,
                                validator: (value) => ValidationRules()
                                    .numberOfPeopleValidation(value),
                                controller: numberOfPeopleController,
                                hintText: TextConstants.numberOfPeople,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: CustomFormField2(
                                readOnly: true,
                                validator: (value) =>
                                    ValidationRules().dateValidation(value),
                                controller: dateController,
                                hintText: TextConstants.slelctDate,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    datePicker();
                                  },
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: ColorConstants.kPrimary,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: CustomFormField2(
                                readOnly: true,
                                validator: (value) =>
                                    ValidationRules().timeValidation(value),
                                controller: timeController,
                                hintText: TextConstants.selecttime,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    timePicker();
                                  },
                                  child: const Icon(
                                    Icons.watch_later_sharp,
                                    color: ColorConstants.kPrimary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * .020),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: CustomButton(
                                loader: isApiCalling,
                                fontSize: 20,
                                hintText: TextConstants.bookNow,
                                onTap: () {
                                  // if (selectedRestaurant == null) {
                                  //   setState(() {
                                  //     _hasInteracted = true;
                                  //   });
                                  // }
                                  if (_formKey.currentState!.validate()) {
                                    print("validation");
                                    bookTable();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: 1,
              )),
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
