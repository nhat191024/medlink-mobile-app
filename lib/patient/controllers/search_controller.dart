import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

import 'package:medlink/model/doctor_model.dart';
import 'package:medlink/model/healthcare_model.dart';
import 'package:intl/intl.dart';

class SearchHeathCareController extends GetxController {
  // final BookingController bookingController = Get.put(BookingController());

  // Core properties
  final String? _token = StorageService.readData(key: LocalStorageKeys.token);

  // UI State observables
  final RxString username = "".obs;
  final RxString userAvatar = "".obs;
  final RxBool isDoctorLoading = true.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Controllers and focus nodes
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Search and category state
  final RxString selectedCategory = "".obs;

  // Date properties
  final String currentMonthYear = DateFormat('MMM, yyyy').format(DateTime.now());

  // Date lists - computed once
  late final RxList<String> listDate;
  late final RxList<String> listDay;

  // Static data
  static const List<String> testimonialsTitle = [
    'Bad',
    'Not happy',
    'Average',
    'Good',
    'Excellent',
  ];

  static const List<String> categoryName = ['doctor', 'pharmacies', 'hospital', 'ambulance'];

  // Categories with results
  final RxList categories = [
    {"name": "Doctors", "image": AppImages.faceMark, "result": 0},
    {"name": "Hospitals", "image": AppImages.firstAid, "result": 0},
    {"name": "Pharmacy", "image": AppImages.firstAidKit, "result": 0},
    {"name": "Ambulance", "image": AppImages.heartBeat, "result": 0},
  ].obs;

  // Pagination for doctors
  final RxInt currentDoctorPage = 1.obs;
  final RxInt totalDoctorPage = 2.obs;

  // Data lists
  RxList<DoctorModel> doctorList = <DoctorModel>[].obs;
  final RxList<HospitalModel> hospital = <HospitalModel>[].obs;
  final RxList<PharmacyModel> pharmacy = <PharmacyModel>[].obs;
  final RxList<AmbulanceModel> ambulance = <AmbulanceModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    _initializeDateLists();
    await _loadUserData();
    await fetchCategoryResult();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  // initialize date lists for the next 7 days
  void _initializeDateLists() {
    listDate = List.generate(7, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return DateFormat('dd').format(date);
    }).obs;

