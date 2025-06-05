import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utills/AppColors.dart';
import '../controller/settings/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'সেটিংস',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ListTile(
                leading: Icon(Icons.person_outline, color: Colors.teal),
                title: Text('আমার প্রোফাইল', style: TextStyle(fontSize: 16)),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to profile page
                },
              ),
              Divider(),

              ListTile(
                leading: Icon(Icons.language, color: Colors.teal),
                title: Text(
                  'profile_language_select'.tr,
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(10),
                    fillColor: AppColors().app_primary_bg,
                    selectedColor: AppColors().app_primary,
                    color: Colors.black54,
                    textStyle: TextStyle(fontSize: 12),
                    isSelected: controller.selectedLanguage,
                    onPressed: (int index) {
                      controller.changeLanguage(
                        index,
                      ); // no need to call setState
                    },
                    children: [Text('EN'), Text('BN')],
                  ),
                ),
              ),
              Divider(),

              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  'লগআউট',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
                onTap: () {
                  Get.defaultDialog(
                    title: 'নিশ্চিত?',
                    middleText: 'আপনি লগআউট করতে চান?',
                    textConfirm: 'হ্যাঁ',
                    textCancel: 'না',
                    onConfirm: () {
                      Get.back();
                      Get.offAllNamed('/login');
                    },
                    onCancel: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
