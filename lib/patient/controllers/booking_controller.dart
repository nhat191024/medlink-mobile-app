import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';
import 'package:medlink/model/service_model.dart';
import 'package:medlink/model/payment_method_model.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BookingController extends GetxController {
  // Controllers and dependencies
  final SearchHeathCareController searchHeathCareController = Get.find<SearchHeathCareController>();
  final String? token = StorageService.readData(key: LocalStorageKeys.token);
  final Duration _requestTimeout = Duration(seconds: 8);

  // Booking state
  final RxInt step = 1.obs;
  final RxInt selectedService = (-1).obs; // -1 means no service selected
  final RxInt bookingType = 1.obs;
  final RxInt selectedMethod = 999.obs;

  // Date and time management
  final RxString selectedDate = ''.obs;
  final RxString selectedTime = ''.obs;
  final String currentMonthYear = DateFormat('MMM, yyyy').format(DateTime.now());

  // Reactive medical problem validation
  final RxString medicalProblemText = ''.obs;

  // Generate 7 days from today
  late final RxList<String> listDate = _generateDateList().obs;
  late final RxList<String> listDay = _generateDayList().obs;

  // Form controllers for patient information
  final TextEditingController fullname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final Rx<Country> selectedCountry = Country.unitedStates.obs;
  final TextEditingController address = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController gps = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController zipCode = TextEditingController();
  final TextEditingController medicalProblem = TextEditingController();
  final TextEditingController note = TextEditingController();

  // Form validation errors
  final RxBool isFullnameError = false.obs;
  final RxBool isPhoneNumberError = false.obs;
  final RxBool isAddressError = false.obs;
  final RxBool isCountryError = false.obs;
  final RxBool isStateError = false.obs;
  final RxBool isCityError = false.obs;
  final RxBool isZipCodeError = false.obs;
  final RxBool isMedicalProblemError = false.obs;

  // Payment methods (from API)
  final RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;
  final RxBool isPaymentMethodsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onClose() {
    super.onClose();
    _disposeController();
  }

  // ============================================================================
  // INITIALIZATION METHODS
  // ============================================================================

  void _initializeController() {
    loadPersonData();
    getPaymentMethods();
    _setupTextListeners();
  }

  void _setupTextListeners() {
    // Add listener to medical problem text field for reactive validation
    medicalProblem.addListener(() {
      medicalProblemText.value = medicalProblem.text.trim();
    });
  }

  void _disposeController() {
    unloadPersonData();
    clearBookingInfo();
  }

  Future<void> getPaymentMethods() async {
    if (isPaymentMethodsLoading.value) return; // Prevent multiple calls

    isPaymentMethodsLoading.value = true;

    try {
      final response = await http
          .get(
            Uri.parse('${Apis.api}payment/methods'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final methods = (data['methods'] as List)
            .map((item) => PaymentMethodModel.fromJson(item))
            .toList();
        paymentMethods.assignAll(methods);
        debugPrint('Payment methods fetched successfully: ${paymentMethods.length}');
      } else {
        debugPrint('Failed to fetch payment methods: ${response.statusCode}');
        paymentMethods.clear();
      }
    } catch (e) {
      debugPrint('Error fetching payment methods: $e');
      paymentMethods.clear();
    } finally {
      isPaymentMethodsLoading.value = false;
    }
  }

  List<String> _generateDateList() {
    return List.generate(7, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return DateFormat('dd').format(date);
    });
  }

  List<String> _generateDayList() {
    return List.generate(7, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return DateFormat('E').format(date);
    });
  }

  // ============================================================================
  // PAYMENT METHOD MANAGEMENT
  // ============================================================================

  /// Get payment methods list (reactive)
  List<PaymentMethodModel> get methods => paymentMethods;

  /// Check if payment methods are available
  bool get hasPaymentMethods => paymentMethods.isNotEmpty;

  /// Get selected payment method safely
  PaymentMethodModel? get selectedPaymentMethod {
    if (selectedMethod.value == 999 || selectedMethod.value < 0) return null;
    if (selectedMethod.value >= paymentMethods.length) return null;
    return paymentMethods[selectedMethod.value];
  }

  /// Refresh payment methods if needed
  Future<void> refreshPaymentMethodsIfNeeded() async {
    if (paymentMethods.isEmpty && !isPaymentMethodsLoading.value) {
      await getPaymentMethods();
    }
  }

  // ============================================================================
  // SERVICE MANAGEMENT
  // ============================================================================

  /// Get the currently selected service safely
  ServiceModel? getSelectedService(int doctorIndex) {
    if (selectedService.value < 0) return null;

    final services = searchHeathCareController.doctorList[doctorIndex].services;
    if (services != null && selectedService.value < services.length) {
      return services[selectedService.value];
    }
    return null;
  }

  /// Check if a service is selected
  bool get hasSelectedService => selectedService.value >= 0;

  /// Get selected service price safely
  int getSelectedServicePrice(int doctorIndex) {
    final service = getSelectedService(doctorIndex);
    return service?.price ?? 0;
  }

  /// Get selected service duration safely
  int getSelectedServiceDuration(int doctorIndex) {
    final service = getSelectedService(doctorIndex);
    return service?.duration ?? 30;
  }

  /// Get selected service name safely
  String getSelectedServiceName(int doctorIndex) {
    final service = getSelectedService(doctorIndex);
    return service?.name ?? 'Service';
  }

  // ============================================================================
  // DATE AND TIME UTILITIES
  // ============================================================================

  String convertDateFormat(String dateStr) {
    try {
      DateTime date = DateFormat("dd MMM, yyyy").parse(dateStr);
      return DateFormat("EEE, dd MMM yyyy").format(date);
    } catch (e) {
      debugPrint('Error parsing date: $dateStr - $e');
      return dateStr;
    }
  }

  String convertDateToApiFormat(String dateStr) {
    try {
      DateTime date = DateFormat("dd MMM, yyyy").parse(dateStr);
      return DateFormat("yyyy-MM-dd").format(date);
    } catch (e) {
      debugPrint('Error converting date to API format: $dateStr - $e');
      return dateStr;
    }
  }

  String convertToDayOfWeek(String dateStr) {
    try {
      DateTime date = DateFormat("dd MMM, yyyy").parse(dateStr);
      return DateFormat("EEEE").format(date);
    } catch (e) {
      debugPrint('Error converting to day of week: $dateStr - $e');
      return dateStr;
    }
  }

  String addMinutesToTime(String timeStr, int minutesToAdd) {
    try {
      DateTime time = DateFormat.jm().parse(timeStr);
      DateTime newTime = time.add(Duration(minutes: minutesToAdd));
      return DateFormat.jm().format(newTime);
    } catch (e) {
      debugPrint('Error adding minutes to time: $timeStr - $e');
      return timeStr;
    }
  }

  // ============================================================================
  // CALCULATION METHODS
  // ============================================================================

  String calculateTotal(int servicePrice) {
    int tax = int.parse(calculateTax(servicePrice));
    int total = servicePrice + tax;
    return total.toString();
  }

  String calculateTax(int servicePrice) {
    // Assuming tax is a fixed percentage of the service price
    const int taxPercentage = 10; // 10% tax
    int taxAmount = (servicePrice * taxPercentage / 100).round();
    return taxAmount.toString();
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  bool checkIfDefaultAvatar(String avatar) {
    String fileName = avatar.split('/').last;
    return fileName.contains('default.png');
  }

  void openCalendar() async {
    try {
      final Uri url = Uri.parse('content://com.android.calendar/time/');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showError('cannot_open_calendar'.tr);
      }
    } catch (e) {
      _showError('cannot_open_calendar'.tr);
    }
  }

  void _showError(String message) {
    Get.snackbar('error'.tr, message, colorText: AppColors.errorMain);
  }

  // ============================================================================
  // DATA MANAGEMENT
  // ============================================================================

  Future<void> loadPersonData() async {
    try {
      fullname.text = StorageService.readData(key: "name") ?? '';
      email.text = StorageService.readData(key: "email") ?? '';
      phoneNumber.text = StorageService.readData(key: "phone") ?? '';
      address.text = StorageService.readData(key: "address") ?? '';
      gps.text = StorageService.readData(key: "gps") ?? '';
      country.text = StorageService.readData(key: "country") ?? '';
      city.text = StorageService.readData(key: "city") ?? '';
      state.text = StorageService.readData(key: "state") ?? '';
      zipCode.text = StorageService.readData(key: "zipCode") ?? '';
    } catch (e) {
      debugPrint('Error loading person data: $e');
    }
  }

  void unloadPersonData() {
    fullname.clear();
    email.clear();
    phoneNumber.clear();
    address.clear();
    gps.clear();
    country.clear();
    city.clear();
    state.clear();
    zipCode.clear();
  }

  void clearBookingInfo() {
    // Reset booking state
    step.value = 1;
    selectedService.value = -1;
    bookingType.value = 1;
    selectedMethod.value = 999;
    selectedDate.value = '';
    selectedTime.value = '';
    medicalProblemText.value = '';

    // Clear form data
    fullname.clear();
    email.clear();
    phoneNumber.clear();
    address.clear();
    address2.clear();
    gps.clear();
    country.clear();
    state.clear();
    city.clear();
    zipCode.clear();
    medicalProblem.clear();
    note.clear();

    // Clear validation errors
    _clearValidationErrors();
  }

  void _clearValidationErrors() {
    isFullnameError.value = false;
    isPhoneNumberError.value = false;
    isAddressError.value = false;
    isCountryError.value = false;
    isStateError.value = false;
    isCityError.value = false;
    isZipCodeError.value = false;
    isMedicalProblemError.value = false;
  }

  // ============================================================================
  // BOOKING API
  // ============================================================================

  Future<void> bookAppointment(int doctorIndex) async {
    try {
      final selectedServiceModel = getSelectedService(doctorIndex);
      final doctor = searchHeathCareController.doctorList[doctorIndex];
      if (selectedServiceModel == null) {
        _showError('Please select a service');
        return;
      }

      final date = convertDateToApiFormat("${selectedDate.value} $currentMonthYear");
      final dayOfWeek = convertToDayOfWeek("${selectedDate.value} $currentMonthYear");
      // Remove AM/PM from start time
      final startTime = DateFormat('jm').parse(selectedTime.value);
      final formattedStartTime = DateFormat('HH:mm').format(startTime);
      final endTime = addMinutesToTime(selectedTime.value, selectedServiceModel.duration);
      final paymentMethod = selectedPaymentMethod;
      final time = "${selectedTime.value} - $endTime";

      final uri = Uri.parse('${Apis.api}appointments/book');
      final response = http.MultipartRequest('POST', uri);

      // Add headers
      if (token != null) {
        response.headers['Authorization'] = 'Bearer $token';
        response.headers['Content-Type'] = 'multipart/form-data';
        response.headers['Accept'] = 'application/json';
      }

      // Add basic booking fieldscls

      response.fields.addAll({
        'doctor_profile_id': doctor.doctorProfileId?.toString() ?? '1',
        'service_id': selectedServiceModel.id.toString(),
        'medical_problem': medicalProblem.text,
        'date': date,
        'day_of_week': dayOfWeek,
        'start_time': formattedStartTime,
        'time': time,
        'payment_method': ?paymentMethod?.id,
      });

      debugPrint('Booking appointment with fields: ${response.fields}');

      var streamedResponse = await response.send();
      var responseBody = await streamedResponse.stream.bytesToString();
      var json = jsonDecode(responseBody);
      if (streamedResponse.statusCode == 201) {
        debugPrint('Appointment booked successfully: ${json['message']}');
        var data = json['data'];
        var checkoutUrl = data['checkoutUrl'];

        Get.toNamed(Routes.webViewScreen, arguments: {'qrPageUrl': checkoutUrl});
      } else {
        debugPrint("Streamed response status code: ${streamedResponse.statusCode}");
        debugPrint('Message: ${json['message']}');
        debugPrint('Error details: ${json['error']}');
        _showError(json['message'] ?? 'Failed to book appointment');
      }
    } catch (e) {
      debugPrint('Error booking appointment: $e');
      _showError('Failed to book appointment');
    }
  }
}
