import 'dart:convert';

import 'package:food_delivery/controllers/side_drawer_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/login_controller.dart';

class API {
  String baseUrl = "https://getfooddelivery.com/api";
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

    print("allow location api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // user login api integration
  login(String email, String password) async {
    var url = "$baseUrl/login";

    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

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
    http.Response response = await http.get(Uri.parse(url));
    print(" best deals api service response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // spcial food api integration
  specialFood() async {
    var url = "$baseUrl/special-food";
    http.Response response = await http.get(Uri.parse(url));
    print(" special food api service response :- ${response.body}");
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
  viewAllRestaurant() async {
    var url = "$baseUrl/all-restaurant";
    http.Response response = await http.get(Uri.parse(url));
    print("api services all restautant response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // view all special food api integration
  viewAllSpecialFood() async {
    var url = "$baseUrl/all-special-food";
    http.Response response = await http.get(Uri.parse(url));
    print("api services all special food response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // view all best deals api integration
  viewAllBestDeals() async {
    var url = "$baseUrl/all-best-deals";
    http.Response response = await http.get(Uri.parse(url));
    print("api services all best deals response :- ${response.body}");
    return jsonDecode(response.body);
  }

  // all food category api integration
  viewAllFoodCategory() async {
    var url = "$baseUrl/all-categories";
    http.Response response = await http.get(Uri.parse(url));
    print("view all food category api response:- ${response.body}");
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
}
