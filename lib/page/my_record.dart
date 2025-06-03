import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_watch/controller/my_record/my_record_conttroller.dart';
import '../Utills/AppColors.dart';

class MyRecordPage extends StatelessWidget {
  final selectionController = Get.put(MyRecordController());

  MyRecordPage({super.key});

  void _showYearPicker(BuildContext context) {
    final controller = Get.find<MyRecordController>();
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: controller.years.length,
        itemBuilder: (_, index) {
          final year = controller.years[index];
          final isSelected = year == controller.selectedYear.value;
          return ListTile(
            title: Text(year.toString()),
            trailing: isSelected ? Icon(Icons.check, color: Colors.teal) : null,
            onTap: () => controller.selectYear(year),
          );
        },
      ),
    );
  }

  void _showParameterPicker(BuildContext context) {
    final controller = Get.find<MyRecordController>();
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: controller.parameters.map((param) {
          final isSelected = param == controller.selectedParameter.value;
          return ListTile(
            title: Text(param),
            trailing: isSelected ? Icon(Icons.check, color: Colors.teal) : null,
            onTap: () => controller.selectParameter(param),
          );
        }).toList(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background1.jpg', // Your background image here
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('আমার রেকর্ড',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  SizedBox(height: 16),
                  Obx(() => Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _showYearPicker(context),
                          child: dropdownBox("বছর নির্বাচন করুন", selectionController.selectedYear.value.toString()),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _showParameterPicker(context),
                          child: dropdownBox("প্যারামিটার নির্বাচন করুন", selectionController.selectedParameter.value),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropdownBox(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.black54)),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ],
      ),
    );
  }

}