import 'package:medlink/utils/app_imports.dart';

class LoginController extends GetxController {
  // Constants
  static const String _doctorUserType = 'healthcare';
  static const int _successStatusCode = 200;

  //information
  final TextEditingController loginInfo = TextEditingController();
  final TextEditingController password = TextEditingController();
  final RxString token = "".obs;

  //error text and error bool
  final RxString loginErrorText = ''.obs;
  final RxString passwordErrorText = ''.obs;
  final RxBool isLoginError = false.obs;
  final RxBool isPasswordError = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  //social login
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   clientId: dotenv.env['googleClientId'],
  // );

  // Future<void> _handleGoogleSignIn() async {
  //   try {
  //     await _googleSignIn.signIn();
  //     print(_googleSignIn.currentUser);
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print(error);
  //     }
  //   }
  // }

  //pattern
  String passwordPattern = r'^(?=.*[A-Za-z]{6,})(?=.*\d)(?=.*[&$#%])[A-Za-z\d&$#%]{8,}$';

  // Validation helper methods
  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _validatePhone(String phone) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
  }

  bool _isValidEmailOrPhone(String input) {
    return _validateEmail(input) || _validatePhone(input);
  }

  bool _validateInputs() {
    bool isValid = true;

    // Reset errors
    isLoginError.value = false;
    isPasswordError.value = false;

    // Validate login info
    if (loginInfo.text.trim().isEmpty) {
      isLoginError.value = true;
      loginErrorText.value = 'Email or phone cannot be blank';
      isValid = false;
    } else if (!_isValidEmailOrPhone(loginInfo.text.trim())) {
      isLoginError.value = true;
      loginErrorText.value = 'Please enter valid email or phone number';
      isValid = false;
    }

    // Validate password
    if (password.text.isEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = 'Password cannot be blank';
      isValid = false;
    }

    return isValid;
  }

  void _handleApiError(String? errorMessage) {
    isPasswordError.value = true;

    final errorMessages = {
      'notExist': 'login_error_not_exist'.tr,
      'wrong': 'login_error_not_correct'.tr,
      'suspended': 'login_error_suspended'.tr,
      'notApproval': 'login_error_not_approved'.tr,
    };

    passwordErrorText.value =
        errorMessages[errorMessage] ?? errorMessage ?? 'Unknown error occurred';
  }

  Future<void> login() async {
    // Validate inputs first
    if (!_validateInputs()) {
      return;
    }

    String url = '${Apis.api}login';
    try {
      isLoading.value = true;

      var response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {'login': loginInfo.text.trim(), 'password': password.text},
      ).timeout(const Duration(seconds: Apis.timeOut));

      var responseData = jsonDecode(response.body);
      var message = responseData['message'];

      if (response.statusCode == _successStatusCode) {
        isPasswordError.value = false;
        isLoginError.value = false;
        storeToken(responseData['token']);
        clear();

        if (responseData['userType'] == _doctorUserType) {
          debugPrint('Doctor logged in successfully');
          // Get.toNamed(Routes.doctorHomeScreen);
        } else {
          Get.toNamed(Routes.patientHomeScreen);
        }
      } else {
        _handleApiError(message);
      }
    } catch (error) {
      isPasswordError.value = true;
      passwordErrorText.value = 'Network error occurred. Please try again.';
      if (kDebugMode) {
        print('Login error: $error');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> storeToken(String token) async {
    if (StorageService.checkData(key: LocalStorageKeys.token)) {
      StorageService.removeData(key: LocalStorageKeys.token);
    }
    StorageService.writeBoolData(key: LocalStorageKeys.isTokenExist, value: true);
    StorageService.writeStringData(key: LocalStorageKeys.token, value: token);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    // Clear sensitive data
    loginInfo.clear();
    password.clear();
    token.value = '';
    super.onClose();
  }

  void clear() {
    loginInfo.clear();
    password.clear();
    isLoginError.value = false;
    isPasswordError.value = false;
    isPasswordVisible.value = false;
    loginErrorText.value = '';
    passwordErrorText.value = '';
  }
}
