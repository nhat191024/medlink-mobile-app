import 'package:medlink/utils/app_imports.dart';

class DoctorHomeController extends GetxController {
  // User profile observables
  final RxString avatar = ''.obs;
  final RxString userName = ''.obs;
  final RxString identity = ''.obs;
  final RxString userType = ''.obs;
  final RxString specialty = ''.obs;

  // App state observables
  final RxBool setup = true.obs;
  final RxBool isHaveNotificationUnread = false.obs;

  // Statistics observables
  final RxInt booking = 0.obs;
  final RxInt upcoming = 0.obs;
  final RxInt review = 0.obs;
  final RxList reviewers = [].obs;

  // UI state
  int currentIndex = 0;

  @override
  void onInit() async {
    await fetchData();
    super.onInit();
  }

  /// Fetches doctor summary data from the API and updates local state
  Future<void> fetchData() async {
    try {
      final token = StorageService.readData(key: LocalStorageKeys.token);
      final response = await _makeApiRequest(token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _updateUserData(data);
        _updateStatistics(data);
        _updateReviewers(data);
        _saveDataToStorage();
        _updateSetupStatus(data);
      } else {
        _handleApiError();
      }
    } catch (e) {
      // Log error and set default state
      setup.value = true;
    }
  }

  /// Makes API request to fetch doctor summary
  Future<Response> _makeApiRequest(String token) async {
    return await get(
      Uri.parse('${Apis.api}doctor-summary'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Updates user profile data from API response
  void _updateUserData(Map<String, dynamic> data) {
    avatar.value = data['avatar'] ?? '';
    userName.value = data['name'] ?? '';
    identity.value = data['identity'] ?? '';
    specialty.value = data['specialty'] ?? '';
    userType.value = data['userType'] ?? '';
    isHaveNotificationUnread.value = data['isHaveNotification'] ?? false;
  }

  /// Updates statistics data from API response
  void _updateStatistics(Map<String, dynamic> data) {
    booking.value = data['pending'] ?? 0;
    upcoming.value = data['upcoming'] ?? 0;
    review.value = data['reviews'] ?? 0;
  }

  /// Updates reviewers list from API response
  void _updateReviewers(Map<String, dynamic> data) {
    reviewers.clear();
    if (data['reviewer'] != null && data['reviewer'].length > 0) {
      reviewers.addAll(data['reviewer']);
    }
  }

  /// Saves important data to local storage
  void _saveDataToStorage() {
    StorageService.writeStringData(key: "avatar", value: avatar.value);
    StorageService.writeStringData(key: "name", value: userName.value);
    StorageService.writeStringData(key: "specialty", value: specialty.value);
    StorageService.writeStringData(key: "identity", value: identity.value);
    StorageService.writeBoolData(key: "haveNotification", value: isHaveNotificationUnread.value);
  }

  /// Updates setup status based on introduction completion
  void _updateSetupStatus(Map<String, dynamic> data) {
    final introduceValue = data['introduce'];
    setup.value = introduceValue == 'true' || introduceValue == true;
  }

  /// Handles API error by setting default state
  void _handleApiError() {
    setup.value = true;
  }

  /// Checks if the avatar is the default avatar
  bool checkIfDefaultAvatar(String avatar) {
    final fileName = avatar.split('/').last;
    return fileName.contains('default.png');
  }
}
