import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class AboutUs extends StatefulWidget {
  final String title;
  const AboutUs({super.key, required this.title});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  dynamic size;
  final customText = CustomText();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
        child: Column(
          children: [

            Container(
              height: size.height * 0.05,
              width: size.width * 0.6,
              margin: EdgeInsets.symmetric(vertical: size.width * 0.03),
              decoration: BoxDecoration(
                color: ColorConstants.kPrimary,
                borderRadius: BorderRadius.circular(size.width * 0.05)
              ),
              child: Center(
                child: customText.kText(widget.title, 24, FontWeight.w900, Colors.white, TextAlign.center),
              ),
            ),

            Container(
              width: size.width,
              padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
              // color: Colors.grey.shade200,
              child: customText.kText("Lorem ipsum dolor sit amet consectetur adipisicing elit. Atque cupiditate cum provident at! Dolorum fuga, deserunt est atque excepturi voluptas architecto exercitationem cumque delectus iste facilis quaerat in minima totam. Lorem ipsum dolor sit amet consectetur adipisicing elit. Atque cupiditate cum provident at! Dolorum fuga, deserunt est atque excepturi voluptas architecto exercitationem cumque delectus iste facilis quaerat in minima totam. Lorem ipsum dolor sit amet consectetur adipisicing elit. Atque cupiditate cum provident at! Dolorum fuga, deserunt est atque excepturi voluptas architecto exercitationem cumque delectus iste facilis quaerat in minima totam. Lorem ipsum dolor sit amet consectetur adipisicing elit. Atque cupiditate cum provident at! Dolorum fuga, deserunt est atque excepturi voluptas architecto exercitationem cumque delectus iste facilis quaerat in minima totam.",
                18, FontWeight.w700, Colors.black, TextAlign.center, TextOverflow.visible, 1000),
            )

          ],
        )
      )
    );
  }
}
