import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/custom_product_item.dart';
import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:food_delivery/utils/custom_text_field2.dart';

class SpecialFood extends StatefulWidget {
  const SpecialFood({super.key});

  @override
  State<SpecialFood> createState() => _SpecialFoodState();
}

class _SpecialFoodState extends State<SpecialFood> {
  dynamic size;
  final customText = CustomText();
  final List<String> items = [
    TextConstants.popularity,
    TextConstants.priceLowHigh,
    TextConstants.priceHighLow,
  ];
  String? selectedValue;
  bool isApiCalling = false;
  final api = API();
  List<dynamic> allSpecialFoodList = [];
  String networkImgUrl =
      "https://s3-alpha-sig.figma.com/img/2d0c/88be/5584e0af3dc9e87947fcb237a160d230?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N3MZ8MuVlPrlR8KTBVNhyEAX4fwc5fejCOUJwCEUpdBsy3cYwOOdTvBOBOcjpLdsE3WXcvCjY5tjvG8bofY3ivpKb5z~b3niF9jcICifVqw~jVvfx4x9WDa78afqPt0Jr4tm4t1J7CRF9BHcokNpg9dKNxuEBep~Odxmhc511KBkoNjApZHghatTA0LsaTexfSZXYvdykbhMuNUk5STsD5J4zS8mjCxVMRX7zuMXz85zYyfi7cAfX5Z6LVsoW0ngO7L6HKAcIgN4Rry9Lj2OFba445Mpd4Mx8t0fcsDPwQPbUDPHiBf3G~6HHcWjCBHKV0PiBZmt86HcvZntkFzWYg__";

  // get special food list
  getAllSpecialFoodData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.viewAllSpecialFood();
    setState(() {
      allSpecialFoodList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["status"] == true) {
      print(' all special food success message: ${response["message"]}');
    } else {
      print('all special food error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllSpecialFoodData();
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
                                      });
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
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
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
                            child: const TextField(
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                suffixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                                hintText: TextConstants.search,
                              ),
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
                                  TextConstants.specialFood,
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
                                              " / ${TextConstants.specialFood}",
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
                maxCrossAxisExtent: 300.0,
                mainAxisSpacing: 15.0,
                // crossAxisSpacing: 10.0,
                childAspectRatio: 1 / 1.4,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: CustomFoodItem(
                        likeCount: "5",
                        dislikeCount: "10",
                        imageURL: "${allSpecialFoodList[index]['image']}",
                        addTocart: "${TextConstants.addToCart}",
                        amount: "${allSpecialFoodList[index]['price']}",
                        restaurantName: "",
                        foodItemName: "${allSpecialFoodList[index]['name']}",
                        likeIcon: Icons.thumb_up,
                        dislikeIcon: Icons.thumb_up,
                        favouriteIcon: Icons.favorite,
                      ));
                },
                childCount: allSpecialFoodList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
