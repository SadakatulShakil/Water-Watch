import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_watch/controller/station_report/station_record_controller.dart';

import '../database_helper/entity/record_entity.dart';

class HistoryPage extends StatefulWidget {
  final String parameterId;

  const HistoryPage({required this.parameterId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _controller = Get.find<StationRecordController>();
  final _expandedDates = <String>{};

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final grouped = _controller.groupedRecordsByDate;

      if (grouped.isEmpty) {
        return Center(
          child: Text('No records found', style: TextStyle(fontSize: 16)),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children:
            grouped.entries.map((entry) {
              final date = entry.key;
              final records = entry.value;
              final isSynced = records.every((e) => e.isSynced);
              final isExpanded = _expandedDates.contains(date);

              return Card(
                margin: EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        date,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSyncButton(isSynced, date),
                          SizedBox(width: 8),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                          ),
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
                    if (isExpanded) ...[
                      _buildTableHeader(),
                      ...records.map((record) => _buildRecordRow(record, records.indexOf(record), records.length)),
                    ],
                  ],
                ),
              );
            }).toList(),
      );
    });
  }

  Widget _buildSyncButton(bool isSynced, String date) {
    return InkWell(
      onTap:
          () =>
              isSynced
                  ? print('data already synced')
                  : _controller.syncRecords(date),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSynced ? Colors.green.shade50 : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSynced ? Colors.green : Colors.blue,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSynced ? Icons.check_circle : Icons.sync,
              color: isSynced ? Colors.green : Colors.blue,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              isSynced ? 'Synced' : 'Sync Now',
              style: TextStyle(
                color: isSynced ? Colors.green : Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.all(color: Colors.blue),
        color: Colors.blue.shade50,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Measurement',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordRow(RecordEntity record, int index, int totalRecords) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blue),
          top: BorderSide(color: Colors.blue),
          right: BorderSide(color: Colors.blue),
          bottom: BorderSide(
            color: Colors.blue,
            width: index == totalRecords - 1 ? 1.0 : 0.0, // Only show bottom border for last item
          ),
        ),
        borderRadius: index == totalRecords - 1
            ? BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              record.time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${record.measurement} মিমি",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  record.isSynced ? Icons.check_circle : Icons.sync_problem,
                  color: record.isSynced ? Colors.green : Colors.orange,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  record.isSynced ? 'Synced' : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    color: record.isSynced ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
