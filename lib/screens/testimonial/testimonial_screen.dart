import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class TestimonialScreen extends StatefulWidget {
  const TestimonialScreen({super.key});

  @override
  State<TestimonialScreen> createState() => _TestimonialScreenState();
}

class _TestimonialScreenState extends State<TestimonialScreen> {
  final customText = CustomText();
  bool isApiCalling = false;
  final api = API();
  List<dynamic> testimonialList = [];
  // testmonials
  testimonilsData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.testimonials();
    setState(() {
      testimonialList = response['data'];
    });

    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('testimonials success message: ${response["message"]}');
    } else {
      print('testimonials error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    testimonilsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: isApiCalling
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.kPrimary,
              ),
            )
          : testimonialList.isEmpty
              ? Center(
                  child: Container(
                    height: height * 0.25,
                    width: width,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                        height: 50,
                        width: width * .400,
                        child: Center(
                          child: customText.kText("No data found", 15,
                              FontWeight.w700, Colors.black, TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: height * .020),
                      Center(
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.6,
                          margin: EdgeInsets.symmetric(vertical: width * 0.03),
                          decoration: BoxDecoration(
                            color: ColorConstants.kPrimary,
                            borderRadius: BorderRadius.circular(width * 0.05),
                          ),
                          child: Center(
                            child: customText.kText(
                              TextConstants.testimonial,
                              20,
                              FontWeight.w900,
                              Colors.white,
                              TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .030),
                      ListView.builder(
                        shrinkWrap:
                            true, // Ensures ListView takes only the required height
                        physics:
                            NeverScrollableScrollPhysics(), // Prevent nested scrolling
                        itemCount: testimonialList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          color: ColorConstants.kPrimary,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * .030),
                              Center(
                                child: customText.kText(
                                  TextConstants.whatDoTheySay,
                                  22,
                                  FontWeight.bold,
                                  Colors.white,
                                  TextAlign.start,
                                ),
                              ),
                              Container(
                                height: height * .5,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/testimonial_circle.png'),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: height * .080,
                                      left: width * .15,
                                      child: Container(
                                        height: height * .200,
                                        width: width * .700,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Center(
                                                child: customText.kText(
                                                  "${testimonialList[index]['title']}",
                                                  18,
                                                  FontWeight.bold,
                                                  ColorConstants.yellowColor,
                                                  TextAlign.start,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: Center(
                                                child: customText.kText(
                                                  "CEO Agency",
                                                  12,
                                                  FontWeight.bold,
                                                  Colors.white,
                                                  TextAlign.start,
                                                  TextOverflow.ellipsis,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                width: width * .22,
                                                height: 1,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: height * .010),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              child: Center(
                                                child: customText.kText(
                                                  "“${testimonialList[index]['description']}”",
                                                  16,
                                                  FontWeight.bold,
                                                  Colors.white,
                                                  TextAlign.start,
                                                  TextOverflow.ellipsis,
                                                  4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: height * .3,
                                      left: width * .6,
                                      child: Container(
                                        height: height * .15,
                                        width: width * .25,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          color: Colors.greenAccent,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                '${testimonialList[index]['image']}'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
