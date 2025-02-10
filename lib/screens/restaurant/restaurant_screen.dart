import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:marquee/marquee.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  dynamic size;
  final customText = CustomText();

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  TextEditingController searchController = TextEditingController();
  String searchValue = "";

  List<dynamic> allRestaurantList = [];
  List<dynamic> bestDealsList = [];
  bool isApiCalling = false;
  final api = API();

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

  // get all restaurant  list for home page
  getAllRestaurantData({String searchResult = ""}) async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.viewAllRestaurant(search: searchResult);
    setState(() {
      allRestaurantList = response["restaurants"];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' all restaurant success message: ${response["message"]}');
    } else {
      print('all restaurant message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    bestDealsData();
    getAllRestaurantData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // SizedBox(height: size.height * .010),
              Container(
                padding: const EdgeInsets.only(left: 15, top: 5),
                margin: const EdgeInsets.only(top: 0, bottom: 10, right: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffixIcon: searchController.text.isEmpty
                        ? const Icon(Icons.search)
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                getAllRestaurantData(
                                  searchResult: searchController.text,
                                );
                              });
                            },
                            child: const Icon(Icons.arrow_forward),
                          ),
                    border: OutlineInputBorder(),
                    hintText: TextConstants.search,
                  ),
                  onChanged: (value) {
                    if (searchController.text.isEmpty) {
                      getAllRestaurantData(
                        searchResult: "",
                      );
                      FocusScope.of(context).unfocus();
                    }

                    setState(() {
                      // searchController.clear();
                    });
                  },
                ),
              ),
              Container(
                height: size.height * 0.18,
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
                          customText.kText(TextConstants.restaurant, 28,
                              FontWeight.w900, Colors.white, TextAlign.center),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          RichText(
                            text: TextSpan(
                                text: TextConstants.home,
                                style: customText.kSatisfyTextStyle(
                                    24, FontWeight.w400, Colors.white),
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
              isApiCalling
                  ? Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary,
                        ),
                      ),
                    )
                  : allRestaurantList.isEmpty
                      ? const CustomNoDataFound()
                      : Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: allRestaurantList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                              child: Container(
                                height: size.height * 0.15,
                                width: size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03),
                                margin: EdgeInsets.only(
                                    bottom: size.height * 0.01,
                                    top: size.height * 0.01),
                                // color: Colors.yellow.shade100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height: size.height * 0.14,
                                      width: size.width * 0.33,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
                                            size.width * 0.05),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: allRestaurantList[index]
                                                      ["business_image"] ==
                                                  null
                                              ? const AssetImage(
                                                  "assets/images/no_image.png")
                                              : NetworkImage(
                                                  "${allRestaurantList[index]["business_image"]}"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            // height: size.height * 0.08,
                                            width: size.width * 0.5,
                                            child: customText.kText(
                                                "${allRestaurantList[index]["business_name"]}",
                                                20,
                                                FontWeight.w700,
                                                ColorConstants.kPrimary,
                                                TextAlign.start),
                                          ),

                                          Container(
                                            // height: size.height * 0.08,
                                            width: size.width * 0.5,
                                            child: customText.kText(
                                                "${allRestaurantList[index]["business_address"]}",
                                                14,
                                                FontWeight.w500,
                                                Colors.black,
                                                TextAlign.start),
                                          ),
                                          // SizedBox(
                                          //   width: size.width * 0.55,
                                          //   child: RatingBar.builder(
                                          //     ignoreGestures: true,
                                          //     initialRating: 3,
                                          //     minRating: 1,
                                          //     direction: Axis.horizontal,
                                          //     allowHalfRating: true,
                                          //     itemSize: 20,
                                          //     itemCount: 5,
                                          //     itemBuilder: (context, _) => const Icon(
                                          //       Icons.star,
                                          //       color: Colors.amber,
                                          //     ),
                                          //     onRatingUpdate: (rating) {},
                                          //   ),
                                          // ),
                                          SizedBox(
                                            width: size.width * 0.5,
                                            child: customText.kText(
                                                "Distance : ${allRestaurantList[index]["resturant_distance"] ?? "0"} mls",
                                                14,
                                                FontWeight.w500,
                                                Colors.black,
                                                TextAlign.start),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                // sideDrawerController.previousIndex =
                                                //     sideDrawerController
                                                //         .index.value;
                                                sideDrawerController
                                                    .previousIndex
                                                    .add(sideDrawerController
                                                        .index.value);
                                                sideDrawerController
                                                        .restaurantId =
                                                    allRestaurantList[index]
                                                            ["id"]
                                                        .toString();
                                                sideDrawerController
                                                        .detailRestaurantName =
                                                    allRestaurantList[index]
                                                            ["business_name"]
                                                        .toString();
                                                sideDrawerController
                                                        .restaurantlatitude =
                                                    allRestaurantList[index]
                                                        ["latitude"];
                                                sideDrawerController
                                                        .restaurantlongitude =
                                                    allRestaurantList[index]
                                                        ["longitude"];
                                                sideDrawerController
                                                        .restaurantAddress =
                                                    allRestaurantList[index]
                                                        ["business_address"];
                                                sideDrawerController
                                                    .index.value = 16;
                                                sideDrawerController
                                                    .pageController
                                                    .jumpToPage(
                                                        sideDrawerController
                                                            .index.value);
                                              },
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      child: customText.kText(
                                                        TextConstants
                                                            .viewDetails,
                                                        14,
                                                        FontWeight.w500,
                                                        Colors.black,
                                                        TextAlign.start,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                // sideDrawerController.previousIndex =
                                //     sideDrawerController.index.value;
                                sideDrawerController.previousIndex
                                    .add(sideDrawerController.index.value);
                                sideDrawerController.restaurantId =
                                    allRestaurantList[index]["id"].toString();
                                sideDrawerController.detailRestaurantName =
                                    allRestaurantList[index]["business_name"]
                                        .toString();
                                sideDrawerController.restaurantlatitude =
                                    allRestaurantList[index]["latitude"];
                                sideDrawerController.restaurantlongitude =
                                    allRestaurantList[index]["longitude"];
                                sideDrawerController.restaurantAddress =
                                    allRestaurantList[index]
                                        ["business_address"];

                                sideDrawerController.index.value = 16;
                                sideDrawerController.pageController.jumpToPage(
                                    sideDrawerController.index.value);
                              },
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
