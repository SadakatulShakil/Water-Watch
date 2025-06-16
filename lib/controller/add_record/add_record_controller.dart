import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:water_watch/database_helper/entity/local_parameter_entity.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../database_helper/db_service.dart';
import '../../database_helper/entity/record_entity.dart';
import '../dashboard/DashboardController.dart';

class AddRecordController extends GetxController {
  final locationData = Get.arguments['item'];
  final stationId = Get.arguments['item'].id ?? "";
  final stationTitle = Get.arguments['item'].title ?? "";
  final selectedParameter = Rx<ParameterEntity?>(null);
  final selectedImages = <File>[].obs;
  final selectedDate = DateTime.now().obs;
  final dbService = Get.find<DBService>();
  final timeMeasurements = <Map<String, String>>[].obs;


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

  Future<void> pickImage() async {
    if (selectedImages.length >= 3) {
      Get.snackbar("সীমা অতিক্রম", "আপনি সর্বোচ্চ ৩টি ছবি আপলোড করতে পারবেন");
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (picked != null) {
      final File imageFile = File(picked.path);
      final File saved = await saveImageToLocalFolder(imageFile);
      selectedImages.add(saved);
    }
  }

  Future<File> saveImageToLocalFolder(File image) async {
    final dateStr = selectedDate.value.toString().split(" ")[0];
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/records/$dateStr');

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await image.copy('${folder.path}/$fileName');

    return savedImage;
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  List<String> getImagePaths() {
    return selectedImages.map((f) => f.path).toList();
  }


  void saveRecord() async {
    final param = selectedParameter.value;

    if (param == null) {
      Get.snackbar("Missing Data", "স্টেশন ও প্যারামিটার নির্বাচন করুন");
      return;
    }

    if (timeMeasurements.isEmpty) {
      Get.snackbar("ত্রুটি", "অন্তত একটি সময় ও পরিমাপ যোগ করুন");
      return;
    }

    // Validate individual entries
    final seenTimes = <String>{};
    for (var entry in timeMeasurements) {
      final time = entry['time']?.trim() ?? '';
      final measurement = entry['measurement']?.trim() ?? '';

      if (time.isEmpty || measurement.isEmpty) {
        Get.snackbar("অপূর্ণ তথ্য", "সময় এবং পরিমাপ পূরণ করুন");
        return;
      }

      if (seenTimes.contains(time)) {
        Get.snackbar("ডুপ্লিকেট সময়", "একই সময় একাধিকবার দেয়া হয়েছে");
        return;
      }
      seenTimes.add(time);
    }

    // Check for 15-minute gaps
    final parsedTimes = timeMeasurements
        .map((e) => _parseTime(e['time'] ?? ''))
        .whereType<DateTime>()
        .toList()
      ..sort((a, b) => a.compareTo(b)); // Explicit sorting

    print("Parsed times: $parsedTimes"); // Debug print

    for (int i = 1; i < parsedTimes.length; i++) {
      final diff = parsedTimes[i].difference(parsedTimes[i - 1]).inMinutes;
      print("Time difference between ${parsedTimes[i-1]} and ${parsedTimes[i]}: $diff minutes"); // Debug print

      if (diff < 15) {
        Get.snackbar("সময় খুব কাছাকাছি", "প্রতিটি রেকর্ডের মাঝে কমপক্ষে ১৫ মিনিট ব্যবধান রাখুন");
        return;
      }
    }

    final date = "${selectedDate.value.toLocal()}".split(' ')[0];

    final imagePaths = getImagePaths(); // from controller
    if (imagePaths.length > 3) {
      Get.snackbar("ছবির সীমা", "সর্বোচ্চ ৩টি ছবি যুক্ত করা যাবে");
      return;
    }

    // Save each entry with same date and images
    for (var entry in timeMeasurements) {
      final time = entry['time'];
      final measurement = entry['measurement'];

      final newRecord = RecordEntity(
        date: date,
        time: time?? '',
        locationId: stationId,
        locationName: stationTitle,
        parameterId: param.id ?? '',
        parameterName: param.title,
        measurement: measurement ?? '',
        image1Path: imagePaths.isNotEmpty ? imagePaths[0] : '',
        image2Path: imagePaths.length > 1 ? imagePaths[1] : '',
        image3Path: imagePaths.length > 2 ? imagePaths[2] : '',
        isSynced: false,
      );

      await dbService.saveRecord(newRecord);
    }

    Get.snackbar("সফল", "রিপোর্ট সফলভাবে সংরক্ষিত হয়েছে (অফলাইনে)");

    selectedImages.clear();
    timeMeasurements.clear();
    timeMeasurements.add({'time': '', 'measurement': ''}); // Add fresh empty row
    timeMeasurements.refresh();
  }

  /// parse date time from string
  DateTime? _parseTime(String timeStr) {
    try {
      // Clean the string by replacing non-breaking spaces with regular spaces
      final cleanedTimeStr = timeStr.replaceAll(' ', ' ').trim();

      // Try parsing with both 12-hour and 24-hour formats
      final formats = [
        DateFormat.jm(),  // 12-hour format (4:32 PM)
        DateFormat.Hm(),  // 24-hour format (16:32)
      ];

      for (final format in formats) {
        try {
          final time = format.parse(cleanedTimeStr);
          // Combine with selected date
          return DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
            time.hour,
            time.minute,
          );
        } catch (e) {
          // Try next format
          continue;
        }
      }

      // If all formats fail
      print('Failed to parse time: $timeStr');
      return null;
    } catch (e) {
      print('Error parsing time: $e');
      return null;
    }
  }

}
