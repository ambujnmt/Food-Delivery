import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';

class RestaurantListForChat extends StatefulWidget {
  const RestaurantListForChat({super.key});

  @override
  State<RestaurantListForChat> createState() => _RestaurantListForChatState();
}

class _RestaurantListForChatState extends State<RestaurantListForChat> {
  dynamic size;
  final customText = CustomText(), api = API(), helper = Helper();
  String searchValue = "";
  List<dynamic> allRestaurantList = [];
  List<dynamic> allRestaurantChatList = [];
  bool isApiCalling = false;
  TextEditingController searchController = TextEditingController();
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  LocationController locationController = Get.put(LocationController());

  // get all restaurant  list for home page
  getAllRestaurantData({String searchResult = ""}) async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.viewAllRestaurant(
        searchResult, locationController.lat, locationController.long);
    setState(() {
      allRestaurantList = response["restaurants"];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' all restaurant success message: ${response["message"]}');
    } else {
      print('all restaurant message: ${response["message"]}');
    }
  }
  userActiveAndInactive() async {
    setState(() {
      isApiCalling = true;
    });
    final response =
    await api.userStatusChat();
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      helper.successDialog(context, response["message"]);
    }
    else {
      helper.errorDialog(context, response["message"]);
      print('error message: ${response["message"]}');
    }
  }

  userMsgStatusChange() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.userChatCount();
    setState(() {
      allRestaurantChatList = response["count"];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' all restaurant success message: ${response["message"]}');
    } else {
      print('all restaurant message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllRestaurantData();
    userMsgStatusChange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * .010),
              Container(
                padding: const EdgeInsets.only(left: 15, top: 5),
                margin: const EdgeInsets.only(top: 0, bottom: 10, right: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffixIcon: searchController.text.isEmpty
                        ? const Icon(Icons.search)
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                getAllRestaurantData(
                                  searchResult: searchController.text,
                                );
                              });
                            },
                            child: const Icon(Icons.arrow_forward),
                          ),
                    border: OutlineInputBorder(),
                    hintText: TextConstants.search,
                  ),
                  onChanged: (value) {
                    if (searchController.text.isEmpty) {
                      getAllRestaurantData(
                        searchResult: "",
                      );
                      FocusScope.of(context).unfocus();
                    }

                    setState(() {
                      // searchController.clear();
                    });
                  },
                ),
              ),
              Container(
                height: size.height * 0.18,
                width: size.width,
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
                          customText.kText(TextConstants.restaurant, 28,
                              FontWeight.w900, Colors.white, TextAlign.center),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          RichText(
                            text: TextSpan(
                                text: TextConstants.home,
                                style: customText.kSatisfyTextStyle(
                                    24, FontWeight.w400, Colors.white),
                                children: [
                                  TextSpan(
                                      text: " / ${TextConstants.restaurant}",
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
              isApiCalling
                  ? Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary,
                        ),
                      ),
                    )
                  : allRestaurantList.isEmpty
                      ? const CustomNoDataFound()
                      : Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: allRestaurantList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                              child: Container(
                                height: size.height * 0.17,
                                width: size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03),
                                margin: EdgeInsets.only(
                                    bottom: size.height * 0.01,
                                    top: size.height * 0.01),
                                // color: Colors.yellow.shade100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height: size.height * 0.14,
                                      width: size.width * 0.33,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(
                                            size.width * 0.05),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: allRestaurantList[index]
                                                      ["business_image"] ==
                                                  null
                                              ? const AssetImage(
                                                  "assets/images/no_image.png")
                                              : NetworkImage(
                                                  "${allRestaurantList[index]["business_image"]}"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            // height: size.height * 0.08,
                                            width: size.width * 0.5,
                                            child: customText.kText(
                                                "${allRestaurantList[index]["business_name"]}",
                                                20,
                                                FontWeight.w700,
                                                ColorConstants.kPrimary,
                                                TextAlign.start),
                                          ),
                                          Container(
                                            // height: size.height * 0.08,
                                            width: size.width * 0.5,
                                            child: customText.kText(
                                                "${allRestaurantList[index]["business_address"]}",
                                                14,
                                                FontWeight.w500,
                                                Colors.black,
                                                TextAlign.start),
                                          ),
                                          Container(
                                            // color: Colors.yellow.shade200,
                                            width: size.width * 0.5,
                                            child: customText.kText(
                                                "Distance : ${allRestaurantList[index]["resturant_distance"].toString().substring(0, 5) ?? "0"} mls",
                                                14,
                                                FontWeight.w500,
                                                Colors.black,
                                                TextAlign.start),
                                          ),
                                          GestureDetector(
                                            child: const Icon(
                                              Icons.chat,
                                              size: 30,
                                              color: ColorConstants.kPrimary,
                                            ),
                                            onTap: () async {
                                              if (loginController
                                                  .accessToken.isNotEmpty) {
                                                sideDrawerController
                                                    .previousIndex
                                                    .add(sideDrawerController
                                                        .index.value);
                                                sideDrawerController
                                                        .restaurantIdForChat =
                                                    allRestaurantList[index]
                                                            ['id']
                                                        .toString();
                                                sideDrawerController
                                                    .index.value = 38;
                                                sideDrawerController
                                                    .pageController
                                                    .jumpToPage(
                                                        sideDrawerController
                                                            .index.value);
                                               await userActiveAndInactive();
                                              } else {
                                                helper.errorDialog(context,
                                                    "Login is required for chat");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (loginController.accessToken.isNotEmpty) {
                                  sideDrawerController.previousIndex
                                      .add(sideDrawerController.index.value);
                                  sideDrawerController.restaurantIdForChat =
                                      allRestaurantList[index]['id'].toString();
                                  sideDrawerController.index.value = 38;
                                  sideDrawerController.pageController
                                      .jumpToPage(
                                          sideDrawerController.index.value);
                                } else {
                                  helper.errorDialog(
                                      context, "Login is required for chat");
                                }
                              },
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
