import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomSpecificFood extends StatefulWidget {
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
  Function()? addToCartPress;
  Function()? imagePress;
  Function()? likePress;
  Function()? dislikePress;
  CustomSpecificFood(
      {super.key,
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
      this.addToCartPress,
      this.imagePress,
      this.likePress,
      this.dislikePress,
      this.favouritePress});

  @override
  State<CustomSpecificFood> createState() => _CustomSpecificFoodState();
}

class _CustomSpecificFoodState extends State<CustomSpecificFood> {
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

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                // color: Colors.yellow.shade200,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(size.width * 0.05),
                  bottomRight: Radius.circular(size.width * 0.05)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: size.height * .005),
                  Container(
                    child: customText.kText("${widget.restaurantName}", 16,
                        FontWeight.w700, ColorConstants.kPrimary, TextAlign.center, TextOverflow.ellipsis, 1),
                  ),

                  SizedBox(height: size.height * .005),
                  Container(
                    child: customText.kText("${widget.foodItemName}", 16,
                      FontWeight.w700, ColorConstants.kPrimary, TextAlign.center, TextOverflow.ellipsis, 1),
                  ),

                  // SizedBox(height: size.height * .005),
                  Container(
                    child: customText.kText("${widget.amount}", 16, FontWeight.w500,
                        ColorConstants.kPrimary, TextAlign.center),
                  ),

                  SizedBox(height: size.height * .005),

                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: size.width * 0.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: widget.likePress,
                                    child: CircleAvatar(
                                      radius: 9,
                                      backgroundColor: ColorConstants.kLike,
                                      child: Icon(
                                        widget.likeIcon,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                  customText.kText(
                                      widget.likeCount.toString(),
                                      14,
                                      FontWeight.w900,
                                      ColorConstants.kLike,
                                      TextAlign.start),
                                  GestureDetector(
                                    onTap: widget.likePress,
                                    child: CircleAvatar(
                                      radius: 9,
                                      backgroundColor: ColorConstants.kDisLike,
                                      child: Icon(
                                        widget.dislikeIcon,
                                        color: Colors.white,
                                        size: 10,
                                      ),
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
                  )
                ],
              ),

            ),
          )


        ],
      ),
    );
  }
}
