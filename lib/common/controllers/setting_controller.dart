import 'package:medlink/utils/app_imports.dart';
import 'package:http/http.dart' as http;

class SettingControllers extends GetxController {
  final token = StorageService.readData(key: LocalStorageKeys.token);

  //============================================================================
  // CONSTANTS
  //============================================================================
  static const String _passwordPattern =
      r'^(?=.*[A-Za-z]{6,})(?=.*\d)(?=.*[&$#%])[A-Za-z\d&$#%]{8,}$';
  final String _passwordErrorMessage = "password_strength".tr;
  final List<String> languages = ['Vietnamese', 'English'];
  final List<String> flag = [AppImages.vietnamese, AppImages.english];

  //============================================================================
  // PERSONAL INFORMATION
  //============================================================================
  final RxString avatar = ''.obs;
  final RxString username = ''.obs;
  final RxString userType = ''.obs;
  final RxString location = ''.obs;
  final RxString specialty = ''.obs;
  final RxString identity = ''.obs;
  final RxBool isHaveNotificationUnread = false.obs;
  final RxBool saveBankInfo = false.obs;
  final RxString language = 'English'.obs;

  //============================================================================
  // TEXT CONTROLLERS
  //============================================================================/
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController support = TextEditingController();

  //============================================================================
  // PASSWORD STATE
  //============================================================================
  final RxBool isOldPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isPasswordFormValid = false.obs;

  //============================================================================
  // PASSWORD ERRORS
  //============================================================================
  final RxBool isOldPasswordErr = false.obs;
  final RxBool isNewPasswordErr = false.obs;
  final RxBool isConfirmPasswordErr = false.obs;
  final RxString oldPasswordErrText = ''.obs;
  final RxString newPasswordErrText = ''.obs;
  final RxString confirmPasswordErrText = ''.obs;

  //============================================================================
  // NOTIFICATION SETTINGS
  //============================================================================
  final RxBool notification = false.obs;
  final RxBool promotion = false.obs;
  final RxBool sms = false.obs;
  final RxBool appNotification = false.obs;

  //============================================================================
  // MESSAGE SETTINGS
  //============================================================================
  final RxBool message = false.obs;
  final RxBool customMessage = false.obs;
  final RxBool messagePrivacy = false.obs;
  final RxBool messageBackup = false.obs;

  //============================================================================
  // SUPPORT STATE
  //============================================================================
  final RxBool isSupportErr = false.obs;

  //============================================================================
  // LOADING STATES
  //============================================================================
  final RxBool isLoading = true.obs;
  final RxBool isChangingPassword = false.obs;
  final RxBool isSendingSupport = false.obs;

  //============================================================================
  // LIFECYCLE METHODS
  //============================================================================
  @override
  Future<void> onInit() async {
    isLoading.value = true;
    _loadSettings();
    await loadInfo();
    isLoading.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  //============================================================================
  // PRIVATE METHODS
  //============================================================================
  void _disposeControllers() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    support.dispose();
  }

  String? get _token => StorageService.readData(key: LocalStorageKeys.token);

  //============================================================================
  // PASSWORD VALIDATION METHODS
  //============================================================================
  void validatePassword() {
    _validateOldPassword();
    _validateNewPassword();
    _validateConfirmPassword();
    _checkPasswordsMatch();
    _updatePasswordFormValidation();
  }

  void _validateOldPassword() {
    if (oldPassword.text.isEmpty) {
      isOldPasswordErr.value = true;
      oldPasswordErrText.value = 'Please enter old password';
    } else {
      isOldPasswordErr.value = false;
      oldPasswordErrText.value = '';
    }
  }

  void _validateNewPassword() {
    if (newPassword.text.isEmpty) {
      isNewPasswordErr.value = true;
      newPasswordErrText.value = 'Please enter new password';
    } else if (!RegExp(_passwordPattern).hasMatch(newPassword.text)) {
      isNewPasswordErr.value = true;
      newPasswordErrText.value = _passwordErrorMessage;
    } else {
      isNewPasswordErr.value = false;
      newPasswordErrText.value = '';
    }
  }

  void _validateConfirmPassword() {
    if (confirmPassword.text.isEmpty) {
      isConfirmPasswordErr.value = true;
      confirmPasswordErrText.value = 'Please enter confirm password';
    } else {
      isConfirmPasswordErr.value = false;
      confirmPasswordErrText.value = '';
    }
  }

  void _checkPasswordsMatch() {
    if (oldPassword.text.isNotEmpty &&
        newPassword.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty) {
      if (newPassword.text != confirmPassword.text) {
        isConfirmPasswordErr.value = true;
        confirmPasswordErrText.value = 'Password does not match';
      } else {
        isConfirmPasswordErr.value = false;
        confirmPasswordErrText.value = '';
      }
    }
  }

  void _updatePasswordFormValidation() {
    isPasswordFormValid.value =
        oldPassword.text.isNotEmpty &&
        newPassword.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty &&
        newPassword.text == confirmPassword.text &&
        RegExp(_passwordPattern).hasMatch(newPassword.text) &&
        !isOldPasswordErr.value &&
        !isNewPasswordErr.value &&
        !isConfirmPasswordErr.value;
  }

