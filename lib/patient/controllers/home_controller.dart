import 'package:medlink/utils/app_imports.dart';

class PatientHomeController extends GetxController {
  // User data observables
  final RxString userName = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString address = ''.obs;
  final RxString gps = ''.obs;
  final RxString country = ''.obs;
  final RxString city = ''.obs;
  final RxString state = ''.obs;
  final RxString zipCode = ''.obs;
  final RxString userType = ''.obs;
  final RxString avatar = ''.obs;
  final RxString location = ''.obs;
  final RxString balance = ''.obs;

  // UI state observables
  final RxBool setup = true.obs;
  final RxBool isHaveNotificationUnread = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final TextEditingController searchController = TextEditingController();

  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await fetchData();
      await saveData();
    } catch (e) {
      errorMessage.value = 'Failed to load user data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchData() async {
    final token = StorageService.readData(key: LocalStorageKeys.token);

    final response = await get(
      Uri.parse('${Apis.api}patient-summary'),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      _updateUserData(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  void _updateUserData(Map<String, dynamic> data) {
    userName.value = data['name'] ?? '';
    email.value = data['email'] ?? '';
    phone.value = data['phone'] ?? '';
    address.value = data['address'] ?? '';
    gps.value = data['gps'] ?? '';
    country.value = data['country'] ?? '';
    city.value = data['city'] ?? '';
    state.value = data['state'] ?? '';
    zipCode.value = data['zip_code'] ?? '';
    userType.value = data['userType'] ?? '';
    location.value = data['location'] ?? '';
    avatar.value = data['avatar'] ?? '';
    isHaveNotificationUnread.value = data['isHaveNotification'] ?? false;
    balance.value = data['balance'] ?? '0';
  }

  Future<void> saveData() async {
    final userData = {
      "avatar": avatar.value,
      "name": userName.value,
      "email": email.value,
      "phone": phone.value,
      "address": address.value,
      "gps": gps.value,
      "country": country.value,
      "city": city.value,
      "state": state.value,
      "zipCode": zipCode.value,
      "userType": userType.value,
      "location": location.value,
      "identity": "patient",
      "balance": balance.value,
    };

    for (final entry in userData.entries) {
      StorageService.writeStringData(key: entry.key, value: entry.value);
    }

    StorageService.writeBoolData(key: "haveNotification", value: isHaveNotificationUnread.value);
  }

  bool checkIfDefaultAvatar(String avatar) {
    return avatar.split('/').last.contains('default.png');
  }

  Future<void> refreshData() async {
    await _loadUserData();
  }
}
