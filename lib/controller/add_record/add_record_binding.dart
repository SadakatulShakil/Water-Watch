import 'package:get/get.dart';
import 'package:water_watch/controller/add_record/add_record_controller.dart';


class AddRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRecordController>(
          () => AddRecordController(),
    );
  }
}
