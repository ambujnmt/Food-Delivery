import 'package:flutter/material.dart';

class ValidationRules {
  static const String regularExpressionEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  // String? normal(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return "FIELD_REQUIRED";
  //   } else if (value.length < 4 || value.length > 30) {
  //     return "SHORT_FIELD";
  //   } else  if(!value.isAlphabetOnly) {
  //     return "ONLY_ALPHABETS";
  //   }
  //   return null;
  // }

  email(String? value) {
    RegExp regExp = RegExp(regularExpressionEmail);
    if (value == null || value.isEmpty) {
      return "Email required";
    } else if (!regExp.hasMatch(value)) {
      return 'Enter Valid Email Address';
    } else if (!value.contains('@')) {
      return "Valid email";
    } else {
      return null;
    }
  }

  password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password required";
    } else if (value.length <= 7) {
      return "Password should be more than 8 characters";
    } else {
      return null;
    }
  }
}
