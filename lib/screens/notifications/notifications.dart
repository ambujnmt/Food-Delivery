import 'package:flutter/material.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/utils/custom_no_data_found.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final customText = CustomText();
  final api = API();
  final helper = Helper();
  bool isApiCalling = false;
  List<dynamic> notificationList = [];

  getNotificationData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.notificationList();
    setState(() {
      isApiCalling = false;
    });
    if (response["success"] == true) {
      setState(() {
        notificationList = response['notifications'];
      });
      print('notification success message: ${response["message"]}');
    } else {
      print('notification error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    getNotificationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: isApiCalling
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.kPrimary,
              ),
            )
          : notificationList.isEmpty
              ? const CustomNoDataFound()
              : Container(
                  margin: const EdgeInsets.all(15),
                  child: ListView.builder(
                    itemCount: notificationList.length,
                    itemBuilder: (BuildContext context, int index) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 8,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: height * .1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                notificationList[index]['image'] == null
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        height: height * .12,
                                        width: width * .12,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.notifications,
                                            size: 32,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        height: height * .12,
                                        width: width * .12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              notificationList[index]['image'],
                                            ),
                                          ),
                                        ),
                                      ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(bottom: ),
                                        child: customText.kText(
                                          notificationList[index]['subject'] ??
                                              "N/A",
                                          20,
                                          FontWeight.w800,
                                          Colors.black,
                                          TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: customText.kText(
                                          notificationList[index]['message'] ??
                                              "N/A",
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
