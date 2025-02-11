import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_best_deals.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DealsScreen extends StatefulWidget {
  String title;
  DealsScreen({super.key, required this.title});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  final customText = CustomText();
  bool isApiCalling = false;
  List<dynamic> allBestDealsList = [];
  List<dynamic> productsList = [];
  final api = API();
  final box = GetStorage();
  double distanceInMiles = 1.0;

  String? userLatitude;
  String? userLongitude;

  // view all best deals
  viewAllBestDeals() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.viewAllBestDeals();
    setState(() {
      allBestDealsList = response['deals_data'];
      print("best deals image: ${allBestDealsList[0]["image"]}");
    });
    setState(() {
      isApiCalling = false;
    });
  }

  // Get Current Location
  String calculateDistance({String? restaurantLat, String? restaurantLong}) {
    userLatitude = box.read("latOfUser");
    userLongitude = box.read("longOfUser");

    print("lat of user : $userLatitude --- long of user: $userLongitude");
    print("lat of res : $restaurantLat --- long of res: $restaurantLong");

    try {
      // Calculate distance in meters
      double distanceInMeters = Geolocator.distanceBetween(
        double.parse(userLatitude.toString()),
        double.parse(userLongitude.toString()),
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
      return "Error calculating distance";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewAllBestDeals();
    print("title value: ${widget.title}");
    if (widget.title == "" || widget.title == null) {
      widget.title = "Best Deals";
    }
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
                  : allBestDealsList.isEmpty
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
                              childAspectRatio: 1 / 1.5,
                            ),
                            itemCount: allBestDealsList.length,
                            itemBuilder: (context, index) {
                              return CustomBestDeals(
                                distance: calculateDistance(
                                    restaurantLat: allBestDealsList[index]
                                        ['latitude'],
                                    restaurantLong: allBestDealsList[index]
                                        ['longitude']),
                                amount: "\$${allBestDealsList[index]['price']}",
                                restaurantName: allBestDealsList[index]
                                    ['business_name'],
                                dislikeCount: "2",
                                likeCount: "5",
                                likeIcon: Icons.thumb_up,
                                dislikeIcon: Icons.thumb_down,
                                foodItemName: allBestDealsList[index]['name'],
                                imageURL: allBestDealsList[index]['image'],
                                favouriteIcon: Icons.favorite_outline,
                                addTocart: TextConstants.addToCart,
                                imagePress: () {
                                  // ================//
                                  sideDrawerController.bestDealsProdName =
                                      allBestDealsList[index]['name'];
                                  sideDrawerController.bestDealsProdImage =
                                      allBestDealsList[index]['image'];
                                  sideDrawerController.bestDealsRestaurantName =
                                      allBestDealsList[index]['business_name'];
                                  sideDrawerController.bestDealsProdPrice =
                                      allBestDealsList[index]['price'];
                                  sideDrawerController.bestDealsProdId =
                                      allBestDealsList[index]['id'].toString();
                                  // ================//
                                  sideDrawerController.previousIndex
                                      .add(sideDrawerController.index.value);
                                  sideDrawerController.index.value = 35;
                                  sideDrawerController.pageController
                                      .jumpToPage(
                                          sideDrawerController.index.value);
                                },
                                addToCartPress: () {},
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
}
