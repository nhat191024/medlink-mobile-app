import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/model/doctor_model.dart';
import 'package:medlink/model/healthcare_model.dart';
import 'package:intl/intl.dart';

class SearchHeathCareController extends GetxController {
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
  final RxString selectedDate = ''.obs;
  final RxString selectedTime = ''.obs;

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
          final doctorModel = DoctorModel.fromJson(doctor);
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

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('MMM dd, yyyy HH:mm');
    return formatter.format(dateTime);
  }

  bool checkIfDefaultAvatar(String avatar) {
    return avatar.split('/').last.contains('default.png');
  }
}
