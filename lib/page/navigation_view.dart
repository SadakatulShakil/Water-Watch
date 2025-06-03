import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utills/AppColors.dart';
import '../controller/navigation/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildNavbarItem(Icons.dashboard_outlined, "Home", 0),
              buildNavbarItem(Icons.bar_chart, "Record", 1),
              buildNavbarItem(Icons.sms_outlined, "SMS", 2),
              buildNavbarItem(Icons.settings, "Settings", 3),
            ],
          ),
        ),
      ),
      body: Obx(()=> controller.screen.elementAt(controller.currentTab.value))
    );
  }


  Widget buildNavbarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => {controller.changePage(index)},
      splashFactory: NoSplash.splashFactory,
      child: Column(
        children: [
          Obx(()=> Icon( icon,
              color: controller.currentTab == index
                  ? AppColors().app_primary
                  : Colors.black54) ),
          Obx(()=> Text( label,
            style: TextStyle( fontWeight: controller.currentTab == index
                ? FontWeight.bold
                : FontWeight.normal,
              color:  controller.currentTab == index
                  ? AppColors().app_primary
                  : Colors.black54 ),
          ))
        ],
      ),
    );
  }
}
