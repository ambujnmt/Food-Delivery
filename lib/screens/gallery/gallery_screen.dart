import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  dynamic size;
  final customText = CustomText();
  bool isApiCalling = false;
  final api = API();
  List<dynamic> imagesList = [];
  List<dynamic> bestDealsList = [];

  galleryImagesData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.galleryImages();
    setState(() {
      imagesList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('about us success message: ${response["message"]}');
    } else {
      print('about us error message: ${response["message"]}');
    }
  }

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
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    galleryImagesData();
    bestDealsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: isApiCalling
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.kPrimary,
                ),
              )
            : imagesList.isEmpty
                ? Center(
                    child: Container(
                      height: size.height * 0.25,
                      width: size.width,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8)),
                          height: 50,
                          width: size.width * .400,
                          child: Center(
                            child: customText.kText(
                                "No data found",
                                15,
                                FontWeight.w700,
                                Colors.black,
                                TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: size.height,
                    width: size.width,
                    padding: EdgeInsets.only(bottom: size.height * 0.02),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(bottom: size.height * 0.01),
                            child: Column(
                              children: [
                                Container(
                                  height: size.height * .060,
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
                                            sideDrawerController.index.value =
                                                4;
                                            sideDrawerController.pageController
                                                .jumpToPage(sideDrawerController
                                                    .index.value);
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
                                Container(
                                  height: size.height * 0.18,
                                  width: size.width,
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
                                                TextConstants.gallery,
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
                                                  style: customText
                                                      .kSatisfyTextStyle(
                                                          24,
                                                          FontWeight.w400,
                                                          Colors.white),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            " / ${TextConstants.gallery}",
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
                        ),
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 15.0,
                            // crossAxisSpacing: 10.0,
                            childAspectRatio: 1 / 0.9,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            childCount: imagesList.length,
                            (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.05),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 4,
                                        color: Colors.black26)
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        imagesList[index]['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ));
  }
}
