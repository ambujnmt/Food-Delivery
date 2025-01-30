import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:get/get.dart';

class FoodCategory extends StatefulWidget {
  const FoodCategory({super.key});

  @override
  State<FoodCategory> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  TextEditingController searchController = TextEditingController();
  dynamic size;
  final customText = CustomText();
  final List<String> items = [
    TextConstants.newNess,
  ];
  String? selectedValue;
  String searchValue = "";

  bool isApiCalling = false;
  final api = API();
  List<dynamic> viewAllFoodCategory = [""];
  // view all category

  viewAllFoodCategoryData(
      {String orderby = "", String searchResult = ""}) async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.viewAllFoodCategory(
      orderBy: orderby,
      searchResult: searchResult,
    );
    setState(() {
      viewAllFoodCategory = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('all food category success message: ${response["message"]}');

      print('product list: ${viewAllFoodCategory}');
    } else {
      print('all food category error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewAllFoodCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      height: size.height,
      width: size.width,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.06,
                  width: size.width,
                  // color: Colors.grey.shade300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * .6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 5, bottom: 5),
                              height: size.height * 0.05,
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                color: ColorConstants.kSortButton,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(TextConstants.sortBy,
                                      style: customText.kTextStyle(
                                          16, FontWeight.w500, Colors.black)),
                                  items: items
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedValue = value;
                                      if (selectedValue == items[0]) {
                                        searchValue = "latest";
                                      }
                                    });
                                    print("search value: ${searchValue}");
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: 140,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * .010),
                            GestureDetector(
                              onTap: () async {
                                // apply filter
                                print("Apply filter: ${searchValue}");
                                viewAllFoodCategoryData(orderby: searchValue);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                width: size.width * .22,
                                decoration: BoxDecoration(
                                    color: ColorConstants.kPrimary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: customText.kText(
                                    TextConstants.applyNow,
                                    12,
                                    FontWeight.w700,
                                    Colors.white,
                                    TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 10),
                          width: size.width * .2,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8)),
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
                                          viewAllFoodCategoryData(
                                              orderby: searchValue,
                                              searchResult:
                                                  searchController.text);
                                        });
                                      },
                                      child: const Icon(Icons.arrow_forward),
                                    ),
                              border: OutlineInputBorder(),
                              hintText: TextConstants.search,
                            ),
                            onChanged: (value) {
                              if (searchController.text.isEmpty) {
                                viewAllFoodCategoryData(
                                    orderby: searchValue, searchResult: "");
                                FocusScope.of(context).unfocus();
                              }

                              setState(() {
                                // searchController.clear();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height * 0.18,
                  width: size.width,
                  margin: EdgeInsets.only(bottom: size.height * 0.01),
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
                            customText.kText(
                                TextConstants.foodCategory,
                                28,
                                FontWeight.w900,
                                Colors.white,
                                TextAlign.center),
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
                                        text:
                                            " / ${TextConstants.foodCategory}",
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
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0, // make it 200 (before value)
              mainAxisSpacing: 15.0,
              // crossAxisSpacing: 10.0,
              childAspectRatio: 1 / 1,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount: viewAllFoodCategory.length,
              (BuildContext context, int index) {
                return isApiCalling
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary,
                        ),
                      )
                    : viewAllFoodCategory.isEmpty
                        ? const CustomNoDataFound()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: GestureDetector(
                              onTap: () {
                                sideDrawerController.previousIndex =
                                    sideDrawerController.index.value;
                                sideDrawerController.foodCategoryId =
                                    viewAllFoodCategory[index]["id"].toString();
                                sideDrawerController.foodCategoryTitle =
                                    viewAllFoodCategory[index]["title"]
                                        .toString();
                                sideDrawerController.index.value = 17;
                                sideDrawerController.pageController.jumpToPage(
                                    sideDrawerController.index.value);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02),
                                decoration: BoxDecoration(
                                    // color: Colors.teal[100 * (index % 9)],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        size.width * 0.05),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 4,
                                          color: Colors.black26)
                                    ]),
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.17,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                size.width * 0.05),
                                            topRight: Radius.circular(
                                                size.width * 0.05),
                                          ),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  viewAllFoodCategory[index]
                                                          ['image_url']
                                                      .toString()),
                                              fit: BoxFit.cover)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.01),
                                      child: Container(
                                        height: size.height * 0.03,
                                        width: size.width,
                                        color: ColorConstants.kPrimary,
                                        child: Center(
                                          child: customText.kText(
                                            "${viewAllFoodCategory[index]['title']}",
                                            15,
                                            FontWeight.w700,
                                            Colors.white,
                                            TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:food_delivery/api_services/api_service.dart';
// import 'package:food_delivery/constants/color_constants.dart';
// import 'package:food_delivery/constants/text_constants.dart';
// import 'package:food_delivery/controllers/side_drawer_controller.dart';
// import 'package:food_delivery/utils/custom_button.dart';
// import 'package:food_delivery/utils/custom_no_data_found.dart';
// import 'package:food_delivery/utils/custom_text.dart';
// import 'package:get/get.dart';

// class FoodCategory extends StatefulWidget {
//   const FoodCategory({super.key});

//   @override
//   State<FoodCategory> createState() => _FoodCategoryState();
// }

// class _FoodCategoryState extends State<FoodCategory> {
//   SideDrawerController sideDrawerController = Get.put(SideDrawerController());
//   TextEditingController searchController = TextEditingController();
//   dynamic size;
//   final customText = CustomText();
//   final List<String> items = [
//     TextConstants.newNess,
//   ];
//   String? selectedValue;
//   String searchValue = "";
//   String networkImgUrl =
//       "https://s3-alpha-sig.figma.com/img/2d0c/88be/5584e0af3dc9e87947fcb237a160d230?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N3MZ8MuVlPrlR8KTBVNhyEAX4fwc5fejCOUJwCEUpdBsy3cYwOOdTvBOBOcjpLdsE3WXcvCjY5tjvG8bofY3ivpKb5z~b3niF9jcICifVqw~jVvfx4x9WDa78afqPt0Jr4tm4t1J7CRF9BHcokNpg9dKNxuEBep~Odxmhc511KBkoNjApZHghatTA0LsaTexfSZXYvdykbhMuNUk5STsD5J4zS8mjCxVMRX7zuMXz85zYyfi7cAfX5Z6LVsoW0ngO7L6HKAcIgN4Rry9Lj2OFba445Mpd4Mx8t0fcsDPwQPbUDPHiBf3G~6HHcWjCBHKV0PiBZmt86HcvZntkFzWYg__";

//   bool isApiCalling = false;
//   final api = API();
//   List<dynamic> viewAllFoodCategory = [""];
//   // view all category

//   viewAllFoodCategoryData(
//       {String orderby = "", String searchResult = ""}) async {
//     setState(() {
//       isApiCalling = true;
//     });
//     final response = await api.viewAllFoodCategory(
//       orderBy: orderby,
//       searchResult: searchResult,
//     );
//     setState(() {
//       viewAllFoodCategory = response['data'];
//     });
//     setState(() {
//       isApiCalling = false;
//     });

//     if (response["status"] == true) {
//       print('all food category success message: ${response["message"]}');

//       print('product list: ${viewAllFoodCategory}');
//     } else {
//       print('all food category error message: ${response["message"]}');
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     viewAllFoodCategoryData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         height: size.height,
//         width: size.width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: size.height * 0.06,
//               width: size.width,
//               // color: Colors.grey.shade300,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: size.width * .6,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.only(
//                               left: 10, top: 5, bottom: 5),
//                           height: size.height * 0.05,
//                           width: size.width * 0.3,
//                           decoration: BoxDecoration(
//                             color: ColorConstants.kSortButton,
//                             borderRadius:
//                                 BorderRadius.circular(size.width * 0.02),
//                           ),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton2<String>(
//                               isExpanded: true,
//                               hint: Text(TextConstants.sortBy,
//                                   style: customText.kTextStyle(
//                                       16, FontWeight.w500, Colors.black)),
//                               items: items
//                                   .map(
//                                       (String item) => DropdownMenuItem<String>(
//                                             value: item,
//                                             child: Text(
//                                               item,
//                                               style: const TextStyle(
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ))
//                                   .toList(),
//                               value: selectedValue,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   selectedValue = value;
//                                   if (selectedValue == items[0]) {
//                                     searchValue = "latest";
//                                   }
//                                 });
//                                 print("search value: ${searchValue}");
//                               },
//                               buttonStyleData: const ButtonStyleData(
//                                 padding: EdgeInsets.symmetric(horizontal: 16),
//                                 height: 40,
//                                 width: 140,
//                               ),
//                               menuItemStyleData: const MenuItemStyleData(
//                                 height: 40,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: size.width * .010),
//                         GestureDetector(
//                           onTap: () async {
//                             // apply filter
//                             print("Apply filter: ${searchValue}");
//                             viewAllFoodCategoryData(orderby: searchValue);
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.only(top: 10, bottom: 10),
//                             width: size.width * .22,
//                             decoration: BoxDecoration(
//                                 color: ColorConstants.kPrimary,
//                                 borderRadius: BorderRadius.circular(8)),
//                             child: Center(
//                               child: customText.kText(
//                                 TextConstants.applyNow,
//                                 12,
//                                 FontWeight.w700,
//                                 Colors.white,
//                                 TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(left: 5),
//                       margin:
//                           const EdgeInsets.only(top: 10, bottom: 10, right: 10),
//                       width: size.width * .2,
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(8)),
//                       child: TextFormField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           enabledBorder: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           suffixIcon: searchController.text.isEmpty
//                               ? const Icon(Icons.search)
//                               : GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       viewAllFoodCategoryData(
//                                           orderby: searchValue,
//                                           searchResult: searchController.text);
//                                     });
//                                   },
//                                   child: const Icon(Icons.arrow_forward),
//                                 ),
//                           border: OutlineInputBorder(),
//                           hintText: TextConstants.search,
//                         ),
//                         onChanged: (value) {
//                           if (searchController.text.isEmpty) {
//                             viewAllFoodCategoryData(
//                                 orderby: searchValue, searchResult: "");
//                             FocusScope.of(context).unfocus();
//                           }

