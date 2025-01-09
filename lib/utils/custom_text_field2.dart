import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomFormField2 extends StatelessWidget {
  CustomFormField2({
    super.key,
    this.controller,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction,
    this.obsecure,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final bool? obsecure;
  final bool readOnly;

  final customText = CustomText();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        cursorColor: ColorConstants.kTextFieldBorder,
        style: customText.kTextStyle(
            20, FontWeight.w600, ColorConstants.kTextFieldBorder),
        textInputAction: textInputAction,
        obscureText: obsecure ?? false,
        // maxLines: null,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: customText.kTextStyle(
              20, FontWeight.w600, ColorConstants.kTextFieldBorder),
          contentPadding: const EdgeInsets.only(top: 10),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kTextFieldBorder),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kTextFieldBorder),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kTextFieldBorder),
          ),
        ),
      ),
    );
  }
}
