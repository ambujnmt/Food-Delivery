import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItemCount = 0.obs;

  void addToCart() {
    cartItemCount++;
  }

  void removeFromCart() {
    if (cartItemCount > 0) {
      cartItemCount--;
    }
  }
}
