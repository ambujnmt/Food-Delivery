import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomBestDeals extends StatefulWidget {
  String? imageURL;
  String? addTocart;
  String? restaurantName;
  String? foodItemName;
  String? distance;
  String? amount;
  String? likeCount;
  String? dislikeCount;
  IconData? likeIcon;
  IconData? dislikeIcon;
  IconData? favouriteIcon;
  Function()? favouritePress;
  Function()? addToCartPress;
  Function()? imagePress;
  Function()? likePress;
  Function()? dislikePress;
  CustomBestDeals(
      {super.key,
      this.imageURL,
      this.addTocart,
      this.restaurantName,
      this.foodItemName,
      this.distance,
      this.amount,
      this.likeIcon,
      this.dislikeIcon,
      this.likeCount,
      this.dislikeCount,
      this.favouriteIcon,
      this.addToCartPress,
      this.imagePress,
      this.likePress,
      this.dislikePress,
      this.favouritePress});

  @override
  State<CustomBestDeals> createState() => _CustomBestDealsState();
}

class _CustomBestDealsState extends State<CustomBestDeals> {
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
          SizedBox(height: size.height * .010),
          Container(
              child: Center(
            child: customText.kText(widget.restaurantName.toString(), 16,
                FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
          )),
          SizedBox(height: size.height * .010),
          Container(
              child: Center(
            child: customText.kText(widget.foodItemName.toString(), 16,
                FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
          )),
          SizedBox(height: size.height * .010),
          Container(
              child: Center(
            child: customText.kText(widget.distance.toString(), 16,
                FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
          )),
          SizedBox(height: size.height * .010),
          Container(
            child: customText.kText("${widget.amount}", 18, FontWeight.w700,
                ColorConstants.kPrimary, TextAlign.center),
          ),
          SizedBox(height: size.height * .010),
        ],
      ),
    );
  }
}
