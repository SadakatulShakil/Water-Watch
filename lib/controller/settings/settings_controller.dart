import 'dart:ui';

import 'package:get/get.dart';

class SettingsController extends GetxController {
  List<bool> selectedLanguage = [false, true].obs;
  Future changeLanguage(int index) async {
    for (int buttonIndex = 0; buttonIndex < selectedLanguage.length; buttonIndex++) {
      if (buttonIndex == index) {
        selectedLanguage[buttonIndex] = true;
      } else {
        selectedLanguage[buttonIndex] = false;
      }
    }
    if(index == 0) {
      await Get.updateLocale(Locale('en', 'US'));
    } else {
      await Get.updateLocale(Locale('bn', 'BD'));
    }
  }
}
