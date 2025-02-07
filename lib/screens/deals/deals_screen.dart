import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_best_deals.dart';
import 'package:food_delivery/utils/custom_product_item.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:get/get.dart';

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

  // get special food list
  getAllBestDealsData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.viewAllBestDeals();
    setState(() {
      allBestDealsList = response['data'];

      for (int i = 0; i < allBestDealsList.length; i++) {
        // productsList.add(allBestDealsList[i]['products']);
        int productLength = allBestDealsList[i]["products"].length;
        for (int j = 0; j < productLength; j++) {
          productsList.add(allBestDealsList[i]["products"][j]);
        }
        // productsList = allBestDealsList[i]['products'];
      }

      print(' product list: ${productsList}');
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' all best deals success message: ${response["message"]}');

      print(' product list: ${productsList}');
    } else {
      print('all best deals error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBestDealsData();
    print("title value: ${widget.title}");
    if (widget.title == "" || widget.title == null) {
      widget.title = "Best Deals";
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
    return Scaffold(
      body: isApiCalling
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.kPrimary,
              ),
            )
          : productsList.isEmpty
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)),
                    height: 50,
                    width: size.width * .400,
                    child: Center(
                      child: customText.kText("No data found", 15,
                          FontWeight.w700, Colors.black, TextAlign.center),
                    ),
                  ),
                )
              : SizedBox(
                  height: size.height,
                  width: size.width,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            // Container(
                            //   height: size.height * 0.06,
                            //   width: size.width,
                            //   color: Colors.grey.shade300,
                            // ),
                            Container(
                              height: size.height * 0.18,
                              width: size.width,
                              margin:
                                  EdgeInsets.only(bottom: size.height * 0.01),
                              decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/banner.png"),
                                      fit: BoxFit.fitHeight)),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    color: Colors.black54,
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        customText.kText(
                                            TextConstants.bestDeals,
                                            28,
                                            FontWeight.w900,
                                            Colors.white,
                                            TextAlign.center),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: TextConstants.home,
                                              style:
                                                  customText.kSatisfyTextStyle(
                                                      24,
                                                      FontWeight.w400,
                                                      Colors.white),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        " / ${TextConstants.bestDeals}",
                                                    style: customText
                                                        .kSatisfyTextStyle(
                                                            24,
                                                            FontWeight.w400,
                                                            ColorConstants
                                                                .kPrimary))
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
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: 15.0,
                          // crossAxisSpacing: 10.0,
                          childAspectRatio: 1 / 1.6,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          childCount: productsList.length,
                          (BuildContext context, int index) {
                            return Container(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: GestureDetector(
                                  onTap: () {
                                    // sideDrawerController.index.value = 18;
                                    // sideDrawerController.pageController
                                    //     .jumpToPage(sideDrawerController.index.value);
                                  },
                                  child: CustomBestDeals(
                                    distance: "5 Mls",
                                    amount: "\$${productsList[index]['price']}",
                                    restaurantName: productsList[index]
                                        ['restaurant_name'],
                                    dislikeCount: "2",
                                    likeCount: "5",
                                    likeIcon: Icons.thumb_up,
                                    dislikeIcon: Icons.thumb_down,
                                    foodItemName: productsList[index]['name'],
                                    imageURL: productsList[index]['image'],
                                    favouriteIcon: Icons.favorite_outline,
                                    addTocart: TextConstants.addToCart,
                                    imagePress: () {
                                      // ================//
                                      sideDrawerController.bestDealsProdName =
                                          productsList[index]['name'];
                                      sideDrawerController.bestDealsProdImage =
                                          productsList[index]['image'];
                                      sideDrawerController
                                              .bestDealsRestaurantName =
                                          productsList[index]
                                              ['restaurant_name'];
                                      sideDrawerController.bestDealsProdPrice =
                                          productsList[index]['price'];
                                      sideDrawerController.bestDealsProdId =
                                          productsList[index]['id'].toString();
                                      // ================//
                                      sideDrawerController.previousIndex.add(
                                          sideDrawerController.index.value);
                                      sideDrawerController.index.value = 35;
                                      sideDrawerController.pageController
                                          .jumpToPage(
                                              sideDrawerController.index.value);
                                    },
                                    likePress: () {},
                                    dislikePress: () {},
                                    addToCartPress: () {},
                                    favouritePress: () {},
                                  ),
                                ),
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
