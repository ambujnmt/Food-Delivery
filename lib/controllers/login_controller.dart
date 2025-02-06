import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  String accessToken = "";
  int userId = 0;
  final box = GetStorage();

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
    }
    print("Token value: $accessToken");
    print("User Id : ${userId}");
  }

  clearToken() {
    accessToken = "";
    box.remove("accessToken");
    box.remove("userId"); // newly added
    print('Clear access token-------- $accessToken');
  }
}
