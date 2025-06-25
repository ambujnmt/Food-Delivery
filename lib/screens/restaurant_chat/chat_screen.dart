import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  dynamic size;
  final customText = CustomText();

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final api = API();
  final helper = Helper();
  bool sendingMessage = false;
  bool imageSelected = false;
  List<dynamic> chatMessageList = [];
  Timer? timer;
  final ImagePicker _picker = ImagePicker();
  String? image1;
  String selectedImageName = "";
  chatWithRestaurant({String? message}) async {
    setState(() {
      sendingMessage = true;
    });
    final response = await api.chatWithRestaurant(
      image: image1,
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
    messageController.clear();
    chatList();
    // Move the scroll position to the bottom
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    messageController.clear();
    image1 = null;
  }

  Future getImageFromGallery() async {
    XFile? image;

    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image?.path != null) {
      image1 = image!.path;
      imageSelected = true;
      selectedImageName = path.basename(image1.toString());
      messageController.text = selectedImageName;
    }
    print("selected image from gallery :- $image1");
    print("selected image name :- $selectedImageName");
    setState(() {});
  }

  Future getImageFromCamera() async {
    XFile? image;

    image = await _picker.pickImage(source: ImageSource.camera);
    if (image?.path != null) {
      image1 = image!.path;
      imageSelected = true;
      selectedImageName = path.basename(image1.toString());
      messageController.text = selectedImageName;
    }
    print("selected image from camera :- $image1");
    print("selected image name :- $selectedImageName");
    setState(() {});
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
  // @override
  // void dispose() {
  //   timer!.cancel();
  //   scrollController.dispose();
  //   super.dispose();
  // }

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
                  reverse: true,
                  controller: scrollController,
                  itemCount: chatMessageList.length,
                  itemBuilder: (context, index) {
                    return loginController.userId ==
                            chatMessageList[index]['sender_id']
                        ? ChatBubble(
                            clipper:
                                ChatBubbleClipper5(type: BubbleType.sendBubble),
                            alignment: Alignment.topRight,
                            margin: const EdgeInsets.only(top: 20),
                            backGroundColor:
                                chatMessageList[index]['image'] == null
                                    ? ColorConstants.kPrimary
                                    : Colors.white,
                            child: chatMessageList[index]['image'] == null
                                ? Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: customText.kText(
                                        chatMessageList[index]['message'] ?? '',
                                        14,
                                        FontWeight.w600,
                                        Colors.white,
                                        TextAlign.start))
                                : Container(
                                    height: size.height * .1,
                                    width: size.width * .2,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                chatMessageList[index]
                                                    ['image']))),
                                  ),
                          )
                        : ChatBubble(
                            clipper: ChatBubbleClipper5(
                                type: BubbleType.receiverBubble),
                            backGroundColor: Colors.white,
                            margin: const EdgeInsets.only(top: 20),
                            child: chatMessageList[index]['image'] == null
                                ? Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: customText.kText(
                                        chatMessageList[index]['message'] ?? '',
                                        14,
                                        FontWeight.w600,
                                        Colors.black,
                                        TextAlign.start))
                                : Container(
                                    height: size.height * .1,
                                    width: size.width * .2,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                chatMessageList[index]
                                                    ['image']))),
                                  ),
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
                  onTap: () {
                    showImageSelection();
                  },
                  child: Container(
                    height: size.height * .040,
                    width: size.width * .10,
                    child: const Icon(
                      Icons.image,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(width: size.width * .020),
                GestureDetector(
                  child: sendingMessage
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Icon(Icons.send, size: 30),
                  onTap: () {
                    print("send button on tap");
                    if (messageController.text.isNotEmpty) {
                      chatWithRestaurant(
                        message: messageController.text,
                      );
                    } else {
                      helper.errorDialog(
                          context, "Please type message or select image");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showImageSelection() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.only(top: 20),
              height: 120,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      getImageFromGallery();
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: const Icon(
                              Icons.photo,
                            ),
                          ),
                          const SizedBox(height: 10),
                          customText.kText("Gallery", 16, FontWeight.w400,
                              Colors.black, TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getImageFromCamera();
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: const Icon(
                              Icons.camera,
                            ),
                          ),
                          const SizedBox(height: 10),
                          customText.kText("Camera", 16, FontWeight.w400,
                              Colors.black, TextAlign.start),
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}
