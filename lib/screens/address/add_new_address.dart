import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:food_delivery/utils/validation_rules.dart';
import 'package:get/get.dart';
import 'dart:developer';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({super.key});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  TextEditingController locationTypeController = TextEditingController();
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  final customText = CustomText();
  final api = API();
  final helper = Helper();

  bool addAddressApiCalling = false,
      isLocationSelected = false,
      countryInteracted = false,
      stateInteracted = false;
  bool cityInteracted = false;
  bool isApiCalling = false;
  bool stateApiCalling = false;
  bool cityApiCalling = false;

  String? finalSelectedLocationType;
  final _formKey = GlobalKey<FormState>();

  int selectedLocation = 0;

  Map<String, dynamic> prefilledMap = {};

  List<dynamic> countryList = [];
  List<String> countryName = [];

  List<dynamic> stateList = [];
  List<String> stateName = [];

  List<dynamic> cityList = [];
  List<String> cityNames = [];

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  String? countryId;
  String? stateId;
  String? cityId;

  // country list api integration
  getStateListData(String selectedCountryId) async {
    setState(() {
      stateApiCalling = true;
    });

    final response = await api.getStateList(selectedCountryId);

    setState(() {
      stateApiCalling = false;
    });

    if (response['status'] = true) {
      stateList.clear();
      stateName.clear();

      log("State list after clear before entering new data :- $stateList");

      setState(() {
        stateList = response['data'];
      });

      log("state list new data :- $stateList");
      for (int i = 0; i < stateList.length; i++) {
        stateName.add(stateList[i]['name']);
      }
    } else {
      print("error message: ${response['message']}");
    }
  }

  // city list api integration
  getCityListData(String selectedStateId) async {
    cityList.clear();
    cityNames.clear();

    setState(() {
      cityApiCalling = true;
    });
    final response = await api.getCityList(selectedStateId);
    setState(() {
      cityList = response['data'];
    });
    setState(() {
      cityApiCalling = false;
    });

    if (response['status'] = true) {
      for (int i = 0; i < cityList.length; i++) {
        cityNames.add(cityList[i]['name']);
      }
      print("city names are: ${cityNames}");
      print("success message: ${response['message']}");
    } else {
      print("error message: ${response['message']}");
    }
  }

  addUserAddress() async {
    setState(() {
      addAddressApiCalling = true;
    });

    var response;
    if (sideDrawerController.editAddressId.isEmpty) {
      print("inside the add address");
      response = await api.addUserAddress(
        name: nameController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
        houseNumber: houseController.text,
        area: areaController.text,
        country: selectedCountry,
        state: selectedState,
        city: selectedCity,
        postalCode: zipCodeController.text,
        workLocationType: finalSelectedLocationType.toString().toLowerCase(),
      );
    } else {
      print("inside the edit address");
      response = await api.editUserAddress(
        name: nameController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
        houseNumber: houseController.text,
        area: areaController.text,
        country: selectedCountry,
        state: selectedState,
        city: selectedCity,
        postalCode: zipCodeController.text,
        workLocationType: finalSelectedLocationType.toString().toLowerCase(),
      );
    }

    setState(() {
      addAddressApiCalling = false;
    });

    if (response["status"] == true) {
      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
      sideDrawerController.index.value = 10;
      clearControllerValue();
      sideDrawerController.editAddressId = ""; // added line
      sideDrawerController.pageController
          .jumpToPage(sideDrawerController.index.value);
    } else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
    }
  }

  clearControllerValue() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    houseController.clear();
    areaController.clear();
    selectedCountry = "";
    selectedState = "";
    selectedCity = "";
    finalSelectedLocationType = "";
  }

  @override
  void initState() {
    super.initState();
    // clearControllerValue();
    fetchData();
  }

  fetchData() async {
    await getCountryListData();
    if (sideDrawerController.editAddressId.isNotEmpty) {
      getParticularAddress();
    }
    print('edit address id : ${sideDrawerController.editAddressId}');
  }

  getCountryListData() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.getCountryList();

    setState(() {
      isApiCalling = false;
    });

    if (response['status'] = true) {
      setState(() {
        countryList = response['data'];
      });
      for (int i = 0; i < countryList.length; i++) {
        countryName.add(countryList[i]['name']);
      }
    } else {
      print("error message: ${response['message']}");
    }
  }

  getParticularAddress() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.getAddressByUserId(
        addressId: sideDrawerController.editAddressId.toString());

    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      setState(() {
        prefilledMap = response['data'];
      });

      managedData();
    } else {
      print('error message: ${response["message"]}');
    }
  }

  managedData() async {
    nameController.text = prefilledMap['name'];
    phoneController.text = prefilledMap['phone'];
    emailController.text = prefilledMap['email'];
    houseController.text = prefilledMap['house_no'];
    areaController.text = prefilledMap['area'];
    zipCodeController.text = prefilledMap['zip_code'].toString();
    if (prefilledMap['location'] == "home") {
      finalSelectedLocationType = prefilledMap['location'];
      selectedLocation = 1;
    } else if (prefilledMap['location'] == "office") {
      finalSelectedLocationType = prefilledMap['location'];
      selectedLocation = 2;
    } else {
      finalSelectedLocationType = prefilledMap['location'];
      selectedLocation = 3;
    }

    selectedCountry = prefilledMap['country'];

    for (int i = 0; i < countryList.length; i++) {
      if (countryList[i]['name'] == selectedCountry) {
        setState(() {
          countryId = countryList[i]['id'].toString();
        });
      }
    }

    await getStateListData(countryId.toString());
    selectedState = prefilledMap['state'];
    for (int i = 0; i < stateList.length; i++) {
      if (stateList[i]['name'] == selectedState) {
        setState(() {
          stateId = stateList[i]['id'].toString();
        });
      }
    }

    log("stateId, StateName :- $stateId, $selectedState");

    await getCityListData(stateId.toString());
    selectedCity = prefilledMap['city'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFormField(
                  controller: nameController,
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
                SizedBox(height: height * 0.010),
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
                SizedBox(height: height * 0.010),
                CustomFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => ValidationRules().email(value),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: ColorConstants.kPrimary,
                    size: 35,
                  ),
                  hintText: TextConstants.email,
                ),
                SizedBox(height: height * 0.010),
                CustomFormField(
                  controller: houseController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) => ValidationRules().houseNumber(value),
                  prefixIcon: const Icon(
                    Icons.house,
                    color: ColorConstants.kPrimary,
                    size: 35,
                  ),
                  hintText: TextConstants.houseNumber,
                ),
                SizedBox(height: height * 0.010),
                CustomFormField(
                  controller: areaController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) => ValidationRules().area(value),
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: ColorConstants.kPrimary,
                    size: 35,
                  ),
                  hintText: TextConstants.area,
                ),
                SizedBox(height: height * 0.010),
                Container(
                  height: height * .060,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: ColorConstants.kPrimary, width: 2)),
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
                      // items: [],
                      items: countryName
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
                      onChanged: (String? value) async {
                        setState(() {
                          selectedCountry = value;
                          selectedState = null;
                          selectedCity = null;
                          countryInteracted = false;
                          print("Selected Country: ${selectedCountry}");
                        });

                        //-------------------
                        for (int i = 0; i < countryList.length; i++) {
                          if (countryList[i]['name'] == selectedCountry) {
                            setState(() {
                              countryId = countryList[i]['id'].toString();
                            });
                          }
                        }
                        print("Country id ---- ${countryId}");
                        await getStateListData(countryId.toString());

                        print("state list: ${stateList}");

                        //-------------------
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
                Container(
                  margin: EdgeInsets.only(left: 0, right: 20),
                  child: Visibility(
                      visible: countryInteracted,
                      child: const Text(
                        "Please Select Country",
                        style: TextStyle(color: ColorConstants.errorColor),
                      )),
                ),
                SizedBox(height: height * 0.010),
                stateApiCalling
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: height * .060,
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
                            items: stateName
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
                                stateInteracted = false;
                              });
                              //-------------------
                              for (int i = 0; i < stateList.length; i++) {
                                if (stateList[i]['name'] == selectedState) {
                                  setState(() {
                                    stateId = stateList[i]['id'].toString();
                                  });
                                }
                              }
                              print("state id ---- ${stateId}");
                              getCityListData(stateId.toString());

                              //-------------------
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
                Container(
                  margin: EdgeInsets.only(left: 0, right: 20),
                  child: Visibility(
                      visible: stateInteracted,
                      child: const Text(
                        "Please Select State",
                        style: TextStyle(color: ColorConstants.errorColor),
                      )),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                cityApiCalling
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: height * .060,
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
                            items: cityNames
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
                                cityInteracted = false;
                              });

                              //-------------------
                              for (int i = 0; i < cityList.length; i++) {
                                if (cityList[i]['name'] == selectedCity) {
                                  setState(() {
                                    cityId = cityList[i]['id'].toString();
                                  });
                                }
                              }
                              print("city id ---- ${cityId}");

                              //-------------------
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
                Container(
                  margin: EdgeInsets.only(left: 0, right: 20),
                  child: Visibility(
                      visible: cityInteracted,
                      child: const Text(
                        "Please Select City",
                        style: TextStyle(color: ColorConstants.errorColor),
                      )),
                ),
                SizedBox(height: height * .010),
                CustomFormField(
                  maxLenght: 5,
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
                SizedBox(height: height * 0.010),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.3,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: selectedLocation == 1
                              ? ColorConstants.kPrimary
                              : Colors.white,
                          border: Border.all(
                              color: ColorConstants.kPrimary, width: 2),
                          borderRadius: BorderRadius.circular(width * 0.02),
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
                          finalSelectedLocationType = "Home";
                          print("loc type: ${finalSelectedLocationType}");
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.3,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: selectedLocation == 2
                              ? ColorConstants.kPrimary
                              : Colors.white,
                          border: Border.all(
                              color: ColorConstants.kPrimary, width: 2),
                          borderRadius: BorderRadius.circular(width * 0.02),
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
                                TextConstants.work,
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
                          finalSelectedLocationType = "Office";
                          print("loc type: ${finalSelectedLocationType}");
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.3,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: selectedLocation == 3
                              ? ColorConstants.kPrimary
                              : Colors.white,
                          border: Border.all(
                              color: ColorConstants.kPrimary, width: 2),
                          borderRadius: BorderRadius.circular(width * 0.02),
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
                          finalSelectedLocationType = "Other";
                          print("loc type: ${finalSelectedLocationType}");
                        });
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: isLocationSelected,
                  child: Container(
                      child: const Text(
                    "Please Select Location",
                    style: TextStyle(color: ColorConstants.errorColor),
                  )),
                ),
                SizedBox(height: height * 0.080),
                CustomButton(
                  loader: addAddressApiCalling,
                  fontSize: 24,
                  hintText: TextConstants.saveAddress,
                  onTap: () {
                    if (selectedLocation == 0 &&
                        selectedCountry == null &&
                        selectedCity == null &&
                        selectedState == null) {
                      setState(() {
                        isLocationSelected = true;
                        countryInteracted = true;
                        cityInteracted = true;
                        stateInteracted = true;
                      });
                    }
                    if (_formKey.currentState!.validate()) {
                      print("hello");
                      addUserAddress();
                    }
                  },
                ),
                SizedBox(height: height * 0.050),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
