import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  dynamic size;
  final customText = CustomText();

  bool isApiCalling = false;
  int aboutUsIndex = 0;
  final api = API();
  List<dynamic> termsAndConditionsList = [];
  String title = "";
  String descriptions = "";
  String image = "";

// terms and conditions
  termsAndConditionsData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.termsAndConditions();
    setState(() {
      termsAndConditionsList = response['data'];
      title = termsAndConditionsList[0]['title'];
      descriptions = termsAndConditionsList[0]['description'];
      image = termsAndConditionsList[0]['image'];
    });
    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('terms and conditions success message: ${response["message"]}');
    } else {
      print('terms and conditions error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    termsAndConditionsData();

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
          : termsAndConditionsList.isEmpty
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
                                "Terms & Conditions",
                                24,
                                FontWeight.w900,
                                Colors.white,
                                TextAlign.center),
                          ),
                        ),
                        sliderWidget(image.toString()),
                        Container(
                          width: size.width,
                          child: customText.kText(title.toString(), 18,
                              FontWeight.w900, Colors.black, TextAlign.center),
                        ),
                        SizedBox(height: size.height * .010),
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          width: size.width,
                          child: customText.kText(
                              descriptions.toString(),
                              18,
                              FontWeight.w700,
                              Colors.black,
                              TextAlign.start,
                              TextOverflow.visible,
                              500),
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
