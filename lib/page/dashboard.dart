import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:water_watch/page/station_report_page.dart';

import '../controller/add_record/add_record_binding.dart';
import '../controller/dashboard/DashboardController.dart';

class DashboardPage extends StatelessWidget {
  final String username = "Sadakatul ajam Shakil";
  final DashboardController controller = Get.put(DashboardController());
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with greeting and bell
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("শুভ বিকেল,", style: TextStyle(fontSize: 16, color: Colors.black54)),
                          SizedBox(height: 4),
                          Text(username,
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.notifications_none, color: Colors.black87),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                // Center image
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      lottie.Lottie.asset(
                        'assets/json/water_anim.json',
                        width: 220,
                        height: 220,
                        repeat: true,
                      ),
                      Image.asset(
                        'assets/images/ruler.png', // Your central image
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                // Grid
                // Dynamic Grid
                Expanded(
                  child: Obx(() {
                    if (controller.locations.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: controller.locations.map((loc) {
                        return locationCard(loc.id, loc.title, loc.subtitle);
                      }).toList(),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget locationCard(String id, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        print("Tapped on location: $title & $id");
        Get.to(StationReportPage(),
          arguments: {'id': id, 'title': title},
          transition: Transition.leftToRight);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle,
                style: TextStyle(fontSize: 13, color: Colors.black54)),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
