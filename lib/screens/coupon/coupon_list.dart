import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

import '../../constants/text_constants.dart';

class CouponList extends StatefulWidget {
  const CouponList({super.key});

  @override
  State<CouponList> createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  final customText = CustomText();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "${TextConstants.enterCouponCode}",
                hintStyle: customText.kTextStyle(
                    20, FontWeight.w700, ColorConstants.kPrimary),
                suffixText: "${TextConstants.apply}",
                suffixStyle: customText.kTextStyle(
                    16, FontWeight.w700, ColorConstants.lightGreyColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1,
                      color: ColorConstants.lightGreyColor), //<-- SEE HERE
                  borderRadius: BorderRadius.circular(50.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1,
                      color: ColorConstants.lightGreyColor), //<-- SEE HERE
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            SizedBox(height: height * .020),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: customText.kText(
                TextConstants.bestCoupon,
                20,
                FontWeight.w700,
                ColorConstants.kPrimary,
                TextAlign.start,
              ),
            ),
            SizedBox(height: height * .020),
            couponCardWidet(),
            SizedBox(height: height * .020),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: customText.kText(
                TextConstants.moreOffers,
                20,
                FontWeight.w700,
                ColorConstants.kPrimary,
                TextAlign.start,
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      couponCardWidet(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget couponCardWidet() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .2,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.lightGreyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: double.infinity,
            width: width * .1,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              color: ColorConstants.kPrimary,
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 0, left: 10, top: 10),
                  child: customText.kText(
                    "WELCOMBACK100",
                    20,
                    FontWeight.w700,
                    ColorConstants.kPrimary,
                    TextAlign.start,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10, left: 10, top: 0),
                  child: customText.kText(
                    "Save -\$10.00 on this order!",
                    14,
                    FontWeight.w700,
                    Colors.black,
                    TextAlign.start,
                  ),
                ),
                Container(
                  width: width * .75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: customText.kText(
                          TextConstants.apply,
                          20,
                          FontWeight.w700,
                          ColorConstants.kPrimary,
                          TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * .010),
                Container(
                  width: width * .75,
                  height: 1,
                  color: ColorConstants.lightGreyColor,
                ),
                Container(
                  width: width * .75,
                  margin: EdgeInsets.only(bottom: 10, left: 10),
                  child: customText.kText(
                    "Lorem Ipsum is simply dummy text of the printing and type setting industry. Lorem Ipsum is simply dummy text of the printing and type setting industry Lorem Ipsum is simply dummy text of the printing and type setting industry.",
                    12,
                    FontWeight.w700,
                    ColorConstants.lightGreyColor,
                    TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
