import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_watch/controller/my_record/my_record_conttroller.dart';
import '../Utills/AppColors.dart';
import '../controller/dashboard/DashboardController.dart';
import '../database_helper/entity/local_parameter_entity.dart';
import '../database_helper/entity/record_entity.dart';

class MyRecordPage extends StatefulWidget {
  MyRecordPage({super.key});

  @override
  State<MyRecordPage> createState() => _MyRecordPageState();
}

class _MyRecordPageState extends State<MyRecordPage> {
  final controller = Get.put(MyRecordController());
  final dashboardController = Get.find<DashboardController>();
  final _expandedDates = <String>{};

  void _showYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => ListView.builder(
            itemCount: controller.years.length,
            itemBuilder: (_, index) {
              final year = controller.years[index];
              final isSelected = year == controller.selectedYear.value;
              return ListTile(
                title: Text(year.toString()),
                trailing:
                    isSelected ? Icon(Icons.check, color: Colors.teal) : null,
                onTap: () => controller.selectYear(year),
              );
            },
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
          children:
              items.map((item) {
                final label = getLabel(item);
                final isSelected =
                    selectedValue.value != null &&
                    getId(selectedValue.value as T) == getId(item);

                return ListTile(
                  title: Text(label),
                  trailing:
                      isSelected ? Icon(Icons.check, color: Colors.blue) : null,
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

  @override
  Widget build(BuildContext context) {
    controller.loadRecords();
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'আমার রেকর্ড',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _showYearPicker(context),
                          child: dropdownBox(
                            "বছর নির্বাচন করুন",
                            controller.selectedYear.value.toString(),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap:
                              () => _showBottomSheet<ParameterEntity>(
                                context,
                                dashboardController.parameters,
                                controller.selectedParameter,
                                (item) =>
                                    Get.locale?.languageCode == 'bn'
                                        ? item.titleBn
                                        : item.title,
                                (item) => item.id,
                              ),
                          child: dropdownBox(
                            "প্যারামিটার নির্বাচন করুন",
                            Get.locale?.languageCode == 'bn'
                                ? controller.selectedParameter.value?.titleBn ??
                                    ''
                                : controller.selectedParameter.value?.title ??
                                    '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                Obx(() {
                  final grouped = controller.groupedRecordsByDate;

                  if (grouped.isEmpty) {
                    return Expanded(
                      // wrap this too!
                      child: Center(
                        child: Text(
                          'No records found',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children:
                          grouped.entries.map((entry) {
                            final date = entry.key;
                            final records = entry.value;
                            final isExpanded = _expandedDates.contains(date);

                            return Card(
                              margin: EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.grey.shade100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      date,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (isExpanded) {
                                          _expandedDates.remove(date);
                                        } else {
                                          _expandedDates.add(date);
                                        }
                                      });
                                    },
                                  ),
                                  if (isExpanded) ...[
                                    _buildTableHeader(),
                                    ...records.map(
                                      (record) => _buildRecordRow(
                                        record,
                                        records.indexOf(record),
                                        records.length,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
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
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.all(color: Colors.blue),
        color: Colors.blue.shade50,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'time'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  'measurement'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'station'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'media'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordRow(RecordEntity record, int index, int totalRecords) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blue),
          top: BorderSide(color: Colors.blue),
          right: BorderSide(color: Colors.blue),
          bottom: BorderSide(
            color: Colors.blue,
            width:
                index == totalRecords - 1
                    ? 1.0
                    : 0.0, // Only show bottom border for last item
          ),
        ),
        borderRadius:
            index == totalRecords - 1
                ? BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )
                : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Time
            Expanded(
              child: Text(
                record.time,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),

            // Quantity
            Text(
              "${record.measurement} মিমি",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),

            // Location
            Expanded(
              child: Text(
                record.locationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  color: record.isSynced ? Colors.green : Colors.orange,
                ),
              ),
            ),

            // Media
            Expanded(
              child:
                  (record.image1Path!.isEmpty &&
                          record.image2Path!.isEmpty &&
                          record.image3Path!.isEmpty)
                      ? Text(
                        "No Media",
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      textAlign: TextAlign.center,
                      )
                      : Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (record.image1Path!.isNotEmpty)
                              _buildMediaImage(record.image1Path!),
                            if (record.image2Path!.isNotEmpty)
                              _buildMediaImage(record.image2Path!),
                            if (record.image3Path!.isNotEmpty)
                              _buildMediaImage(record.image3Path!),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaImage(String filePath) {
    return Padding(
      padding: EdgeInsets.only(left: 2.0),
      child: GestureDetector(
        onTap: () {
          Get.dialog(
            Dialog(
              backgroundColor: Colors.black,
              insetPadding: EdgeInsets.all(10),
              child: InteractiveViewer(
                child: Image.file(
                  File(Uri.parse(filePath).path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(Uri.parse(filePath).path), // Important: convert URI to path
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
