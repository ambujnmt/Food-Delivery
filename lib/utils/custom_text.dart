import 'package:flutter/material.dart';

class CustomText {

  kText(String hint, double fontSize, FontWeight fontWeight, Color color,
      TextAlign textAlign, [TextOverflow? textOverFlow, int? maxLines]) {
    return Text(
      hint,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color,
          fontFamily: "Raleway"),
      textAlign: textAlign,
      overflow: textOverFlow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 2,
    );
  }

  kTextStyle(double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color, fontFamily: "Raleway");
  }

  kSatisfyText(String hint, double fontSize, FontWeight fontWeight, Color color,
      TextAlign textAlign, [TextOverflow? textOverFlow, int? maxLines]) {
    return Text(
      hint,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color,
          fontFamily: "Satisfy"),
      textAlign: textAlign,
      overflow: textOverFlow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 2,
    );
  }

  kSatisfyTextStyle(double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color, fontFamily: "Satisfy");
  }

}