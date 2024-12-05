import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class SpecialFood extends StatefulWidget {
  const SpecialFood({super.key});

  @override
  State<SpecialFood> createState() => _SpecialFoodState();
}

class _SpecialFoodState extends State<SpecialFood> {

  dynamic size;
  final customText = CustomText();
  String networkImgUrl = "https://s3-alpha-sig.figma.com/img/2d0c/88be/5584e0af3dc9e87947fcb237a160d230?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N3MZ8MuVlPrlR8KTBVNhyEAX4fwc5fejCOUJwCEUpdBsy3cYwOOdTvBOBOcjpLdsE3WXcvCjY5tjvG8bofY3ivpKb5z~b3niF9jcICifVqw~jVvfx4x9WDa78afqPt0Jr4tm4t1J7CRF9BHcokNpg9dKNxuEBep~Odxmhc511KBkoNjApZHghatTA0LsaTexfSZXYvdykbhMuNUk5STsD5J4zS8mjCxVMRX7zuMXz85zYyfi7cAfX5Z6LVsoW0ngO7L6HKAcIgN4Rry9Lj2OFba445Mpd4Mx8t0fcsDPwQPbUDPHiBf3G~6HHcWjCBHKV0PiBZmt86HcvZntkFzWYg__";


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
                    margin: EdgeInsets.only(bottom: size.height * 0.01),
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
                              customText.kText(TextConstants.specialFood, 28, FontWeight.w900, Colors.white, TextAlign.center),
                              SizedBox(height: size.height * 0.01,),
                              RichText(
                                text: TextSpan(
                                    text: TextConstants.home,
                                    style: customText.kSatisfyTextStyle(24, FontWeight.w400, Colors.white),
                                    children: [
                                      TextSpan(
                                          text: " / ${TextConstants.specialFood}",
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

            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 15.0,
                // crossAxisSpacing: 10.0,
                childAspectRatio: 1/1.4,
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      decoration: BoxDecoration(
                        // color: Colors.teal[100 * (index % 9)],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size.width * 0.05),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black26
                          )
                        ]
                      ),
                      child: Column(
                        children: [

                          Container(
                            height: size.height * 0.14,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(size.width * 0.05),
                                topRight: Radius.circular(size.width * 0.05),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(networkImgUrl),
                                fit: BoxFit.cover
                              )
                            ),
                          ),

                          GestureDetector(
                            child: Container(
                              height: size.height * 0.03,
                              decoration: const BoxDecoration(
                                color: ColorConstants.kPrimary,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0,1),
                                    blurRadius: 4,
                                    color: Colors.black26
                                  )
                                ]
                              ),
                              child: Center(
                                child: customText.kText(TextConstants.addToCart, 16, FontWeight.w700, Colors.white, TextAlign.center),
                              ),
                            ),
                            onTap: () {

                            },
                          ),

                          Container(
                              height: size.height * 0.05,
                              // color: Colors.yellow.shade200,
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                              child: Center(
                                child: customText.kText("Restaurant name", 14, FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
                              )
                          ),

                          Container(
                            height: size.height * 0.055,
                            // color: Colors.yellow,
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                            child: Center(
                              child: customText.kText("Food Item Name", 16, FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
                            )
                          ),

                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    SizedBox(
                                      // color: Colors.lightGreen,
                                      width: size.width * 0.2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const CircleAvatar(
                                            radius: 9,
                                            backgroundColor: ColorConstants.kLike,
                                            child: Icon(Icons.thumb_up, color: Colors.white, size: 10,),
                                          ),
                                          customText.kText("20", 14, FontWeight.w900, ColorConstants.kLike, TextAlign.start),

                                          const CircleAvatar(
                                            radius: 9,
                                            backgroundColor: ColorConstants.kDisLike,
                                            child: Icon(Icons.thumb_up, color: Colors.white, size: 10,),
                                          ),
                                          customText.kText("10", 14, FontWeight.w900, ColorConstants.kDisLike, TextAlign.start),
                                        ],
                                      )
                                    ),

                                    Container(
                                      width: size.width * 0.15,
                                      // color: Colors.yellow,
                                      child: customText.kText("\$200", 18, FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
                                    ),

                                    Icon(Icons.favorite, size: 25, color: Colors.red)

                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: 3,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
