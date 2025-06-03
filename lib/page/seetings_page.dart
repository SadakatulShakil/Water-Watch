import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utills/AppColors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade100,
        title: Text("settings".tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo/bmd_logo.png', height: 96),
            SizedBox(height: 16),
            Text("No Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            SizedBox(height: 16),
            Text("You have no settings at this time.", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}