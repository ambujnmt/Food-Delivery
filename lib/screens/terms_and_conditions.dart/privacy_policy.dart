import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  dynamic size;
  final customText = CustomText();

  bool isApiCalling = false;
  int aboutUsIndex = 0;
  final api = API();
  List<dynamic> privacyPolicyList = [];

  String image = "";

// terms and conditions
  privacyPolicyData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.privacyPolicy();
    setState(() {
      privacyPolicyList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('return and refund success message: ${response["message"]}');
    } else {
      print('return and refund error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    privacyPolicyData();
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
          : privacyPolicyList.isEmpty
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
                    scrollDirection: Axis.vertical,
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
                                "Privacy & Policy",
                                24,
                                FontWeight.w900,
                                Colors.white,
                                TextAlign.center),
                          ),
                        ),
                        SizedBox(height: size.height * .010),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child:Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            height: size.height * .7,
                            width: double.infinity,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: privacyPolicyList.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Column(
                                    children: [
                                      Container(
                                        width: size.width,
                                        child: customText.kText(
                                            privacyPolicyList[index]['title'],
                                            18,
                                            FontWeight.w900,
                                            Colors.black,
                                            TextAlign.start),
                                      ),
                                      SizedBox(height: size.height * .010),
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        width: size.width,
                                        child: HtmlWidget(
                                          "${privacyPolicyList[index]['description']}",
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Raleway"),
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * .010),
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
