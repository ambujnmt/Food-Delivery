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

  // first name validation
  firstNameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Name Required";
    } else if (value.length < 3) {
      return "Name should be at least 3 characters";
    } else if (value.length > 25) {
      return "Name should not exceed 25 characters";
    } else {
      return null;
    }
  }

  // last name validation
  lastNameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Last Name Required";
    } else if (value.length < 3) {
      return "Last name should be at least 3 characters";
    } else if (value.length > 25) {
      return "Last name should not exceed 25 characters";
    } else {
      return null;
    }
  }

  // phone number validation
  phoneNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone Number Required";
    } else if (value.length < 10) {
      return "Phone Number should be at least 10 digit";
    } else if (value.length > 12) {
      return "Phone number should not exceed 12 digit";
    } else {
      return null;
    }
  }

  // password validation
  passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Password Required";
    } else if (value.length < 8) {
      return "Password should be at least 8 characters";
    } else if (value.length > 15) {
      return "Password should not exceed 15 characters";
    } else {
      return null;
    }
  }

  // confirm password validation
  confirmPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm Password Required";
    } else if (value.length < 8) {
      return "Confirm password should be at least 8 characters";
    } else if (value.length > 15) {
      return "Confirm password should not exceed 15 characters";
    } else {
      return null;
    }
  }

  // address validation 1
  addressValidation1(String? value) {
    if (value == null || value.isEmpty) {
      return "Address Line 1 Required";
    } else if (value.length < 5) {
      return "Address line 1 should be more than 5 characters";
    } else if (value.length > 40) {
      return "Address line 1 should not exceed 40 characters";
    } else {
      return null;
    }
  }

// address validation 2
  addressValidation2(String? value) {
    if (value == null || value.isEmpty) {
      return "Address Line 2 Required";
    } else if (value.length < 5) {
      return "Address line 2 should be more than 5 characters";
    } else if (value.length > 40) {
      return "Address line 2 should not exceed 40 characters";
    } else {
      return null;
    }
  }

  //land mark  validation
  landMarkValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Landmark Required";
    } else if (value.length < 5) {
      return "Landmark should be more than 5 characters";
    } else if (value.length > 40) {
      return "Landmark should not exceed 40 characters";
    } else {
      return null;
    }
  }

  // contact us message

  contactMessageValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Message Required";
    } else if (value.length < 5) {
      return "Message should be more than 5 characters";
    } else if (value.length > 100) {
      return "Message should not exceed 100 characters";
    } else {
      return null;
    }
  }

  //land mark  validation
  postalCodeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Postal Code Required";
    } else if (value.length < 6) {
      return "Postal code should be 6 characters";
    } else if (value.length > 6) {
      return "Postal code should be 6 characters";
    } else {
      return null;
    }
  }

// number of people
  numberOfPeopleValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Number of People Required";
    } else if (value.length < 1) {
      return "Number of people should be at least 1";
    } else if (value.length > 2) {
      return "Number of people should not exceed 99";
    } else {
      return null;
    }
  }

  // date validation
  dateValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Date Required";
    } else {
      return null;
    }
  }

  // time validation
  timeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Time Required";
    } else {
      return null;
    }
  }
}
