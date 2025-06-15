import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/parameter_model.dart';
import '../dashboard/DashboardController.dart';

class AddRecordController extends GetxController {
  final locationData = Get.arguments['item'];
  final stationId = Get.arguments['item'].id ?? "";
  final stationTitle = Get.arguments['item'].title ?? "";
  final selectedParameter = Rx<ParameterModel?>(null);

  final selectedDate = DateTime.now().obs;

  RxList<Map<String, String>> timeMeasurements = <Map<String, String>>[].obs;


  @override
  void onInit() {
    print('Station ID: $stationId, Title: $stationTitle');
    final dashboard = Get.find<DashboardController>();

    if (dashboard.parameters.isNotEmpty) {
      selectedParameter.value = dashboard.parameters.first;
    }

    addTimeMeasurement(); // Initial row
    super.onInit();
  }


  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (picked != null) selectedDate.value = picked;
  }

  void updateMeasurementByItem(Map<String, String> item, String value) {
    final index = timeMeasurements.indexOf(item);
    if (index != -1) {
      timeMeasurements[index]['measurement'] = value;
      timeMeasurements.refresh();
    }
  }

  void pickTimeByItem(Map<String, String> item, BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      String formatted = picked.format(context);
      final index = timeMeasurements.indexOf(item);
      if (index != -1) {
        timeMeasurements[index]['time'] = formatted;
        timeMeasurements.refresh();
      }
    }
  }

  void addTimeMeasurement() {
    timeMeasurements.add({'time': '', 'measurement': ''});
  }

  void removeTimeMeasurementByItem(Map<String, String> item) {
    if (timeMeasurements.length > 1) {
      timeMeasurements.remove(item);
    }
  }
  void saveRecord() {
    final param = selectedParameter.value;

    if (param == null) {
      Get.snackbar("Missing Data", "স্টেশন ও প্যারামিটার নির্বাচন করুন");
      return;
    }

    // Validate each timeMeasurement entry
    for (var entry in timeMeasurements) {
      final time = entry['time']?.trim() ?? '';
      final measurement = entry['measurement']?.trim() ?? '';
      if (time.isEmpty || measurement.isEmpty) {
        Get.snackbar("অপূর্ণ তথ্য", "সময় এবং পরিমাপ পূরণ করুন");
        return;
      }
    }

    final date = "${selectedDate.value.toLocal()}".split(' ')[0];
    final report = timeMeasurements.map((entry) {
      final time = entry['time'] ?? "";
      final measurement = entry['measurement'] ?? "";
      return "$date: $time: ${param.title} - $measurement মিমি #$stationTitle #$stationId";
    }).join("; ");

    final message = "তারিখ: $date\nস্টেশন: ${stationTitle} (${stationId})\nপ্যারামিটার: ${param.title} (${param.id})\nরিপোর্ট: $report";

    final smsUri = Uri(
      scheme: 'sms',
      path: "01751330394",
      queryParameters: {'body': message},
    );

    print("SMS URI: $report");
    // launchUrl(smsUri);
  }
}
