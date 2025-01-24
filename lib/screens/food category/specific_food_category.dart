import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_specific_food.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_product_item.dart';
import 'package:get/get.dart';

class SpecificFoodCategory extends StatefulWidget {
  const SpecificFoodCategory({super.key});

  @override
  State<SpecificFoodCategory> createState() => _SpecificFoodCategoryState();
}

class _SpecificFoodCategoryState extends State<SpecificFoodCategory> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  TextEditingController searchController = TextEditingController();
  dynamic size;
  bool isApiCalling = false;

  final customText = CustomText();
  final api = API();
  List<dynamic> specificFoodCategoryList = [""];
  final List<String> items = [
    TextConstants.newNess,
  ];
  String? selectedValue;
  String searchValue = "";

  specificFoodCategoryData(
      {String orderby = "", String searchResult = ""}) async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.specificFoodCategory(
      categoryId: sideDrawerController.foodCategoryId.toString(),
      orderBy: orderby,
      searchResult: searchResult,
    );
    setState(() {
      specificFoodCategoryList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('specific food category success message: ${response["message"]}');
    } else {
      print('all food category error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    specificFoodCategoryData();
    print(
        "category id is : ${sideDrawerController.foodCategoryId} and ${sideDrawerController.foodCategoryTitle}");
    super.initState();
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
                              onTap: () {
                                // apply filter
                                // apply filter
                                print("Apply filter: ${searchValue}");
                                specificFoodCategoryData(orderby: searchValue);
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
                                          specificFoodCategoryData(
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
                                specificFoodCategoryData(
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
                                sideDrawerController.foodCategoryTitle.isEmpty
                                    ? TextConstants.foodCategory
                                    : sideDrawerController.foodCategoryTitle,
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
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 15.0,
              // crossAxisSpacing: 10.0,
              childAspectRatio: 1 / 1.4,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount: specificFoodCategoryList.length,
              (BuildContext context, int index) {
                return isApiCalling
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.kPrimary,
                        ),
                      )
                    : specificFoodCategoryList.isEmpty
                        ? const CustomNoDataFound()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: GestureDetector(
                              onTap: () {
                                sideDrawerController.previousIndex =
                                    sideDrawerController.index.value;
                                sideDrawerController.index.value = 18;
                                sideDrawerController.pageController.jumpToPage(
                                    sideDrawerController.index.value);
                              },
                              child: CustomSpecificFood(
                                likeCount:
                                    "${specificFoodCategoryList[index]['likes']}",
                                dislikeCount:
                                    "${specificFoodCategoryList[index]['dislikes']}",
                                addTocart: TextConstants.addToCart,
                                amount:
                                    "\$${specificFoodCategoryList[index]['price']}",
                                imageURL: specificFoodCategoryList[index]
                                    ['image'],
                                foodItemName:
                                    "${specificFoodCategoryList[index]['name']}",
                                restaurantName: "",
                                likeIcon: Icons.thumb_up,
                                dislikeIcon: Icons.thumb_up,
                                favouriteIcon: Icons.favorite,
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
