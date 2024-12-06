// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_button2.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';

class BookTable extends StatefulWidget {
  const BookTable({super.key});

  @override
  State<BookTable> createState() => _BookTableState();
}

class _BookTableState extends State<BookTable> {
  final customText = CustomText();
  String dropdownvalue = 'Select Restaurant';
  var items = [
    'Select Restaurant',
    'Hotel 1',
    'Hotel 2',
    'Hotel 3',
    'Hotel 4',
  ];
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.06,
              width: width,
              color: Colors.grey.shade300,
            ),
            Container(
              height: height * 0.18,
              width: width,
              margin: EdgeInsets.only(bottom: height * 0.01),
              decoration: const BoxDecoration(
                  color: Colors.yellow,
                  image: DecorationImage(
                      image: AssetImage("assets/images/banner.png"),
                      fit: BoxFit.fitHeight)),
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
                        customText.kText(TextConstants.bookATable, 28,
                            FontWeight.w900, Colors.white, TextAlign.center),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        RichText(
                          text: TextSpan(
                              text: TextConstants.home,
                              style: customText.kSatisfyTextStyle(
                                  24, FontWeight.w400, Colors.white),
                              children: [
                                TextSpan(
                                    text: " / ${TextConstants.table}",
                                    style: customText.kSatisfyTextStyle(
                                        24,
                                        FontWeight.w400,
                                        ColorConstants.kPrimary))
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * .020),
            Container(
                margin: EdgeInsets.only(bottom: 10, left: 20),
                child: Center(
                  child: customText.kText(
                    TextConstants.bookATable,
                    20,
                    FontWeight.w800,
                    ColorConstants.kPrimary,
                    TextAlign.start,
                  ),
                )),
            Container(
                margin: EdgeInsets.only(bottom: 10, left: 20),
                child: customText.kText(
                  TextConstants.selectableRestaurant,
                  20,
                  FontWeight.w800,
                  Colors.black,
                  TextAlign.start,
                )),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorConstants.lightGreyColor, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorConstants.lightGreyColor, width: 1),
                  ),
                ),
                style: customText.kTextStyle(
                  16,
                  FontWeight.w800,
                  ColorConstants.lightGreyColor,
                ),
                isExpanded: true,
                value: dropdownvalue,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorConstants.kPrimary,
                  size: 28,
                ),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: ColorConstants.lightGreyColor),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    print("Drop down value: ${dropdownvalue}");
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: CustomFormField2(
                hintText: TextConstants.fullName,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: CustomFormField2(
                hintText: TextConstants.phone,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: CustomFormField2(
                hintText: TextConstants.emailAddress,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: CustomFormField2(
                hintText: TextConstants.numberOfPeople,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: CustomFormField2(
                hintText: TextConstants.slelctDate,
                suffixIcon: Icon(
                  Icons.calendar_month,
                  color: ColorConstants.kPrimary,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: CustomFormField2(
                hintText: TextConstants.selecttime,
                suffixIcon: Icon(
                  Icons.watch_later_sharp,
                  color: ColorConstants.kPrimary,
                ),
              ),
            ),
            SizedBox(height: height * .020),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child:
                  CustomButton(fontSize: 20, hintText: TextConstants.bookNow),
            ),
          ],
        )),
      ),
    );
  }
}
