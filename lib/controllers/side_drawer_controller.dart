import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideDrawerController extends GetxController {
  RxInt index = 0.obs;
  int previousIndex = 0;
  PageController pageController = PageController();

  String editAddressId = "";
  String restaurantId = "";
  String detailRestaurantName = "";
  String foodCategoryId = "";
  String foodCategoryTitle = "";
  // specific category controller
  String specificCatTitle = "";
  String specificCatName = "";
  String specificCatImage = "";
  String specificCatPrice = "";
  String specificFoodResId = "";
  String SpecificFoodProId = "";
}