  //============================================================================
  // USER INFORMATION METHODS
  //============================================================================
  Future<void> loadInfo() async {
    if (StorageService.checkData(key: 'avatar')) {
      avatar.value = StorageService.readData(key: 'avatar');
    }

    if (StorageService.checkData(key: 'name')) {
      username.value = StorageService.readData(key: 'name');
    }

    if (StorageService.checkData(key: 'userType')) {
      userType.value = StorageService.readData(key: 'userType');
    }

    if (StorageService.checkData(key: 'specialty') && userType.value == 'healthcare') {
      specialty.value = StorageService.readData(key: 'specialty');
    }

    if (StorageService.checkData(key: 'identity') && userType.value == 'healthcare') {
      identity.value = StorageService.readData(key: 'identity');
    }

    if (StorageService.checkData(key: 'location')) {
      location.value = StorageService.readData(key: 'location');
    }

    if (StorageService.checkData(key: 'haveNotification')) {
      isHaveNotificationUnread.value = StorageService.readData(key: 'haveNotification');
    }
  }

  //============================================================================
  // PASSWORD MANAGEMENT METHODS
  //============================================================================
  Future<void> changePassword() async {
    if (!isPasswordFormValid.value) return;

    isChangingPassword.value = true;
    try {
      final response = await post(
        Uri.parse('${Apis.api}setting/change_password'),
        headers: {'Authorization': 'Bearer $_token'},
        body: {
          'password': oldPassword.text,
          'new_password': newPassword.text,
          'confirm_password': confirmPassword.text,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 401) {
        isOldPasswordErr.value = true;
        oldPasswordErrText.value = data['message'];
      } else if (response.statusCode == 200) {
        _clearPasswordFields();
        Get.back();
        Get.snackbar('Success', data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to change password');
    } finally {
      isChangingPassword.value = false;
    }
  }

  void _clearPasswordFields() {
    oldPassword.clear();
    newPassword.clear();
    confirmPassword.clear();
    isOldPasswordErr.value = false;
    isNewPasswordErr.value = false;
    isConfirmPasswordErr.value = false;
    oldPasswordErrText.value = '';
    newPasswordErrText.value = '';
    confirmPasswordErrText.value = '';
  }

  //============================================================================
  // SETTINGS MANAGEMENT METHODS
  //============================================================================
  Future<void> _loadSettings() async {
    try {
      final response = await get(
        Uri.parse('${Apis.api}settings'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _updateNotificationSettings((data['notificationSettings'] as Map).values.toList());
        _updateMessageSettings((data['messageSettings'] as Map).values.toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load settings');
      debugPrint('Error loading settings: $e');
    }
  }

  void _updateNotificationSettings(List<dynamic> notificationSettingData) {
    final notificationSettingList = [notification, promotion, sms, appNotification];

    for (int i = 0; i < notificationSettingData.length; i++) {
      notificationSettingList[i].value = notificationSettingData[i] == 1;
    }
  }

  void _updateMessageSettings(List<dynamic> messageSettingData) {
    final messageSettingList = [message, customMessage, messagePrivacy, messageBackup];

    for (int i = 0; i < messageSettingData.length; i++) {
      messageSettingList[i].value = messageSettingData[i] == 1;
    }
  }

  Future<void> updateSetting(String name, int value) async {
    try {
      final uri = Uri.parse('${Apis.api}settings/update');
      final response = http.MultipartRequest("POST", uri);
      response.headers['Authorization'] = 'Bearer $token';
      response.headers['Accept'] = 'application/json';
      response.headers['Content-Type'] = 'application/json';

      response.fields.addAll({'name': name, 'value': value.toString()});

      var streamedResponse = await response.send();

      if (streamedResponse.statusCode == 200) {
        //
      } else {
        Get.snackbar('Error', 'Failed to update setting');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update setting');
    }
  }

  //============================================================================
  // SUPPORT METHODS
  //============================================================================
  Future<void> sendSupport() async {
    if (support.text.isEmpty) {
      isSupportErr.value = true;
      return;
    }

    isSupportErr.value = false;
    isSendingSupport.value = true;

    try {
      final response = await post(
        Uri.parse('${Apis.api}setting/support'),
        headers: {'Authorization': 'Bearer $_token'},
        body: {'message': support.text},
      );

      if (response.statusCode == 201) {
        support.clear();
        Get.back();
        Get.snackbar('Success', 'Support sent successfully');
      } else {
        Get.snackbar('Error', 'Failed to send support message');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send support message');
    } finally {
      isSendingSupport.value = false;
    }
  }

  //============================================================================
  // AUTHENTICATION METHODS
  //============================================================================
  Future<void> logout() async {
    try {
      final response = await get(
        Uri.parse('${Apis.api}setting/logout'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        _clearUserData();
        Get.deleteAll();
        Get.toNamed(Routes.splashScreen);
      } else {
        Get.snackbar('Error', 'Failed to logout');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout');
    }
  }

  //============================================================================
  // HELPER METHODS
  //============================================================================
  void _clearUserData() {
    StorageService.removeData(key: LocalStorageKeys.token);
    StorageService.removeData(key: 'avatar');
    StorageService.removeData(key: 'name');
    StorageService.removeData(key: 'specialty');
    StorageService.removeData(key: 'identity');
    StorageService.removeData(key: 'haveNotification');
  }

  bool checkIfDefaultAvatar(String avatar) {
    avatar = avatar.split('/').last;
    if (avatar.contains('default.png')) {
      return true;
    } else {
      return false;
    }
  }

  void updateLanguage(String newLanguage) {
    language.value = newLanguage;
  }

  void debug(String text) {
    debugPrint(text);
  }
}
