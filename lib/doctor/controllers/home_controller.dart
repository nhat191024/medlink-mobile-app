import 'package:medlink/utils/app_imports.dart';

class DoctorHomeController extends GetxController {
  // User profile observables
  final RxString avatar = ''.obs;
  final RxString userName = ''.obs;
  final RxString identity = ''.obs;
  final RxString userType = ''.obs;
  final RxString specialty = ''.obs;
  final RxString balance = ''.obs;

  // App state observables
  final RxBool isProfileSetuped = false.obs;
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
      } else {
        isProfileSetuped.value = false;
      }
    } catch (e) {
      isProfileSetuped.value = false;
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
    balance.value = data['balance'] ?? '0.0';
    final profileSetupPoint = data['profileSetupPoint'];
    double point = 0.0;
    if (profileSetupPoint is double) {
      point = profileSetupPoint;
    } else if (profileSetupPoint is String) {
      point = double.tryParse(profileSetupPoint) ?? 0.0;
    }
    isProfileSetuped.value = point < 100 ? false : true;

    if (int.tryParse(balance.value)! < 1000000) {
      isProfileSetuped.value = false;
    } else {
      isProfileSetuped.value = true;
    }
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
    StorageService.writeStringData(key: "userType", value: userType.value);
    StorageService.writeBoolData(key: "haveNotification", value: isHaveNotificationUnread.value);
    StorageService.writeStringData(key: "balance", value: balance.value.toString());
  }

  /// Checks if the avatar is the default avatar
  bool checkIfDefaultAvatar(String avatar) {
    final fileName = avatar.split('/').last;
    return fileName.contains('default.png');
  }
}
