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

  // show confirmation dialog
  void showAlertDialog(
      BuildContext context, String message, Function() deleteItem) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                height: h * .030,
                width: w * .2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorConstants.kPrimary),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                print("OK Button");
                // Perform any action here, then close the dialog
                Navigator.of(context).pop();
                deleteItem();
              },
              child: Container(
                height: h * .030,
                width: w * .2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
