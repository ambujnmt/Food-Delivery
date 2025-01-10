// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_button2.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:food_delivery/utils/validation_rules.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookTable extends StatefulWidget {
  const BookTable({super.key});

  @override
  State<BookTable> createState() => _BookTableState();
}

class _BookTableState extends State<BookTable> {
  final customText = CustomText();
  String dropdownvalue = 'Select Restaurant';
  final _formKey = GlobalKey<FormState>();
  bool _hasInteracted = false;
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberOfPeopleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool isApiCalling = false;
  bool restaurantCalling = false;
  final api = API();
  final helper = Helper();

  TimeOfDay selectedTime = TimeOfDay.now();

  List<dynamic> restaurantList = [];
  List<String> restaurantName = [];
  String? selectedRestaurant;
  String? selectedRestaurantId;

  // date picker function
  datePicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        dateController.text =
            formattedDate; //set output date to TextField value.
        print("date controller: ${dateController.text}");
      });
    } else {}
  }

  // show time picker
  timePicker() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
        timeController.text =
            _formatTime24Hour(selectedTime); // Update TextField
        print("time controller: ${timeController.text}");
      });
    }
  }

  // 12 hour time format

  // String _formatTime(TimeOfDay time) {
  //   final hour = time.hourOfPeriod == 0
  //       ? 12
  //       : time.hourOfPeriod; // Convert 0 to 12 for AM/PM
  //   final minute = time.minute.toString().padLeft(2, '0');
  //   final period = time.period == DayPeriod.am ? "AM" : "PM";
  //   return "$hour:$minute $period"; // Example: "2:30 PM"
  // }

// 24 hour time format
  String _formatTime24Hour(TimeOfDay time) {
    final hour =
        time.hour.toString().padLeft(2, '0'); // Ensures 2 digits for the hour
    final minute = time.minute
        .toString()
        .padLeft(2, '0'); // Ensures 2 digits for the minute
    return "$hour:$minute"; // Example: "14:30"
  }

  bookTable() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.bookATable(
      restaurantName: selectedRestaurantId,
      fullName: nameController.text,
      phoneNumber: phoneController.text,
      emailAdress: emailController.text,
      numberOfPeople: numberOfPeopleController.text,
      date: dateController.text,
      time: timeController.text,
    );

    setState(() {
      isApiCalling = false;
    });

    if (response["success"] == true) {
      print('success message: ${response["message"]}');
      helper.successDialog(context, response["message"]);
      sideDrawerController.index.value = 0;
      sideDrawerController.pageController
          .jumpToPage(sideDrawerController.index.value);
    } else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
    }
  }

  // restaurant list for booking
  restaurantData() async {
    setState(() {
      restaurantCalling = true;
    });
    final response = await api.bookingTableRestaurant();
    setState(() {
      restaurantList = response['data'];
      for (int i = 0; i < restaurantList.length; i++) {
        restaurantName.add(restaurantList[i]['name']);
      }
    });

    setState(() {
      restaurantCalling = false;
    });

    if (response["success"] == true) {
      print('restaurant success message: ${restaurantList}');
    } else {
      print('restaurant error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    dateController.text = "";
    timeController.text = "";
    restaurantData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.06,
                width: width,
                color: Colors.grey.shade300,
              ),
              Container(
                height: height * 0.18,
                width: width,
                margin: EdgeInsets.only(bottom: height * 0.01),
                decoration: const BoxDecoration(
                    color: Colors.yellow,
                    image: DecorationImage(
                        image: AssetImage("assets/images/banner.png"),
                        fit: BoxFit.fitHeight)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.black54,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText.kText(TextConstants.bookATable, 28,
                              FontWeight.w900, Colors.white, TextAlign.center),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          RichText(
                            text: TextSpan(
                                text: TextConstants.home,
                                style: customText.kSatisfyTextStyle(
                                    24, FontWeight.w400, Colors.white),
                                children: [
                                  TextSpan(
                                      text: " / ${TextConstants.table}",
                                      style: customText.kSatisfyTextStyle(
                                          24,
                                          FontWeight.w400,
                                          ColorConstants.kPrimary))
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * .020),
              Container(
                  margin: EdgeInsets.only(bottom: 10, left: 20),
                  child: Center(
                    child: customText.kText(
                      TextConstants.bookATable,
                      20,
                      FontWeight.w800,
                      ColorConstants.kPrimary,
                      TextAlign.start,
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ColorConstants.kTextFieldBorder, // Underline color
                      width: 1,
                    ),
                  ),
                ),
                height: height * .060,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    underline: Container(
                      height: 2,
                      color: Colors.red,
                    ),
                    hint: Text(TextConstants.selectRestaurant,
                        style: customText.kTextStyle(
                          20,
                          FontWeight.w600,
                          ColorConstants.kTextFieldBorder,
                        )),
                    iconStyleData: const IconStyleData(
                        icon: Icon(Icons.keyboard_arrow_down)),
                    // items: [],
                    items: restaurantName
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: ColorConstants.kTextFieldBorder,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Raleway"),
                              ),
                            ))
                        .toList(),
                    value: selectedRestaurant,
                    onChanged: (String? value) {
                      setState(() {
                        selectedRestaurant = value;
                        _hasInteracted = false;
                        print("Selected restaurant: ${selectedRestaurant}");
                      });

                      //-------------------
                      for (int i = 0; i < restaurantList.length; i++) {
                        if (restaurantList[i]['name'] == selectedRestaurant) {
                          setState(() {
                            selectedRestaurantId =
                                restaurantList[i]['id'].toString();
                          });
                        }
                      }
                      print("res id ---- ${selectedRestaurantId}");

                      //-------------------
                    },
                    buttonStyleData: const ButtonStyleData(
                      // padding: EdgeInsets.symmetric(horizontal: 16),
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
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Visibility(
                    visible: _hasInteracted,
                    child: Text(
                      "Please Select Restaurant",
                      style: TextStyle(color: ColorConstants.errorColor),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: CustomFormField2(
                  controller: nameController,
                  validator: (value) =>
                      ValidationRules().firstNameValidation(value),
                  hintText: TextConstants.fullName,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: CustomFormField2(
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  validator: (value) =>
                      ValidationRules().phoneNumberValidation(value),
                  hintText: TextConstants.phone,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: CustomFormField2(
                  controller: emailController,
                  validator: (value) => ValidationRules().email(value),
                  hintText: TextConstants.emailAddress,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: CustomFormField2(
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      ValidationRules().numberOfPeopleValidation(value),
                  controller: numberOfPeopleController,
                  hintText: TextConstants.numberOfPeople,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: CustomFormField2(
                  readOnly: true,
                  validator: (value) => ValidationRules().dateValidation(value),
                  controller: dateController,
                  hintText: TextConstants.slelctDate,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      datePicker();
                    },
                    child: Icon(
                      Icons.calendar_month,
                      color: ColorConstants.kPrimary,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: CustomFormField2(
                  readOnly: true,
                  validator: (value) => ValidationRules().timeValidation(value),
                  controller: timeController,
                  hintText: TextConstants.selecttime,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      timePicker();
                    },
                    child: Icon(
                      Icons.watch_later_sharp,
                      color: ColorConstants.kPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * .020),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomButton(
                  loader: isApiCalling,
                  fontSize: 20,
                  hintText: TextConstants.bookNow,
                  onTap: () {
                    if (selectedRestaurant == null) {
                      setState(() {
                        _hasInteracted = true;
                      });
                    }
                    if (_formKey.currentState!.validate()) {
                      print("validation");
                      bookTable();
                    }
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
