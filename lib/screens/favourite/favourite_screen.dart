import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/utils/custom_favourite.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_product_item.dart';
import 'package:food_delivery/utils/custom_specific_food.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  final api = API();
  final customText = CustomText();

  bool isApiCalling = false;
  List<dynamic> favouriteList = [];
  List<dynamic> bestDealsList = [];

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

  // get special food list
  favouriteFoodData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.favouriteFood();
    setState(() {
      favouriteList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print('favourite success message: ${response["message"]}');
    } else {
      print('favourite error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    favouriteFoodData();
    bestDealsData();
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
                      child: customText.kText("No deals available at the moment", 18, FontWeight.w400, Colors.black, TextAlign.center),
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
                        customText.kText(TextConstants.favourites, 28,
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
                                    text: " / ${TextConstants.favourites}",
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

            // GridView inside Column (Wrapped in Container + ShrinkWrap)
            isApiCalling
                ? const Center(
                    child: CircularProgressIndicator(
                        color: ColorConstants.kPrimary),
                  )
                : favouriteList.isEmpty
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
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 1.0,
                            childAspectRatio: 1 / 1.4,
                          ),
                          itemCount: favouriteList.length,
                          itemBuilder: (context, index) {
                            return CustomFavourite(
                              imagePress: () {
                                //---------------//

                                sideDrawerController.favoriteName =
                                    favouriteList[index]['product_name'];
                                sideDrawerController.favouriteImage =
                                    favouriteList[index]['product_image'];
                                sideDrawerController.favoritePrice =
                                    favouriteList[index]['product_price'];
                                sideDrawerController.favoriteResId =
                                    favouriteList[index]['resturant_id']
                                        .toString();
                                sideDrawerController.favoriteProdId =
                                    favouriteList[index]['product_id']
                                        .toString();
                                //-------------------//
                                // sideDrawerController.previousIndex =
                                //     sideDrawerController.index.value;
                                sideDrawerController.previousIndex
                                    .add(sideDrawerController.index.value);
                                sideDrawerController.index.value = 33;
                                sideDrawerController.pageController.jumpToPage(
                                    sideDrawerController.index.value);
                              },
                              addToCartPress: () {
                                print("add to cart");
                                if (loginController.accessToken.isNotEmpty) {
                                  bottomSheet(
                                      favouriteList[index]['product_image'],
                                      favouriteList[index]['product_name'],
                                      favouriteList[index]['product_price'],
                                      favouriteList[index]['product_id']
                                          .toString(),
                                      favouriteList[index]['resturant_id']
                                          .toString());
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                }
                              },
                              amount:
                                  "\$ ${favouriteList[index]['product_price']}",
                              favouriteIcon: Icons.favorite,
                              foodItemName: favouriteList[index]
                                  ['product_name'],
                              imageURL: favouriteList[index]['product_image'],
                              addTocart: TextConstants.addToCart,
                              restaurantName: favouriteList[index]
                                  ['business_name'],
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  // bottom sheet for adding items to the cart
  void bottomSheet(String image, String name, String price, String productId,
      String restaurantId) {
    int quantity = 1;
    int calculatedPrice = 0;
    bool cartCalling = false;
    final api = API();
    final helper = Helper();
    dynamic size = MediaQuery.of(context).size;

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
                restaurantId: restaurantId.toString(),
                productId: productId.toString(),
              );

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
