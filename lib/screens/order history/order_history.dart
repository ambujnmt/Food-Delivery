import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  dynamic size;
  final customText = CustomText();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        // padding: Ed,
        child: CustomScrollView(
          slivers: [

            SliverToBoxAdapter(
              child: SizedBox(
                height: size.height * 0.07,
                width: size.width,
                // color: Colors.lightGreen,
                child: Center(
                  child: customText.kText(TextConstants.orderHistory, 25, FontWeight.w900, ColorConstants.kPrimary, TextAlign.center),
                ),
              )
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Container(
                    width: size.width,
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      border: Border.all(color: ColorConstants.kPrimary, width: 1.5),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    child: Column(
                      children: [

                        Row(
                          children: [
                            customText.kText("${TextConstants.orderId} : ", 20, FontWeight.w900, Colors.black, TextAlign.center),
                            const Text("29348234", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),),
                            const Spacer(),
                            customText.kText(TextConstants.pending, 18, FontWeight.w700, ColorConstants.kPrimary, TextAlign.center),
                            SizedBox(width: size.width * 0.02,),
                            const ImageIcon(
                              AssetImage("assets/images/pending.png"),
                              color: ColorConstants.kPrimary,
                              size: 25,
                            ),
                          ]
                        ),

                        Container(
                          width: size.width,
                          color: Colors.lightGreen,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: customText.kText("Restaurant Name", 20, FontWeight.w700, Colors.black, TextAlign.start),
                          ),
                        ),

                        Container(
                          width: size.width,
                          color: Colors.lightBlue,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: customText.kText("Restaurant Address", 20, FontWeight.w700, Colors.black, TextAlign.start),
                          ),
                        ),

                        const Divider(color: ColorConstants.kDashGrey,),

                        for(int i = 0; i < 3; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.5,
                                color: Colors.grey,
                                child: customText.kText("Food Name", 16, FontWeight.w500, Colors.black, TextAlign.center)
                              ),
                              Container(
                                  width: size.width * 0.15,
                                  color: Colors.grey.shade200,
                                  child: customText.kText("Qty 2", 16, FontWeight.w500, Colors.black, TextAlign.center)
                              ),
                              Container(
                                  width: size.width * 0.2,
                                  color: Colors.grey,
                                  child: customText.kText("\$ 1000", 16, FontWeight.w500, Colors.black, TextAlign.center)
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                },
                childCount: 1
              ),
            ),

          ],
        ),
      )
    );
  }
}
