import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utills/AppColors.dart';
import '../Utills/AppDrawer.dart';
import '../controller/dashboard/DashboardController.dart';
import '../controller/network/network_controller.dart';
import '../services/api_urls.dart';
import 'notification_page.dart';

class DashboardPage extends StatelessWidget {
  // Sample pie chart data for landslide types
  final controller = Get.put(DashboardController());
  final NetworkController internetController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal.shade50,
          automaticallyImplyLeading: false,
          title: Obx(() => ListTile(
              title: Text(controller.fullname.value.isEmpty ? controller.mobile.value : controller.fullname.value, style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(controller.initTime.value),
          )
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, size: 28, color: AppColors().app_primary,),
                    onPressed: () {
                      Get.to(()=> NotificationPage(),transition: Transition.rightToLeft);
                      // Handle notification icon press
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 6,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.teal.shade100,
                  child: Builder(
                    builder: (context) => IconButton(onPressed: (){ Scaffold.of(context).openDrawer();},
                      icon: Icon(Icons.menu), iconSize: 20, color: AppColors().app_primary,),
                  )
              ),
            ),
          ]
      ),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('data')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
