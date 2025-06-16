import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:water_watch/controller/station_report/station_record_controller.dart';

class HistoryPage extends StatefulWidget {
  final String parameterId;

  const HistoryPage({required this.parameterId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _controller = Get.find<StationRecordController>(); // or your relevant controller
  final _expandedDates = <String>{};

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final grouped = _controller.groupedRecordsByDate;

      return ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((entry) {
          final date = entry.key;
          final records = entry.value;
          final isSynced = records.every((e) => e.isSynced);
          final isExpanded = _expandedDates.contains(date);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                tileColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text(
                  date,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isSynced)
                      Icon(Icons.sync, color: Colors.red, size: 20),
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  ],
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
              if (isExpanded)
                ...records.map((record) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(record.time, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text("${record.measurement} মিমি"),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(record.parameterName),
                      ),
                    ],
                  ),
                ))
            ],
          );
        }).toList(),
      );
    });
  }
}
