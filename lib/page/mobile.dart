import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/mobile/MobileController.dart';
import '../utills/AppColors.dart';

class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {

  MobileController controller = Get.put(MobileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset( 'assets/logo/bmd_logo.png', height: 96 ),
              SizedBox(height: 16),
              Text("LOGIN TO Landslide Report", style: TextStyle( fontSize: 20, fontWeight: FontWeight.w500, ) ),
              Text("Please Enter the mobile number to login" ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 0),
                child: TextField(
                  controller: controller.mobile,
                  decoration: InputDecoration(
                      hintText: "01xxxxxxxxx",
                      label: Text("Enter Mobile Number", style: TextStyle(color: AppColors().app_primary),),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: AppColors().app_primary),
                    ),
                  ),
                  cursorColor: AppColors().app_primary,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 0),
                  child: ElevatedButton(
                    onPressed: controller.gotoOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().app_primary,
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text("Powered by RIMES" ),
            ],
          ),
        ),
      ),
    );
  }
}
