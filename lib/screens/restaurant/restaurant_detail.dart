import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';

class RestaurantDetail extends StatefulWidget {
  const RestaurantDetail({super.key});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  dynamic size;
  final customText = CustomText();
  int tabSelected = 0;
  final List<String> items = [
    TextConstants.popularity,
    TextConstants.priceLowHigh,
    TextConstants.priceHighLow,
  ];

  List<String> itemName = [
    "Recommended(12)",
    "North Indian(18)",
    "West Indian(6)",
    "Fast Food(4)",
  ];
  String? selectedValue;
  String networkImgUrl =
      "https://s3-alpha-sig.figma.com/img/2d0c/88be/5584e0af3dc9e87947fcb237a160d230?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N3MZ8MuVlPrlR8KTBVNhyEAX4fwc5fejCOUJwCEUpdBsy3cYwOOdTvBOBOcjpLdsE3WXcvCjY5tjvG8bofY3ivpKb5z~b3niF9jcICifVqw~jVvfx4x9WDa78afqPt0Jr4tm4t1J7CRF9BHcokNpg9dKNxuEBep~Odxmhc511KBkoNjApZHghatTA0LsaTexfSZXYvdykbhMuNUk5STsD5J4zS8mjCxVMRX7zuMXz85zYyfi7cAfX5Z6LVsoW0ngO7L6HKAcIgN4Rry9Lj2OFba445Mpd4Mx8t0fcsDPwQPbUDPHiBf3G~6HHcWjCBHKV0PiBZmt86HcvZntkFzWYg__";

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
                    color: Colors.grey.shade300,
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
                              customText.kText(
                                  "Restaurant Name",
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
                                              " / ${TextConstants.restaurant}",
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

            SliverToBoxAdapter(
              child: Container(
                // color: Colors.yellow.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: size.height * 0.15,
                      width: size.width * 0.45,
                      margin: EdgeInsets.only(
                          top: size.height * 0.01,
                          left: size.width * 0.02,
                          bottom: size.height * 0.01),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02)),
                    ),
                    Container(
                      height: size.height * 0.15,
                      width: size.width * 0.45,
                      margin: EdgeInsets.only(
                          top: size.height * 0.01,
                          right: size.width * 0.02,
                          bottom: size.height * 0.01),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 4.0,
                                childAspectRatio: 1 / 0.73),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02)),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  height: size.height * 0.05,
                  width: size.width,
                  // color: Colors.lightGreen,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: size.width * 0.02),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01),
                          decoration: BoxDecoration(
                              color: tabSelected == 0
                                  ? ColorConstants.kPrimary
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02)),
                          child: Center(
                            child: customText.kText(
                                TextConstants.orderOnline,
                                16,
                                FontWeight.w700,
                                tabSelected == 0 ? Colors.white : Colors.black,
                                TextAlign.center),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            tabSelected = 0;
                          });
                        },
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      GestureDetector(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: size.width * 0.02),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01),
                          decoration: BoxDecoration(
                              color: tabSelected == 1
                                  ? ColorConstants.kPrimary
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02)),
                          child: Center(
                            child: customText.kText(
                                TextConstants.overview,
                                16,
                                FontWeight.w700,
                                tabSelected == 1 ? Colors.white : Colors.black,
                                TextAlign.center),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            tabSelected = 1;
                          });
                        },
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      GestureDetector(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: size.width * 0.02),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01),
                          decoration: BoxDecoration(
                              color: tabSelected == 2
                                  ? ColorConstants.kPrimary
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02)),
                          child: Center(
                            child: customText.kText(
                                TextConstants.reviews,
                                16,
                                FontWeight.w700,
                                tabSelected == 2 ? Colors.white : Colors.black,
                                TextAlign.center),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            tabSelected = 2;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const Divider(
                  color: ColorConstants.kPrimary,
                  thickness: 2,
                  height: 0,
                ),

                // Container(
                //   height: size.height * 0.05,
                //   width: size.width,
                //   margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //
                //       Container(
                //         height: size.height * 0.05,
                //         width: size.width * 0.65,
                //         decoration: BoxDecoration(
                //           color: ColorConstants.kSortButton,
                //           borderRadius: BorderRadius.circular(size.width * 0.02),
                //           boxShadow: const [
                //             BoxShadow(
                //               offset: Offset(0,1),
                //               blurRadius: 4,
                //               color: Colors.black26
                //             )
                //           ]
                //         ),
                //         child: DropdownButtonHideUnderline(
                //           child: DropdownButton2<String>(
                //             isExpanded: true,
                //             hint: Text(
                //               TextConstants.sortBy,
                //               style: customText.kTextStyle(16, FontWeight.w500, Colors.black)
                //             ),
                //             items: items
                //                 .map((String item) => DropdownMenuItem<String>(
                //               value: item,
                //               child: Text(
                //                 item,
                //                 style: const TextStyle(
                //                   fontSize: 14,
                //                 ),
                //               ),
                //             ))
                //                 .toList(),
                //             value: selectedValue,
                //             onChanged: (String? value) {
                //               setState(() {
                //                 selectedValue = value;
                //               });
                //             },
                //             buttonStyleData: const ButtonStyleData(
                //               padding: EdgeInsets.symmetric(horizontal: 16),
                //               height: 40,
                //               width: 140,
                //             ),
                //             menuItemStyleData: const MenuItemStyleData(
                //               height: 40,
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //       SizedBox(
                //         width: size.width * 0.28,
                //         child: CustomButton(
                //           fontSize: 16,
                //           hintText: TextConstants.applyNow),
                //       ),
                //
                //     ],
                //   ),
                // )
              ],
            )),

            if (tabSelected == 0)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // sort by
                    Container(
                      height: size.height * 0.05,
                      width: size.width,
                      margin:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.width * 0.65,
                            decoration: BoxDecoration(
                                color: ColorConstants.kSortButton,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02),
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                      color: Colors.black26)
                                ]),
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
                            width: size.width * 0.28,
                            child: CustomButton(
                                fontSize: 16, hintText: TextConstants.applyNow),
                          ),
                        ],
                      ),
                    ),

                    // title
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.01),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: customText.kText(TextConstants.topPicks, 20,
                            FontWeight.w700, Colors.black, TextAlign.center),
                      ),
                    ),

                    // best selling
                    SizedBox(
                      height: size.height * 0.25,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02),
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  height: size.height * 0.25,
                                  width: size.width * 0.75,
                                  margin:
                                      EdgeInsets.only(left: size.width * 0.02),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(networkImgUrl),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.05)),
                                ),
                                Container(
                                  height: size.height * 0.25,
                                  width: size.width * 0.75,
                                  margin:
                                      EdgeInsets.only(left: size.width * 0.02),
                                  decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.05)),
                                ),
                                SizedBox(
                                  height: size.height * 0.25,
                                  width: size.width * 0.75,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: size.height * 0.15,
                                        width: size.width * 0.4,
                                        margin: EdgeInsets.only(
                                            left: size.width * 0.02),
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.height * 0.01),
                                        decoration: BoxDecoration(
                                            // color: Colors.black,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    size.width * 0.05))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.03),
                                                child: customText.kSatisfyText(
                                                    TextConstants.bestSelling,
                                                    18,
                                                    FontWeight.w900,
                                                    Colors.white,
                                                    TextAlign.center)),
                                            const Divider(
                                              color: ColorConstants.kPrimary,
                                              thickness: 2,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.03),
                                                child: customText.kText(
                                                    "BURGER",
                                                    22,
                                                    FontWeight.w700,
                                                    Colors.white,
                                                    TextAlign.start)),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.01),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.04),
                                              child: customText.kText(
                                                  "\$200",
                                                  22,
                                                  FontWeight.w700,
                                                  Colors.white,
                                                  TextAlign.center),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.width * 0.02,
                                                  vertical:
                                                      size.height * 0.005),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorConstants.kPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.width * 0.02)),
                                              child: Center(
                                                child: customText.kText(
                                                    TextConstants.add,
                                                    18,
                                                    FontWeight.w900,
                                                    Colors.white,
                                                    TextAlign.center),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01)
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),

            if (tabSelected == 1)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width,
                        child: customText.kText(
                            "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iure voluptatum accusantium culpa aperiam! Maiores veniam asperiores cum a beatae unde alias eligendi minima? Consequatur libero quam nesciunt dolores provident. Mollitia. Lorem ipsum dolor, sit amet consectetur adipisicing elit. Voluptatibus iusto impedit blanditiis dignissimos cumque, esse sapiente, soluta similique natus laborum doloremque magni. Id reiciendis quae, architecto hic obcaecati ea consequatur.",
                            16,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                            TextOverflow.visible,
                            150),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: customText.kText(
                            TextConstants.popularDishes,
                            20,
                            FontWeight.w900,
                            ColorConstants.kPrimary,
                            TextAlign.center),
                      ),
                      SizedBox(
                        width: size.width,
                        child: customText.kText(
                            "Idli Sambar, Deluxe Thali, Rasgulla, Dhokla, Raj Kachori, Chocolate Fudge",
                            16,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                            TextOverflow.visible,
                            150),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: customText.kText(
                            TextConstants.peopleSayAboutPlace,
                            20,
                            FontWeight.w900,
                            ColorConstants.kPrimary,
                            TextAlign.center),
                      ),
                      SizedBox(
                        width: size.width,
                        child: customText.kText(
                            "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iure voluptatum accusantium culpa aperiam! Maiores veniam asperiores cum a beatae unde alias eligendi minima? Consequatur libero quam nesciunt dolores provident. Mollitia. Lorem ipsum dolor, sit amet consectetur adipisicing elit. Voluptatibus iusto impedit blanditiis dignissimos cumque, esse sapiente, soluta similique natus laborum doloremque magni. Id reiciendis quae, architecto hic obcaecati ea consequatur.",
                            16,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                            TextOverflow.visible,
                            150),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: customText.kText(
                            TextConstants.moreInfo,
                            20,
                            FontWeight.w900,
                            ColorConstants.kPrimary,
                            TextAlign.center),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      )
                    ],
                  ),
                ),
              ),

            if (tabSelected == 0)
              SliverList(
                // itemExtent: 70.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: customText.kText("${itemName[index]}", 16,
                          FontWeight.bold, Colors.black, TextAlign.start),
                      children: [
                        Padding(
                          // color: Colors.red,
                          // height: 150,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            // physics: NeverScrollableScrollPhysics(),
                            children: [
                              for (int i = 0; i < 3; i++)
                                Container(
                                  height: size.height * .200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: customText.kText(
                                                "CHICKEN SALAD",
                                                16,
                                                FontWeight.w700,
                                                Colors.black,
                                                TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: customText.kText(
                                                "-\$200.0",
                                                14,
                                                FontWeight.w500,
                                                Colors.black,
                                                TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              width: size.width * .5,
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: customText.kText(
                                                "Lorem Ipsum is simply dummy text of the printing and type setting industry. Lorem Ipsum is simply dummy text of the printing and type setting industry....................... more",
                                                14,
                                                FontWeight.w500,
                                                Colors.black,
                                                TextAlign.start,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 20, bottom: 10),
                                            height: size.height * .12,
                                            width: size.width * .3,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: const DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    'https://thumbs.dreamstime.com/b/indian-veg-thali-traditional-food-285733456.jpg'),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              left: 20,
                                              child: Container(
                                                height: 35,
                                                width: size.width * .2,
                                                decoration: BoxDecoration(
                                                    color:
                                                        ColorConstants.kPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: const Center(
                                                    child: Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: "Raleway",
                                                      color: Colors.white),
                                                )),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                  childCount: itemName.length,
                ),
              ),

            if (tabSelected == 2)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    width: size.width,
                    margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.01),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size.width * 0.02),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 4,
                              color: Colors.black26)
                        ]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: size.height * 0.13,
                              width: size.width * 0.3,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: ColorConstants.kPrimary,
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/doll.png"),
                                      fit: BoxFit.contain,
                                    ),
                                    shape: BoxShape.circle,
                                  )),
                            ),
                            Container(
                              height: size.height * 0.13,
                              width: size.width * 0.6,
                              decoration: BoxDecoration(
                                // color: Colors.lightGreen.shade100,
                                borderRadius: BorderRadius.only(
                                    topRight:
                                        Radius.circular(size.width * 0.02),
                                    bottomRight:
                                        Radius.circular(size.width * 0.02)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText.kText(
                                      "Customer Name fdslfjsdfjlsdjfs dflsjdfs dffsd ",
                                      22,
                                      FontWeight.w900,
                                      ColorConstants.kPrimary,
                                      TextAlign.start),
                                  customText.kText(
                                      "24/11/2024 9:30 PM",
                                      18,
                                      FontWeight.w700,
                                      Colors.black,
                                      TextAlign.start),
                                  SizedBox(
                                    width: size.width * 0.55,
                                    child: RatingBar.builder(
                                      ignoreGestures: true,
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemSize: 20,
                                      itemCount: 5,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.height * 0.01),
                          child: customText.kText(
                              "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iure voluptatum accusantium culpa aperiam! Maiores veniam asperiores cum a beatae unde alias eligendi minima? Consequatur libero quam nesciunt dolores provident. Mollitia. Lorem ipsum dolor, sit amet consectetur adipisicing elit. Voluptatibus iusto impedit blanditiis dignissimos cumque, esse sapiente, soluta similique natus laborum doloremque magni. Id reiciendis quae, architecto hic obcaecati ea consequatur.",
                              16,
                              FontWeight.w700,
                              Colors.black,
                              TextAlign.start,
                              TextOverflow.visible,
                              150),
                        ),
                      ],
                    ),
                  );
                }, childCount: 7),
              ),
          ],
        ),
      ),
    );
  }
}

