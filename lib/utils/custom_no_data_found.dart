import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomNoDataFound extends StatefulWidget {
  const CustomNoDataFound({super.key});

  @override
  State<CustomNoDataFound> createState() => _CustomNoDataFoundState();
}

class _CustomNoDataFoundState extends State<CustomNoDataFound> {
  final customText = CustomText();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.25,
      width: width,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8)),
          height: 50,
          width: width * .400,
          child: Center(
            child: customText.kText("No data found", 15, FontWeight.w700,
                Colors.black, TextAlign.center),
          ),
        ),
      ),
    );
  }
}
