import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomButton2 extends StatelessWidget {
  CustomButton2({super.key, this.onTap, required this.fontSize, required this.hintText});

  final double fontSize;
  final String hintText;
  final void Function()? onTap;
  final customText = CustomText();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size.height * 0.05,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.03),
              border: Border.all(color: Colors.black54, width: 1.5),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 4.0,
                    color: Colors.black26
                )
              ]
          ),
          child: Center(
            child: customText.kText(hintText, fontSize, FontWeight.w600, Colors.black, TextAlign.center),
          ),
        ),
      ),
    );
  }
}
