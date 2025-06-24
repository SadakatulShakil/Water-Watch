import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_watch/services/LocalizationString.dart';
import 'package:water_watch/services/firebase_service.dart';
import 'package:water_watch/services/location_service.dart';
import 'package:water_watch/services/user_pref_service.dart';

import 'Utills/firebase_option.dart';
import 'Utills/routes/app_pages.dart';
import 'Utills/widgets/location_gate.dart';
import 'controller/mobile/MobileController.dart';
import 'controller/navigation/navigation_binding.dart';
import 'controller/settings/settings_controller.dart';
import 'database_helper/db_service.dart'; // Import your DBService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPreferences
  await UserPrefService().init();
  Get.put(SettingsController());
  final savedLang = UserPrefService().appLanguage;
  await LocationService().getLocation();
  // Initialize DBService
  final dbService = await DBService().init();
  Get.put(dbService, permanent: true); // Add DBService with permanent flag

  try {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on Exception catch (e, stack) {
    print('🔥 Location Initialization Error: $e');
    print(stack);
  }
  runApp(MyApp(savedLang));
}

class MyApp extends StatelessWidget {
  final MobileController mobileController = Get.put(MobileController());
  final FirebaseService _firebaseService = FirebaseService();
  final String savedLang;
  MyApp(this.savedLang);
  @override
  Widget build(BuildContext context) {
    _firebaseService.initNotifications();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Report',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotificationGatePage(),
      //getPages: AppPages.routes,
      initialBinding: NavigationBinding(),
      translations: LocalizationString(),
      locale: Locale(savedLang),
    );
  }
}