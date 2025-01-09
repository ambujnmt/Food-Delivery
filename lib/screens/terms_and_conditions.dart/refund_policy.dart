import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class RefundPolicy extends StatefulWidget {
  const RefundPolicy({super.key});

  @override
  State<RefundPolicy> createState() => _RefundPolicyState();
}

class _RefundPolicyState extends State<RefundPolicy> {
  dynamic size;
  final customText = CustomText();

  bool isApiCalling = false;
  int aboutUsIndex = 0;
  final api = API();
  List<dynamic> refundPolicyList = [];

  String image = "";

// refund policy
  refundPolicyData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.returnAndRefundPolicy();
    setState(() {
      refundPolicyList = response['data'];

      image = refundPolicyList[0]['image'];
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
    refundPolicyData();
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
          : refundPolicyList.isEmpty
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
                                "Refund Policy",
                                24,
                                FontWeight.w900,
                                Colors.white,
                                TextAlign.center),
                          ),
                        ),
                        sliderWidget(image.toString()),
                        SizedBox(height: size.height * .010),
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          height: size.height * .7,
                          width: double.infinity,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: refundPolicyList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              children: [
                                Container(
                                  width: size.width,
                                  child: customText.kText(
                                      refundPolicyList[index]['title'],
                                      18,
                                      FontWeight.w900,
                                      Colors.black,
                                      TextAlign.start),
                                ),
                                SizedBox(height: size.height * .010),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  width: size.width,
                                  child: HtmlWidget(
                                    "${refundPolicyList[index]['description']}",
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
