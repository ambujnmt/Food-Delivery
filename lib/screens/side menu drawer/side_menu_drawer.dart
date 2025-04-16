import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/deal_controller.dart';
import 'package:food_delivery/screens/restaurant/restaurant_deal_detail.dart';
import 'package:food_delivery/screens/restaurant/restaurant_deals_product_list.dart';
import 'package:food_delivery/screens/restaurant/restaurant_product_detail.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/about%20us/about_us.dart';
import 'package:food_delivery/screens/address/add_new_address.dart';
import 'package:food_delivery/screens/address/address_screen.dart';
import 'package:food_delivery/screens/auth/change_password.dart';
import 'package:food_delivery/screens/auth/change_password_successfully.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/screens/cart/cart_screen.dart';
import 'package:food_delivery/screens/contact%20us/contact_us.dart';
import 'package:food_delivery/screens/coupon/coupon_list.dart';
import 'package:food_delivery/screens/deals/deals_detail.dart';
import 'package:food_delivery/screens/deals/deals_screen.dart';
import 'package:food_delivery/screens/deals/group_deals.dart';
import 'package:food_delivery/screens/favourite/favourite_detail.dart';
import 'package:food_delivery/screens/favourite/favourite_screen.dart';
import 'package:food_delivery/screens/food%20category/food_category.dart';
import 'package:food_delivery/screens/food%20category/specific_food_category.dart';
import 'package:food_delivery/screens/gallery/gallery_screen.dart';
import 'package:food_delivery/screens/home/book_table.dart';
import 'package:food_delivery/screens/home/home_screen.dart';
import 'package:food_delivery/screens/order%20history/order_history.dart';
import 'package:food_delivery/screens/populars/populars_screen.dart';
import 'package:food_delivery/screens/profile/profile_screen.dart';
import 'package:food_delivery/screens/rate%20meal/rate_your_meal.dart';
import 'package:food_delivery/screens/recent%20viewed/recent_viewed.dart';
import 'package:food_delivery/screens/restaurant/restaurant_detail.dart';
import 'package:food_delivery/screens/restaurant/restaurant_screen.dart';
import 'package:food_delivery/screens/restaurant_chat/chat_screen.dart';
import 'package:food_delivery/screens/restaurant_chat/restaurant_list.dart';
import 'package:food_delivery/screens/special%20food/special_food.dart';
import 'package:food_delivery/screens/special%20food/special_food_detail.dart';
import 'package:food_delivery/screens/terms_and_conditions.dart/privacy_policy.dart';
import 'package:food_delivery/screens/terms_and_conditions.dart/refund_policy.dart';
import 'package:food_delivery/screens/testimonial/testimonial_screen.dart';
import 'package:food_delivery/utils/custom_favourite.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import '../food category/special_food_category_detail.dart';
import '../notifications/notifications.dart';
import '../order history/invoice_details.dart';
import '../terms_and_conditions.dart/terms_conditions.dart';

class SideMenuDrawer extends StatefulWidget {
  const SideMenuDrawer({super.key});

  @override
  State<SideMenuDrawer> createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
  dynamic size;
  final customText = CustomText(), api = API();
  bool _isVisible = false, isApiCalling = false;
  String selectedValue = "", userName = "", profileImageUrl = "";
  GlobalKey<ScaffoldState> key = GlobalKey();
  Map<String, dynamic> getUserProfileMap = {};

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  final CartController cartController = Get.put(CartController());
  DealsController dealsController = Get.put(DealsController());

  List<dynamic> dealTitleList = [];
  List<dynamic> allBestDealsList = [];
  List<dynamic> productsList = [];

