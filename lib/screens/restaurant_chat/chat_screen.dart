import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  dynamic size;
  final customText = CustomText();

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List messageList = [
    "Hello",
    "Hi",
    "How are you ?",
    "I am good what about you man"
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        // color: Colors.yellow.shade200,
        child: Stack(
          children: [
            // chat messages list
            Positioned(
              top: size.height * 0.1,
              left: size.width * 0.025,
              child: SizedBox(
                height: size.height * 0.73,
                width: size.width * 0.95,
                // color: Colors.white60,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    // return msgsList[index]["sender_id"] == driverId
                    return index % 2 == 0
                        ? ChatBubble(
                      clipper: ChatBubbleClipper5(
                          type: BubbleType.sendBubble),
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(top: 20),
                      backGroundColor: ColorConstants.kPrimary,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth:
                          MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: customText.kText(messageList[index], 14, FontWeight.w600, Colors.white, TextAlign.start)
                      ),
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
                          child: customText.kText(messageList[index], 14, FontWeight.w600, Colors.black, TextAlign.start)
                      ),
                    );
                  },
                ),
              ),
            ),

            // message input or send button
            Positioned(
              bottom: 25,
              left: size.width * 0.025,
              child: Container(
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
                    // input message field
                    SizedBox(
                      width: size.width * 0.73,
                      child: TextField(
                        controller: messageController,
                        keyboardType: TextInputType.text,
                        // style: customText.kTextStyle(16, FontWeight.w600, ColorConstants.kChatInputColor),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: TextConstants.chatInputPlaceholder,
                            // hintStyle: customText.kTextStyle(16, FontWeight.w600, ColorConstants.kChatInputColor)
                        ),
                      ),
                    ),
                    //send button
                    GestureDetector(
                      child: SizedBox(
                        width: size.width * 0.15,
                        child: const Icon(Icons.send, size: 30,),
                      ),
                      onTap: () {
                        log("send button on tap");
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
