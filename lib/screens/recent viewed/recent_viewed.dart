import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/deal_controller.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_favourite.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_product_item.dart';
import 'package:food_delivery/utils/custom_recent.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class RecentViewed extends StatefulWidget {
  const RecentViewed({super.key});

  @override
  State<RecentViewed> createState() => _RecentViewedState();
}

class _RecentViewedState extends State<RecentViewed> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  DealsController dealsController = Get.put(DealsController());
  final customText = CustomText();

  bool isApiCalling = false;
  List<dynamic> recentProductList = [];
  List<dynamic> recentRestaurantlist = [];
  List<dynamic> bestDealsList = [];
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

  // get recent product and restaurant list
  getRecentViewed() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.recentViewed();
    setState(() {
      recentProductList = response['data']['products'];
      recentRestaurantlist = response['data']['restaurants'];
      print(' recent product list: ${recentProductList}');
      print(' recent restaurant list: ${recentRestaurantlist}');
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' recent product success message: ${response["status"]}');

      print(' product list: ${recentProductList}');
    } else {
      print('recent product error message: ${response["status"]}');
    }
  }

  @override
  void initState() {
    bestDealsData();
    getRecentViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        // Make the entire page scrollable
        child: Column(
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
            // Banner
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
                        customText.kText(TextConstants.recentViewed, 28,
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
                                    text: " / ${TextConstants.recentViewed}",
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              width: width * .9,
              margin: EdgeInsets.only(left: 15),
              child: customText.kText(
                TextConstants.recentlyViewedRestaurant,
                20,
                FontWeight.w700,
                ColorConstants.kPrimary,
                TextAlign.start,
              ),
            ),
            SizedBox(height: height * .01),
            // GridView inside Column (Wrapped in Container + ShrinkWrap)
            isApiCalling
                ? const Center(
                    child: CircularProgressIndicator(
                        color: ColorConstants.kPrimary),
                  )
                : recentRestaurantlist.isEmpty
                    ? const CustomNoDataFound()
                    : Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GridView.builder(
                          shrinkWrap:
                              true, // Prevent GridView from expanding infinitely
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.0,
                            crossAxisSpacing: 1.0,
                            childAspectRatio: 1 / 1,
                          ),
                          itemCount: recentRestaurantlist.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                sideDrawerController.restaurantId =
                                    recentRestaurantlist[index]
                                            ['resturant_id'] // restaurant_id
                                        .toString();
                                sideDrawerController.detailRestaurantName =
                                    recentRestaurantlist[index]['business_name']
                                        .toString();
                                sideDrawerController.restaurantAddress =
                                    recentRestaurantlist[index]
                                            ['business_address']
                                        .toString();
                                sideDrawerController.restaurantlatitude =
                                    recentRestaurantlist[index]['latitude']
                                        .toString();
                                sideDrawerController.restaurantlongitude =
                                    recentRestaurantlist[index]['longitude']
                                        .toString();
                                sideDrawerController.previousIndex
                                    .add(sideDrawerController.index.value);
                                sideDrawerController.index.value = 16;
                                sideDrawerController.pageController.jumpToPage(
                                    sideDrawerController.index.value);
                              },
                              child: CustomRecent(
                                product: false,
                                imageURL: recentRestaurantlist[index]
                                        ['business_image'] ??
                                    "",
                                restaurantName: recentRestaurantlist[index]
                                        ['business_name'] ??
                                    "",
                              ),
                            );
                          },
                        ),
                      ),
            SizedBox(height: height * .01),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              width: width * .9,
              margin: EdgeInsets.only(left: 15),
              child: customText.kText(
                TextConstants.recentlyViewedProducts,
                20,
                FontWeight.w700,
                ColorConstants.kPrimary,
                TextAlign.start,
              ),
            ),
            SizedBox(height: height * .01),

            isApiCalling
                ? const Center(
                    child: CircularProgressIndicator(
                        color: ColorConstants.kPrimary),
                  )
                : recentProductList.isEmpty
                    ? const CustomNoDataFound()
                    : Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GridView.builder(
                          shrinkWrap:
                              true, // Prevent GridView from expanding infinitely
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.0,
                            crossAxisSpacing: 1.0,
                            childAspectRatio: 1 / 1,
                          ),
                          itemCount: recentProductList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                sideDrawerController.restaurantId =
                                    recentProductList[index]['resturantid']
                                        .toString();
                                sideDrawerController.detailRestaurantName =
                                    recentRestaurantlist[index]['business_name']
                                        .toString();
                                sideDrawerController.restaurantAddress =
                                    recentRestaurantlist[index]
                                            ['business_address']
                                        .toString();
                                sideDrawerController.restaurantlatitude =
                                    recentRestaurantlist[index]['latitude']
                                        .toString();
                                sideDrawerController.restaurantlongitude =
                                    recentRestaurantlist[index]['longitude']
                                        .toString();
                                sideDrawerController.previousIndex
                                    .add(sideDrawerController.index.value);
                                sideDrawerController.index.value = 16;
                                sideDrawerController.pageController.jumpToPage(
                                    sideDrawerController.index.value);
                              },
                              child: CustomRecent(
                                product: false,
                                amount:
                                    "\$ ${recentProductList[index]['price'] ?? ""}",
                                imageURL: recentProductList[index]
                                        ['product_image_url'] ??
                                    "",
                                restaurantName:
                                    recentProductList[index]['name'] ?? "",
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
