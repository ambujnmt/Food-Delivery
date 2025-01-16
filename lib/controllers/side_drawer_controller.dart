import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideDrawerController extends GetxController {
  RxInt index = 0.obs;
  PageController pageController = PageController();

  String editAddressId = "";
  String restaurantId = "";
}
