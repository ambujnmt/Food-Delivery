import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/controllers/login_controller.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:food_delivery/screens/auth/change_password.dart';
import 'package:food_delivery/utils/custom_button.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:developer';

import 'package:food_delivery/utils/custom_text_field.dart';
import 'package:food_delivery/utils/helper.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic size;
  final customText = CustomText();
  final api = API();
  final helper = Helper();
  bool isEditable = false;
  bool isApiCalling = false;
  bool imageSelected = false;
  bool isImageDownloading = false;
  bool isEditCalling = false;
  Map<String, dynamic> getUserProfileMap = {};
  final ImagePicker _picker = ImagePicker();
  String? image1;

  String userName = "";
  String? profileImageUrl = "";

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  LoginController loginController = Get.put(LoginController());
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future getImageFromGallery() async {
    XFile? image;

    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image?.path != null) {
      image1 = image!.path;
      imageSelected = true;
    }

    print("images list :- $image1");

    setState(() {});
  }

  Future getImageFromCamera() async {
    XFile? image;

    image = await _picker.pickImage(source: ImageSource.camera);
    if (image?.path != null) {
      image1 = image!.path;
      imageSelected = true;
    }

    print("images list :- $image1");

    setState(() {});
  }

  getUserProfileData() async {
    setState(() {
      isApiCalling = true;
    });

    final response = await api.getUserProfileDetails();

    setState(() {
      getUserProfileMap = response['data'];
      userName = getUserProfileMap['name'];
      emailController.text = getUserProfileMap['email'];
      profileImageUrl = getUserProfileMap['avatar'];
      usernameController.text = userName.toString();
    });

    setState(() {
      isApiCalling = false;
    });
    print("user profile list data: ${getUserProfileMap}");
    if (response["status"] == true) {
    } else {
      print('error message: ${response["message"]}');
    }
    image1 = profileImageUrl;
    downloadAllImage();
  }

  downloadAllImage() async {
    late var appDocDir;

    if (Platform.isAndroid) {
      appDocDir = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      appDocDir = await getApplicationDocumentsDirectory();
    }

    setState(() {
      isImageDownloading = true;
    });

    List temp = profileImageUrl.toString().split(".");
    String fileExtension = temp.last;

    String fileUrl = profileImageUrl.toString();
    String savePath = "${appDocDir!.path}/image.$fileExtension";

    print("save path :- $savePath");

    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      print("${(count / total * 100).toStringAsFixed(0)}%");
    });

    // downloadedImages.add("${appDocDir!.path}/$fileName");

    image1 = "${appDocDir!.path}/image.$fileExtension";
    print("image path 1 :- $image1");

    setState(() {
      isImageDownloading = false;
    });
  }

  editProfileUser() async {
    setState(() {
      isEditCalling = true;
    });
    final response = await api.updateProfileDetails(
      userImage: image1,
      userName: usernameController.text,
    );
    setState(() {
      isEditCalling = false;
    });
    if (response['status'] == true) {
      helper.successDialog(context, response["message"]);
      sideDrawerController.index.value = 13;
      sideDrawerController.pageController
          .jumpToPage(sideDrawerController.index.value);
      isEditable = false;
    } else {
      helper.successDialog(context, response["message"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserProfileData();
    print("user profile: ${profileImageUrl}");
    print("user name: $userName");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.01),
            customText.kText(TextConstants.userProfile, 30, FontWeight.w900,
                Colors.black, TextAlign.center),
            Container(
              height: size.height * 0.25,
              width: size.width,
              margin: EdgeInsets.only(top: size.height * 0.05),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    "assets/images/angleRect.png",
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: -35,
                    child: Container(
                        height: size.height * 0.13,
                        width: size.width * 0.4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: image1 == null
                            ? GestureDetector(
                                onTap: () {
                                  // select image
                                  showImageSelection();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: ColorConstants.kPrimary,
                                    image: DecorationImage(
                                      // image: profileImageUrl == null
                                      //     ? const AssetImage(
                                      //         "assets/images/profile_image.jpg")
                                      //     : NetworkImage(
                                      //         profileImageUrl.toString()),
                                      image: image1 == null
                                          ? const AssetImage(
                                              'assets/images/profile_image.jpg')
                                          : FileImage(File(image1!))
                                              as ImageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  // select image
                                  showImageSelection();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: ColorConstants.kPrimary,
                                    image: DecorationImage(
                                      // image: profileImageUrl == null
                                      //     ? const AssetImage(
                                      //         "assets/images/profile_image.jpg")
                                      //     : NetworkImage(
                                      //         profileImageUrl.toString()),
                                      image: image1!.contains("uploads/users")
                                          ? NetworkImage(
                                                  profileImageUrl.toString())
                                              as ImageProvider
                                          : FileImage(File(image1!)),
                                      fit: BoxFit.contain,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )),
                  ),
                  Positioned(
                    top: size.height * 0.05,
                    left: size.width * 0.57,
                    child: GestureDetector(
                      child: Container(
                        height: size.height * 0.04,
                        width: size.width * 0.09,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(
                            //     color: ColorConstants.kPrimary, width: 1.5),
                            borderRadius:
                                BorderRadius.circular(size.width * 0.03)),
                        child: const Center(
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                      onTap: () {
                        log("edit button pressed");
                        setState(() {
                          isEditable = true;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                    width: size.width,
                    // color: Colors.white,
                    child: Center(
                      child: customText.kText(
                          isEditable ? usernameController.text : "${userName}",
                          25,
                          FontWeight.w900,
                          Colors.white,
                          TextAlign.center),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              height: size.height * 0.4,
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: customText.kText(TextConstants.about, 30,
                        FontWeight.w700, Colors.black, TextAlign.center),
                  ),
                  Visibility(
                    visible: isEditable,
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.01),
                      child: CustomFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(
                          Icons.account_circle,
                          color: ColorConstants.kPrimary,
                          size: 35,
                        ),
                        hintText: TextConstants.username,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          setState(() {});
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    child: CustomFormField(
                      readOnly: true,
                      controller: emailController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: ColorConstants.kPrimary,
                        size: 35,
                      ),
                      hintText: TextConstants.email,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        setState(() {});
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * .4,
                        child: CustomButton(
                          loader: isEditCalling,
                          fontSize: 14,
                          hintText: TextConstants.updateProfile,
                          onTap: () {
                            editProfileUser();
                          },
                        ),
                      ),
                      Container(
                        width: size.width * .4,
                        child: CustomButton(
                          fontSize: 14,
                          hintText: TextConstants.changePassword,
                          onTap: () {
                            // change password
                            // sideDrawerController.previousIndex =
                            //     sideDrawerController.index.value;
                            sideDrawerController.previousIndex
                                .add(sideDrawerController.index.value);
                            sideDrawerController.index.value = 24;
                            sideDrawerController.pageController
                                .jumpToPage(sideDrawerController.index.value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: Container(
                      height: size.height * 0.06,
                      width: size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      decoration: BoxDecoration(
                          color: ColorConstants.kPrimary,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 9.9,
                                color: Colors.black54)
                          ]),
                      child: Row(
                        children: [
                          const ImageIcon(
                            AssetImage("assets/images/delete.png"),
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: size.width * 0.15,
                          ),
                          customText.kText(TextConstants.accountDelete, 24,
                              FontWeight.w600, Colors.white, TextAlign.center),
                        ],
                      ),
                    ),
                    onTap: () async {
                      _showAlertDialog(context, () async {
                        print("account delete");
                        print("Delete Account");
                        final response = await api.accountDelete();
                        if (response['status'] == "0") {
                          helper.successDialog(context, response['message']);
                          setState(() {
                            loginController.clearToken();
                            loginController.userId = 0;
                          });

                          sideDrawerController.index.value = 0;
                          sideDrawerController.pageController
                              .jumpToPage(sideDrawerController.index.value);
                        } else {
                          helper.errorDialog(context, response['message']);
                        }
                      });
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  // Function to show an alert dialog
  void _showAlertDialog(BuildContext context, Function() deleteItem) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              'Are you sure want to delete this account ?',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                height: h * .030,
                width: w * .2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorConstants.kPrimary),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform any action here, then close the dialog
                deleteItem();
                Navigator.of(context).pop();
              },
              child: Container(
                height: h * .030,
                width: w * .2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showImageSelection() {
    showModalBottomSheet(
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
