import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  dynamic size;
  final customText = CustomText();
  bool isApiCalling = false;
  final api = API();
  final helper = Helper();
  List<dynamic> addressList = [];

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  addressData() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.getUserAddress();

    setState(() {
      addressList = response['data'];
      print("address list length: ${addressList.length}");
    });

    setState(() {
      isApiCalling = false;
    });
    print("user address  list data: ${addressList}");
    if (response["status"] == true) {
    } else {
      print('error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    addressData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: SizedBox(
            height: size.height * 0.07,
            width: size.width,
            // color: Colors.lightGreen,
            child: Center(
              child: customText.kText(TextConstants.savedAddress, 25,
                  FontWeight.w900, ColorConstants.kPrimary, TextAlign.center),
            ),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: addressList.length,
              (context, index) {
                return Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.023,
                        vertical: size.height * 0.01),
                    margin: EdgeInsets.only(
                        bottom: size.height * 0.01, top: size.height * 0.01),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorConstants.kPrimary),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            addressList[index]['location'] == "home"
                                ? const Icon(Icons.home,
                                    size: 30, color: Colors.black)
                                : addressList[index]['location'] == "office"
                                    ? const Icon(Icons.local_post_office)
                                    : const Icon(Icons.location_on),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200),
                              padding: EdgeInsets.all(5),
                              child: customText.kText(
                                  "${addressList[index]['location']}",
                                  20,
                                  FontWeight.w900,
                                  Colors.black,
                                  TextAlign.center),
                            ),
                          ],
                        ),
                        customText.kText(
                          "${addressList[index]['area']} ${addressList[index]['house_no']} ${addressList[index]['city']} ${addressList[index]['zip_code']} ${addressList[index]['state']} ${addressList[index]['country']}",
                          18,
                          FontWeight.w700,
                          Colors.black,
                          TextAlign.start,
                          TextOverflow.visible,
                          3,
                        ),
                        customText.kText("+${addressList[index]['phone']}", 18,
                            FontWeight.w700, Colors.black, TextAlign.start),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            // color: Colors.yellow,
                            width: size.width * 0.32,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: customText.kText(
                                      TextConstants.edit,
                                      20,
                                      FontWeight.w900,
                                      ColorConstants.kPrimary,
                                      TextAlign.center),
                                  onTap: () {
                                    print('Edit address');
                                    sideDrawerController.editAddressId =
                                        addressList[index]['id'].toString();
                                    sideDrawerController.index.value = 40;
                                    sideDrawerController.pageController
                                        .jumpToPage(
                                            sideDrawerController.index.value);
                                  },
                                ),
                                GestureDetector(
                                  child: customText.kText(
                                      TextConstants.delete,
                                      20,
                                      FontWeight.w900,
                                      ColorConstants.kPrimary,
                                      TextAlign.center),
                                  onTap: () {
                                    // place your delete function
                                    _showAlertDialog(context, () async {
                                      final response =
                                          await api.deleteUserAddress(
                                              addressId: addressList[index]
                                                      ['id']
                                                  .toString());
                                      if (response['status'] == true) {
                                        helper.successDialog(
                                            context, response['message']);
                                      } else {
                                        helper.errorDialog(
                                            context, response['message']);
                                      }
                                      addressData();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            ),
          ),
          SliverToBoxAdapter(
            child: CustomButton(
              fontSize: 24,
              hintText: TextConstants.addAddress,
              onTap: () {
                // place address
                sideDrawerController.index.value = 40;
                sideDrawerController.pageController
                    .jumpToPage(sideDrawerController.index.value);
              },
            ),
          ),
        ],
      ),
    ));
  }

  // Function to show an alert dialog
  void _showAlertDialog(BuildContext context, Function() deleteItem) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              'Are you sure want to delete this address ?',
              style: TextStyle(
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
                // Perform any action here, then close the dialog
                deleteItem();
                Navigator.of(context).pop();
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
