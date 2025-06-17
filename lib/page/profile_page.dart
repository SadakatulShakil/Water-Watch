import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utills/AppColors.dart';
import '../controller/dashboard/DashboardController.dart';
import '../controller/profile/ProfileController.dart';
import '../database_helper/entity/local_location_entity.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Get.put(ProfileController());
  final DashboardController d_controller = Get.find<DashboardController>();
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
        resizeToAvoidBottomInset: true,
        body: Obx(() => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    controller.isConfirmVisible.value
                        ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors().positive_bg.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () => controller.uploadImage(),
                          child: Row(
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 20),
                              SizedBox(width: 5),
                              Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: 16),

                // Profile Picture
                Stack(
                  children: [
                    CircleAvatar(
                      maxRadius: 65,
                      backgroundColor: AppColors().app_primary,
                      child: CircleAvatar(
                        radius: 63,
                        backgroundImage: controller.selectedImagePath.value.isNotEmpty
                            ? FileImage(File(controller.selectedImagePath.value))
                            : AssetImage("assets/images/profile.png") as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.shade200,
                        foregroundColor: AppColors().app_secondary,
                        radius: 18,
                        child: IconButton(
                          onPressed: () {
                            controller.pickImage();
                          },
                          icon: Icon(Icons.camera_alt_rounded, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // First Name
                      TextField(
                        controller: controller.nameController,
                        enabled: true,
                        decoration: InputDecoration(
                          label: Text('First Name', style: TextStyle(color: AppColors().app_primary)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().app_primary)),
                        ),
                        cursorColor: AppColors().app_primary,
                      ),
                      SizedBox(height: 12),

                      // Last Name
                      TextField(
                        controller: controller.nameController,
                        enabled: true,
                        decoration: InputDecoration(
                          label: Text('Last Name', style: TextStyle(color: AppColors().app_primary)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().app_primary)),
                        ),
                        cursorColor: AppColors().app_primary,
                      ),
                      SizedBox(height: 12),

                      // Station Info
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "স্টেশনসমূহ (শুধু দেখা)",
                              style: TextStyle(
                                color: AppColors().app_primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: d_controller.locations.map((loc) {
                                return Chip(
                                  label: Text(loc.title),
                                  backgroundColor: Colors.blue.shade100,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),

                      // Mobile (disabled + verified)
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: controller.mobileController,
                            readOnly: true,
                            enabled: false,
                            style: TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              label: Text('Mobile', style: TextStyle(color: AppColors().app_primary)),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().app_primary)),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, color: Colors.green, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "Verified",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Address
                      TextField(
                        controller: controller.addressController,
                        enabled: true,
                        decoration: InputDecoration(
                          label: Text("profile_info_address".tr, style: TextStyle(color: AppColors().app_primary)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().app_primary)),
                        ),
                        cursorColor: AppColors().app_primary,
                      ),
                      SizedBox(height: 24),

                      // Update Button
                      ElevatedButton(
                        onPressed: controller.updateProfile,
                        child: Text("profile_info_update_button".tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().app_primary,
                          foregroundColor: AppColors().app_secondary,
                          textStyle: TextStyle(fontSize: 16),
                          minimumSize: Size(100, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ))
      ),
    );
  }
}
