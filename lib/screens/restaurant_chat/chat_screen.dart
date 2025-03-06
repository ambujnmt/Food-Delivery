import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  dynamic size;
  final customText = CustomText();

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final api = API();
  final helper = Helper();
  bool sendingMessage = false;

  List messageList = [
    "Hello",
    "Hi",
    "How are you ?",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
    "I am good what about you man",
  ];

  chatWithRestaurant({String? message}) async {
    setState(() {
      sendingMessage = true;
    });
    final response = await api.chatWithRestaurant(
      image: null,
      message: message,
      receiverId: sideDrawerController.restaurantIdForChat.toString(),
    );
    setState(() {
      sendingMessage = false;
    });
    if (response['status'] == true) {
      messageController.clear();
      print(" success response: ${response['message']}");
    } else {
      print("error message in the chat response: ${response['message']}");
    }
  }

  @override
  void initState() {
    print("res id for chat : ${sideDrawerController.restaurantIdForChat}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: size.height * 0.73,
              width: size.width * 0.95,
              child: ListView.builder(
                controller: scrollController,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  // return msgsList[index]["sender_id"] == driverId
                  return index % 2 == 0
                      ? ChatBubble(
                          clipper:
                              ChatBubbleClipper5(type: BubbleType.sendBubble),
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.only(top: 20),
                          backGroundColor: ColorConstants.kPrimary,
                          child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: customText.kText(
                                  messageList[index],
                                  14,
                                  FontWeight.w600,
                                  Colors.white,
                                  TextAlign.start)),
                        )
                      : ChatBubble(
                          clipper: ChatBubbleClipper5(
                              type: BubbleType.receiverBubble),
                          backGroundColor: Colors.white,
                          margin: const EdgeInsets.only(top: 20),
                          child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: customText.kText(
                                  messageList[index],
                                  14,
                                  FontWeight.w600,
                                  Colors.black,
                                  TextAlign.start)),
                        );
                },
              ),
            ),
          ),
          Container(
            height: size.height * 0.06,
            width: size.width * 0.95,
            padding: EdgeInsets.only(left: size.width * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ColorConstants.kPrimary),
              borderRadius: BorderRadius.circular(size.width),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.73,
                  child: TextField(
                    controller: messageController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: TextConstants.chatInputPlaceholder,
                    ),
                  ),
                ),
                GestureDetector(
                  child: SizedBox(
                    width:
                        sendingMessage ? size.width * 0.1 : size.width * 0.15,
                    child: sendingMessage
                        ? Container(
                            margin: const EdgeInsets.only(top: 2, bottom: 2),
                            child: const CircularProgressIndicator(
                                color: Colors.black))
                        : const Icon(
                            Icons.send,
                            size: 30,
                          ),
                  ),
                  onTap: () {
                    print("send button on tap");
                    chatWithRestaurant(
                      message: messageController.text,
                    );
                  },
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
