import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SmsController extends GetxController {
  final selectedStation = 'স্টেশন ১'.obs;
  final selectedParameter = 'বৃষ্টিপাত'.obs;
  final selectedDate = DateTime.now().obs;

  final timeMeasurements = <Map<String, String>>[].obs;

  SmsController() {
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

  void pickTime(int index, BuildContext context) async {
    TimeOfDay initial = TimeOfDay.now();
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      String formatted = picked.format(context);
      timeMeasurements[index]['time'] = formatted;
      timeMeasurements.refresh();
    }
  }

  void updateMeasurement(int index, String value) {
    timeMeasurements[index]['measurement'] = value;
    timeMeasurements.refresh();
  }

  void addTimeMeasurement() {
    timeMeasurements.add({'time': '', 'measurement': ''});
  }

  void removeTimeMeasurement(int index) {
    if (timeMeasurements.length > 1) {
      timeMeasurements.removeAt(index);
    }
  }
}