  // view all best deals
  // viewAllBestDeals({String? search = ""}) async {
  //   productsList.clear();
  //   setState(() {
  //     isApiCalling = true;
  //   });
  //
  //   final response = await api.viewAllBestDeals(
  //       search: sideDrawerController.dealsSearchValue);
  //
  //   setState(() {
  //     isApiCalling = false;
  //   });
  //
  //   if (response['status'] == true) {
  //     setState(() {
  //       allBestDealsList = response['deals_data'];
  //     });
  //     for (int i = 0; i < allBestDealsList.length; i++) {
  //       // productsList.add(allBestDealsList[i]);
  //
  //       String dealTitle = allBestDealsList[i]["title"];
  //       String businessName = allBestDealsList[i]["business_name"];
  //       String businessAddress = allBestDealsList[i]["business_address"];
  //       String businessLat = allBestDealsList[i]["latitude"];
  //       String businessLong = allBestDealsList[i]["longitude"];
  //       List tempProductsList = allBestDealsList[i]["products"];
  //       for (int j = 0; j < tempProductsList.length; j++) {
  //         tempProductsList[j]["dealTitle"] = dealTitle;
  //         tempProductsList[j]["businessName"] = businessName;
  //         tempProductsList[j]["businessAddress"] = businessAddress;
  //         tempProductsList[j]["businessLat"] = businessLat;
  //         tempProductsList[j]["businessLong"] = businessLong;
  //         productsList.add(tempProductsList[j]);
  //       }
  //     }
  //   }
  //
  //   log("all best deal list :- $allBestDealsList");
  //   log("all product list :- $productsList");
  // }

  viewAllBestDeals(String query) async {
    dealsController.productsList.clear();
    final response = await api.viewAllBestDeals(search: query);

    log("response :- $response");

    // dealsController.productsList.value = response["deals_data"];
    setState(() {
      allBestDealsList = response["deals_data"];
    });

    for (int i = 0; i < allBestDealsList.length; i++) {
      // productsList.add(allBestDealsList[i]);
      String dealTitle = allBestDealsList[i]["title"];
      String businessName = allBestDealsList[i]["business_name"];
      String businessAddress = allBestDealsList[i]["business_address"];
      String businessLat = allBestDealsList[i]["latitude"];
      String businessLong = allBestDealsList[i]["longitude"];
      List tempProductsList = allBestDealsList[i]["products"];
      for (int j = 0; j < tempProductsList.length; j++) {
        tempProductsList[j]["dealTitle"] = dealTitle;
        tempProductsList[j]["businessName"] = businessName;
        tempProductsList[j]["businessAddress"] = businessAddress;
        tempProductsList[j]["businessLat"] = businessLat;
        tempProductsList[j]["businessLong"] = businessLong;
        dealsController.productsList.add(tempProductsList[j]);
      }
    }

    log("side drawer deals product list :- ${dealsController.productsList}");
  }

  // view deals by title
  dealsWithTitle() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.dealsWithTitle();

    setState(() {
      isApiCalling = false;
    });

    if (response['status'] == true) {
      setState(() {
        dealTitleList = response['data'];
      });
    }

