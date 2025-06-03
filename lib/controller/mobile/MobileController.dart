import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../page/navigation_view.dart';
import '../../page/otp.dart';
import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
import '../navigation/navigation_binding.dart';

class MobileController extends GetxController{
  final TextEditingController mobile = TextEditingController();
  final userPrefService = UserPrefService();
  var isChecking = true.obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }


  gotoOTP() async {
    var params = jsonEncode({ "mobile": "${mobile.value.text}" });
    Get.to(Otp(), arguments: {'mobile': mobile.value.text}, transition: Transition.leftToRight);

    // var response = await http.post(ApiURL.mobile, body: params);
    // dynamic decode = jsonDecode(response.body) ;
    // print('shakil mobile: ${decode}');
    // if(response.statusCode != 200) {
    //   return Get.defaultDialog(
    //       title: "Alert",
    //       middleText: decode['message'],
    //       textCancel: 'Ok',
    //   );
    // } else {
    //   Get.to(Otp(), arguments: {'mobile': mobile.value.text}, transition: Transition.leftToRight);
    // }
  }

  Future checkLogin() async {
    print('shakil token#1: ${userPrefService.userToken}');
    if(userPrefService.userToken != null && userPrefService.userToken!.isNotEmpty) {
      Get.offAll(NavigationView(), transition: Transition.downToUp, binding: NavigationBinding());
    }else {
      isChecking.value = false; // Stop loading, show login page
    }
  }
}