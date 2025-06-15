import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utills/AppColors.dart';


class NotificationPage extends StatefulWidget {
  final int tabIndex;

  const NotificationPage({super.key, this.tabIndex = 0});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.tabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade100,
        title: Text("notification".tr),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo/bwdb_logo.png', height: 96),
              SizedBox(height: 16),
              Text("No Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(height: 16),
              Text("You have no notifications at this time.", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      )
    );
  }
}
