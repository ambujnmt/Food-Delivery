import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, this.onTap, required this.fontSize, required this.hintText});

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
          height: size.height * 0.06,
          width: size.width,
          decoration: BoxDecoration(
              color: ColorConstants.kPrimary,
              borderRadius: BorderRadius.circular(size.width * 0.03),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 9.9,
                    color: Colors.black54
                )
              ]
          ),
          child: Center(
            child: customText.kText(hintText, fontSize, FontWeight.w600, Colors.white, TextAlign.center),
          ),
        ),
      ),
    );
  }
}
