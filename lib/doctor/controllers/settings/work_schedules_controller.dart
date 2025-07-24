import 'package:medlink/utils/app_imports.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TimeSlot {
  RxString startTime;
  RxString endTime;

  TimeSlot({required this.startTime, required this.endTime});
}

class DaySchedule {
  RxBool isActive;
  RxList<TimeSlot> timeSlots;
  RxBool isAllDay;

  DaySchedule({required this.isActive, required this.timeSlots, required this.isAllDay});
}

class WorkSchedulesController extends GetxController {
  final token = StorageService.readData(key: LocalStorageKeys.token);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Map<String, DaySchedule> weeklySchedule = {
    "Monday": DaySchedule(isActive: false.obs, timeSlots: <TimeSlot>[].obs, isAllDay: false.obs),
    "Tuesday": DaySchedule(isActive: false.obs, timeSlots: <TimeSlot>[].obs, isAllDay: false.obs),
    "Wednesday": DaySchedule(isActive: false.obs, timeSlots: <TimeSlot>[].obs, isAllDay: false.obs),
    "Thursday": DaySchedule(isActive: false.obs, timeSlots: <TimeSlot>[].obs, isAllDay: false.obs),
    "Friday": DaySchedule(isActive: false.obs, timeSlots: <TimeSlot>[].obs, isAllDay: false.obs),
    "Saturday": DaySchedule(isActive: false.obs, timeSlots: <TimeSlot>[].obs, isAllDay: false.obs),
    "Sunday": DaySchedule(isActive: false.obs, timeSlots: <TimeSlot>[].obs, isAllDay: false.obs),
  };

  var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  Future<void> fetchData() async {
    isLoading.value = true;
    var response = await get(
      Uri.parse('${Apis.api}work-schedules'),
      headers: {'Authorization': 'Bearer $token'},
    );

    var data = jsonDecode(response.body);

    for (var day in days) {
      if (data.length == 0) break;
      if (data[day] != null) {
        weeklySchedule[day]?.isActive.value = true;
        if (data[day][0]['all_day'] == 1) {
          weeklySchedule[day]?.isAllDay.value = true;
        } else {
          weeklySchedule[day]?.isAllDay.value = false;
          for (var time in data[day]) {
            addTimeSlot(day, time['start_time'], time['end_time']);
          }
        }
      }
    }
    isLoading.value = false;
  }

  Future<void> saveWorkSchedule() async {
    Map<String, dynamic> workSchedule = {};
    for (var day in days) {
      if (weeklySchedule[day]?.isActive.value == true) {
        List<Map<String, dynamic>> timeSlots = [];
        if (weeklySchedule[day]!.timeSlots.isEmpty) {
          if (weeklySchedule[day]!.isAllDay.value == true) {
            timeSlots.add({'start_time': null, 'end_time': null, 'all_day': true});
            workSchedule[day] = timeSlots;
            continue;
          } else {
            Get.snackbar(
              'error'.tr,
              '${"work_schedule_error_1".tr} $day ${"work_schedule_error_2".tr}',
              colorText: AppColors.errorMain,
              backgroundColor: AppColors.white,
            );
            return;
          }
        }
        for (var timeSlot in weeklySchedule[day]!.timeSlots) {
          if (timeSlot.startTime.value == 'From' || timeSlot.endTime.value == 'To') {
            Get.snackbar(
              'error'.tr,
              '${'work_schedule_error_3'.tr} $day',
              colorText: AppColors.errorMain,
              backgroundColor: AppColors.white,
            );
            return;
          }
          timeSlots.add({
            'start_time': timeSlot.startTime.value,
            'end_time': timeSlot.endTime.value,
            'all_day': false,
          });
          workSchedule[day] = timeSlots;
        }
      }
    }

    isLoading.value = true;
    final uri = Uri.parse('${Apis.api}work-schedules/add');
    final response = http.MultipartRequest("POST", uri);
    response.headers['Authorization'] = 'Bearer $token';
    response.headers['Accept'] = 'application/json';
    response.headers['Content-Type'] = 'application/json';

    response.fields['work_schedule'] = jsonEncode(workSchedule);

    debugPrint(jsonEncode(workSchedule));

    var streamedResponse = await response.send();
    var responseBody = await streamedResponse.stream.bytesToString();
    var json = jsonDecode(responseBody);

    if (streamedResponse.statusCode == 201) {
      Get.back();
      Get.snackbar(
        'success'.tr,
        'work_schedule_save_success'.tr,
        colorText: AppColors.successMain,
        backgroundColor: AppColors.white,
      );
    } else {
      debugPrint('Error saving work schedule: ${json['message']}');
      Get.snackbar(
        'error'.tr,
        'work_schedule_save_error'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
    }
    isLoading.value = false;
  }

  void addTimeSlot(String day, String startTime, String endTime) {
    weeklySchedule[day]?.timeSlots.add(TimeSlot(startTime: startTime.obs, endTime: endTime.obs));
  }

  void removeTimeSlot(String day, int index) {
    weeklySchedule[day]?.timeSlots.removeAt(index);
  }

  void removeAllTimeSlotInDay(String day) {
    weeklySchedule[day]?.timeSlots.clear();
  }

  void toggleAllDay(String day, bool value) {
    final daySchedule = weeklySchedule[day];
    if (daySchedule != null) {
      daySchedule.isAllDay.value = value;
      if (value) {
        daySchedule.timeSlots.clear();
      }
    }
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat('HH:mm:ss');
    return format.format(dt);
  }

  bool isEndTimeValid(String startTime, String endTime) {
    final format = DateFormat('HH:mm:ss');
    final start = format.parse(startTime);
    final end = format.parse(endTime);
    return end.isAfter(start);
  }
}
