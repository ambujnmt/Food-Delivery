import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_product_item.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:get/get.dart';

class PopularsScreen extends StatefulWidget {
  const PopularsScreen({super.key});

  @override
  State<PopularsScreen> createState() => _PopularsScreenState();
}

class _PopularsScreenState extends State<PopularsScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  final customText = CustomText();
  String networkImgUrl =
      "https://s3-alpha-sig.figma.com/img/2d0c/88be/5584e0af3dc9e87947fcb237a160d230?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N3MZ8MuVlPrlR8KTBVNhyEAX4fwc5fejCOUJwCEUpdBsy3cYwOOdTvBOBOcjpLdsE3WXcvCjY5tjvG8bofY3ivpKb5z~b3niF9jcICifVqw~jVvfx4x9WDa78afqPt0Jr4tm4t1J7CRF9BHcokNpg9dKNxuEBep~Odxmhc511KBkoNjApZHghatTA0LsaTexfSZXYvdykbhMuNUk5STsD5J4zS8mjCxVMRX7zuMXz85zYyfi7cAfX5Z6LVsoW0ngO7L6HKAcIgN4Rry9Lj2OFba445Mpd4Mx8t0fcsDPwQPbUDPHiBf3G~6HHcWjCBHKV0PiBZmt86HcvZntkFzWYg__";
  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
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
                    height: size.height * 0.06,
                    width: size.width,
                    color: Colors.grey.shade300,
                  ),
                  Container(
                    height: size.height * 0.18,
                    width: size.width,
                    margin: EdgeInsets.only(bottom: size.height * 0.01),
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
                                  TextConstants.populars,
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
                                    style: customText.kSatisfyTextStyle(
                                        24, FontWeight.w400, Colors.white),
                                    children: [
                                      TextSpan(
                                          text: " / ${TextConstants.populars}",
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
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 15.0,
                // crossAxisSpacing: 10.0,
                childAspectRatio: 1 / 1.4,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: GestureDetector(
                      onTap: () {
                        // sideDrawerController.index.value = 18;
                        // sideDrawerController.pageController
                        //     .jumpToPage(sideDrawerController.index.value);
                      },
                      child: CustomFoodItem(
                        addTocart: TextConstants.addToCart,
                        amount: "200",
                        imageURL: networkImgUrl,
                        foodItemName: "Food Item Name",
                        restaurantName: "Restaurant Name",
                        likeIcon: Icons.thumb_up,
                        dislikeIcon: Icons.thumb_up,
                        favouriteIcon: Icons.favorite,
                      ),
                    ),
                  );
                },
                childCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
