import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_watch/controller/add_record/add_record_controller.dart';
import 'package:water_watch/page/add_report_page.dart';
import 'package:water_watch/page/graphical_page.dart';
import 'package:water_watch/page/history_page.dart';
import '../controller/dashboard/DashboardController.dart';
import '../controller/sms/sms_controller.dart';
import '../controller/station_report/station_record_controller.dart';
import '../database_helper/entity/local_parameter_entity.dart';

class StationReportPage extends StatefulWidget {
  final int tabIndex;
  const StationReportPage({super.key, this.tabIndex = 0});
  @override
  State<StationReportPage> createState() => _StationReportPageState();
}

class _StationReportPageState extends State<StationReportPage> with SingleTickerProviderStateMixin {
  final StationRecordController controller = Get.put(StationRecordController());
  final dashboardController = Get.find<DashboardController>();
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
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  Text("${controller.locationData.title}",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Add your button action here
                        final result = await Get.to(AddReportPage(),
                            arguments: {'item': controller.locationData},
                            transition: Transition.rightToLeft);
                        if (result == 'refresh') {
                          controller.onRefresh();
                        }
                      },
                      child: Text("Add Data", style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() => buildDropdown(
                  title: "প্যারামিটার নির্বাচন করুন",
                  value: Get.locale?.languageCode == 'bn'
                      ?controller.selectedParameter.value?.titleBn ?? ''
                      :controller.selectedParameter.value?.title ?? '',
                  onTap: () => _showBottomSheet<ParameterEntity>(
                    context,
                    dashboardController.parameters,
                    controller.selectedParameter,
                        (item) => Get.locale?.languageCode == 'bn'
                            ?item.titleBn
                            :item.title,
                        (item) => item.id,
                  ),
                )),
              ),

              // Add TabBar
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5AAFE5), Color(0xFF3B8DD2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.storage),
                          SizedBox(width: 8),
                          Text("History"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_graph),
                          SizedBox(width: 8),
                          Text("Graph"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(child: HistoryPage(parameterId: controller.selectedParameter.value?.id ?? ''),), // Replace with your actual widgets
                    Center(child: GraphicalPage()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({required String title, required String value, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? title : value,
                style: TextStyle(
                  color: value.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet<T>(
      BuildContext context,
      List<T> items,
      Rx<T?> selectedValue,
      String Function(T) getLabel,
      String Function(T) getId, // <-- Add this
      ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: items.map((item) {
            final label = getLabel(item);
            final isSelected = selectedValue.value != null &&
                getId(selectedValue.value as T) == getId(item);

            return ListTile(
              title: Text(label),
              trailing: isSelected
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                selectedValue.value = item;
                Get.back();
              },
            );
          }).toList(),
        );
      },
    );
  }


}
