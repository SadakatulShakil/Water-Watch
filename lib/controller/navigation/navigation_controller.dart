import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../page/dashboard.dart';
import '../../page/my_record.dart';
import '../../page/seetings_page.dart';
import '../../page/sms_page.dart';
import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';

class NavigationController extends GetxController {
  //TODO: Implement HomeController
  static NavigationController get to => Get.find();

  final count = 0.obs;
  var currentTab = 0.obs;
  final List<Widget> screen = [
    DashboardPage(),
    MyRecordPage(),
    SmsPage(),
    SettingsPage(),
  ];
  final userPrefService = UserPrefService();

  @override
  void onInit() {
    super.onInit();
    //checkLogin();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void onItemTapped(index) {
    currentTab.value = index;
  }

  void changePage(int index) {
    currentTab.value = index;
  }
}
