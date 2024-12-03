import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/about%20us/about_us.dart';
import 'package:food_delivery/screens/address/address_screen.dart';
import 'package:food_delivery/screens/cart/cart_screen.dart';
import 'package:food_delivery/screens/contact%20us/contact_us.dart';
import 'package:food_delivery/screens/favourite/favourite_screen.dart';
import 'package:food_delivery/screens/food%20category/food_category.dart';
import 'package:food_delivery/screens/gallery/gallery_screen.dart';
import 'package:food_delivery/screens/home/home_screen.dart';
import 'package:food_delivery/screens/order%20history/order_history.dart';
import 'package:food_delivery/screens/profile/profile_screen.dart';
import 'package:food_delivery/screens/restaurant/restaurant_screen.dart';
import 'package:food_delivery/screens/special%20food/special_food.dart';
import 'package:food_delivery/screens/testimonial/testimonial_screen.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'dart:developer';
import 'package:get/get.dart';

class SideMenuDrawer extends StatefulWidget {
  const SideMenuDrawer({super.key});

  @override
  State<SideMenuDrawer> createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {

  dynamic size;
  final customText = CustomText();
  GlobalKey<ScaffoldState> key = GlobalKey();

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  customAppBar() {
    return Container(
      decoration: const BoxDecoration(
          color: ColorConstants.kPrimary
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: size.width * 0.85,
            child: Image.asset("assets/images/name_logo.png"),
          ),
          Padding(
            // color: Colors.yellow,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                GestureDetector(
                  child: SizedBox(
                    height: size.width * 0.07,
                    child: Image.asset("assets/images/menu.png"),
                  ),
                  onTap: () {
                    key.currentState!.openDrawer();
                  },
                ),

                Row(
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.account_circle  , color: Colors.white, size: 30),
                      onTap: () {},
                    ),
                    SizedBox(width: size.width * 0.02),
                    GestureDetector(
                      child: const Icon(Icons.favorite  , color: Colors.white, size: 30),
                      onTap: () {},
                    ),
                    SizedBox(width: size.width * 0.02),
                    GestureDetector(
                      child: const Icon(Icons.shopping_cart_rounded  , color: Colors.white, size: 30),
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01,)
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
        width: size.width * 0.6,
        margin: EdgeInsets.only(bottom: size.width * 0.02,),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        decoration: BoxDecoration(
          // color: Colors.yellow,
          border: sideDrawerController.index.value == selectedIndex ? customSelectedBorder() : customUnselectedBorder(),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(size.width * 0.03),
              bottomRight: Radius.circular(size.width * 0.03)
          ),
        ),
        child: Row(
          children: [
            ImageIcon(
              AssetImage(image),
              color: ColorConstants.kPrimary,
              size: 30,
            ),
            SizedBox(width: size.width * 0.03),
            customText.kText(title, 20, FontWeight.w900, Colors.black, TextAlign.center)
          ],
        ),
      ),
      onTap: () {
        sideDrawerController.index.value = selectedIndex;
        sideDrawerController.pageController.jumpToPage(selectedIndex);
        key.currentState!.closeDrawer();
        setState(() {});
      },
    );
  }

  customDrawer() {
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

                Container(
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
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            image: DecorationImage(
                                image: AssetImage("assets/images/delivery_logo.png"),
                            ),
                            shape: BoxShape.circle,
                          )
                        ),
                      ),

                      Container(
                        height: size.height * 0.1,
                        width: size.width * 0.45,
                        // color: Colors.yellow,
                        child: customText.kText("Hanna", 30, FontWeight.w700, Colors.white, TextAlign.start),
                      )

                    ],
                  ),
                ),

                const SizedBox(height: 2,),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Wrap(
                      spacing: 5,
                      children: [
                        const Icon(Icons.settings, size: 25, color: Colors.white,),
                        customText.kText(TextConstants.logOut, 16, FontWeight.w900, Colors.white, TextAlign.center)
                      ],
                    ),
                    onTap: () {
                      log("log out pressed");
                    },
                  ),
                )

              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  customTile(0, TextConstants.home, "assets/images/home.png"),
                  customTile(1, TextConstants.restaurant, "assets/images/restaurant.png"),
                  customTile(2, TextConstants.specialFood, "assets/images/specialFood.png"),
                  customTile(3, TextConstants.foodCategory, "assets/images/foodCategory.png"),
                  customTile(4, TextConstants.profile, "assets/images/profile.png"),
                  customTile(5, TextConstants.gallery, "assets/images/gallery.png"),
                  customTile(6, TextConstants.contactUs, "assets/images/contactUs.png"),
                  customTile(7, TextConstants.orderHistory, "assets/images/clock.png"),
                  customTile(8, TextConstants.address, "assets/images/address.png"),
                  customTile(9, TextConstants.favourite, "assets/images/favourite.png"),
                  customTile(10, TextConstants.testimonials, "assets/images/testimonial.png"),
                  customTile(11, TextConstants.aboutUs, "assets/images/aboutUs.png"),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: customAppBar()
      ),

      // drawer: customDrawer(),

      drawer: Obx(() {
        return customDrawer();
      }),

      body: Container(
        color: Colors.grey.shade400,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: sideDrawerController.pageController,
          children: const [
            HomeScreen(), // 0
            RestaurantScreen(), // 1
            SpecialFood(), // 2
            FoodCategory(), // 3
            ProfileScreen(), // 4
            GalleryScreen(), // 5
            ContactUs(), // 6
            OrderHistory(), // 7
            AddressScreen(), // 8
            FavouriteScreen(), // 9
            TestimonialScreen(), // 10
            AboutUs(), // 11
            CartScreen(), // 12
          ],
        ),
      ),
    );
  }
}
