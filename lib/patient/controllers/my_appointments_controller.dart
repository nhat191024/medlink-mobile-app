import 'package:intl/intl.dart';
import 'package:medlink/utils/app_imports.dart';
import 'package:http/http.dart' as http;

import 'package:medlink/model/patient_appointment_model.dart';

import 'package:medlink/components/widget/appointments/patient/history_appointment_detail.dart';
import 'package:medlink/components/widget/appointments/patient/upcoming_appointment_detail.dart';
import 'package:medlink/components/widget/appointments/patient/blur_dialog.dart';
import 'package:medlink/components/widget/appointments/patient/review_modal.dart';
import 'package:medlink/components/widget/appointments/support_modal.dart';

class PatientMyAppointmentsControllers extends GetxController
    with GetSingleTickerProviderStateMixin {
  var token = StorageService.readData(key: LocalStorageKeys.token);
  late TabController patientMyAppointmentsTabController;

  final RxList<PatientAppointmentModel> upcomingAppointments = <PatientAppointmentModel>[].obs;
  final RxList<PatientAppointmentModel> historyAppointments = <PatientAppointmentModel>[].obs;
  final RxList<PatientAppointmentModel> suggestions = <PatientAppointmentModel>[].obs;

  // Store original data để có thể restore khi clear search
  List<PatientAppointmentModel> _originalUpcomingAppointments = [];
  List<PatientAppointmentModel> _originalHistoryAppointments = [];

  final RxBool isLoading = true.obs;

  final RxInt upcomingQuantity = 0.obs;
  final RxInt historyQuantity = 0.obs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxBool isSearching = false.obs;
  final RxBool showSuggestions = false.obs;

  // Debounce và Cache variables
  Timer? _debounceTimer;
  final Map<String, List<PatientAppointmentModel>> _searchCache = {};
  final Map<String, List<PatientAppointmentModel>> _suggestionsCache = {};
  final RxBool isFilterLoading = false.obs;
  String _lastQuery = '';

  final Rx<DateTime> currentTime = DateTime.now().obs;
  late Timer _timer;

  final TextEditingController rejectReason = TextEditingController();
  final RxBool rejectError = false.obs;

  final TextEditingController feedback = TextEditingController();
  final RxBool isFeedbackError = false.obs;
  final RxBool isRecommend = true.obs;
  final RxDouble rating = 1.0.obs;

  final TextEditingController supportMessage = TextEditingController();
  final RxBool isSupportMessageError = false.obs;

  RefreshController refreshController = RefreshController(initialRefresh: false);

  //============================================================================
  // LIFECYCLE METHODS
  //============================================================================
  @override
  void onInit() {
    super.onInit();
    patientMyAppointmentsTabController = TabController(length: 2, vsync: this);
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      currentTime.value = DateTime.now();
    });
  }

  @override
  void onClose() {
    patientMyAppointmentsTabController.dispose();
    _timer.cancel();
    _debounceTimer?.cancel();
    refreshController.dispose();
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

  //============================================================================
  //DATA METHODS
  //============================================================================
  Future<void> fetchData() async {
    isLoading.value = true;
    var response = await get(
      Uri.parse('${Apis.api}appointments/patient'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      upcomingAppointments.clear();
      for (var upcomingAppointment in data['upcomingAppointments']) {
        upcomingAppointments.add(
          PatientAppointmentModel.fromApiJson(upcomingAppointment, formatDateTime),
        );
      }
      // Store original data for restore functionality
      _originalUpcomingAppointments = List<PatientAppointmentModel>.from(upcomingAppointments);
      upcomingQuantity.value = upcomingAppointments.length;

      historyAppointments.clear();
      for (var historyAppointment in data['historyAppointments']) {
        historyAppointments.add(
          PatientAppointmentModel.fromApiJson(historyAppointment, formatDateTime),
        );
      }
      // Store original data for restore functionality
      _originalHistoryAppointments = List<PatientAppointmentModel>.from(historyAppointments);
      historyQuantity.value = historyAppointments.length;
      isLoading.value = false;

      // Clear search cache when data is updated
      _clearSearchCache();
    } else {
      debugPrint('Error fetching appointments: ${response.statusCode}');
    }
  }

  //============================================================================
  //APPOINTMENT ACTION METHODS
  //============================================================================
  Future<void> acceptRejectAppointment(
    PatientAppointmentModel appointment,
    int index,
    String status,
  ) async {
    final uri = Uri.parse('${Apis.api}appointments/status');
    final response = http.MultipartRequest("POST", uri);
    response.headers['Authorization'] = 'Bearer $token';
    response.headers['Accept'] = 'application/json';
    response.headers['Content-Type'] = 'application/json';

    response.fields.addAll({
      'appointment_id': appointment.id,
      'status': status,
      'reason': rejectReason.text,
    });

    // debugPrint(
    //   'Accept/Reject appointment: ${appointment.id}, Status: $status, Reason: ${rejectReason.text}',
    // );

    var streamedResponse = await response.send();

    if (streamedResponse.statusCode == 200) {
      historyAppointments.add(appointment.copyWith(status: status, reason: rejectReason.text));

      upcomingQuantity.value = upcomingQuantity.value - 1;
      upcomingAppointments.removeAt(index);

      historyQuantity.value = historyQuantity.value + 1;
      rejectReason.text = "";

      Get.back();
      Get.snackbar(
        'success'.tr,
        'appointment_status_updated'.tr,
        backgroundColor: AppColors.successMain,
        colorText: AppColors.white,
      );
    } else {
      debugPrint('Error updating appointment status: ${streamedResponse.statusCode}');
      debugPrint('Response body: ${await streamedResponse.stream.bytesToString()}');
    }
  }

  Future<void> reviewAppointment(String id) async {
    final uri = Uri.parse('${Apis.api}appointments/review');
    final response = http.MultipartRequest("POST", uri);
    response.headers['Authorization'] = 'Bearer $token';
    response.headers['Accept'] = 'application/json';
    response.headers['Content-Type'] = 'application/json';

    response.fields.addAll({
      'appointment_id': id,
      'review': feedback.text,
      'rating': rating.value.toInt().toString(),
      'recommend': isRecommend.value.toString(),
    });

    var streamedResponse = await response.send();

    if (streamedResponse.statusCode == 201) {
      clearFeedback();
      Get.back();
      Get.snackbar(
        'success'.tr,
        'review_submitted'.tr,
        backgroundColor: AppColors.successMain,
        colorText: AppColors.white,
      );
    } else {
      debugPrint('Error submitting review: ${streamedResponse.statusCode}');
      debugPrint('Response body: ${await streamedResponse.stream.bytesToString()}');
      isFeedbackError.value = true;
    }
  }

  Future<void> sendSupportMessage(String id) async {
    final uri = Uri.parse('${Apis.api}support/add');
    final response = http.MultipartRequest("POST", uri);
    response.headers['Authorization'] = 'Bearer $token';
    response.headers['Accept'] = 'application/json';
    response.headers['Content-Type'] = 'application/json';

    response.fields.addAll({'appointment_id': id, 'message': supportMessage.text});

    var streamedResponse = await response.send();

    if (streamedResponse.statusCode == 201) {
      clearSupport();
      Get.back();
      Get.snackbar(
        'success'.tr,
        'support_sent_successfully'.tr,
        backgroundColor: AppColors.successMain,
        colorText: AppColors.white,
      );
    } else {
      debugPrint('Error submitting review: ${streamedResponse.statusCode}');
      debugPrint('Response body: ${await streamedResponse.stream.bytesToString()}');
      isFeedbackError.value = true;
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

  void appointmentFilter(String query) {
    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      suggestions.clear();
      isFilterLoading.value = false;
      if (isSearching.value) {
        // Restore original data when clearing search
        _restoreOriginalData();
      }
      return;
    }

    // Debounce: Delay search for 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void _restoreOriginalData() {
    // Restore original data without refetching from API
    final currentTabIndex = patientMyAppointmentsTabController.index;
    _updateFilteredListByTab(currentTabIndex, _getOriginalListByTab(currentTabIndex));
  }

  List<PatientAppointmentModel> _getOriginalListByTab(int tabIndex) {
    // Return the original unfiltered data
    switch (tabIndex) {
      case 0:
        return _originalUpcomingAppointments;
      case 1:
        return _originalHistoryAppointments;
      default:
        return [];
    }
  }

  Future<void> _performSearch(String query) async {
    if (query == _lastQuery) return; // Prevent duplicate searches

    _lastQuery = query;
    isFilterLoading.value = true;

    try {
      final currentTabIndex = patientMyAppointmentsTabController.index;
      final cacheKey = '${currentTabIndex}_$query';

      // Check cache first
      if (_searchCache.containsKey(cacheKey) && _suggestionsCache.containsKey(cacheKey)) {
        _applyCachedResults(currentTabIndex, cacheKey);
        return;
      }

      // Perform async filtering
      final results = await _performAsyncFilter(query, currentTabIndex);

      // Cache results
      _searchCache[cacheKey] = results.filteredList;
      _suggestionsCache[cacheKey] = results.suggestions;

      // Apply results if query hasn't changed
      if (query == _lastQuery) {
        _applyFilterResults(currentTabIndex, results.filteredList, results.suggestions);
      }
    } catch (e) {
      debugPrint('Error during search: $e');
    } finally {
      isFilterLoading.value = false;
    }
  }

  Future<SearchResult> _performAsyncFilter(String query, int tabIndex) async {
    // Sử dụng Future.microtask thay vì compute để tránh serialization issues
    return await Future.microtask(() {
      final sourceList = _getSourceListByTab(tabIndex);
      return _filterAppointments(FilterParams(sourceList: sourceList, query: query.toLowerCase()));
    });
  }

  void _applyCachedResults(int tabIndex, String cacheKey) {
    final filteredList = _searchCache[cacheKey]!;
    final suggestionsList = _suggestionsCache[cacheKey]!;

    _applyFilterResults(tabIndex, filteredList, suggestionsList);
    isFilterLoading.value = false;
  }

  void _applyFilterResults(
    int tabIndex,
    List<PatientAppointmentModel> filteredList,
    List<PatientAppointmentModel> suggestionsList,
  ) {
    suggestions.value = suggestionsList;
    _updateFilteredListByTab(tabIndex, filteredList);
  }

  void _clearSearchCache() {
    _searchCache.clear();
    _suggestionsCache.clear();
    _lastQuery = '';
  }

  List<PatientAppointmentModel> _getSourceListByTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return upcomingAppointments;
      case 1:
        return historyAppointments;
      default:
        return [];
    }
  }

  void _updateFilteredListByTab(int tabIndex, List<PatientAppointmentModel> filteredList) {
    switch (tabIndex) {
      case 0:
        upcomingAppointments.value = filteredList;
        break;
      case 1:
        historyAppointments.value = filteredList;
        break;
    }
  }

  //============================================================================
  //APPOINTMENT DETAIL METHODS
  //============================================================================

  Future buildHistoryAppointmentDetail(BuildContext context, PatientAppointmentModel appointment) {
    return Get.bottomSheet(
      HistoryAppointmentDetail(
        appointment: appointment,
        formatDate: formatDate,
        formatPrice: formatPrice,
        checkIfDefaultAvatar: checkIfDefaultAvatar,
        buildReviewModal: buildReviewModal,
        buildSupportModal: buildSupportModal,
      ),
      isScrollControlled: true,
    );
  }

  Future buildUpcomingAppointmentDetail(
    BuildContext context,
    PatientAppointmentModel appointment,
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

  Future buildReviewModal(
    BuildContext context,
    String appointmentId,
    String name,
    String avatar,
    String speciality,
  ) {
    return Get.bottomSheet(
      ReviewModal(
        appointmentId: appointmentId,
        name: name,
        avatar: avatar,
        speciality: speciality,
        feedback: feedback,
        isFeedbackError: isFeedbackError,
        isRecommend: isRecommend,
        rating: rating,
        clearFeedback: clearFeedback,
        reviewAppointment: reviewAppointment,
      ),
      isScrollControlled: true,
    );
  }

  Future buildSupportModal(BuildContext context, String appointmentId, String name, String avatar) {
    return Get.bottomSheet(
      SupportModal(
        appointmentId: appointmentId,
        name: name,
        avatar: avatar,
        supportMessage: supportMessage,
        isSupportMessageError: isSupportMessageError,
        clearSupport: clearSupport,
        sendSupportMessage: sendSupportMessage,
      ),
      isScrollControlled: true,
    );
  }

  void showBlurDialog(
    BuildContext context,
    PatientAppointmentModel appointment,
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

  //============================================================================
  // HELPER METHODS
  //============================================================================
  void clearSearch() {
    searchController.clear();
    _clearSearchCache();
    suggestions.clear();
    _debounceTimer?.cancel();
    isFilterLoading.value = false;

    // Restore original data
    upcomingAppointments.value = List<PatientAppointmentModel>.from(_originalUpcomingAppointments);
    historyAppointments.value = List<PatientAppointmentModel>.from(_originalHistoryAppointments);
  }

  void clearFeedback() {
    feedback.clear();
    isFeedbackError.value = false;
    rating.value = 0;
    isRecommend.value = true;
  }

  void clearSupport() {
    supportMessage.clear();
    isSupportMessageError.value = false;
  }

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

  double hoursUntilAppointment(PatientAppointmentModel appointment) {
    DateTime appointmentDateTime = parseDateTime(appointment.date, appointment.time);
    Duration difference = appointmentDateTime.difference(currentTime.value);
    return difference.inMinutes / 60;
  }

  double hoursSinceAppointment(PatientAppointmentModel appointment) {
    DateTime appointmentDateTime = parseDateTime(appointment.date, appointment.time);
    Duration difference = currentTime.value.difference(appointmentDateTime);
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

  String formatPrice(int price) {
    final formatted = NumberFormat('#,##0', 'en_US').format(price);
    return '$formatted ${"currency".tr}';
  }
}

// Classes for async filtering
class FilterParams {
  final List<PatientAppointmentModel> sourceList;
  final String query;

  FilterParams({required this.sourceList, required this.query});
}

class SearchResult {
  final List<PatientAppointmentModel> filteredList;
  final List<PatientAppointmentModel> suggestions;

  SearchResult({required this.filteredList, required this.suggestions});
}

// Top-level function for compute isolation
SearchResult _filterAppointments(FilterParams params) {
  final filteredList = params.sourceList.where((appointment) {
    return appointment.doctorName.toLowerCase().contains(params.query);
  }).toList();

  // Create suggestions (unique doctors)
  final seenNames = <String>{};
  final suggestions = <PatientAppointmentModel>[];

  for (final appointment in filteredList) {
    final name = appointment.doctorName.toLowerCase();
    if (seenNames.add(name)) {
      suggestions.add(appointment);
    }
  }

  return SearchResult(filteredList: filteredList, suggestions: suggestions);
}
