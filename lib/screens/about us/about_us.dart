import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class AboutUs extends StatefulWidget {
  final String title;
  const AboutUs({super.key, required this.title});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  dynamic size;
  final customText = CustomText();

  bool isApiCalling = false;
  int aboutUsIndex = 0;
  final api = API();
  List<dynamic> aboutUsList = [];
  // view all category
  String? image1;
  String? image2;
  String? image3;
  String? leftImage;
  String? rightImage;
  String? titleImage;
  String? titleContent;
  String? description;
  String? ourStory;

  aboutUsData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.aboutUs();
    setState(() {
      aboutUsList = response['data'];
      image1 = aboutUsList[0]['image_1'];
      image2 = aboutUsList[0]['image_2'];
      image3 = aboutUsList[0]['image_3'];
      leftImage = aboutUsList[0]['leftImage'];
      rightImage = aboutUsList[0]['rightImage'];
      titleImage = aboutUsList[0]['title_img'];
      titleContent = aboutUsList[0]['title_content'];
      description = aboutUsList[0]['description'];
      ourStory = aboutUsList[0]['ourStory'];
    });
    setState(() {
      isApiCalling = false;
    });

    print("title image: $titleImage");

    if (response["status"] == true) {
      print('about us success message: ${response["message"]}');

      print('about us list: ${aboutUsList}');
    } else {
      print('about us error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    aboutUsData();
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
          : aboutUsList.isEmpty
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
                          child: customText.kText("No data found", 15,
                              FontWeight.w700, Colors.black, TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: size.height,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: size.height * 0.05,
                          width: size.width * 0.6,
                          margin:
                              EdgeInsets.symmetric(vertical: size.width * 0.03),
                          decoration: BoxDecoration(
                              color: ColorConstants.kPrimary,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.05)),
                          child: Center(
                            child: customText.kText(
                                widget.title,
                                24,
                                FontWeight.w900,
                                Colors.white,
                                TextAlign.center),
                          ),
                        ),
                        // carousl slider images

                        aboutUsList.isEmpty
                            ? Container(
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
                              )
                            : Container(
                                child: CarouselSlider(
                                  items: [
                                    sliderWidget(titleImage.toString()),
                                    sliderWidget(leftImage.toString()),
                                    sliderWidget(rightImage.toString()),
                                    sliderWidget(image1.toString()),
                                    sliderWidget(image2.toString()),
                                    sliderWidget(image3.toString()),
                                  ],
                                  options: CarouselOptions(
                                      height: size.height * .2,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      // aspectRatio: 16 / 9,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enableInfiniteScroll: true,
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      viewportFraction: 0.8,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          aboutUsIndex = index;
                                        });
                                      }),
                                ),
                              ),
                        aboutUsList.isEmpty
                            ? Container()
                            : Center(
                                child: DotsIndicator(
                                  // dotsCount: getNearbyRestaurantList.length,
                                  dotsCount: 6,
                                  position: aboutUsIndex,
                                  decorator: const DotsDecorator(
                                    color: Colors.black, // Inactive color
                                    activeColor: ColorConstants.kPrimary,
                                  ),
                                ),
                              ),

                        Container(
                          width: size.width,
                          child: customText.kText(titleContent.toString(), 18,
                              FontWeight.w900, Colors.black, TextAlign.center),
                        ),
                        SizedBox(height: size.height * .010),
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          width: size.width,
                          child: customText.kText(
                              description.toString(),
                              18,
                              FontWeight.w700,
                              Colors.black,
                              TextAlign.start,
                              TextOverflow.visible,
                              500),
                        ),
                        SizedBox(height: size.height * .010),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
                          width: size.width,
                          child: customText.kText(
                              ourStory.toString(),
                              18,
                              FontWeight.w700,
                              Colors.black,
                              TextAlign.start,
                              TextOverflow.visible,
                              500),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget sliderWidget(String url) {
    return Container(
      height: size.height * 0.180,
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(size.width * 0.02),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(url),
        ),
      ),
    );
  }
}
