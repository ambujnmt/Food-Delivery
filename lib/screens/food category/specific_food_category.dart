import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/login_screen.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_specific_food.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_product_item.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SpecificFoodCategory extends StatefulWidget {
  const SpecificFoodCategory({super.key});

  @override
  State<SpecificFoodCategory> createState() => _SpecificFoodCategoryState();
}

class _SpecificFoodCategoryState extends State<SpecificFoodCategory> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  TextEditingController searchController = TextEditingController();
  dynamic size;
  bool isApiCalling = false;

  final customText = CustomText();
  final api = API(), box = GetStorage();
  final helper = Helper();
  List<dynamic> specificFoodCategoryList = [""];
  final List<String> items = [
    TextConstants.newNess,
  ];
  String? selectedValue;
  String searchValue = "";
  Position? _currentPosition;
  String _currentAddress = 'Unknown location';
  String? getLatitude;
  String? getLongitude;
  String calculatedDistance = "";

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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: specificFoodCategoryList.isEmpty
            ? Center(child: const CustomNoDataFound())
            : SizedBox(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 5, bottom: 5),
                                        height: size.height * 0.05,
                                        width: size.width * 0.3,
                                        decoration: BoxDecoration(
                                          color: ColorConstants.kSortButton,
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.02),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(TextConstants.sortBy,
                                                style: customText.kTextStyle(
                                                    16,
                                                    FontWeight.w500,
                                                    Colors.black)),
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
                                              print(
                                                  "search value: ${searchValue}");
                                            },
                                            buttonStyleData:
                                                const ButtonStyleData(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              height: 40,
                                              width: 140,
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
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
                                          specificFoodCategoryData(
                                              orderby: searchValue);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          width: size.width * .22,
                                          decoration: BoxDecoration(
                                              color: ColorConstants.kPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
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
                                        suffixIcon: searchController
                                                .text.isEmpty
                                            ? const Icon(Icons.search)
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    specificFoodCategoryData(
                                                        orderby: searchValue,
                                                        searchResult:
                                                            searchController
                                                                .text);
                                                  });
                                                },
                                                child: const Icon(
                                                    Icons.arrow_forward),
                                              ),
                                        border: OutlineInputBorder(),
                                        hintText: TextConstants.search,
                                      ),
                                      onChanged: (value) {
                                        if (searchController.text.isEmpty) {
                                          specificFoodCategoryData(
                                              orderby: searchValue,
                                              searchResult: "");
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
                          // Container(
                          //   height: size.height * 0.18,
                          //   width: size.width,
                          //   margin: EdgeInsets.only(bottom: size.height * 0.01),
                          //   decoration: const BoxDecoration(
                          //       color: Colors.yellow,
                          //       image: DecorationImage(
                          //           image:
                          //               AssetImage("assets/images/banner.png"),
                          //           fit: BoxFit.fitHeight)),
                          //   child: Stack(
                          //     alignment: Alignment.center,
                          //     children: [
                          //       Container(
                          //         color: Colors.black54,
                          //       ),
                          //       Center(
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             customText.kText(
                          //                 sideDrawerController
                          //                         .foodCategoryTitle.isEmpty
                          //                     ? TextConstants.foodCategory
                          //                     : sideDrawerController
                          //                         .foodCategoryTitle,
                          //                 28,
                          //                 FontWeight.w900,
                          //                 Colors.white,
                          //                 TextAlign.center),
                          //             SizedBox(
                          //               height: size.height * 0.01,
                          //             ),
                          //             RichText(
                          //               text: TextSpan(
                          //                   text: TextConstants.home,
                          //                   style: customText.kSatisfyTextStyle(
                          //                       24,
                          //                       FontWeight.w400,
                          //                       Colors.white),
                          //                   children: [
                          //                     TextSpan(
                          //                         text:
                          //                             " / ${TextConstants.foodCategory}",
                          //                         style: customText
                          //                             .kSatisfyTextStyle(
                          //                                 24,
                          //                                 FontWeight.w400,
                          //                                 ColorConstants
                          //                                     .kPrimary))
                          //                   ]),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
          isApiCalling
              ? const Center(
            child: CircularProgressIndicator(
              color: ColorConstants.kPrimary,
            ),
          )
              : specificFoodCategoryList.isEmpty
              ? Container(
            width: width,
            height: height * 0.23,
            margin: EdgeInsets.only(bottom: height * 0.01),
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                "No Data Found",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
              : Builder(
            builder: (context) {
              final data = specificFoodCategoryList[0];

              final imageUrl =
                  data['restaurant_business_image']?.toString() ?? '';
              final latitude = data['latitude']?.toString() ?? '';
              final longitude = data['longitude']?.toString() ?? '';
              final hasImage = imageUrl.isNotEmpty;

              return Container(
                width: width,
                height: height * 0.23,
                margin: EdgeInsets.only(bottom: height * 0.01),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background image with dark overlay
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.75),
                        BlendMode.darken,
                      ),
                      child: hasImage
                          ? Image.network(
                        imageUrl,
                        width: width,
                        height: height * 0.23,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _fallbackImage(width, height),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _fallbackImage(width, height);
                        },
                      )
                          : _fallbackImage(width, height),
                    ),

                    // Foreground content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText.kText(
                          sideDrawerController.foodCategoryTitle.isEmpty
                              ? TextConstants.foodCategory
                              : sideDrawerController.foodCategoryTitle,
                          28,
                          FontWeight.w900,
                          Colors.white,
                          TextAlign.center,
                        ),
                        SizedBox(height: height * 0.01),
                        RichText(
                          text: TextSpan(
                            text: TextConstants.home,
                            style: customText.kSatisfyTextStyle(
                              24,
                              FontWeight.w400,
                              Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: " / ${TextConstants.foodDetail}",
                                style: customText.kSatisfyTextStyle(
                                  24,
                                  FontWeight.w400,
                                  ColorConstants.kPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        customText.kText(
                          latitude.isNotEmpty && longitude.isNotEmpty
                              ? calculateDistance(
                            restaurantLat: latitude,
                            restaurantLong: longitude,
                          )
                              : 'Distance not available',
                          18,
                          FontWeight.w700,
                          Colors.white,
                          TextAlign.center,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: customText.kText(
                            sideDrawerController.restaurantAddress ??
                                'No address available',
                            14,
                            FontWeight.w900,
                            Colors.white,
                            TextAlign.center,
                            TextOverflow.ellipsis,
                            2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
          ],
                      ),
                    ),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                      child: CustomSpecificFood(
                                        favouritePress: () async {
                                          if (loginController
                                              .accessToken.isNotEmpty) {
                                            var response;
                                            if (specificFoodCategoryList[index]
                                                    ['is_favorite'] ==
                                                false) {
                                              print("MARK AS FAV");
                                              response =
                                                  await api.markFavourite(
                                                productId:
                                                    specificFoodCategoryList[
                                                            index]['id']
                                                        .toString(),
                                              );
                                            } else {
                                              print("REMOVE FROM FAV");
                                              response =
                                                  await api.removeFromFavourite(
                                                productId:
                                                    specificFoodCategoryList[
                                                            index]['id']
                                                        .toString(),
                                              );
                                            }

                                            if (response['status'] == true) {
                                              helper.successDialog(
                                                  context, response['message']);
                                              specificFoodCategoryData();
                                            } else {
                                              helper.errorDialog(
                                                  context, response['message']);
                                            }
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          }
                                        },
                                        likePress: () async {
                                          if (loginController
                                              .accessToken.isNotEmpty) {
                                            final response =
                                                await api.likeProduct(
                                              productId:
                                                  specificFoodCategoryList[
                                                          index]['id']
                                                      .toString(),
                                            );
                                            if (response['status'] == true) {
                                              helper.successDialog(
                                                  context, response['message']);
                                              specificFoodCategoryData();
                                            } else {
                                              helper.errorDialog(
                                                  context, response['message']);
                                            }
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          }
                                        },
                                        dislikePress: () async {
                                          if (loginController
                                              .accessToken.isNotEmpty) {
                                            final response =
                                                await api.dislikeProduct(
                                              productId:
                                                  specificFoodCategoryList[
                                                          index]['id']
                                                      .toString(),
                                            );
                                            if (response['status'] == true) {
                                              helper.successDialog(
                                                  context, response['message']);
                                              specificFoodCategoryData();
                                            } else {
                                              helper.errorDialog(
                                                  context, response['message']);
                                            }
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          }
                                        },
                                        imagePress: () {
                                          //---------------//

                                          sideDrawerController
                                                  .specificCatTitle =
                                              sideDrawerController
                                                  .foodCategoryTitle;
                                          sideDrawerController.specificCatName =
                                              specificFoodCategoryList[index]
                                                  ['name'];
                                          sideDrawerController
                                                  .specificCatImage =
                                              specificFoodCategoryList[index]
                                                  ['image'];
                                          sideDrawerController
                                                  .specificCatPrice =
                                              specificFoodCategoryList[index]
                                                  ['price'];
                                          sideDrawerController
                                                  .specificFoodResId =
                                              specificFoodCategoryList[index]
                                                      ['user_id']
                                                  .toString();
                                          sideDrawerController
                                                  .SpecificFoodProId =
                                              specificFoodCategoryList[index]
                                                      ['id']
                                                  .toString();
                                          //-------------------//
                                          print(
                                              "specific food back press: ${sideDrawerController.index.value}");
                                          // sideDrawerController.previousIndex =
                                          // sideDrawerController.index.value;

                                          sideDrawerController.previousIndex
                                              .add(sideDrawerController
                                                  .index.value);
                                          print(
                                              "food category previous index: ${sideDrawerController.previousIndex}");
                                          print(
                                              "food category back press: ${sideDrawerController.index.value}");
                                          sideDrawerController.index.value = 18;
                                          sideDrawerController.pageController
                                              .jumpToPage(sideDrawerController
                                                  .index.value);
                                        },
                                        addToCartPress: () async {
                                          log("specific food category :- ${specificFoodCategoryList[index]}");

                                          // print("add to cart");
                                          if (loginController
                                              .accessToken.isNotEmpty) {
                                            if (sideDrawerController
                                                    .cartListRestaurant
                                                    .isEmpty ||
                                                sideDrawerController
                                                        .cartListRestaurant ==
                                                    specificFoodCategoryList[
                                                            index]["user_id"]
                                                        .toString()) {
                                              log("add product and update value");

                                              await box.write(
                                                  "cartListRestaurant",
                                                  specificFoodCategoryList[
                                                          index]["user_id"]
                                                      .toString());
                                              setState(() {
                                                sideDrawerController
                                                        .cartListRestaurant =
                                                    specificFoodCategoryList[
                                                            index]["user_id"]
                                                        .toString();
                                              });

                                              bottomSheet(
                                                specificFoodCategoryList[index]
                                                    ['image'],
                                                specificFoodCategoryList[index]
                                                    ['name'],
                                                specificFoodCategoryList[index]
                                                    ['price'],
                                                specificFoodCategoryList[index]
                                                        ['id']
                                                    .toString(),
                                                specificFoodCategoryList[index]
                                                        ['user_id']
                                                    .toString(),
                                              );
                                            } else {
                                              helper.errorDialog(context,
                                                  "Your cart is already have food from different restaurant");
                                            }
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ),
                                            );
                                          }
                                        },
                                        likeCount:
                                            "${specificFoodCategoryList[index]['likes']}",
                                        dislikeCount:
                                            "${specificFoodCategoryList[index]['dislikes']}",
                                        addTocart: TextConstants.addToCart,
                                        amount:
                                            "\$${specificFoodCategoryList[index]['price']}",
                                        imageURL:
                                            specificFoodCategoryList[index]
                                                ['image'],
                                        foodItemName:
                                            "${specificFoodCategoryList[index]['name']}",
                                        restaurantName:
                                            "${specificFoodCategoryList[index]['resturant_name']}",
                                        likeIcon: Icons.thumb_up,
                                        dislikeIcon: Icons.thumb_up,
                                        favouriteIcon:
                                            specificFoodCategoryList[index]
                                                        ['is_favorite'] ==
                                                    true
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                      ),
                                    );
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }

  // bottom sheet for adding items to the cart
  void bottomSheet(String image, String name, String price, String productId,
      String restaurantId) {
    int quantity = 1;
    int calculatedPrice = 0;
    bool cartCalling = false;
    final api = API();
    final helper = Helper();

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter update) {
            void increaseQuantity() {
              print("Incrementing");

              quantity++;
              calculatedPrice =
                  int.parse(price.toString().split('.')[0]) * quantity;
              update(() {});
              print("Quantity: $quantity");
              print("price: ${calculatedPrice.toString()}");
            }

            void decreaseQuantity() {
              if (quantity > 1) {
                quantity--;
                calculatedPrice =
                    int.parse(price.toString().split('.')[0]) * quantity;
                // price = (double.parse(price) * quantity).toStringAsFixed(2);
              }
              update(() {});
              print("price: ${calculatedPrice.toString()}");
            }

            addToCart() async {
              update(() {
                cartCalling = true;
              });

              final response = await api.addItemsToCart(
                userId: loginController.userId.toString(),
                price: calculatedPrice.toString(),
                quantity: quantity.toString(),
                // restaurantId: sideDrawerController.restaurantId,
                restaurantId: restaurantId.toString(),
                productId: productId.toString(),
              );

              update(() {
                cartCalling = false;
              });

              if (response["status"] == true) {
                print('success message: ${response["message"]}');
                helper.successDialog(context, response["message"]);
                Navigator.pop(context);
              } else {
                helper.errorDialog(context, response["error"]);
                print('error message: ${response["error"]}');
              }
            }

            return Container(
              margin: EdgeInsets.all(20),
              height: size.height * .25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: size.height * .050,
                        width: size.width * .1,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: NetworkImage(image),
                          ),
                        ),
                      ),
                      Container(
                        child: customText.kText(
                          name,
                          18,
                          FontWeight.w800,
                          Colors.black,
                          TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .010),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: customText.kText(
                              "\$$price",
                              20,
                              FontWeight.w800,
                              Colors.black,
                              TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Container(
                            child: customText.kText(
                              calculatedPrice == 0
                                  ? "Total amount: \$$price"
                                  : "Total amount: \$$calculatedPrice",
                              20,
                              FontWeight.w800,
                              Colors.black,
                              TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: size.height * .050,
                        width: size.width * .3,
                        decoration: BoxDecoration(
                          color: ColorConstants.kPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                decreaseQuantity();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: customText.kText(
                                quantity.toString(),
                                18,
                                FontWeight.w800,
                                Colors.white,
                                TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                increaseQuantity();
                              },
                              child: Container(
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .020),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        addToCart();
                      },
                      child: Container(
                        width: size.width * .2,
                        height: size.height * .050,
                        decoration: BoxDecoration(
                          color: ColorConstants.kPrimary,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
                        ),
                        child: Center(
                          child: cartCalling
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : customText.kText(
                                  TextConstants.add,
                                  18,
                                  FontWeight.w900,
                                  Colors.white,
                                  TextAlign.center,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
      _currentAddress =
      'Lat: ${position.latitude}, Long: ${position.longitude}';
      getLatitude = position.latitude.toString();
      getLongitude = position.longitude.toString();
    });
  }

  // Get Current Location
  String calculateDistance({String? restaurantLat, String? restaurantLong}) {
    getCurrentPosition();
    print("get lat: $getLatitude");
    print("get long: $getLongitude");
    try {
      // Calculate distance in meters
      double distanceInMeters = Geolocator.distanceBetween(
        double.parse(getLatitude.toString()),
        double.parse(getLongitude.toString()),
        double.parse(restaurantLat.toString()),
        double.parse(restaurantLong.toString()),
      );

      // Convert to miles
      double distanceInMiles = distanceInMeters / 1609.34;
      String formattedMiles = distanceInMiles.toStringAsFixed(2);

      print("Distance: ${distanceInMeters.toStringAsFixed(2)} meters");
      print("Distance in miles updated: $formattedMiles miles");

      return "$formattedMiles MLs";
    } catch (e) {
      print("Error retrieving location: $e");
      return "Loading...";
    }
  }

  _fallbackImage(double width, double height) {
    return
      Container(
        width: width,
        height: height * 0.23,
        color: Colors.grey[300],
        child: const Center(
            child:
            CircularProgressIndicator()),
      );
  }
}
