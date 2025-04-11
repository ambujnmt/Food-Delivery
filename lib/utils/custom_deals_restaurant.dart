// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomDealsRestaurant extends StatefulWidget {
  String? imageURL;
  String? addTocart;
  String? foodItemName;
  String? amount;
  Function()? addToCartPress;
  Function()? imagePress;

  CustomDealsRestaurant({
    super.key,
    this.imageURL,
    this.addTocart,
    this.foodItemName,
    this.amount,
    this.addToCartPress,
    this.imagePress,
  });

  @override
  State<CustomDealsRestaurant> createState() => _CustomDealsRestaurantState();
}

class _CustomDealsRestaurantState extends State<CustomDealsRestaurant> {
  final customText = CustomText();

  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
      decoration: BoxDecoration(
          // color: Colors.teal[100 * (index % 9)],
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
          GestureDetector(
            onTap: widget.imagePress,
            child: Container(
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
          ),
          GestureDetector(
            child: Container(
              height: size.height * 0.03,
              decoration: const BoxDecoration(
                  color: ColorConstants.kPrimary,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 4,
                        color: Colors.black26)
                  ]),
              child: Center(
                child: customText.kText(widget.addTocart.toString(), 16,
                    FontWeight.w700, Colors.white, TextAlign.center),
              ),
            ),
            onTap: widget.addToCartPress,
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                // color: Colors.yellow.shade200,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width * 0.05),
                    bottomRight: Radius.circular(size.width * 0.05))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: size.height * .005),
                Container(
                  child: customText.kText(
                      "${widget.foodItemName}",
                      16,
                      FontWeight.w700,
                      ColorConstants.kPrimary,
                      TextAlign.center,
                      TextOverflow.ellipsis,
                      1),
                ),
                Container(
                  child: customText.kText(
                      "${widget.amount}",
                      16,
                      FontWeight.w500,
                      ColorConstants.kPrimary,
                      TextAlign.center),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