//return Container(
//                     height: size.height * 0.15,
//                     width: size.width,
//                     padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
//                     margin: EdgeInsets.only(bottom: size.height * 0.01, top: size.height * 0.01),
//                     color: Colors.yellow.shade100,
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: size.height * 0.14,
//                             width: size.width * 0.35,
//                             decoration: BoxDecoration(
//                                 color: Colors.grey,
//                                 borderRadius: BorderRadius.circular(size.width * 0.05)
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//
//                               SizedBox(
//                                 height: size.height * 0.08,
//                                 width: size.width * 0.55,
//                                 child: customText.kText("Restaurant ${index +1}", 20, FontWeight.w700, ColorConstants.kPrimary, TextAlign.start),
//                               ),
//
//                               // SizedBox(
//                               //   width: size.width * 0.55,
//                               //   child: RatingBar.builder(
//                               //     ignoreGestures: true,
//                               //     initialRating: 3,
//                               //     minRating: 1,
//                               //     direction: Axis.horizontal,
//                               //     allowHalfRating: true,
//                               //     itemSize: 20,
//                               //     itemCount: 5,
//                               //     itemBuilder: (context, _) => const Icon(
//                               //       Icons.star,
//                               //       color: Colors.amber,
//                               //     ),
//                               //     onRatingUpdate: (rating) {
//                               //
//                               //     },
//                               //   ),
//                               // ),
//
//                               SizedBox(
//                                 width: size.width * 0.55,
//                                 child: customText.kText("Distance : 15.0 Mls", 14, FontWeight.w500, Colors.black, TextAlign.start),
//                               ),
//
//                             ],
//                           )
//                         ],
//                       ),
//                     );
