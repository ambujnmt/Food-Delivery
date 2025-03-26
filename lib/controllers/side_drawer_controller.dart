import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideDrawerController extends GetxController {
  RxInt index = 0.obs;
  List<int> previousIndex = [];
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

  //favourite food controller
  String favoriteName = "";
  String favouriteImage = "";
  String favoritePrice = "";
  String favoriteResId = "";
  String favoriteProdId = "";

  // special food controller
  String specialFoodName = "";
  String specialFoodImage = "";
  String specialFoodPrice = "";
  String specialFoodResId = "";
  String specialFoodProdId = "";

  // best deals controller
  String bestDealsProdName = "";
  String bestDealsProdImage = "";
  String bestDealsProdPrice = "";
  String bestDealsRestaurantName = "";
  String bestDealsProdId = "";
  String bestDealsResId = "";
  String bestDealsId = "";

  // details for particular restaurant
  String restaurantlatitude = "";
  String restaurantlongitude = "";
  String restaurantAddress = "";
  String restaurantImage = "";

  // coupon
  String couponListRestaurantId = "";
  String couponType = "";
  double couponAmount = 0;
  String couponId = "";

  //cartList Restaurant
  String cartListRestaurant = "";

  // selected deal object
  List dealData = [];
  String dealTitle = "";
  // order History Rate
  int? resIdFromHistory;
  int? prodIdFromHistory;
  int? orderIdFromHistory;
  String resNameFromHistory = "";

  // chat controller
  String navigationToResFromChat = "";
  String restaurantIdForChat = "";

  // fcm token
  String fcmTokenForRegisterUser = "";

  // restaurant product detail controller
  String restaurantProductId = "";

  // user profile details
  String userProfileName = "";
}
