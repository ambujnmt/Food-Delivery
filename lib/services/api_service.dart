import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/login_controller.dart';
import 'dart:developer';

class API {
  String baseUrl = "https://getfooddelivery.com/api"; // Production server
  // String baseUrl =
  //     "https://nmtdevserver.com/getfooddelivery/api"; // Development server
  LoginController loginController = Get.put(LoginController());
  SideDrawerController sideDrawerController = Get.put(SideDrawerController());
  // user login api integration
  postCurrentLocation({String? latitude, String? longitude}) async {
    var url = "$baseUrl/allow-location-restaurant";
    Map<String, dynamic> body = {
      "latitude": latitude,
      "longitude": longitude,
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("allow location api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // user login api integration
  login(String email, String password) async {
    var url = "$baseUrl/login";
    final fcmToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "fcmtoken": fcmToken
    };
    print("body$body");
    http.Response response = await http.post(Uri.parse(url), body: body);

    print("api services login response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // country api integration
  getCountryList() async {
    var url = "$baseUrl/country";

    http.Response response = await http.get(Uri.parse(url));

    print("api services country response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // state api integration
  getStateList(String countryId) async {
    var url = "$baseUrl/state";

    Map<String, dynamic> body = {
      "country_id": countryId,
    };

    http.Response response = await http.post(Uri.parse(url), body: body);

    print("api services state response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // city api integration
  getCityList(String stateId) async {
    var url = "$baseUrl/city";

    Map<String, dynamic> body = {
      "state_id": stateId,
    };

    http.Response response = await http.post(Uri.parse(url), body: body);

    print("api services city response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // user registration api integration
  registerUser({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    String? addressLineOne,
    String? addressLineTwo,
    String? landMark,
    String? country,
    String? state,
    String? city,
    String? postalCode,
    String? addressType,
    String? fcmToken,
  }) async {
    var url = "$baseUrl/register";

    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phoneNumber,
      "password": password,
      "c_password": confirmPassword,
      "address1": addressLineOne,
      "address2": addressLineTwo,
      "landmark": landMark,
      "country": country,
      "state": state,
      "city": city,
      "zip_code": postalCode,
      "location": addressType,
      "fcmtoken": fcmToken,
    };

    http.Response response = await http.post(Uri.parse(url), body: body);

    print("api services register response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // otp verification api integration
  otpVerification({String? email, String? otp}) async {
    var url = "$baseUrl/verify-otp";

    Map<String, dynamic> body = {
      "email": email,
      "otp": otp,
    };

    http.Response response = await http.post(Uri.parse(url), body: body);

    print("api services otp verify response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // resend otp api integration
  resendOtp({String? email}) async {
    var url = "$baseUrl/send-otp";

    Map<String, dynamic> body = {
      "email": email,
    };

    http.Response response = await http.post(Uri.parse(url), body: body);

    print("api service resend sresponse :- ${response.body}");
    return jsonDecode(response.body);
  }

  // resend otp api integration
  forgetPassword({String? email}) async {
    var url = "$baseUrl/forgot-password";

    Map<String, dynamic> body = {
      "email": email,
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("api services forgot password response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // reset password api integration
  resetPassword(
      {String? email, String? password, String? confirmPassword}) async {
    var url = "$baseUrl/reset-password";
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "c_password": confirmPassword,
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("api services reset password response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // get food category api integration
  getHomeBanner() async {
    var url = "$baseUrl/home-banner";
    http.Response response = await http.get(Uri.parse(url));
    print("api services banner response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // get food category api integration
  getFood() async {
    var url = "$baseUrl/food-category";
    http.Response response = await http.get(Uri.parse(url));
    print("api services get food category response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // best deals api integration
  bestDeals() async {
    var url = "$baseUrl/best-deals";
    print("url$url");
    http.Response response = await http.get(Uri.parse(url));
    log(" best deals api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // best deals api integration
  topRestaurantCity({
    String? latitude,
    String? longitude,
    String? radius,
  }) async {
    var url = "$baseUrl/restaurant-city";
    Map<String, dynamic> body = {
      "latitude": latitude,
      "longitude": longitude,
      "radius": radius,
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("top restaurant city api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // spcial food api integration
  specialFood() async {
    var url = "$baseUrl/special-food";
    print("urlBase$url");
    http.Response response = await http.get(Uri.parse(url));
    log(" special food api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // home contact info api integration
  homeContactInfo() async {
    var url = "$baseUrl/footer-contact-info";
    http.Response response = await http.get(Uri.parse(url));
    print("contact info api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // view all restaurant api integration
  viewAllRestaurant(String? search, String latitude, String longitude) async {
    var url = "$baseUrl/all-restaurant";
    print("url$url");
    Map<String, dynamic> body = {
      'search': search,
      "latitude": latitude,
      "longitude": longitude,
    };
    print("body$body");
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("api services all restautant response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // userChat status change  api integration
  userStatusChat() async {
    var url = "$baseUrl/active-in-active-status";
    Map<String, dynamic> body = {
      'user_id': loginController.userId.toString(),
      "online_status": '1',
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("api services all status active response :- ${response.body}");
    return jsonDecode(response.body);
  }

  userChatCount() async {
    var url = "$baseUrl/unread-message-count";
    Map<String, dynamic> body = {'user_id': loginController.userId.toString()};

    print("body$body");
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("api response${response.body}");
    return jsonDecode(response.body);
  }

  // notificationCount api integration
  notificationCount() async {
    var url = "$baseUrl/all-notification";
    Map<String, dynamic> body = {
      'user_id': loginController.userId.toString(),
      "online_status": '1',
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("api services all status active response :- ${response.body}");
    return jsonDecode(response.body);
  }

  userStatusChatUpdate() async {
    var url = "$baseUrl/active-in-active-status";
    Map<String, dynamic> body = {
      'user_id': loginController.userId.toString(),
      "online_status": '0',
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("api services all status active response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // view all special food api integration
  viewAllSpecialFood() async {
    var url = "$baseUrl/all-special-food";

    print("url$url");

    http.Response response = await http.get(Uri.parse(url));
    log("api services all special food response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // view all best deals api integration
  viewAllBestDeals({String? search}) async {
    var url = "$baseUrl/all-best-deals";
    print("url%$url");

    Map<String, dynamic> body = {'search': search};
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("api services all best deals response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // deals by title
  dealsWithTitle() async {
    var url = "$baseUrl/deals-title";
    print("url$url");

    http.Response response = await http.get(Uri.parse(url));
    log("deals by title api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // all food category api integration
  viewAllFoodCategory({String orderBy = "", String searchResult = ""}) async {
    var url = "$baseUrl/all-categories";
    Map<String, dynamic> body = {
      "orderby": orderBy,
      "search": searchResult,
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("view all food category api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  //specific food category api integration
  specificFoodCategory({
    String? categoryId,
    String orderBy = "",
    String searchResult = "",
  }) async {
    var url = "$baseUrl/food-category-products";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "category_id": categoryId.toString(),
      "order_by": orderBy,
      "search": searchResult,
    };

    print("url$url");

    http.Response response = await http.post(Uri.parse(url), body: body);
    print("specific food category api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // about us API integration
  aboutUs() async {
    var url = "$baseUrl/all-list-aboutus";
    http.Response response = await http.get(Uri.parse(url));
    print("about us api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // terms and conditions API integration
  termsAndConditions() async {
    var url = "$baseUrl/all-termandcondition";
    print("termsUrl$url");
    http.Response response = await http.get(Uri.parse(url));
    print("terms and conditions api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // return and refund policy API integration
  returnAndRefundPolicy() async {
    var url = "$baseUrl/all-return-and-refound-policy";
    http.Response response = await http.get(Uri.parse(url));
    print("return and refund policy api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // privacy policy API integration
  privacyPolicy() async {
    var url = "$baseUrl/privacy-policy";
    http.Response response = await http.get(Uri.parse(url));
    print("privacy policy api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // post contact us infromation
  postContactInformation({
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? message,
  }) async {
    var url = "$baseUrl/contactus-create";

    Map<String, dynamic> body = {
      "name": name,
      "phone": phoneNumber,
      "email": email,
      "address": address,
      "message": message,
    };

    http.Response response = await http.post(Uri.parse(url), body: body);

    print(" post contact us api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // Gallery images API integration
  galleryImages() async {
    var url = "$baseUrl/all-gallery";
    http.Response response = await http.get(Uri.parse(url));
    print("gallery images api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // testimonials API integration
  testimonials() async {
    var url = "$baseUrl/all-testimonial";
    http.Response response = await http.get(Uri.parse(url));
    print("testimonials api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // book restaurant
  bookingTableRestaurant() async {
    var url = "$baseUrl/bookingtable-resturant";
    http.Response response = await http.get(Uri.parse(url));
    print("booking table api response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // book a table api integration
  bookATable({
    String? restaurantName,
    String? fullName,
    String? phoneNumber,
    String? emailAdress,
    String? numberOfPeople,
    String? date,
    String? time,
  }) async {
    var url = "$baseUrl/create-bookingtable";

    Map<String, dynamic> body = {
      "restaurant_id": restaurantName,
      "name": fullName,
      "phone": phoneNumber,
      "email": emailAdress,
      "people": numberOfPeople,
      "booking_date": date,
      "booking_time": time,
    };

    http.Response response = await http.post(Uri.parse(url), body: body);

    print("book a table api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // change password api integration
  changePasswordFn({
    String? oldPassword,
    String? newPassword,
    String? confirmNewPassword,
  }) async {
    var url = "$baseUrl/change-password";
    Map<String, dynamic> body = {
      "current_password": oldPassword,
      "new_password": newPassword,
      "new_password_confirmation": confirmNewPassword,
    };
    http.Response response =
        await http.post(Uri.parse(url), body: body, headers: {
      "Authorization":
          "Bearer ${loginController.accessToken}", // Add Bearer token here
      "Accept": "application/json",
    });
    print("change password api servies response :- ${response.body}");
    return jsonDecode(response.body);
  }

  //get user profile details
  getUserProfileDetails() async {
    var url = "$baseUrl/get-user-profile-details";
    Map<String, dynamic> body = {
      // "id": loginController.userId,
    };
    print("user id: ${loginController.userId}");
    http.Response response =
        await http.post(Uri.parse(url), body: body, headers: {
      "Authorization":
          "Bearer ${loginController.accessToken}", // Add Bearer token here
      // "Accept": "application/json",
    });
    print("user profile details api servies response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // edit user profile api integration
  editUserProfile({
    String? userName,
    String? userImage,
  }) async {
    var url = "$baseUrl/edit-profile";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "name": userName,
      "profile": userImage,
    };
    http.Response response =
        await http.post(Uri.parse(url), body: body, headers: {
      "Authorization":
          "Bearer ${loginController.accessToken}", // Add Bearer token here
      "Accept": "application/json",
    });
    print("change password api servies response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // update profile details
  updateProfileDetails({
    String? userName,
    String? userImage,
  }) async {
    var url = '$baseUrl/edit-profile';

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(url),
    );
    if (userImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath("profile", userImage));
    }

    request.fields["user_id"] = loginController.userId.toString();
    request.fields["name"] = userName.toString();

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    final responseData = json.decode(response.body);
    print("edit profile response in api :- $responseData");
    return responseData;
  }

  //get user address
  getUserAddress() async {
    var url = "$baseUrl/get-user-address";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
    };
    print("user id for address: ${loginController.userId}");
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("user address list api servies response :- ${response.body}");
    return jsonDecode(response.body);
  }

  //delete user address
  deleteUserAddress({String? addressId}) async {
    var url = "$baseUrl/delete-address";
    Map<String, dynamic> body = {
      "address_id": addressId.toString(),
    };
    print("delete user id for address: ${loginController.userId}");
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("delete user address api servies response :- ${response.body}");
    return jsonDecode(response.body);
  }

  //add new user address
  addUserAddress({
    String? addressId,
    String? name,
    String? phoneNumber,
    String? email,
    String? houseNumber,
    String? area,
    String? country,
    String? state,
    String? city,
    String? postalCode,
    String? workLocationType,
  }) async {
    var url = "$baseUrl/add-new-address";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "name": name,
      "phone": phoneNumber,
      "email": email,
      "house_no": houseNumber,
      "area": area,
      "country": country,
      "state": state,
      "city": city,
      "zip_code": postalCode,
      "location": workLocationType,
    };
    print("add new address: ${loginController.userId}");
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("add new address api servies response :- ${response.body}");
    return jsonDecode(response.body);
  }

  //edit user address
  editUserAddress({
    String? addressId,
    String? name,
    String? phoneNumber,
    String? email,
    String? houseNumber,
    String? area,
    String? country,
    String? state,
    String? city,
    String? postalCode,
    String? workLocationType,
  }) async {
    var url = "$baseUrl/edit-address";
    Map<String, dynamic> body = {
      "address_id": sideDrawerController.editAddressId.toString(),
      "name": name,
      "phone": phoneNumber,
      "email": email,
      "house_no": houseNumber,
      "area": area,
      "country": country,
      "state": state,
      "city": city,
      "zip_code": postalCode,
      "location": workLocationType,
    };
    print("edit address: ${loginController.userId}");
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("edit address api servies response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // get particular address by id
  getAddressByUserId({
    String? addressId,
  }) async {
    var url = "$baseUrl/single-address";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "address_id": sideDrawerController.editAddressId.toString(),
    };
    print("get address by id: ${loginController.userId}");
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("get address by id api servies response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // favourite food listing
  getFavouriteFood({
    String? productId,
  }) async {
    var url = "$baseUrl/favorite-list";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
    };
    print(" fav food listing userid: ${loginController.userId}");

    http.Response response = await http.post(Uri.parse(url), body: body);
    print("favourite food api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // restaurant detail page api integration

  restaurantDetailProducts({String? restaurantId, String? orderBy}) async {
    var url = "$baseUrl/restaurant-detail-products";

    Map<String, dynamic> body = {
      "restaurant_id": restaurantId.toString(),
      "orderby": orderBy
    };

    print("body_check$body");

    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  restaurantDetailCategoryProducts({String? restaurantId}) async {
    var url = "$baseUrl/restaurant-category-products";

    print("urlBaseUrl$url");

    Map<String, dynamic> body = {
      "restaurant_id": restaurantId.toString(),
    };

    print("bodyList$body");

    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  restaurantDetailReviews({String? restaurantId}) async {
    var url = "$baseUrl/restaurant-review";
    Map<String, dynamic> body = {
      "restaurant_id": restaurantId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  restaurantDetailOverview({String? restaurantId}) async {
    var url = "$baseUrl/restaurant-overview";

    print("url$url");

    Map<String, dynamic> body = {
      "restaurant_id": restaurantId.toString(),
    };

    print("body$body");

    http.Response response = await http.post(Uri.parse(url), body: body);
    print("response:$response");

    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  restaurantDetailBanner({String? restaurantId}) async {
    var url = "$baseUrl/restaurant-banner";
    print("url$url");
    Map<String, dynamic> body = {
      "restaurant_id": restaurantId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);

    print("body$body");

    print("response:$response");

    return jsonDecode(response.body);
  }

  addItemsToCart({
    String? userId,
    String? restaurantId,
    String? productId,
    String? quantity,
    String? price,
    String? sidePrice,
    List<dynamic>? extraFeature,
    String? sideOptionsId,
    String? sideItemId,
    String? sideQuestionId,
    String? oftenBoughtOptionsId,
    String? optionGroupId,
  }) async {
    var url = "$baseUrl/addto-cart";
    Map<String, String> header = {"Content-Type": "application/json"};

    print(
        "SideIte43r34r34r34r34rm: $sideItemId | Question: $sideQuestionId | Option: $sideOptionsId");
    print("Often Bought: $oftenBoughtOptionsId | Option Group: $optionGroupId");
    Map<String, dynamic> selectedOptions = {};
    Map<String, dynamic> groupOptions = {};
    if (sideQuestionId != null &&
        sideQuestionId.isNotEmpty &&
        sideOptionsId != null &&
        sideOptionsId.isNotEmpty) {
      selectedOptions[sideQuestionId] = sideOptionsId;
    }
    if (optionGroupId != null &&
        optionGroupId.isNotEmpty &&
        oftenBoughtOptionsId != null &&
        oftenBoughtOptionsId.isNotEmpty) {
      groupOptions[optionGroupId] = [oftenBoughtOptionsId];
    }

    Map<String, dynamic> body = {
      "user_id": userId.toString(),
      "restaurant_id": restaurantId.toString(),
      "product_id": productId.toString(),
      "price": price.toString(),
      "side_price": sidePrice?.toString() ?? '0',
      "quantity": quantity.toString(),
      "extra_features": extraFeature ?? [],
      "selected_options": selectedOptions.isEmpty ? [] : selectedOptions,
      "group_options": groupOptions.isEmpty ? [] : groupOptions,
    };
    print("calling api: $body");
    http.Response response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: header);
    print("calling api sport ${response.body}");

    return jsonDecode(response.body);
  }

  // add product to the cart list
  addItemsMultiToCart({
    String? userId,
    String? restaurantId,
    String? productId,
    String? quantity,
    String? price,
    String? sidePrice,
    List<dynamic>? extraFeature,
    String? sideOptionsId,
    String? sideItemId,
    String? sideQuestionId,
    String? oftenBoughtOptionsId,
    String? optionGroupId,
  }) async {
    var url = "$baseUrl/addto-cart";
    Map<String, String> header = {"Content-Type": "application/json"};

    print(
        "SideItefyff7ym: $sideItemId | Question: $sideQuestionId | Option: $sideOptionsId");
    print("Often Bought: $oftenBoughtOptionsId | Option Group: $optionGroupId");
    Map<String, dynamic> selectedOptions = {};
    Map<String, dynamic> groupOptions = {};
    if (sideQuestionId != null &&
        sideQuestionId.isNotEmpty &&
        sideOptionsId != null &&
        sideOptionsId.isNotEmpty) {
      selectedOptions[sideQuestionId] = sideOptionsId;
    }
    if (optionGroupId != null &&
        optionGroupId.isNotEmpty &&
        oftenBoughtOptionsId != null &&
        oftenBoughtOptionsId.isNotEmpty) {
      groupOptions[optionGroupId] = [oftenBoughtOptionsId];
    }
    Map<String, dynamic> body = {
      "user_id": userId.toString(),
      "restaurant_id": restaurantId.toString(),
      "product_id": productId.toString(),
      "price": price.toString(),
      "side_price": sidePrice?.toString() ?? '0',
      "quantity": quantity.toString(),
      "extra_features": extraFeature ?? [],
      "selected_options": selectedOptions.isEmpty ? [] : selectedOptions,
      "group_options": groupOptions.isEmpty ? [] : groupOptions,
    };
    print("calling api: $body");
    http.Response response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: header);
    print("calling api 11: ${response.body}");

    return jsonDecode(response.body);
  }

  Future<dynamic> addItemsSpecialToCart({
    String? userId,
    String? restaurantId,
    String? productId,
    String? quantity,
    String? price,
    String? sidePrice,
    List<dynamic>? extraFeature,
    String? sideOptionsId,
    String? sideItemId,
    String? sideQuestionId,
    String? oftenBoughtOptionsId,
    String? optionGroupId,
  }) async {
    var url = "$baseUrl/addto-cart";
    Map<String, String> header = {"Content-Type": "application/json"};

    print(
        "SideItem: $sideItemId | Question: $sideQuestionId | Option: $sideOptionsId");
    print("Often Bought: $oftenBoughtOptionsId | Option Group: $optionGroupId");
    Map<String, dynamic> selectedOptions = {};
    Map<String, dynamic> groupOptions = {};
    if (sideQuestionId != null &&
        sideQuestionId.isNotEmpty &&
        sideOptionsId != null &&
        sideOptionsId.isNotEmpty) {
      selectedOptions[sideQuestionId] = sideOptionsId;
    }
    if (optionGroupId != null &&
        optionGroupId.isNotEmpty &&
        oftenBoughtOptionsId != null &&
        oftenBoughtOptionsId.isNotEmpty) {
      groupOptions[optionGroupId] = [oftenBoughtOptionsId];
    }

    Map<String, dynamic> body = {
      "user_id": userId ?? '',
      "restaurant_id": restaurantId ?? '',
      "product_id": productId ?? '',
      "price": price ?? '0.0',
      "side_price": sidePrice ?? '0',
      "quantity": quantity ?? '1',
      "extra_features": extraFeature ?? [],
      "selected_options": selectedOptions.isEmpty ? [] : selectedOptions,
      "group_options": groupOptions.isEmpty ? [] : groupOptions,
    };
    print("Calling API with body: $body");
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: header);
    print("API Response: ${response.body}");
    return jsonDecode(response.body);
  }

  addItemsToCartByDealId({
    String? userId,
    String? restaurantId,
    String? productId,
    String? quantity,
    String? price,
    String? sidePrice,
    List<dynamic>? extraFeature,
    String? sideOptionsId,
    String? sideItemId,
    String? sideQuestionId,
    String? oftenBoughtOptionsId,
    String? optionGroupId,
    String? dealId,
  }) async {
    var url = "$baseUrl/addto-cart";
    Map<String, String> header = {"Content-Type": "application/json"};

    print(
        "SideItem: $sideItemId | Question: $sideQuestionId | Option: $sideOptionsId");
    print("Often Bought: $oftenBoughtOptionsId | Option Group: $optionGroupId");
    Map<String, dynamic> selectedOptions = {};
    Map<String, dynamic> groupOptions = {};
    if (sideQuestionId != null &&
        sideQuestionId.isNotEmpty &&
        sideOptionsId != null &&
        sideOptionsId.isNotEmpty) {
      selectedOptions[sideQuestionId] = sideOptionsId;
    }
    if (optionGroupId != null &&
        optionGroupId.isNotEmpty &&
        oftenBoughtOptionsId != null &&
        oftenBoughtOptionsId.isNotEmpty) {
      groupOptions[optionGroupId] = [oftenBoughtOptionsId];
    }

    Map<String, dynamic> body = {
      "user_id": userId.toString(),
      "restaurant_id": restaurantId.toString(),
      "product_id": productId.toString(),
      "price": price.toString(),
      "deal_id": dealId.toString(),
      "side_price": sidePrice?.toString() ?? '0',
      "quantity": quantity.toString(),
      "extra_features": extraFeature ?? [],
      "selected_options": selectedOptions.isEmpty ? [] : selectedOptions,
      "group_options": groupOptions.isEmpty ? [] : groupOptions,
    };
    print("calling api: $body");
    http.Response response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: header);
    print("calling api sport ${response.body}");
    return jsonDecode(response.body);
  }

  // account deactivation
  accountDelete() async {
    var url = "$baseUrl/account-status-update";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "status": "0",
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  //like product
  likeProduct({String? productId}) async {
    var url = "$baseUrl/product/like";
    Map<String, dynamic> body = {
      "product_id": productId,
      "user_id": loginController.userId.toString(),
      "like": "1",
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // dislike product
  dislikeProduct({String? productId}) async {
    var url = "$baseUrl/product/dislike";
    Map<String, dynamic> body = {
      "product_id": productId,
      "user_id": loginController.userId.toString(),
      "dislike": "1",
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // mark as favourite
  markFavourite({String? productId}) async {
    var url = "$baseUrl/favorite";
    Map<String, dynamic> body = {
      "product_id": productId,
      "user_id": loginController.userId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // remove from favourite
  removeFromFavourite({String? productId}) async {
    var url = "$baseUrl/remove-favorite";
    Map<String, dynamic> body = {
      "product_id": productId,
      "user_id": loginController.userId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // favourite food list
  favouriteFood() async {
    var url = "$baseUrl/favorite-product-list";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // cart listing api integration
  cartList() async {
    var url = "$baseUrl/cart-list";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    // print("detail page products api services response:- ${response.body}");
    return jsonDecode(response.body);
  }

  // remove item from cart list api integration
  removeItemFromCart({String? productId}) async {
    var url = "$baseUrl/remove-cart-list";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "product_id": productId,
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  // coupan listing api integration
  coupanList(
      {String? restaurantId, String? couponTitle, String? couponCode}) async {
    var url = "$baseUrl/coupon-listing";

    print("urlCouponUrl$url");

    Map<String, dynamic> body = {
      "restaurant_id": restaurantId.toString(),
      "title": couponTitle,
      "coupon_code": couponCode,
    };
    print("bodyRequest$body");

    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }
  // recent review list api integration
  recentViewed() async {
    var url = "$baseUrl/recently-list";
    print("recentlyUrl$url");
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  // add to the recent either the products or the restaurant
  addToRecent({String? type, String? id}) async {
    var url = "$baseUrl/add-recently-view";
    Map<String, dynamic> body = {
      "id": loginController.userId.toString(),
      "type": type.toString(),
      "resturant_id": id.toString()
    };
    print("");
    http.Response response = await http.post(Uri.parse(url), body: body);




    return jsonDecode(response.body);
  }

  // place order with your cart item list
  placeOrder({
    String? shippingPrice,
    String? restaurantId,
    String? userId,
    double? totalPrice,
    String? paymentMethod,
    String? address,
    String? couponId,
    String? cookingRequest,
    String? deliveryType,
    String? profileName,
    List<Map<String, dynamic>>? cartItems,
  }) async {
    List<Map<String, dynamic>> processedCartItems = [];
    print("cartItems$cartItems");
    if (cartItems != null) {
      for (var item in cartItems) {
        Map<String, String> itemSelectedOptions = {};
        Map<String, List<String>> itemGroupOptions = {};
        if (item.containsKey('selected_options') &&
            item['selected_options'] is List) {
          for (var selectedOptionDetail in item['selected_options']) {
            if (selectedOptionDetail is Map<String, dynamic> &&
                selectedOptionDetail.containsKey('side_item_questions') &&
                selectedOptionDetail['side_item_questions'] is List) {
              for (var question
                  in selectedOptionDetail['side_item_questions']) {
                if (question is Map<String, dynamic> &&
                    question.containsKey('option_id') &&
                    question.containsKey('question_id')) {
                  String questionId = question['question_id'].toString();
                  String optionId = question['option_id'].toString();
                  itemSelectedOptions[questionId] = optionId;
                }
              }
            }
          }
        }
        if (item.containsKey('group_option_details') &&
            item['group_option_details'] is List) {
          for (var groupDetail in item['group_option_details']) {
            if (groupDetail is Map<String, dynamic> &&
                groupDetail.containsKey('group_id') &&
                groupDetail.containsKey('options') &&
                groupDetail['options'] is List) {
              String optionGroupId = groupDetail['group_id'].toString();

              if (!itemGroupOptions.containsKey(optionGroupId)) {
                itemGroupOptions[optionGroupId] = [];
              }

              for (var option in groupDetail['options']) {
                if (option is Map<String, dynamic> &&
                    option.containsKey('id')) {
                  String oftenBoughtOptionId = option['id'].toString();
                  itemGroupOptions[optionGroupId]!.add(oftenBoughtOptionId);
                }
              }
            }
          }
        }
        Map<String, dynamic> newCartItem = {
          "product_id": item['product_id'],
          "quantity": item['quantity'],
          "price": item['price'],
          "name": item.containsKey('item_name') ? item['item_name'] : null,
          "extra_features":
              item.containsKey('extra_features') ? item['extra_features'] : [],
          "selected_options":
              itemSelectedOptions.isEmpty ? [] : itemSelectedOptions,
          "group_options": itemGroupOptions.isEmpty ? [] : itemGroupOptions,
        };
        print("newCartItem$newCartItem");
        processedCartItems.add(newCartItem);
      }
    }
    var url = "$baseUrl/order-place";
    Map<String, dynamic> body = {
      "user_id": userId,
      "resturant_id": restaurantId.toString(),
      "shipping": shippingPrice,
      "cart_items": processedCartItems,
      "totalprice": totalPrice,
      "peyment_method": paymentMethod,
      "address": address,
      "coupon_id": couponId,
      "cookies_request": cookingRequest,
      "checkbox": deliveryType,
      "name": profileName,
    };
    print("processedCartItems$processedCartItems");
    print("body$body");
    Map<String, String> header = {"Content-Type": "application/json"};
    http.Response response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: header);
    print("order place api response :- ${response.body}");
    return json.decode(response.body);
  }

  // order list api integration
  orderList({int page = 1, int limit = 6}) async {
    var url = "$baseUrl/orders-list";
    // String url = "${baseUrl}order-list?page=$page&limit=$limit";
    log("loginController.userId :- ${loginController.userId}");
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "page": '$page'
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  // cancel the pending order api integration
  cancelPendingOrder({String? orderId}) async {
    var url = "$baseUrl/orders-cancel";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "orderid": orderId
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("cancel pending order :- ${response.body}");
    return jsonDecode(response.body);
  }

  rateOrder({
    String? review,
    String? rating,
    int? productId,
    int? restaurantId,
    int? orderId,
  }) async {
    var url = "$baseUrl/review-rating";
    Map<String, dynamic> body = {
      "review": review,
      "rating": rating,
      "product_id": productId.toString(),
      "restaurent_id": restaurantId.toString(),
      "order_id": orderId.toString(),
      "user_id": loginController.userId.toString(),
    };
    print("rate order body: $body");
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("rate order api response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // chat with restaurant api integration
  chatWithRestaurant({
    String? message,
    String? receiverId,
    String? image,
  }) async {
    var url = '$baseUrl/chat';
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(url),
    );
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath("image", image));
    }
    request.fields["sender_id"] = loginController.userId.toString();
    request.fields["receiver_id"] = receiverId.toString();
    request.fields["message"] = message.toString();
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    final responseData = json.decode(response.body);
    print("chat response in api :- $responseData");
    return responseData;
  }

  subscribeDeal(String dealId, String productId) async {
    var url = "$baseUrl/subscribe";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "deal_id": dealId,
      "product_id": productId
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("subscribe deal api response :- ${response.body}");
    return jsonDecode(response.body);
  }

  unSubscribeDeal(String dealId, String productId) async {
    var url = "$baseUrl/unsubscribe";
    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
      "deal_id": dealId,
      "product_id": productId
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("subscribe deal api response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // chat list
  chatList({
    String? receiverId,
  }) async {
    var url = "$baseUrl/chat-list";
    Map<String, dynamic> body = {
      "receiver_id": receiverId.toString(),
      "sender_id": loginController.userId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("chat list api response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // chat list
  notificationList() async {
    var url = "$baseUrl/notification-list";

    print("urlNotification$url");

    Map<String, dynamic> body = {
      "user_id": loginController.userId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("notification list api response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // login with google or with the twitter
  loginWithGoogleOrTwitter({
    String? email,
    String? type,
    String? name,
    String? phone,
    String? image,
    String? token,
  }) async {
    var url = "$baseUrl/login-callback";
    Map<String, dynamic> body = {
      "email": email,
      "type": type,
      "name": name ?? "",
      "phone": phone ?? "",
      "image": image ?? "",
      "token": token ?? "",
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("login with google or twitter api response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // food details
  foodDetails({String? foodId}) async {
    var url = "$baseUrl/food-details";
    print("url_check$url");
    Map<String, dynamic> body = {
      "products_id": foodId.toString(),
    };
    print("foodCategoryUrl:$url");

    print("productId#${foodId.toString()}");
    http.Response response = await http.post(Uri.parse(url), body: body);
    print("food detail api response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // deal food details
  dealfoodDetails({String? dealId, String? productId}) async {
    var url = "$baseUrl/food-deal-details";
    Map<String, dynamic> body = {
      "deal_id": dealId.toString(),
      "products_id": productId.toString(),
    };
    print("food-deal-url${url}");

    print("body__________$body");
    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  // multi deal food details
  multiDealFoodDetails({String? dealId}) async {
    var url = "$baseUrl/multi-food-deal-details";
    print("urlMulti-Food$url");
    Map<String, dynamic> body = {
      "deal_id": dealId.toString(),
    };
    print("deal_id$dealId");
    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  //our deals
  ourDealsRestaurant({String? restaurantId}) async {
    var url = "$baseUrl/our-deals";
    Map<String, dynamic> body = {
      "restaurant_id": restaurantId.toString(),
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  //product list based on our deal
  productListBasedOnRestaurant({String? restaurantId, String? dealId}) async {
    var url = "$baseUrl/our-products";

    print("url$url");

    Map<String, dynamic> body = {
      "restaurant_id": restaurantId.toString(),
      "deal_id": dealId.toString(),
    };

    print("body$body");


    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  // order bill details api integration
  orderViewDetails({required String orderId}) async {
    var url = "$baseUrl/orders-billing-detail";
    Map<String, dynamic> body = {
      "order_id": orderId,
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  // userNotification status change  api integration
  makrAsRead({required String notificationId}) async {
    var url = "$baseUrl/notifications-mark-as-read";
    Map<String, dynamic> body = {
      'user_id': loginController.userId.toString(),
      "notification_id": notificationId,
    };
    http.Response response = await http.post(Uri.parse(url), body: body);
    log("api services all status active response :- ${response.body}");
    return jsonDecode(response.body);
  }
}
