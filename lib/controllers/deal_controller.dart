import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealsController extends GetxController {
  // var dealsUpdatedList = [].obs;
  //
  // void updateDealsList(List<dynamic> newList) {
  //   dealsUpdatedList.value = newList;
  // }

  RxList productsList = [].obs;
  String comingFrom = "";
}
