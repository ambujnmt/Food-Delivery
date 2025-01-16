import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomFoodItem extends StatefulWidget {
  String? imageURL;
  String? addTocart;
  String? restaurantName;
  String? foodItemName;
  String? amount;
  String? likeCount;
  String? dislikeCount;
  IconData? likeIcon;
  IconData? dislikeIcon;
  IconData? favouriteIcon;
  Function()? favouritePress;
  CustomFoodItem({
    super.key,
    this.imageURL,
    this.addTocart,
    this.restaurantName,
    this.foodItemName,
    this.amount,
    this.likeIcon,
    this.dislikeIcon,
    this.likeCount,
    this.dislikeCount,
    this.favouriteIcon,
  });

  @override
  State<CustomFoodItem> createState() => _CustomFoodItemState();
}

class _CustomFoodItemState extends State<CustomFoodItem> {
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
            onTap: () {},
          ),
          Container(
              height: size.height * 0.05,
              // color: Colors.yellow.shade200,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              child: Center(
                child: customText.kText(widget.restaurantName.toString(), 14,
                    FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
              )),
          Container(
              height: size.height * 0.055,
              // color: Colors.yellow,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              child: Center(
                child: customText.kText(widget.foodItemName.toString(), 16,
                    FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
              )),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        // color: Colors.lightGreen,
                        width: size.width * 0.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 9,
                              backgroundColor: ColorConstants.kLike,
                              child: Icon(
                                widget.likeIcon,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                            customText.kText(
                                widget.likeCount.toString(),
                                14,
                                FontWeight.w900,
                                ColorConstants.kLike,
                                TextAlign.start),
                            CircleAvatar(
                              radius: 9,
                              backgroundColor: ColorConstants.kDisLike,
                              child: Icon(
                                widget.dislikeIcon,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                            customText.kText(
                                widget.dislikeCount.toString(),
                                14,
                                FontWeight.w900,
                                ColorConstants.kDisLike,
                                TextAlign.start),
                          ],
                        )),
                    Container(
                      width: size.width * 0.15,
                      // color: Colors.yellow,
                      child: customText.kText(
                          "\$${widget.amount}",
                          18,
                          FontWeight.w700,
                          ColorConstants.kPrimary,
                          TextAlign.center),
                    ),
                    GestureDetector(
                      onTap: widget.favouritePress,
                      child: Icon(
                        widget.favouriteIcon,
                        size: 25,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
