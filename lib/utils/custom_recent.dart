import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomRecent extends StatefulWidget {
  String? imageURL;
  String? restaurantName;
  String? amount;
  bool product;
  CustomRecent({
    super.key,
    this.imageURL,
    this.restaurantName,
    this.amount,
    this.product = false,
  });

  @override
  State<CustomRecent> createState() => _CustomRecentState();
}

class _CustomRecentState extends State<CustomRecent> {
  final customText = CustomText();

  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.05),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 1), blurRadius: 4, color: Colors.black26)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    image: NetworkImage(
                      widget.imageURL.toString(),
                    ),
                    fit: BoxFit.cover)),
          ),
          SizedBox(height: size.height * .010),
          Container(
              child: Center(
            child: customText.kText(widget.restaurantName.toString(), 16,
                FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
          )),
          SizedBox(height: size.height * .010),
          Visibility(
            visible: widget.product,
            child: Container(
              child: customText.kText("${widget.amount}", 18, FontWeight.w700,
                  ColorConstants.kPrimary, TextAlign.center),
            ),
          ),
          SizedBox(height: size.height * .010),
        ],
      ),
    );
  }
}
