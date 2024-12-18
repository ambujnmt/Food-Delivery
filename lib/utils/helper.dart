import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class Helper {
  final customText = CustomText();

  errorDialog(context, message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Container(
          child: Text(
            message,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: "Raleway"),
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: ColorConstants.kPrimary,
      ),
    );
  }

  successDialog(context, message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // content: customText.kText(
        //     message, 20, FontWeight.w900, Colors.white, TextAlign.start),
        content: Container(
          child: Text(
            message,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: "Raleway"),
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