    listDay = List.generate(7, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return DateFormat('E').format(date);
    }).obs;
  }

  // Load user data from local storage
  Future<void> _loadUserData() async {
    if (StorageService.checkData(key: 'name')) {
      username.value = StorageService.readData(key: 'name');
    }
    if (StorageService.checkData(key: 'avatar')) {
      userAvatar.value = StorageService.readData(key: 'avatar');
    }
  }

  // fetch category results from the API
  Future<void> fetchCategoryResult() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await get(
        Uri.parse('${Apis.api}search/number-of-each-category'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (int i = 0; i < categories.length; i++) {
          categories[i]['result'] = data[categoryName[i]] ?? 0;
        }
      } else {
        throw Exception('Failed to fetch category results: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load categories: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDoctor() async {
    if (currentDoctorPage.value > totalDoctorPage.value) return;

    try {
      isDoctorLoading.value = true;

      final response = await get(
        Uri.parse('${Apis.api}search/doctor?page=${currentDoctorPage.value}'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        totalDoctorPage.value = responseData['total_page'] ?? 1;

        for (var doctor in responseData['data']) {
          // debugPrint(DoctorModel.fromJson(doctor).toString());
          // debugPrint(doctor.toString());
          final doctorModel = DoctorModel.fromJson(doctor);
          // debugPrint('doctor: ${doctorModel.workSchedule?.toJson()}');
          doctorList.add(doctorModel);
        }

        _updateSelectedDate();
        currentDoctorPage.value++;
      } else {
        throw Exception('Failed to fetch doctors: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load doctors: $e';
    } finally {
      isDoctorLoading.value = false;
      doctorList.refresh();
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

void _updateSelectedDate() {
    if (doctorList.isNotEmpty) {
      final doctorWorkSchedule = doctorList[0].workSchedule;

      if (doctorWorkSchedule != null) {
        // Lấy tháng hiện tại (Jul, Aug, etc.)
        final currentMonth = DateFormat('MMM').format(DateTime.now());

        // Lấy schedule của tháng hiện tại
        final monthSchedule = doctorWorkSchedule.getScheduleForMonth(currentMonth);

        if (monthSchedule != null) {
          // Duyệt qua các ngày trong listDate để tìm ngày có lịch available
          for (final date in listDate) {
            final timeSlots = monthSchedule.getTimeSlotsForDay(date);

            // Kiểm tra xem ngày này có time slots available không
            if (timeSlots != null && timeSlots.any((slot) => slot.isAvailable == true)) {
              // Uncomment dòng này khi có BookingController
              // bookingController.selectedDate.value = date;
              break;
            }
          }
        }
      }
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (currentDoctorPage.value <= totalDoctorPage.value && !isDoctorLoading.value) {
        fetchDoctor();
      }
    }
  }

  // void openPhoneCall(String phone) async {
  //   final Uri url = Uri.parse('tel:$phone');
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   }
  // }

  bool checkIfDefaultAvatar(String avatar) {
    return avatar.split('/').last.contains('default.png');
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('MMM dd, yyyy HH:mm');
    return formatter.format(dateTime);
  }

  Map<String, List<Map<String, dynamic>>> _extractTimeSlots(Map<String, dynamic> workSchedule) {
    final Map<String, List<Map<String, dynamic>>> timeSlots = {};

    List<Map<String, dynamic>> generateAllDaySlots(List<Map<String, dynamic>> bookedSlots) {
      final List<Map<String, dynamic>> slots = [];
      DateTime time = DateFormat('hh:mm a').parse('07:00 AM');

      for (int i = 0; i < 8; i++) {
        final DateTime currentSlot = time.add(Duration(minutes: 45 * i));
        final String formattedTime = DateFormat('hh:mm a').format(currentSlot);

        // Check if current time slot conflicts with any booked appointments
        bool isAvailable = true;
        for (final bookedSlot in bookedSlots) {
          if (bookedSlot['time'] == null || bookedSlot['time'] == 'All day') continue;

          final DateTime bookedTime = DateFormat('hh:mm a').parse(bookedSlot['time']);
          final int appointmentDuration = bookedSlot['appointment_time'] ?? 30;

          // Calculate start and end times of the booked appointment
          final DateTime bookedEndTime = bookedTime.add(Duration(minutes: appointmentDuration));

          // Check if current slot falls within any booked appointment's time range
          if (currentSlot.isAtSameMomentAs(bookedTime) ||
              (currentSlot.isAfter(bookedTime) && currentSlot.isBefore(bookedEndTime)) ||
              currentSlot.add(const Duration(minutes: 45)).isAfter(bookedTime) &&
                  currentSlot.isBefore(bookedTime)) {
            isAvailable = false;
            break;
          }
        }

        slots.add({'time': formattedTime, 'is_available': isAvailable});
      }
      return slots;
    }

    try {
      workSchedule.forEach((month, days) {
        if (days is Map) {
          days.forEach((day, schedules) {
            if (!timeSlots.containsKey(day)) {
              timeSlots[day] = [];
            }

            if (schedules is List) {
              final bool hasAllDay = schedules.any((schedule) => schedule['time'] == 'All day');

              if (hasAllDay) {
                // Generate all day slots but consider booked appointments
                timeSlots[day] = generateAllDaySlots(schedules.cast<Map<String, dynamic>>());
              } else {
                // Handle regular time slots
                for (final schedule in schedules) {
                  final bool isAvailable = schedule['is_available'] ?? false;
                  final String time = schedule['time'] ?? '';

                  if (time.isNotEmpty && time != 'null') {
                    timeSlots[day]!.add({'time': time, 'is_available': isAvailable});
                  }
                }
              }
            }
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error extracting time slots: $e');
      }
    }

    return timeSlots;
  }
}
