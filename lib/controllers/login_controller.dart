import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  String accessToken = "";
  String userId = "";
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getStorage();
  }

  getStorage() {
    final token = box.read("accessToken");
    print("token :- $token");

    if (token != null) {
      accessToken = box.read("accessToken");
      userId = box.read("userId");
    }
  }

  clearToken() {
    accessToken = "";
    box.remove("accessToken");
    print('Clear access token-------- $accessToken');
  }
}
