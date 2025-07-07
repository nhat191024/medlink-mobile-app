class TimeSlotModel {
  String? time;
  bool? isAvailable;

  TimeSlotModel({this.time, this.isAvailable});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    isAvailable = json['is_available'];
  }

  Map<String, dynamic> toJson() {
    return {'time': time, 'is_available': isAvailable};
  }
}

class DayScheduleModel {
  Map<String, List<TimeSlotModel>>? dailySchedule;

  DayScheduleModel({this.dailySchedule});

  DayScheduleModel.fromJson(Map<String, dynamic> json) {
    dailySchedule = <String, List<TimeSlotModel>>{};

    json.forEach((day, timeSlots) {
      if (timeSlots is List) {
        dailySchedule![day] = timeSlots.map((slot) => TimeSlotModel.fromJson(slot)).toList();
      }
    });
  }

  Map<String, dynamic> toJson() {
    if (dailySchedule == null) return {};

    Map<String, dynamic> data = {};
    dailySchedule!.forEach((day, timeSlots) {
      data[day] = timeSlots.map((slot) => slot.toJson()).toList();
    });
    return data;
  }

  // Helper methods
  List<TimeSlotModel>? getTimeSlotsForDay(String day) {
    return dailySchedule?[day];
  }

  bool isDayAvailable(String day) {
    final timeSlots = getTimeSlotsForDay(day);
    return timeSlots?.any((slot) => slot.isAvailable == true) ?? false;
  }

  List<String> getAvailableDays() {
    if (dailySchedule == null) return [];
    return dailySchedule!.keys.where((day) => isDayAvailable(day)).toList();
  }
}

class WorkScheduleModel {
  Map<String, DayScheduleModel>? monthlySchedule;

  WorkScheduleModel({this.monthlySchedule});

  WorkScheduleModel.fromJson(Map<String, dynamic> json) {
    monthlySchedule = <String, DayScheduleModel>{};

    json.forEach((month, monthData) {
      if (monthData is Map<String, dynamic>) {
        monthlySchedule![month] = DayScheduleModel.fromJson(monthData);
      }
    });
  }

  Map<String, dynamic> toJson() {
    if (monthlySchedule == null) return {};

    Map<String, dynamic> data = {};
    monthlySchedule!.forEach((month, daySchedule) {
      data[month] = daySchedule.toJson();
    });
    return data;
  }

  // Helper methods
  DayScheduleModel? getScheduleForMonth(String month) {
    return monthlySchedule?[month];
  }

  List<String> getAvailableMonths() {
    if (monthlySchedule == null) return [];
    return monthlySchedule!.keys.toList();
  }

  bool isMonthAvailable(String month) {
    final monthSchedule = getScheduleForMonth(month);
    return monthSchedule?.getAvailableDays().isNotEmpty ?? false;
  }

  // Lấy tất cả ngày available trong một tháng
  List<String> getAvailableDaysInMonth(String month) {
    return getScheduleForMonth(month)?.getAvailableDays() ?? [];
  }

  // Lấy time slots cho một ngày cụ thể trong tháng
  List<TimeSlotModel>? getTimeSlotsForDate(String month, String day) {
    return getScheduleForMonth(month)?.getTimeSlotsForDay(day);
  }
}