    print("deals title list in side drawer :- $dealTitleList");
  }

  customAppBar() {
    return Container(
      decoration: const BoxDecoration(color: ColorConstants.kPrimary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: size.width * 0.85,
            child: Image.asset("assets/images/name_logo.png"),
          ),
          Obx(() {
            return Padding(
              // color: Colors.yellow,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sideDrawerController.index.value == 0 ||
                          sideDrawerController.index.value == 1 ||
                          sideDrawerController.index.value == 13 ||
                          sideDrawerController.index.value == 12 ||
                          sideDrawerController.index.value == 14 ||
                          sideDrawerController.index.value == 11 ||
                          sideDrawerController.index.value == 10 ||
                          sideDrawerController.index.value == 8 ||
                          sideDrawerController.index.value == 9 ||
                          sideDrawerController.index.value == 6 ||
                          sideDrawerController.index.value == 5 ||
                          sideDrawerController.index.value == 4 ||
                          sideDrawerController.index.value == 3 ||
                          sideDrawerController.index.value == 2 ||
                          sideDrawerController.index.value == 20 ||
                          sideDrawerController.index.value == 19 ||
                          sideDrawerController.index.value == 27 ||
                          sideDrawerController.index.value == 25 ||
                          sideDrawerController.index.value == 23 ||
                          sideDrawerController.index.value == 15 ||
                          sideDrawerController.index.value == 37
                      ? GestureDetector(
                          child: SizedBox(
                            height: size.width * 0.07,
                            child: Image.asset("assets/images/menu.png"),
                          ),
                          onTap: () {
                            key.currentState!.openDrawer();
                          },
                        )
                      : GestureDetector(
                          onTap: () {
                            print(
                                "list value of previous index : ${sideDrawerController.previousIndex}");
                            print(
                                "sidemenu drawer back press: ${sideDrawerController.index.value}");

                            sideDrawerController.index.value =
                                sideDrawerController.previousIndex.last;

                            print(
                                "side menu prev index after clear: ${sideDrawerController.previousIndex}");
                            sideDrawerController.pageController.jumpToPage(
                                sideDrawerController.previousIndex.last);
                            sideDrawerController.previousIndex.removeLast();
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                  Row(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.account_circle,
                            color: Colors.white, size: 30),
                        onTap: () {
                          if (loginController.accessToken.isEmpty &&
                              loginController.userId == 0) {
                            Helper().errorDialog(context, "Login is required");
                          } else {
                            sideDrawerController.index.value = 13;
                            sideDrawerController.pageController
                                .jumpToPage(sideDrawerController.index.value);
                          }
                        },
                      ),
                      SizedBox(width: size.width * 0.02),
                      GestureDetector(
                        child: const Icon(Icons.favorite,
                            color: Colors.white, size: 30),
                        onTap: () {
                          sideDrawerController.index.value = 20;
                          sideDrawerController.pageController
                              .jumpToPage(sideDrawerController.index.value);
                        },
                      ),
                      SizedBox(width: size.width * 0.02),
                      Container(
                        child: Obx(() => badges.Badge(
                              badgeStyle:
                                  badges.BadgeStyle(badgeColor: Colors.white),
                              badgeContent: customText.kText(
                                  cartController.cartItemCount > 99
                                      ? "99+"
                                      : "${cartController.cartItemCount}",
                                  12,
                                  FontWeight.w500,
                                  Colors.red,
                                  TextAlign.start),
                              showBadge: cartController.cartItemCount > 0,
                              child: GestureDetector(
                                onTap: () {
                                  if (loginController.accessToken.isEmpty &&
                                      loginController.userId == 0) {
                                    Helper().errorDialog(
                                        context, "Login is required");
                                  } else {
                                    sideDrawerController.index.value = 19;
                                    sideDrawerController.pageController
                                        .jumpToPage(
                                            sideDrawerController.index.value);
                                  }
                                },
                                child: const Icon(
                                  Icons.shopping_cart,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                      SizedBox(width: size.width * 0.02),
                      GestureDetector(
                        child: const Icon(Icons.notifications,
                            color: Colors.white, size: 30),
                        onTap: () {
                          if (loginController.accessToken.isEmpty &&
                              loginController.userId == 0) {
                            Helper().errorDialog(context, "Login is required");
                          } else {
                            sideDrawerController.index.value = 27;
                            sideDrawerController.pageController
                                .jumpToPage(sideDrawerController.index.value);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
          SizedBox(
            height: size.height * 0.01,
          )
        ],
      ),
    );
  }

  customSelectedBorder() {
    return const Border(
      top: BorderSide(
        color: ColorConstants.kPrimary,
        width: 2.0,
      ),
      right: BorderSide(
        color: ColorConstants.kPrimary,
        width: 2.0,
      ),
      bottom: BorderSide(
        color: ColorConstants.kPrimary,
        width: 2.0,
      ),
    );
  }

  customUnselectedBorder() {
    return const Border(
      top: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
      right: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
      bottom: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    );
  }

  customTile(int selectedIndex, String title, String image) {
    return GestureDetector(
      child: Container(
        height: size.height * 0.055,
        width: size.width * 0.62, // .62
        margin: EdgeInsets.only(
          bottom: size.width * 0.02,
        ),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        decoration: BoxDecoration(
          // color: Colors.green,
          // color: Colors.yellow,
          border: sideDrawerController.index.value == selectedIndex
              ? customSelectedBorder()
              : customUnselectedBorder(),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(size.width * 0.03),
              bottomRight: Radius.circular(size.width * 0.03)),
        ),
        child: Row(
          children: [
            ImageIcon(
              AssetImage(image),
              color: ColorConstants.kPrimary,
              size: 30,
            ),
            SizedBox(width: size.width * 0.03),
            customText.kText(
                title, 20, FontWeight.w900, Colors.black, TextAlign.center)
          ],
        ),
      ),
      onTap: () {
        if (loginController.accessToken.isEmpty && selectedIndex == 10 ||
            loginController.accessToken.isEmpty && selectedIndex == 13 ||
            loginController.accessToken.isEmpty && selectedIndex == 11 ||
            loginController.accessToken.isEmpty && selectedIndex == 6) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          sideDrawerController.index.value = selectedIndex;
          sideDrawerController.pageController.jumpToPage(selectedIndex);
          key.currentState!.closeDrawer();
          setState(() {});
        }
      },
    );
  }

  // alert dialog for logout confirmation
  void _showAlertDialog(BuildContext context, Function() logoutPress) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              'Are you sure want to logout ?',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                height: h * .030,
                width: w * .2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorConstants.kPrimary),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform any action here, then close the dialog
                logoutPress();
                Navigator.of(context).pop();
              },
              child: Container(
                height: h * .030,
                width: w * .2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  customDrawer() {
    log("username on custom Drawer :- $userName");

    return Container(
      height: size.height,
      width: size.width * 0.7,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.2,
            width: size.width,
            margin: EdgeInsets.only(bottom: size.width * 0.02),
            color: ColorConstants.kPrimary,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loginController.accessToken.isEmpty
                    ? Container(
                        margin: EdgeInsets.only(
                            top: size.height * 0.07,
                            bottom: size.height * 0.02),
                        child: Image.asset("assets/images/name_logo.png"),
                      )
                    : Container(
                        // color: Colors.white,
                        margin: EdgeInsets.only(top: size.height * 0.05),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: size.height * 0.1,
                              width: size.width * 0.18,
                              decoration: const BoxDecoration(
                                color: ColorConstants.kPrimaryDark,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: loginController
                                                .accessToken.isNotEmpty
                                            ? NetworkImage(profileImageUrl)
                                            : const AssetImage(
                                                "assets/images/profile_image.jpg"),
                                        fit: BoxFit.fill),
                                    shape: BoxShape.circle,
                                  )),
                            ),
                            Container(
                              height: size.height * 0.1,
                              width: size.width * 0.45,
                              // color: Colors.yellow,
                              child: customText.kText(
                                  loginController.accessToken.isEmpty
                                      ? "food Delivery"
                                      : "$userName",
                                  30,
                                  FontWeight.w700,
                                  Colors.white,
                                  TextAlign.start),
                            )
                          ],
                        ),
                      ),
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Wrap(
                      spacing: 5,
                      children: [
                        const Icon(
                          Icons.settings,
                          size: 25,
                          color: Colors.white,
                        ),
                        loginController.accessToken.isEmpty
                            ? customText.kText(TextConstants.kLogin, 16,
                                FontWeight.w900, Colors.white, TextAlign.center)
                            : customText.kText(TextConstants.logOut, 16,
                                FontWeight.w900, Colors.white, TextAlign.center)
                      ],
                    ),
                    onTap: () {
                      print("log out pressed");
                      if (loginController.accessToken.isEmpty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else {
                        key.currentState!.closeDrawer();
                        _showAlertDialog(context, () {
                          loginController.clearToken();
                          key.currentState!.closeDrawer();
                          Helper().successDialog(
                              context, "User logged out successfully");
                          sideDrawerController.index.value = 0;
                          sideDrawerController.pageController
                              .jumpToPage(sideDrawerController.index.value);
                          setState(() {});
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTile(0, TextConstants.home, "assets/images/home.png"),
                  customTile(1, TextConstants.restaurant,
                      "assets/images/restaurant.png"),
                  customTile(2, TextConstants.foodCategory,
                      "assets/images/foodCategory.png"),
                  customTile(3, TextConstants.specialFood,
                      "assets/images/specialFood.png"),

                  GestureDetector(
                    child: Container(
                      height: size.height * 0.055,
                      width: size.width * 0.6,
                      margin: EdgeInsets.only(
                        bottom: size.width * 0.02,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      decoration: BoxDecoration(
                        // color: Colors.yellow,
                        border: sideDrawerController.index.value == 4
                            ? customSelectedBorder()
                            : customUnselectedBorder(),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(size.width * 0.03),
                            bottomRight: Radius.circular(size.width * 0.03)),
                      ),
                      child: Row(
                        children: [
                          const ImageIcon(
                            AssetImage("assets/images/deals.png"),
                            color: ColorConstants.kPrimary,
                            size: 30,
                          ),
                          SizedBox(width: size.width * 0.03),
                          customText.kText(TextConstants.deals, 20,
                              FontWeight.w900, Colors.black, TextAlign.center),
                          SizedBox(width: size.width * 0.03),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      // sideDrawerController.index.value = 4;
                      _isVisible = !_isVisible;
                      // sideDrawerController.pageController.jumpToPage(4);
                      // key.currentState!.closeDrawer();
                      setState(() {});
                    },
                  ),
                  for (int i = 0; i < dealTitleList.length; i++)
                    Visibility(
                      visible: _isVisible,
                      child: Container(
                        margin: const EdgeInsets.only(left: 70),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // sideDrawerController.index.value = 0;

                                // for init call of that page
                                // viewAllBestDeals(
                                //     search:
                                //         dealTitleList[i]['title'].toString());
                                // dealsController.updateDealsList(productsList);
                                // print("updated deal list: $productsList ");

                                // print("side drawer: ${sideDrawerController.index.value}");
                                sideDrawerController.dealsSearchValue =
                                    dealTitleList[i]['title'];
                                // print(" deals tap: ${dealTitleList[i]['title']} side controller value ${sideDrawerController.dealsSearchValue} ");
                                //
                                // sideDrawerController.index.value = 4;
                                // sideDrawerController.pageController.jumpToPage(4);
                                // key.currentState!.closeDrawer();
                                // setState(() {});

                                viewAllBestDeals(dealTitleList[i]["title"]);
                                dealsController.comingFrom = "sideDrawer";
                                sideDrawerController.index.value = 4;
                                sideDrawerController.pageController
                                    .jumpToPage(4);
                                key.currentState!.closeDrawer();
                                setState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: customText.kText(
                                    "${dealTitleList[i]['title']}(${dealTitleList[i]['deal_count']})",
                                    18,
                                    FontWeight.w500,
                                    Colors.black,
                                    TextAlign.start),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Visibility(
                  //   visible: _isVisible,
                  //   child: Container(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedValue = "Best Deals";
                  //             });
                  //             print("${selectedValue}");
                  //             sideDrawerController.pageController.jumpToPage(4);
                  //             key.currentState!.closeDrawer();
                  //           },
                  //           child: Container(
                  //             margin: EdgeInsets.only(bottom: 5),
                  //             child: customText.kText(
                  //                 TextConstants.bestDeals,
                  //                 16,
                  //                 FontWeight.w700,
                  //                 Colors.black,
                  //                 TextAlign.center),
                  //           ),
                  //         ),
                  //         GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedValue = "New Deals";
                  //             });
                  //             print("${selectedValue}");
                  //             sideDrawerController.pageController.jumpToPage(4);
                  //             key.currentState!.closeDrawer();
                  //           },
                  //           child: Container(
                  //             margin: EdgeInsets.only(bottom: 5),
                  //             child: customText.kText(
                  //                 TextConstants.newDeals,
                  //                 16,
                  //                 FontWeight.w700,
                  //                 Colors.black,
                  //                 TextAlign.center),
                  //           ),
                  //         ),
                  //         GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedValue = "Chrismas Deals";
                  //             });
                  //             print("${selectedValue}");
                  //             sideDrawerController.pageController.jumpToPage(4);
                  //             key.currentState!.closeDrawer();
                  //           },
                  //           child: Container(
                  //             child: customText.kText(
                  //                 TextConstants.cristmasDeals,
                  //                 16,
                  //                 FontWeight.w700,
                  //                 Colors.black,
                  //                 TextAlign.center),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  customTile(
                      5, TextConstants.gallery, "assets/images/gallery.png"),
                  customTile(
                    6,
                    TextConstants.recentlyViewed,
                    "assets/images/recent.png",
                  ),
                  // customTile(
                  //     7, TextConstants.popular, "assets/images/popular.png"),
                  customTile(
                      8, TextConstants.orderHistory, "assets/images/clock.png"),
                  customTile(9, TextConstants.contactUs,
                      "assets/images/contactUs.png"),
                  customTile(
                      10, TextConstants.address, "assets/images/address.png"),
                  customTile(11, TextConstants.favourite,
                      "assets/images/favourite.png"),
                  customTile(12, TextConstants.testimonials,
                      "assets/images/testimonial.png"),
                  customTile(
                      13, TextConstants.profile, "assets/images/profile.png"),
                  customTile(
                      14, TextConstants.aboutUs, "assets/images/aboutUs.png"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUserProfileData() async {
    log("get user profile call on side menu drawer :- $getUserProfileMap");

    setState(() {
      isApiCalling = true;
    });

    final response = await api.getUserProfileDetails();

    setState(() {
      getUserProfileMap = response['data'];
      userName = getUserProfileMap['name'];
      profileImageUrl = getUserProfileMap['avatar'];
      sideDrawerController.userProfileName = userName.toString();
    });

    setState(() {
      isApiCalling = false;
    });
    print("user profile list data: ${getUserProfileMap}");
    if (response["status"] == true) {
    } else {
      print('error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    print("acc token : ${loginController.accessToken}");
    if (loginController.accessToken.isNotEmpty) {
      getUserProfileData();
    }
    dealsWithTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: customAppBar(),
      ),
      drawer: Obx(() {
        return customDrawer();
      }),
      body: Container(
        color: Colors.grey.shade400,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: sideDrawerController.pageController,
          children: [
            const HomeScreen(), // 0
            const RestaurantScreen(), // 1
            const FoodCategory(), // 2
            const SpecialFood(), // 3
            DealsScreen(title: selectedValue), // 4
            const GalleryScreen(), // 5
            const RecentViewed(), // 6
            const PopularsScreen(), // 7
            const OrderHistory(), // 8
            const ContactUs(), // 9
            const AddressScreen(), // 10
            const FavouriteScreen(), // 11
            const TestimonialScreen(), // 12
            const ProfileScreen(), // 13
            const AboutUs(title: TextConstants.aboutUs), // 14
            const CartScreen(), // 15
            const RestaurantDetail(), // 16
            const SpecificFoodCategory(), // 17
            const SpecificFoodCategoryDetail(), //18
            const CartScreen(), //19
            const FavouriteScreen(), // 20
            const RateYourMeal(), // 21
            const CouponList(), // 22
            const BookTable(), //23
            const ChangePassword(), // 24
            const ChangePasswordSuccessFully(), //25
            const InvoiceDetails(), //26
            const NotificationScreen(), // 27
            const TermsConditions(), // 28
            const RefundPolicy(), // 29
            const PrivacyPolicy(), // 30
            const AddNewAddress(), // 31
            const LoginScreen(), //32
            const FavouriteDetail(), // 33
            const SpecialFoodDetail(), // 34
            const DealsDetail(), // 35
            const GroupDeals(), // 36
            const RestaurantListForChat(), //37
            const ChatScreen(), // 38
            const RestaurantProductDetail(), // 39
            const RestaurantProductsList(), // 40
            const RestaurantDealDetail(), //41
          ],
        ),
      ),
    );
  }
}
