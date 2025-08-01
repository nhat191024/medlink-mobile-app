import 'package:intl/intl.dart';
import 'package:medlink/utils/app_imports.dart';
import 'package:http/http.dart' as http;

import 'package:medlink/doctor/controllers/home_controller.dart';
import 'package:medlink/model/appointment_model.dart';

import 'package:medlink/components/widget/appointments/doctor/history_appointment_detail.dart';
import 'package:medlink/components/widget/appointments/doctor/upcoming_appointment_detail.dart';
import 'package:medlink/components/widget/appointments/doctor/blur_dialog.dart';

import 'package:medlink/components/widget/appointments/accpeted_appointment.dart';

class DoctorMyAppointmentsControllers extends GetxController
    with GetSingleTickerProviderStateMixin {
  final homeController = Get.find<DoctorHomeController>();
  final token = StorageService.readData(key: LocalStorageKeys.token);

  final RxList<AppointmentModel> newAppointments = <AppointmentModel>[].obs;
  final RxList<AppointmentModel> upcomingAppointments = <AppointmentModel>[].obs;
  final RxList<AppointmentModel> historyAppointments = <AppointmentModel>[].obs;
  final RxList<AppointmentModel> suggestions = <AppointmentModel>[].obs;

  final RxBool isLoading = true.obs;

  final RxInt newQuantity = 0.obs;
  final RxInt upcomingQuantity = 0.obs;
  final RxInt historyQuantity = 0.obs;
  final TextEditingController rejectReason = TextEditingController();
  final RxBool rejectError = false.obs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxBool isSearching = false.obs;
  final RxBool showSuggestions = false.obs;

  late TabController tabController;

  final Rx<DateTime> currentTime = DateTime.now().obs;
  late Timer _timer;

  RxString selectedHistoryAppointmentId = "".obs;
  RxString selectedUpcomingAppointmentId = "".obs;

  RefreshController refreshController = RefreshController(initialRefresh: false);

  //=================
  //LIFECYCLE METHODS
  //=================
  @override
  void onInit() {
    super.onInit();
    fetchData();
    tabController = TabController(length: 3, vsync: this);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      currentTime.value = DateTime.now();
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    tabController.dispose();
    refreshController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onRefresh() {
    fetchData();
    refreshController.refreshCompleted();
  }

  void onLoadMore() async {
    fetchData();
    refreshController.loadComplete();
  }

  //=================
  //DATA METHODS
  //=================
  Future<void> fetchData() async {
    isLoading.value = true;
    var response = await get(
      Uri.parse('${Apis.api}appointments/doctor'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      newAppointments.clear();
      for (var newAppointment in data['newAppointments']) {
        newAppointments.add(
          AppointmentModel.fromApiJson(newAppointment, data['officeAddress'] ?? '', formatDateTime),
        );
      }
      newQuantity.value = newAppointments.length;

      upcomingAppointments.clear();
      for (var upcomingAppointment in data['upcomingAppointments']) {
        upcomingAppointments.add(
          AppointmentModel.fromApiJson(
            upcomingAppointment,
            data['officeAddress'] ?? '',
            formatDateTime,
          ),
        );
      }
      upcomingQuantity.value = upcomingAppointments.length;

      historyAppointments.clear();
      for (var historyAppointment in data['historyAppointments']) {
        historyAppointments.add(
          AppointmentModel.fromApiJson(
            historyAppointment,
            data['officeAddress'] ?? '',
            formatDateTime,
          ),
        );
      }
      historyQuantity.value = historyAppointments.length;
    }
    isLoading.value = false;
  }

  //=================
  //APPOINTMENT ACTION METHODS
  //=================
  Future<void> acceptRejectAppointment(
    AppointmentModel appointment,
    int index,
    String status,
    bool isUpcoming,
  ) async {
    final uri = Uri.parse('${Apis.api}appointments/status');
    final request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..headers['Content-Type'] = 'application/json';

    Map<String, String> fields = {'appointment_id': appointment.id, 'status': status};

    if (status.contains('rejected') || status.contains('cancelled')) {
      fields['reason'] = rejectReason.text;
    }

    request.fields.addAll(fields);

    for (final field in request.fields.entries) {
      debugPrint('${field.key}: ${field.value}');
    }

    var streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      switch (status) {
        case 'upcoming':
          debugPrint('upcoming appointment accepted');
          homeController.booking.value--;
          homeController.upcoming.value++;
          upcomingAppointments.add(appointment.copyWith(status: 'upcoming'));
          upcomingQuantity.value++;
          newAppointments.removeAt(index);
          newQuantity.value--;
          Get.bottomSheet(
            AcceptedAppointment(
              appointment: appointment,
              formatDate: formatDate,
              checkIfDefaultAvatar: checkIfDefaultAvatar,
            ),
            isScrollControlled: true,
          );
          break;
        case 'rejected':
          debugPrint('appointment rejected');
          homeController.booking.value--;
          historyAppointments.add(appointment.copyWith(status: status, reason: rejectReason.text));
          historyQuantity.value++;
          newAppointments.removeAt(index);
          newQuantity.value--;
          Get.back();
          Get.snackbar(
            'success'.tr,
            'appointment_rejected'.tr,
            backgroundColor: AppColors.white,
            colorText: AppColors.successMain,
          );
          rejectReason.text = "";
          break;
        case 'cancelled':
          debugPrint('appointment cancelled');
          homeController.upcoming.value--;
          historyAppointments.add(appointment.copyWith(status: status, reason: rejectReason.text));
          upcomingAppointments.removeAt(index);
          historyQuantity.value++;
          upcomingQuantity.value--;
          Get.back();
          Get.snackbar(
            'success'.tr,
            'appointment_cancelled'.tr,
            backgroundColor: AppColors.successMain,
            colorText: AppColors.white,
          );
          rejectReason.text = "";
          break;
        case 'completed':
          debugPrint('appointment completed');
          historyAppointments.add(appointment.copyWith(status: status));
          historyAppointments.removeAt(index);
          Get.back();
          Get.snackbar(
            'success'.tr,
            'appointment_completed'.tr,
            backgroundColor: AppColors.successMain,
            colorText: AppColors.white,
          );
          break;
        default:
          Get.snackbar(
            'error'.tr,
            'unknown_status_error'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.errorLight,
            colorText: AppColors.white,
          );
      }
    } else {
      debugPrint('Error: ${streamedResponse.statusCode}');
      var json = await streamedResponse.stream.bytesToString();
      debugPrint('Response: $json');
    }
  }

  //=================
  //UTILITY METHODS
  //=================
  String formatDateTime(String date, String dayOfWeek) {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(parsedDate);
    formattedDate = formattedDate.replaceFirst(DateFormat('EEEE').format(parsedDate), dayOfWeek);

    return formattedDate;
  }

  bool isTime(String timeRange, String dateString) {
    String startTimeString = timeRange.split(" - ")[0];
    DateFormat timeFormat = DateFormat.jm();
    DateTime startTime = timeFormat.parse(startTimeString);

    DateFormat dateFormat = DateFormat('EEEE, dd MMMM yyyy');
    DateTime date = dateFormat.parse(dateString);

    DateTime now = DateTime.now();
    DateTime currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    DateTime startDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );

    if (currentTime.isAtSameMomentAs(startDateTime)) {
      return true;
    } else {
      return false;
    }
  }

  double hoursUntilAppointment(AppointmentModel appointment) {
    DateTime appointmentDateTime = parseDateTime(appointment.date, appointment.time);
    Duration difference = appointmentDateTime.difference(currentTime.value);
    return difference.inMinutes / 60;
  }

  DateTime parseDateTime(String date, String time) {
    DateTime parsedDate = DateFormat('EEEE, dd MMMM yyyy').parse(date);
    DateTime parsedTime = DateFormat('hh:mm a').parse(time.split(' - ')[0]);
    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
  }

  String formatDate(String date) {
    DateTime parsedDate = DateFormat('EEEE, dd MMMM yyyy').parse(date);
    String formattedDate = DateFormat('EEE, dd, MMM yyyy').format(parsedDate);
    return formattedDate;
  }

  bool checkIfDefaultAvatar(String avatar) {
    avatar = avatar.split('/').last;
    if (avatar.contains('default.png')) {
      return true;
    } else {
      return false;
    }
  }

  void openCalendar() async {
    final Uri url = Uri.parse('content://com.android.calendar/time/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        'error'.tr,
        'cannot_open_calendar'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorLight,
        colorText: AppColors.white,
      );
    }
  }

  String formatPrice(int price) {
    final formatted = NumberFormat('#,##0', 'en_US').format(price);
    return '$formatted ${"currency".tr}';
  }

  //=================
  //SEARCH METHODS
  //=================
  void appointmentFilter(String query) {
    if (query.isNotEmpty) {
      List<AppointmentModel> sourceList;
      switch (tabController.index) {
        case 0:
          sourceList = newAppointments;
          break;
        case 1:
          sourceList = upcomingAppointments;
          break;
        case 2:
          sourceList = historyAppointments;
          break;
        default:
          sourceList = [];
      }

      List<AppointmentModel> filteredList = sourceList.where((element) {
        return element.patientName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      Set<String> seenNames = {};
      List<AppointmentModel> uniqueList = [];

      for (var appointment in filteredList) {
        String name = appointment.patientName.toLowerCase();
        if (!seenNames.contains(name)) {
          seenNames.add(name);
          uniqueList.add(appointment);
        }
      }

      suggestions.value = uniqueList;

      switch (tabController.index) {
        case 0:
          newAppointments.value = filteredList;
          break;
        case 1:
          upcomingAppointments.value = filteredList;
          break;
        case 2:
          historyAppointments.value = filteredList;
          break;
      }
    } else {
      suggestions.clear();
      if (isSearching.value) fetchData();
    }
  }

  //=================
  //DIALOG METHODS
  //=================
  void showBlurDialog(
    BuildContext context,
    AppointmentModel appointment,
    int index,
    String status,
    bool isUpcoming,
    bool isReject,
  ) {
    BlurDialog.show(
      context,
      appointment,
      index,
      status,
      isUpcoming,
      isReject,
      acceptRejectAppointment,
      rejectReason,
      rejectError,
    );
  }

  Future buildHistoryAppointmentDetail(
    BuildContext context,
    AppointmentModel appointment,
    int index,
  ) {
    return Get.bottomSheet(
      HistoryAppointmentDetail(
        appointment: appointment,
        index: index,
        formatDate: formatDate,
        checkIfDefaultAvatar: checkIfDefaultAvatar,
        formatPrice: formatPrice,
        acceptRejectAppointment: acceptRejectAppointment,
      ),
      isScrollControlled: true,
    );
  }

  Future buildUpcomingAppointmentDetail(
    BuildContext context,
    AppointmentModel appointment,
    int index,
  ) {
    return Get.bottomSheet(
      UpcomingAppointmentDetail(
        appointment: appointment,
        index: index,
        formatDate: formatDate,
        checkIfDefaultAvatar: checkIfDefaultAvatar,
        hoursUntilAppointment: hoursUntilAppointment,
        formatPrice: formatPrice,
        showBlurDialog: showBlurDialog,
      ),
      isScrollControlled: true,
    );
  }
}
