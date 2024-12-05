import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  dynamic size;
  final customText = CustomText();

  List addressList = [
    "home",
    "work",
    "other"
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return  Scaffold(
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
                    child: customText.kText(TextConstants.savedAddress, 25, FontWeight.w900, ColorConstants.kPrimary, TextAlign.center),
                  ),
                )
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.023, vertical: size.height * 0.01),
                      margin: EdgeInsets.only(bottom: size.height * 0.01, top: size.height * 0.01),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorConstants.kPrimary),
                        borderRadius: BorderRadius.circular(size.width * 0.02),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              const Icon(Icons.home, size: 30, color: Colors.black),
                              SizedBox(width: size.width * 0.02,),
                              customText.kText(TextConstants.home, 20, FontWeight.w900, Colors.black, TextAlign.center)
                            ],
                          ),
                          
                          customText.kText("132 Dartmouth Street Boston, Massachusetts 02156 United States", 18, FontWeight.w700, Colors.black, TextAlign.start, TextOverflow.visible, 3,),

                          customText.kText("+1012 3456 789", 18, FontWeight.w700, Colors.black, TextAlign.start),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              // color: Colors.yellow,
                              width: size.width * 0.32,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: customText.kText(TextConstants.edit, 20, FontWeight.w900, ColorConstants.kPrimary, TextAlign.center),
                                    onTap: () {},
                                  ),
                                  GestureDetector(
                                    child: customText.kText(TextConstants.delete, 20, FontWeight.w900, ColorConstants.kPrimary, TextAlign.center),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      )
                    );
                  },
                  childCount: 3
              ),
            ),

            SliverToBoxAdapter(
                child: CustomButton(
                  fontSize: 24,
                  hintText: TextConstants.addAddress)
            ),

          ],
        ),
      )
    );
  }
}
