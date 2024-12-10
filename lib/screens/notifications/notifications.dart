import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final customText = CustomText();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 8,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: height * .1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        height: height * .12,
                        width: width * .12,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://cdn.psychologytoday.com/sites/default/files/styles/article-inline-half-caption/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=0hb44OrI'))),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(bottom: ),
                              child: customText.kText(
                                "Notification title",
                                20,
                                FontWeight.w800,
                                Colors.black,
                                TextAlign.start,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: customText.kText(
                                "Notification description",
                                14,
                                FontWeight.w400,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * .010),
            ],
          ),
        ),
      ),
    );
  }
}
