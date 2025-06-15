import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StationRecordController extends GetxController {
  final stationId = Get.arguments['id'] ?? "";
  final stationTitle = Get.arguments['title'] ?? "";

  final selectedParameter = 'বৃষ্টিপাত'.obs;


  @override
  void onInit() {
    print('Station ID: $stationId, Title: $stationTitle');
    super.onInit();
  }
}
