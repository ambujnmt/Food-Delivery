import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class CustomFormField extends StatelessWidget {
  CustomFormField(
      {super.key,
      this.controller,
      this.validator,
      this.keyboardType,
      this.hintText,
      this.suffixIcon,
      this.prefixIcon,
      this.textInputAction,
      this.obsecure,
      this.onChanged,
      this.readOnly,
      this.maxLenght});

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final int? maxLenght;
  final bool? obsecure, readOnly;

  final customText = CustomText();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      child: TextFormField(
        maxLength: maxLenght,
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        cursorColor: ColorConstants.kPrimary,
        style: customText.kTextStyle(20, FontWeight.w600, Colors.black),
        textInputAction: textInputAction,
        obscureText: obsecure ?? false,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          counterText: "",
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: customText.kTextStyle(20, FontWeight.w600, Colors.black),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: ColorConstants.kPrimary, width: 2),
            borderRadius: BorderRadius.circular(size.width * 0.03),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: ColorConstants.kPrimary, width: 2),
            borderRadius: BorderRadius.circular(size.width * 0.03),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: ColorConstants.kPrimary, width: 2),
            borderRadius: BorderRadius.circular(size.width * 0.03),
          ),
        ),
      ),
    );
  }
}
