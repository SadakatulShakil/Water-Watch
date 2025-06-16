import 'package:get/get.dart';
import 'package:water_watch/database_helper/entity/record_entity.dart';

import '../../database_helper/db_service.dart';
import '../../database_helper/entity/local_parameter_entity.dart';
import '../dashboard/DashboardController.dart';

class StationRecordController extends GetxController {
  final locationData = Get.arguments['item'];
  final stationId = Get.arguments['item'].id ?? "";
  final stationTitle = Get.arguments['item'].title ?? "";
  final dbService = Get.find<DBService>();
  final selectedParameter = Rx<ParameterEntity?>(null);

  final groupedRecordsByDate = <String, List<RecordEntity>>{}.obs;
  final expandedDates = <String>{}.obs;

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

  /// Load all records from DB for this station + selected parameter
  Future<void> loadRecords() async {
    if (selectedParameter.value == null) return;

    final paramId = selectedParameter.value!.id;

    final records = await dbService.loadRecordsByStationAndParameter(
      stationId,
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

  bool isDateSynced(String date) {
    final records = groupedRecordsByDate[date] ?? [];
    return records.every((r) => r.isSynced);
  }
}
