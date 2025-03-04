import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {

  String accessToken = "";
  int userId = 0;
  final box = GetStorage();

  SideDrawerController sideDrawerController = Get.put(SideDrawerController());

  @override
  void onInit() {
    super.onInit();
    getStorage();
  }

  getStorage() async {
    String token = await box.read("accessToken");
    print("token :- $token");

    if (token != null) {
      accessToken = box.read("accessToken");
      userId = box.read("userId");
      sideDrawerController.cartListRestaurant = box.read("cartListRestaurant");
    }
    print("Token value: $accessToken");
    print("User Id : ${userId}");
  }

  clearToken() {
    accessToken = "";
    box.remove("accessToken");
    box.remove("userId"); // newly added
    box.remove("cartListRestaurant");
    print('Clear access token-------- $accessToken');
  }
}
