import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StationRecordController extends GetxController {
  final locationData = Get.arguments['item'];
  final stationId = Get.arguments['item'].id ?? "";
  final stationTitle = Get.arguments['item'].title ?? "";

  final selectedParameter = 'বৃষ্টিপাত'.obs;


  @override
  void onInit() {
    print('Station ID: $stationId, Title: $stationTitle');
    super.onInit();
  }
}