//                           setState(() {
//                             // searchController.clear();
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: size.height * 0.18,
//               width: size.width,
//               margin: EdgeInsets.only(bottom: size.height * 0.01),
//               decoration: const BoxDecoration(
//                   color: Colors.yellow,
//                   image: DecorationImage(
//                       image: AssetImage("assets/images/banner.png"),
//                       fit: BoxFit.fitHeight)),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     color: Colors.black54,
//                   ),
//                   Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         customText.kText(TextConstants.foodCategory, 28,
//                             FontWeight.w900, Colors.white, TextAlign.center),
//                         SizedBox(
//                           height: size.height * 0.01,
//                         ),
//                         RichText(
//                           text: TextSpan(
//                               text: TextConstants.home,
//                               style: customText.kSatisfyTextStyle(
//                                   24, FontWeight.w400, Colors.white),
//                               children: [
//                                 TextSpan(
//                                     text: " / ${TextConstants.foodCategory}",
//                                     style: customText.kSatisfyTextStyle(
//                                         24,
//                                         FontWeight.w400,
//                                         ColorConstants.kPrimary))
//                               ]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // grid view
//             Container(
//               height: size.height * .3,
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // number of items in each row
//                   mainAxisSpacing: 8.0, // spacing between rows
//                   crossAxisSpacing: 8.0, // spacing between columns
//                 ),
//                 padding: EdgeInsets.all(8.0), // padding around the grid
//                 itemCount: viewAllFoodCategory.length, // total number of items
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 3),
//                     child: GestureDetector(
//                       onTap: () {
//                         sideDrawerController.previousIndex =
//                             sideDrawerController.index.value;
//                         sideDrawerController.foodCategoryId =
//                             viewAllFoodCategory[index]["id"].toString();
//                         sideDrawerController.index.value = 17;
//                         sideDrawerController.pageController
//                             .jumpToPage(sideDrawerController.index.value);
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         margin:
//                             EdgeInsets.symmetric(horizontal: size.width * 0.02),
//                         decoration: BoxDecoration(
//                             // color: Colors.teal[100 * (index % 9)],
//                             color: Colors.white,
//                             borderRadius:
//                                 BorderRadius.circular(size.width * 0.05),
//                             boxShadow: const [
//                               BoxShadow(
//                                   offset: Offset(0, 1),
//                                   blurRadius: 4,
//                                   color: Colors.black26)
//                             ]),
//                         child: Column(
//                           children: [
//                             Container(
//                               height: size.height * 0.17,
//                               width: size.width,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(size.width * 0.05),
//                                     topRight:
//                                         Radius.circular(size.width * 0.05),
//                                   ),
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           viewAllFoodCategory[index]
//                                                   ['image_url']
//                                               .toString()),
//                                       fit: BoxFit.cover)),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(top: size.height * 0.01),
//                               child: Container(
//                                 height: size.height * 0.03,
//                                 width: size.width,
//                                 color: ColorConstants.kPrimary,
//                                 child: Center(
//                                   child: customText.kText(
//                                     "${viewAllFoodCategory[index]['title']}",
//                                     15,
//                                     FontWeight.w700,
//                                     Colors.white,
//                                     TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
