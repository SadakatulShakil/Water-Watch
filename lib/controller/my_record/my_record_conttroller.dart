// dashboard_selection_controller.dart
import 'package:get/get.dart';

import '../../database_helper/db_service.dart';
import '../../database_helper/entity/local_parameter_entity.dart';
import '../../database_helper/entity/record_entity.dart';
import '../dashboard/DashboardController.dart';

class MyRecordController extends GetxController {
  var selectedYear = DateTime.now().year.obs;
  final selectedParameter = Rx<ParameterEntity?>(null);
  final dbService = Get.find<DBService>();
  List<int> get years => List.generate(27, (index) => 2026 - index);

  final groupedRecordsByDate = <String, List<RecordEntity>>{}.obs;
  final expandedDates = <String>{}.obs;

  void selectYear(int year) {
    selectedYear.value = year;
    loadRecords();
    Get.back();
  }

  @override
  void onInit() {
    final dashboard = Get.find<DashboardController>();
    if (dashboard.parameters.isNotEmpty) {
      selectedParameter.value = dashboard.parameters.first;
    }

    if (selectedParameter.value != null) {
      loadRecords(); // Load initially
    }

    ever(selectedParameter, (_) {
      loadRecords(); // Reload when parameter changes
    });

    super.onInit();
  }

  /// Load all records from DB for the year + selected parameter
  Future<void> loadRecords() async {
    if (selectedParameter.value == null) return;

    final year = selectedYear.value.toString();
    final paramId = selectedParameter.value!.id;

    final records = await dbService.loadRecordsByDateAndParam(
      year,
      paramId,
    );

    final Map<String, List<RecordEntity>> grouped = {};

    for (var record in records) {
      grouped.putIfAbsent(record.date, () => []).add(record);
    }

    groupedRecordsByDate.value = grouped;
  }

  void toggleExpand(String date) {
    if (expandedDates.contains(date)) {
      expandedDates.remove(date);
    } else {
      expandedDates.add(date);
    }
  }

  bool isDateExpanded(String date) => expandedDates.contains(date);

}
