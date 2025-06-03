// dashboard_selection_controller.dart
import 'package:get/get.dart';

class MyRecordController extends GetxController {
  var selectedYear = DateTime.now().year.obs;
  var selectedParameter = "বৃষ্টিপাত".obs;

  List<int> get years => List.generate(27, (index) => 2026 - index);
  List<String> parameters = ["বৃষ্টিপাত", "পানির লেভেল"];

  void selectYear(int year) {
    selectedYear.value = year;
    Get.back();
  }

  void selectParameter(String param) {
    selectedParameter.value = param;
    Get.back();
  }
}
