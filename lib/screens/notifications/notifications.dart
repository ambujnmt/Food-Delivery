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
      notificationList = response['notifications'];
    });
    setState(() {
      isApiCalling = false;
    });
    if (response["success"] == true) {
      print('notification success message: ${notificationList.length}');
    } else {
      print('notification error message: ${notificationList.length}');
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
                          color: notificationList[index]['status'] == 0
                              ? Colors.grey.shade200
                              : Colors.grey.shade100,
                          elevation: 4,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: height * .12,
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
                                        width: width * .65,
                                        // margin: EdgeInsets.only(bottom: ),
                                        child: customText.kText(
                                          notificationList[index]['title'] ??
                                              "N/A",
                                          20,
                                          FontWeight.w800,
                                          Colors.black,
                                          TextAlign.start,
                                          TextOverflow.ellipsis,
                                          1,
                                        ),
                                      ),
                                      Container(
                                        width: width * .65,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: customText.kText(
                                          notificationList[index]['body'] ??
                                              "N/A",
                                          14,
                                          FontWeight.w400,
                                          ColorConstants.lightGreyColor,
                                          TextAlign.start,
                                          TextOverflow.ellipsis,
                                          2,
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
