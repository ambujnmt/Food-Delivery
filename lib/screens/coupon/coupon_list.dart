import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:get/get.dart';

import '../../constants/text_constants.dart';

class CouponList extends StatefulWidget {
  const CouponList({super.key});

  @override
  State<CouponList> createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  TextEditingController coupanCodeController = TextEditingController();
  final customText = CustomText();
  final api = API();
  bool isApiCalling = false;
  bool searching = false;
  List<dynamic> coupanList = [];
  coupanListData({String? couponTitle = "", String? couponCode = ""}) async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.coupanList(
      restaurantId: sideDrawerController.couponListRestaurantId,
      couponTitle: couponTitle,
      couponCode: couponCode,
    );
    setState(() {
      coupanList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print('coupan success message: ${response["message"]} : $coupanList');
    } else {
      print('cart list error message: ${response["message"]}: $coupanList');
    }
  }
  @override
  void initState() {
    coupanListData();
    super.initState();
  }
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
            Container(
              height: height * .050,
              child: TextFormField(
                controller: coupanCodeController,
                decoration: InputDecoration(
                  hintText: TextConstants.enterCouponCode,
                  hintStyle: customText.kTextStyle(
                      16, FontWeight.w700, ColorConstants.kPrimary),
                  suffixIcon: searching
                      ? GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              coupanCodeController.clear();
                              searching = false;
                              coupanListData();
                            });
                          },
                          child: const Icon(
                            Icons.clear,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(right: 10, top: 8),
                          child: GestureDetector(
                            onTap: () {
                              // start searching
                              print(
                                  "controller value: ${coupanCodeController.text.toString()}");
                              setState(() {
                                coupanListData(
                                  couponCode:
                                      coupanCodeController.text.toString(),
                                  couponTitle:
                                      coupanCodeController.text.toString(),
                                );
                                searching = true;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            child: customText.kText(
                                TextConstants.apply,
                                16,
                                FontWeight.w700,
                                ColorConstants.lightGreyColor,
                                TextAlign.center),
                          ),
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: ColorConstants.lightGreyColor),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: ColorConstants.lightGreyColor),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ),
            coupanCodeController.text.isEmpty
                ? const SizedBox(
                    height: 5,
                  )
                : Container(),
            SizedBox(height: height * .020),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: customText.kText(
                TextConstants.offers,
                20,
                FontWeight.w700,
                ColorConstants.kPrimary,
                TextAlign.start,
              ),
            ),
            Expanded(
              child: isApiCalling
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary),
                    )
                  : coupanList.isEmpty
                      ? const CustomNoDataFound()
                      : Container(
                          child: ListView.builder(
                              itemCount: coupanList.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                    onTap: () {
                                      sideDrawerController.couponId =
                                          coupanList[index]['id'].toString();
                                      sideDrawerController.couponType =
                                          coupanList[index]['coupon_type'];
                                      sideDrawerController.couponAmount =
                                          double.parse(coupanList[index]
                                                  ['coupon_amount']
                                              .toString());
                                      sideDrawerController.index.value = 15;
                                      sideDrawerController.pageController
                                          .jumpToPage(
                                              sideDrawerController.index.value);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      height: height * .2,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: ColorConstants.lightGreyColor,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: double.infinity,
                                            width: width * .1,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              color: ColorConstants.kPrimary,
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 0,
                                                      left: 10,
                                                      top: 10),
                                                  child: customText.kText(
                                                    "${coupanList[index]['coupon_code']}",
                                                    20,
                                                    FontWeight.w700,
                                                    ColorConstants.kPrimary,
                                                    TextAlign.start,
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 10,
                                                      top: 0),
                                                  child: customText.kText(
                                                    "Save -\$${coupanList[index]['coupon_amount']} on this order!",
                                                    14,
                                                    FontWeight.w700,
                                                    Colors.black,
                                                    TextAlign.start,
                                                  ),
                                                ),
                                                Container(
                                                  width: width * .75,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: customText.kText(
                                                          TextConstants.apply,
                                                          20,
                                                          FontWeight.w700,
                                                          ColorConstants
                                                              .kPrimary,
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
                                                  color: ColorConstants
                                                      .lightGreyColor,
                                                ),
                                                Container(
                                                  width: width * .75,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10, left: 10),
                                                  child: customText.kText(
                                                    "${coupanList[index]['description']}",
                                                    12,
                                                    FontWeight.w700,
                                                    ColorConstants
                                                        .lightGreyColor,
                                                    TextAlign.start,
                                                    TextOverflow.ellipsis,
                                                    2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
