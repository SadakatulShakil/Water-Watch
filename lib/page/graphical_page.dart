import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/station_report/station_record_controller.dart';

class GraphicalPage extends StatelessWidget {
  final controller = Get.find<StationRecordController>();

  GraphicalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final grouped = controller.groupedRecordsByDate;

      if (grouped.isEmpty) {
        return Center(
          child: Text('No data to display'),
        );
      }

      // Step 1: Compute average per date
      final entries = grouped.entries.toList();
      final List<String> xLabels = [];
      final List<FlSpot> spots = [];

      for (int i = 0; i < entries.length; i++) {
        final date = entries[i].key;
        final records = entries[i].value;
        final avg = records.map((e) => e.measurement).reduce((a, b) => a + b);
        final netAvg = double.parse(avg) / records.length;
        spots.add(FlSpot(i.toDouble(), netAvg));
        xLabels.add(date);
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 6, // Adjust based on your data range
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 0.5,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toStringAsFixed(1), style: TextStyle(fontSize: 12));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < xLabels.length) {
                      final parts = xLabels[index].split('-');
                      final day = DateTime.parse(xLabels[index]).weekday;
                      final dayStr = _weekdayName(day);
                      return Text(dayStr, style: TextStyle(fontSize: 12));
                    }
                    return Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              )
            ],
          ),
        ),
      );
    });
  }

  String _weekdayName(int weekday) {
    switch (weekday) {
      case 1: return "Mon";
      case 2: return "Tue";
      case 3: return "Wed";
      case 4: return "Thu";
      case 5: return "Fri";
      case 6: return "Sat";
      case 7: return "Sun";
      default: return "";
    }
  }
}
