import 'dart:async';

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
  List<dynamic> chatMessageList = [];
  Timer? timer;

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
      print(" success response: ${response['message']}");
      onFieldSubmitted();
    } else {
      print("error message in the chat response: ${response['message']}");
    }
  }

  // chat list
  chatList() async {
    final response = await api.chatList(
        receiverId: sideDrawerController.restaurantIdForChat.toString());

    if (response["status"] == true) {
      print('chat list success message: ${response["message"]}');
      setState(() {
        chatMessageList = response['messages'] ?? [];
      });
    } else {
      print('chat list error message: ${response["message"]}');
    }
  }

  Future<void> onFieldSubmitted() async {
    // Move the scroll position to the bottom
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    messageController.clear();
  }

  @override
  void initState() {
    print("res id for chat : ${sideDrawerController.restaurantIdForChat}");
    // Call the API every 5 seconds
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      chatList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ✅ Expandable Chat List
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: size.width * 0.95,
                child: ListView.builder(
                  shrinkWrap: true,
                  // reverse: true,
                  controller: scrollController,
                  itemCount: chatMessageList.length,
                  // itemCount: 3,
                  itemBuilder: (context, index) {
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
                                    chatMessageList[index]['message'] ?? '',
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
                                    chatMessageList[index]['message'] ?? '',
                                    14,
                                    FontWeight.w600,
                                    Colors.black,
                                    TextAlign.start)),
                          );
                  },
                ),
              ),
            ),
          ),

          // ✅ Message Input Field at Bottom
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ColorConstants.kPrimary),
              borderRadius: BorderRadius.circular(size.width),
            ),
            child: Row(
              children: [
                Expanded(
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
                  child: sendingMessage
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Icon(Icons.send, size: 30),
                  onTap: () {
                    print("send button on tap");
                    chatWithRestaurant(
                      message: messageController.text,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
