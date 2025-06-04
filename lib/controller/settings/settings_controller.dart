import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/user_pref_service.dart';

class SettingsController extends GetxController {
  RxList<bool> selectedLanguage = [false, true].obs; // Default Bangla

  @override
  void onInit() {
    super.onInit();
    loadLanguagePreference();
  }

  Future<void> changeLanguage(int index) async {
    selectedLanguage.value = [index == 0, index == 1];

    // Save language to shared prefs
    final langCode = index == 0 ? 'en' : 'bn';
    await UserPrefService().saveAppLanguage(langCode);

    // Update locale
    await Get.updateLocale(Locale(langCode));
  }

  Future<void> loadLanguagePreference() async {
    final langCode = UserPrefService().appLanguage;

    selectedLanguage.value = [langCode == 'en', langCode == 'bn'];
    await Get.updateLocale(Locale(langCode));
  }
}
