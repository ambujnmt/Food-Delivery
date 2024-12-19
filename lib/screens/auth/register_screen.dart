import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/screens/auth/otp_verify.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:food_delivery/utils/validation_rules.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final customText = CustomText();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  dynamic size;
  bool isPassHidden = true, isConfirmPassHidden = true;
  String countryValue = "", stateValue = "", cityValue = "";
  int selectedLocation = 0;
  bool isLocationSelected = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController addressLineOneController = TextEditingController();
  TextEditingController addressLineTwoController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();

  TextEditingController zipCodeController = TextEditingController();
  final List<String> countryList = [
    "Country A",
    "Country B",
    "Country C",
    "Country D",
    "Country E",
  ];
  final List<String> stateList = [
    "State A",
    "State B",
    "State C",
    "State D",
    "State E",
  ];
  final List<String> cityList = [
    "City A",
    "City B",
    "City C",
    "City D",
    "City E",
  ];
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/register_img.png"),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.26,
              child: Container(
                height: size.height * 0.7,
                width: size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * 0.05),
                      topRight: Radius.circular(size.width * 0.05),
                    )),
                child: ListView(
                  children: [
                    customText.kText(
                        TextConstants.register,
                        32,
                        FontWeight.w700,
                        ColorConstants.kPrimary,
                        TextAlign.center),
                    customText.kText(
                        TextConstants.registerDes,
                        16,
                        FontWeight.w400,
                        ColorConstants.kPrimary,
                        TextAlign.center),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFormField(
                            controller: firstNameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) =>
                                ValidationRules().firstNameValidation(value),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.firstName,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomFormField(
                            controller: lastNameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) =>
                                ValidationRules().lastNameValidation(value),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.lastName,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                ValidationRules().email(value),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.email,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomFormField(
                            controller: phoneController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                ValidationRules().phoneNumberValidation(value),
                            prefixIcon: const Icon(
                              Icons.phone_android,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.phoneNo,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) =>
                                ValidationRules().passwordValidation(value),
                            prefixIcon: const Icon(
                              Icons.password,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.password,
                            obsecure: isPassHidden,
                            suffixIcon: GestureDetector(
                              child: isPassHidden
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: ColorConstants.kPrimary,
                                      size: 35,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: ColorConstants.kPrimary,
                                      size: 35,
                                    ),
                              onTap: () {
                                setState(() {
                                  isPassHidden = !isPassHidden;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomFormField(
                            controller: confirmPassController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) => ValidationRules()
                                .confirmPasswordValidation(value),
                            prefixIcon: const Icon(
                              Icons.password,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.confirmPassword,
                            obsecure: isConfirmPassHidden,
                            suffixIcon: GestureDetector(
                              child: isConfirmPassHidden
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: ColorConstants.kPrimary,
                                      size: 35,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: ColorConstants.kPrimary,
                                      size: 35,
                                    ),
                              onTap: () {
                                setState(() {
                                  isConfirmPassHidden = !isConfirmPassHidden;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomFormField(
                            controller: addressLineOneController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) =>
                                ValidationRules().addressValidation1(value),
                            prefixIcon: const Icon(
                              Icons.location_on,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.address1,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomFormField(
                            controller: addressLineTwoController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) =>
                                ValidationRules().addressValidation2(value),
                            prefixIcon: const Icon(
                              Icons.location_on,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.address2,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomFormField(
                            controller: landmarkController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) =>
                                ValidationRules().landMarkValidation(value),
                            prefixIcon: const Icon(
                              Icons.location_on,
                              color: ColorConstants.kPrimary,
                              size: 35,
                            ),
                            hintText: TextConstants.landMark,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      height: size.height * .060,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: ColorConstants.kPrimary, width: 2)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(TextConstants.country,
                              style: customText.kTextStyle(
                                20,
                                FontWeight.bold,
                                Colors.black,
                              )),
                          iconStyleData: const IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down)),
                          items: countryList
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Raleway"),
                                    ),
                                  ))
                              .toList(),
                          value: selectedCountry,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      height: size.height * .060,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: ColorConstants.kPrimary, width: 2)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(TextConstants.state,
                              style: customText.kTextStyle(
                                20,
                                FontWeight.bold,
                                Colors.black,
                              )),
                          iconStyleData: const IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down)),
                          items: stateList
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Raleway"),
                                    ),
                                  ))
                              .toList(),
                          value: selectedState,
                          onChanged: (String? value) {
                            setState(() {
                              selectedState = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      height: size.height * .060,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: ColorConstants.kPrimary, width: 2)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(TextConstants.city,
                              style: customText.kTextStyle(
                                20,
                                FontWeight.bold,
                                Colors.black,
                              )),
                          iconStyleData: const IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down)),
                          items: cityList
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Raleway"),
                                    ),
                                  ))
                              .toList(),
                          value: selectedCity,
                          onChanged: (String? value) {
                            setState(() {
                              selectedCity = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Form(
                      key: _formKey2,
                      child: CustomFormField(
                        maxLenght: 6,
                        validator: (value) =>
                            ValidationRules().postalCodeValidation(value),
                        controller: zipCodeController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: ColorConstants.kPrimary,
                          size: 35,
                        ),
                        hintText: TextConstants.zipCode,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.3,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: selectedLocation == 1
                                  ? ColorConstants.kPrimary
                                  : Colors.white,
                              border: Border.all(
                                  color: ColorConstants.kPrimary, width: 2),
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.home,
                                  size: 30,
                                  color: selectedLocation == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                customText.kText(
                                    TextConstants.home,
                                    18,
                                    FontWeight.w900,
                                    selectedLocation == 1
                                        ? Colors.white
                                        : Colors.black,
                                    TextAlign.center)
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedLocation = 1;
                              isLocationSelected = false;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.3,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: selectedLocation == 2
                                  ? ColorConstants.kPrimary
                                  : Colors.white,
                              border: Border.all(
                                  color: ColorConstants.kPrimary, width: 2),
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.work,
                                  size: 30,
                                  color: selectedLocation == 2
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                customText.kText(
                                    TextConstants.home,
                                    18,
                                    FontWeight.w900,
                                    selectedLocation == 2
                                        ? Colors.white
                                        : Colors.black,
                                    TextAlign.center)
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedLocation = 2;
                              isLocationSelected = false;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.3,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: selectedLocation == 3
                                  ? ColorConstants.kPrimary
                                  : Colors.white,
                              border: Border.all(
                                  color: ColorConstants.kPrimary, width: 2),
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.apartment,
                                  size: 30,
                                  color: selectedLocation == 3
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                customText.kText(
                                    TextConstants.other,
                                    18,
                                    FontWeight.w900,
                                    selectedLocation == 3
                                        ? Colors.white
                                        : Colors.black,
                                    TextAlign.center)
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedLocation = 3;
                              isLocationSelected = false;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Visibility(
                      visible: isLocationSelected,
                      child: Container(
                        child: customText.kText(
                            "Please select location",
                            12,
                            FontWeight.w500,
                            ColorConstants.errorColor,
                            TextAlign.start),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    CustomButton(
                      fontSize: 24,
                      hintText: TextConstants.register,
                      onTap: () {
                        if (selectedLocation == 0) {
                          setState(() {
                            isLocationSelected = true;
                          });
                        }
                        if (_formKey.currentState!.validate() &&
                            _formKey2.currentState!.validate()) {
                          print("hello");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OTPVerify(),
                            ),
                          );
                          // login();
                        }
                      },
                    ),
                    SizedBox(height: size.height * 0.35),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



// CSCPicker(
                      //   showStates: true,
                      //   showCities: true,
                      //   flagState: CountryFlag.DISABLE,
                      //   dropdownDecoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       color: Colors.white,
                      //       border:
                      //       Border.all(color: Colors.grey.shade300, width: 1)),
                      //   disabledDropdownDecoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       color: Colors.grey.shade300,
                      //       border:
                      //       Border.all(color: Colors.grey.shade300, width: 1)),
                      //   countrySearchPlaceholder: "Country",
                      //   stateSearchPlaceholder: "State",
                      //   citySearchPlaceholder: "City",
                      //   countryDropdownLabel: "*Country",
                      //   stateDropdownLabel: "*State",
                      //   cityDropdownLabel: "*City",

                      //   ///Default Country
                      //   //defaultCountry: CscCountry.India,

                      //   ///Disable country dropdown (Note: use it with default country)
                      //   //disableCountry: true,

                      //   ///Country Filter [OPTIONAL PARAMETER]
                      //   // countryFilter: [CscCountry.India,CscCountry.United_States,CscCountry.Canada],

                      //   ///selected item style [OPTIONAL PARAMETER]
                      //   selectedItemStyle: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 14,
                      //   ),

                      //   ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      //   dropdownHeadingStyle: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 17,
                      //       fontWeight: FontWeight.bold),

                      //   ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      //   dropdownItemStyle: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 14,
                      //   ),

                      //   ///Dialog box radius [OPTIONAL PARAMETER]
                      //   dropdownDialogRadius: 10.0,

                      //   ///Search bar radius [OPTIONAL PARAMETER]
                      //   searchBarRadius: 10.0,

                      //   ///triggers once country selected in dropdown
                      //   onCountryChanged: (value) {
                      //     setState(() {
                      //       ///store value in country variable
                      //       countryValue = value;
                      //     });
                      //   },

                      //   ///triggers once state selected in dropdown
                      //   onStateChanged: (value) {
                      //     setState(() {
                      //       ///store value in state variable
                      //       stateValue = value!;
                      //     });
                      //   },

                      //   ///triggers once city selected in dropdown
                      //   onCityChanged: (value) {
                      //     setState(() {
                      //       ///store value in city variable
                      //       cityValue = value!;
                      //     });
                      //   },
                      // ),
