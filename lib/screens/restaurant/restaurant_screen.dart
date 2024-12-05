import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {

  dynamic size;
  final customText = CustomText();

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

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
                    height: size.height * 0.06,
                    width: size.width,
                    color: Colors.grey.shade300,
                  ),

                  Container(
                    height: size.height * 0.18,
                    width: size.width,
                    decoration: const BoxDecoration(
                        color: Colors.yellow,
                        image: DecorationImage(
                            image: AssetImage("assets/images/banner.png"),
                            fit: BoxFit.fitHeight
                        )
                    ),
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
                              customText.kText(TextConstants.restaurant, 28, FontWeight.w900, Colors.white, TextAlign.center),
                              SizedBox(height: size.height * 0.01,),
                              RichText(
                                text: TextSpan(
                                    text: TextConstants.home,
                                    style: customText.kSatisfyTextStyle(24, FontWeight.w400, Colors.white),
                                    children: [
                                      TextSpan(
                                          text: " / ${TextConstants.restaurant}",
                                          style: customText.kSatisfyTextStyle(24, FontWeight.w400, ColorConstants.kPrimary)
                                      )
                                    ]
                                ),
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

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    child: Container(
                      height: size.height * 0.15,
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                      margin: EdgeInsets.only(bottom: size.height * 0.01, top: size.height * 0.01),
                      color: Colors.yellow.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height * 0.14,
                            width: size.width * 0.35,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(size.width * 0.05)
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                    
                              SizedBox(
                                height: size.height * 0.08,
                                width: size.width * 0.55,
                                child: customText.kText("Restaurant ${index +1}", 20, FontWeight.w700, ColorConstants.kPrimary, TextAlign.start),
                              ),
                    
                              SizedBox(
                                width: size.width * 0.55,
                                child: RatingBar.builder(
                                  ignoreGestures: true,
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemSize: 20,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                    
                                  },
                                ),
                              ),
                    
                              SizedBox(
                                width: size.width * 0.55,
                                child: customText.kText("Distance : 15.0 Mls", 14, FontWeight.w500, Colors.black, TextAlign.start),
                              ),
                    
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      sideDrawerController.index.value = 16;
                      sideDrawerController.pageController.jumpToPage(sideDrawerController.index.value);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const RestaurantDetail() ));
                    },
                  );
                },
                childCount: 7
              ),
            ),

          ],

        )
      ),
    );
  }
}
