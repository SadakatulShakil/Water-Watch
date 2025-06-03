import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/sms/sms_controller.dart';

class SmsPage extends StatelessWidget {
  final SmsController controller = Get.put(SmsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background1.jpg', // Your background image here
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text('এসএমএস পাঠান',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                Obx(() => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildDropdown(
                          title: "স্টেশন নির্বাচন করুন",
                          value: controller.selectedStation.value,
                          onTap: () => _showBottomSheet(
                            context,
                            ["স্টেশন ১", "স্টেশন ২"],
                            controller.selectedStation,
                          ),
                        ),
                        SizedBox(height: 12),
                        buildDropdown(
                          title: "প্যারামিটার নির্বাচন করুন",
                          value: controller.selectedParameter.value,
                          onTap: () => _showBottomSheet(
                            context,
                            ["বৃষ্টিপাত", "পানি স্তর"],
                            controller.selectedParameter,
                          ),
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("তারিখ নির্বাচন করুন",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
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
                        ...List.generate(
                          controller.timeMeasurements.length,
                              (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Time Field
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () => controller.pickTime(index, context),
                                      child: buildDropdown(
                                        title: "সময়",
                                        value: controller.timeMeasurements[index]['time']!,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                  // Measurement Field
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      onChanged: (v) => controller.updateMeasurement(index, v),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "পরিমাপ (মিমি)",
                                        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                  // Delete Button
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => controller.removeTimeMeasurement(index),
                                      iconSize: 18,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                  // Add Button (only for the last item)
                                  (index == controller.timeMeasurements.length - 1)?
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade900,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.add, color: Colors.white),
                                        onPressed: controller.addTimeMeasurement,
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ):
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.check, color: Colors.white),
                                      onPressed: controller.addTimeMeasurement,
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                    ),
                                  )
                                ],
                              ),
                              ),
                        ),

                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {sendSms();},
                          child: Text("এসএমএস পাঠান", style: TextStyle(color: Colors.white, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget buildDropdown({required String title, required String value, VoidCallback? onTap}) {
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

  void _showBottomSheet(BuildContext context, List<String> items, RxString selectedValue) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            return ListTile(
              title: Text(item),
              trailing: selectedValue.value == item
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

  void sendSms() {
    final SmsController controller = Get.find<SmsController>();
    final String phoneNumber = "01751330394";

    final String date = controller.selectedDate.toString(); // Format: dd/MM/yyyy
    final String report = controller.timeMeasurements.map((entry) {
      final time = entry['time'];
      final measurement = entry['measurement'];
      return "$time: ${controller.selectedParameter} - $measurement মিমি";
    }).join("; ");

    final String message = "তারিখ: $date; রিপোর্ট: $report";

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': message,
      },
    );

    launchUrl(smsUri);
  }

}
