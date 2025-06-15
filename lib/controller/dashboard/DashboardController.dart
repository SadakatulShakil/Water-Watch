import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:water_watch/models/parameter_model.dart';

import '../../models/location_model.dart';
import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';

class DashboardController extends GetxController {

  final userService = UserPrefService();

  var initTime = "Good Morning".obs;
  late var fullname = "".obs;
  late var mobile = "".obs;
  late var email = "".obs;
  late var photo = "".obs;

  //weather
  var currentLocationId = "".obs;
  var currentLocationName = "".obs;
  dynamic forecast = [].obs;
  dynamic notification = [].obs;
  var notificationValue = "".obs;
  var cLocationUpazila = "".obs;
  var cLocationDistrict = "".obs;
  var isForecastLoading = false.obs;
  var locations = <LocationModel>[].obs;
  var parameters = <ParameterModel>[].obs;
  //final dbService = Get.find<DBService>();

  @override
  void onInit() {
    getTime();
    getSharedPrefData();
  }

  Future onRefresh() async {
    await getTime();
    await getSharedPrefData();
  }

  getTime() {
    var currentHour = DateTime.timestamp();
    var hour = int.parse(currentHour.toString().substring(11, 13)) + 6;
    if(hour > 23) {
      hour = hour - 23;
    }
    if (hour >= 5 && hour < 12) {
      initTime.value = "dashboard_time_good_morning".tr;
    } else if (hour >= 12 && hour < 15) {
      initTime.value = "dashboard_time_good_noon".tr;
    } else if (hour >= 15 && hour < 17) {
      initTime.value = "dashboard_time_good_afternoon".tr;
    } else if (hour >= 17 && hour < 19) {
      initTime.value = "dashboard_time_good_evening".tr;
    } else {
      initTime.value = "dashboard_time_good_night".tr;
    }
  }

  Future getSharedPrefData() async {
    //await dbService.fetchAndSaveMasterQuestions();
    currentLocationId.value = userService.locationId ?? '';
    fullname.value = userService.userName ?? '';
    mobile.value = userService.userMobile ?? '';
    email.value = userService.userEmail ?? '';
    currentLocationName.value = userService.locationName ?? '';
    cLocationDistrict.value = userService.locationDistrict ?? '';
    cLocationUpazila.value = userService.locationUpazila ?? '';
    // type.value = userService.userType ?? '';

    if (userService.userPhoto != null && userService.userPhoto!.startsWith("https://landslide.bdservers.site/")) {
      // Case 1: Already a full URL, use it as is.
      photo.value = userService.userPhoto!;
    } else if (userService.userPhoto != null && userService.userPhoto!.startsWith("/assets/auth/")) {
      // Case 2: User photo starts with "/assets/auth/", prepend base URL
      photo.value = "${ApiURL.base_url_image}${userService.userPhoto!}";
    } else if (userService.userPhoto != null && !userService.userPhoto!.contains("/assets/auth/")) {
      // Case 3: Only contains image name like "image.png", add "/assets/auth/" and base URL
      photo.value = "${ApiURL.base_url_image}/assets/auth/${userService.userPhoto!}";
    } else {
      // Case 4: Handle null or empty userPhoto (fallback)
      photo.value = "${ApiURL.base_url_image}/assets/auth/default.png"; // Use default image
    }

    fetchLocations();
    fetchParameters();
    print("Current Location ID: ${currentLocationId.value}");

  }

  void fetchLocations() async {

    locations.value = [
      LocationModel(
        id: '1',
        title: 'শেরপুর - সিলেট',
        subtitle: 'তথ্য দেখুন ও যুক্ত করুন'
      ),
      LocationModel(
          id: '2',
          title: 'সুনামগঞ্জ',
          subtitle: 'তথ্য দেখুন ও যুক্ত করুন'
      ),
      LocationModel(
          id: '3',
          title: 'হবিগঞ্জ',
          subtitle: 'তথ্য দেখুন ও যুক্ত করুন'
      ),
      LocationModel(
          id: '4',
          title: 'মৌলভীবাজার',
          subtitle: 'তথ্য দেখুন ও যুক্ত করুন'
      ),

    ];

  }

  void fetchParameters() async {

    parameters.value = [
      ParameterModel(
          id: '1',
          title: 'বৃষ্টিপাত',
      ),
      ParameterModel(
          id: '2',
          title: 'পানির স্তর',
      ),
    ];

  }


}