import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AddRecordController extends GetxController {
  final stationId = Get.arguments['id'] ?? "";
  final stationTitle = Get.arguments['title'] ?? "";

  final selectedParameter = 'বৃষ্টিপাত'.obs;
  final selectedDate = DateTime.now().obs;

  RxList<Map<String, String>> timeMeasurements = <Map<String, String>>[].obs;


  @override
  void onInit() {
    print('Station ID: $stationId, Title: $stationTitle');
    super.onInit();
  }

  AddRecordController() {
    addTimeMeasurement(); // Initial row
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
    final String phoneNumber = "01751330394";

    final String date = "${selectedDate.value.toLocal()}".split(' ')[0];
    final String report = timeMeasurements.map((entry) {
      final time = entry['time'] ?? "";
      final measurement = entry['measurement'] ?? "";
      return "$time: ${selectedParameter.value} - $measurement মি.মি.";
    }).join("; ");

    final String message = "তারিখ: $date; রিপোর্ট: $report";

    print("SMS URI: $message");
    //launchUrl(smsUri);
  }
}
