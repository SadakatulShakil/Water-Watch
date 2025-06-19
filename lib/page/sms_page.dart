import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_watch/database_helper/entity/local_location_entity.dart';
import 'package:water_watch/database_helper/entity/local_parameter_entity.dart';

import '../controller/dashboard/DashboardController.dart';
import '../controller/sms/sms_controller.dart';

class SmsPage extends StatefulWidget {
  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  final SmsController controller = Get.put(SmsController());

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'এসএমএস পাঠান',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() => SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDropdown(
                        title: "স্টেশন নির্বাচন করুন",
                        value: controller.selectedStation.value?.title ?? '',
                        onTap: () => _showBottomSheet<LocationEntity>(
                          context,
                          dashboardController.locations,
                          controller.selectedStation,
                              (item) => item.title,
                              (item) => item.id,
                        ),
                      ),
                      SizedBox(height: 12),
                      buildDropdown(
                        title: "প্যারামিটার নির্বাচন করুন",
                        value: controller.selectedParameter.value?.title ?? '',
                        onTap: () => _showBottomSheet<ParameterEntity>(
                          context,
                          dashboardController.parameters,
                          controller.selectedParameter,
                              (item) => item.title,
                              (item) => item.id,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("তারিখ নির্বাচন করুন",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("ডিফল্ট আজকের তারিখ দেখায়; গত ৭ দিন পর্যন্ত সামঞ্জস্য করুন।"),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => controller.pickDate(context),
                        child: buildDropdown(
                          title: "তারিখ নির্বাচন করুন",
                          value: "${controller.selectedDate.value.toLocal()}".split(' ')[0],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Dynamic Rows
                      ...List.generate(
                        controller.timeMeasurements.length,
                            (index) {
                          final item = controller.timeMeasurements[index];
                          final isLast =
                              index == controller.timeMeasurements.length - 1;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                // Time Picker
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () => controller
                                        .pickTimeByItem(item, context),
                                    child: buildDropdown(
                                      title: "সময়",
                                      value: item['time'] ?? '',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),

                                // Measurement input
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    onChanged: (v) =>
                                        controller.updateMeasurementByItem(
                                            item, v),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "পরিমাপ (মিমি)",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),

                                // Delete icon (only for last row)
                                isLast
                                    ? Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => controller
                                        .removeTimeMeasurementByItem(
                                        item),
                                    iconSize: 18,
                                    padding: EdgeInsets.zero,
                                  ),
                                )
                                    : Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white60,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.delete,
                                      color: Colors.red.shade100),
                                ),
                                SizedBox(width: 8),

                                // Add icon or check
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isLast
                                        ? Colors.blue.shade900
                                        : Colors.green.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: isLast
                                      ? IconButton(
                                    icon: Icon(Icons.add,
                                        color: Colors.white),
                                    onPressed: () => controller
                                        .addTimeMeasurement(),
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                  )
                                      : Icon(Icons.check,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => controller.saveRecord(),
                          child: Text("এসএমএস পাঠান", style: TextStyle(fontSize: 16, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String title,
    required String value,
    VoidCallback? onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? title : value,
                style: TextStyle(
                  color: value.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet<T>(
      BuildContext context,
      List<T> items,
      Rx<T?> selectedValue,
      String Function(T) getLabel,
      String Function(T) getId, // <-- Add this
      ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: items.map((item) {
            final label = getLabel(item);
            final isSelected = selectedValue.value != null &&
                getId(selectedValue.value as T) == getId(item);

            return ListTile(
              title: Text(label),
              trailing: isSelected
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                selectedValue.value = item;
                Get.back();
              },
            );
          }).toList(),
        );
      },
    );
  }

}
