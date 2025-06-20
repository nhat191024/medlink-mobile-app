import 'package:medlink/utils/app_imports.dart';
import 'package:http/http.dart' as http;

class CreateAccountController extends GetxController {
  // Constants
  static const String _verifyCodeTest = '1234';
  static const int _successStatusCode = 200;
  static const int _createdStatusCode = 201;
  static const String _doctorUserType = 'healthcare';
  static const String _patientUserType = 'patient';
  static const double _progressIncrement = 0.01;
  static const int _progressInterval = 100;
  static const int _resendTimerSeconds = 60;

  // Patterns
  static const String _passwordPattern =
      r'^(?=.*[A-Za-z]{6,})(?=.*\d)(?=.*[&$#%])[A-Za-z\d&$#%]{8,}$';
  static const String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  //common information
  final Rx<Country> selectedCountry = Country.unitedStates.obs;
  final TextEditingController phoneNumber = TextEditingController();
  final RxString verifyCode = ''.obs;

  // Timer for resend code
  final RxInt remainingSeconds = 60.obs;
  final RxBool isResendEnabled = false.obs;
  Timer? _resendTimer;

  // Password strength tracking
  final RxDouble passwordStrength = 0.0.obs;
  final RxString passwordStrengthText = ''.obs;
  final Rx<Color> passwordStrengthColor = AppColors.disable.obs;

  final RxString userType = ''.obs;
  final Rx<File?> avatarImage = Rx<File?>(null);
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  //doctor information (not required)
  final RxInt identify = 1.obs;
  final Rx<File?> idImage = Rx<File?>(null);
  final Rx<File?> degreeImage = Rx<File?>(null);
  final TextEditingController professionalNumber = TextEditingController();

  //patient information (required)
  final TextEditingController fullName = TextEditingController();
  final RxInt age = 18.obs;
  final RxString gender = ''.obs;
  final RxDouble height = 1.0.obs;
  final RxInt weight = 40.obs;
  final RxString bloodGroup = ''.obs;
  final TextEditingController medicalHistory = TextEditingController();
  final RxString insuranceType = 'insurance_type_option_1'.tr.obs;
  final TextEditingController insuranceNumber = TextEditingController();
  final RxString assuranceType = ''.obs;

  //patient insurance information (vietnam only)
  final TextEditingController registry = TextEditingController();
  final TextEditingController registryAddress = TextEditingController();
  final Rx<DateTime?> validFrom = DateTime.now().obs;

  final TextEditingController address = TextEditingController();

  //private insurance information (only required for private insurance)
  final TextEditingController mainInsurance = TextEditingController();
  final TextEditingController entitledInsurance = TextEditingController();

  //error text and error bool
  final RxString emailErrorText = 'email_error_blank'.tr.obs;
  final RxString passwordErrorText = 'password_error_blank'.tr.obs;
  final RxBool verifyError = false.obs;
  final RxBool isEmailError = false.obs;
  final RxBool isPasswordError = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool termAndCondition = false.obs;
  final RxBool isProfessionalNumberError = false.obs;

  final RxBool buttonLoading = false.obs;
  final RxString error = ''.obs;

  //step
  final RxBool step = false.obs;
  final RxBool step2 = false.obs;
  final RxBool step3 = false.obs;
  final RxInt isPicked = 0.obs;
  final RxBool step4 = false.obs;
  final RxBool success = false.obs;

  // Progress tracking
  RxDouble progress = 0.0.obs;
  Timer? _progressTimer;

  //pattern
  String get passwordPattern => _passwordPattern;
  String get emailPattern => _emailPattern;

  @override
  void onInit() {
    super.onInit();
    startProgress();
  }

  @override
  void onClose() {
    _progressTimer?.cancel();
    _resendTimer?.cancel(); // Cancel resend timer
    // Clean up controllers
    phoneNumber.dispose();
    email.dispose();
    password.dispose();
    professionalNumber.dispose();
    fullName.dispose();
    medicalHistory.dispose();
    insuranceNumber.dispose();
    address.dispose();
    mainInsurance.dispose();
    entitledInsurance.dispose();
    super.onClose();
  }

  // ==================== VERIFY CODE SCREEN ====================

  // Start resend timer
  void startResendTimer() {
    remainingSeconds.value = _resendTimerSeconds;
    isResendEnabled.value = false;

    _resendTimer?.cancel(); // Cancel existing timer if any
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        isResendEnabled.value = true;
        timer.cancel();
      }
    });
  }

  // Resend verification code
  void resendVerificationCode() {
    if (isResendEnabled.value) {
      // TODO: Add actual resend API call here
      startResendTimer();
      // Show success message
      Get.snackbar(
        'Code Sent',
        'Verification code has been resent to your phone',
        backgroundColor: AppColors.successMain,
        colorText: AppColors.white,
      );
    }
  }

  // Verify code
  void verify() {
    if (verifyCode.value == _verifyCodeTest) {
      step2.value = true;
      verifyError.value = false;
      Get.toNamed(Routes.userTypeScreen);
    } else {
      verifyError.value = true;
      step2.value = false;
      verifyCode.value = '';
    }
  }

  // ==================== CREATE ACCOUNT SCREEN ====================

  // Validation helper methods
  bool _validateEmail(String email) {
    return RegExp(_emailPattern).hasMatch(email.trim());
  }

  // Check if password is valid
  bool _validatePassword(String password) {
    return RegExp(_passwordPattern).hasMatch(password) && password.length >= 8;
  }

  // Check if email or phone is valid
  bool _validateRequiredFields() {
    bool isValid = true;

    // Reset errors
    _resetValidationErrors();

    // Email validation
    if (email.text.trim().isEmpty) {
      emailErrorText.value = 'email_error_blank'.tr;
      isEmailError.value = true;
      isValid = false;
    } else if (!_validateEmail(email.text)) {
      emailErrorText.value = 'email_error_invalid'.tr;
      isEmailError.value = true;
      isValid = false;
    }

    // Password validation
    if (password.text.isEmpty) {
      passwordErrorText.value = 'password_error_blank'.tr;
      isPasswordError.value = true;
      isValid = false;
    } else if (!_validatePassword(password.text)) {
      passwordErrorText.value = 'password_error_invalid'.tr;
      isPasswordError.value = true;
      isValid = false;
    }

    return isValid;
  }

  void _resetValidationErrors() {
    isEmailError.value = false;
    isPasswordError.value = false;
    isProfessionalNumberError.value = false;
  }

  // Check if email exists
  Future<void> checkIfEmailExists() async {
    if (!_validateRequiredFields()) {
      return;
    }

    buttonLoading.value = true;
    try {
      var uri = Uri.parse('${Apis.api}mail-check');
      var response = await post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {'email': email.text.trim()},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == _successStatusCode) {
        emailErrorText.value = 'emailExist'.tr;
        isEmailError.value = true;
        return;
      } else {
        isEmailError.value = false;
        // userType.value == _doctorUserType
        //     ? Get.toNamed(Routes.identifyScreen)
        //     :
        //TODO: uncomment the above line when navigation is ready
        userType.value == _doctorUserType
            ? debugPrint('Doctor user type selected')
            : Get.toNamed(Routes.informationScreen);
      }
    } catch (error) {
      emailErrorText.value = 'network_error'.tr;
      isEmailError.value = true;
      debugPrint('Error checking email: $error');
    } finally {
      buttonLoading.value = false;
    }
  }

  // Verify account information
  void verifyAccount() {
    if (!_validateRequiredFields()) {
      step3.value = false;
      return;
    }

    // Check terms and conditions
    if (!termAndCondition.value) {
      step3.value = false;
      return;
    }

    step3.value = true;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Password strength methods
  void updatePasswordStrength(String password) {
    passwordStrength.value = _calculatePasswordStrength(password);
    passwordStrengthColor.value = _getStrengthColor(passwordStrength.value);
    passwordStrengthText.value = _getStrengthText(passwordStrength.value);
  }

  // Calculate password strength - create account screen
  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;

    // Length check
    if (password.length >= 8) strength += 0.25;

    // Uppercase check
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;

    // Number check
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.25;

    // Special character check
    if (RegExp(r'[&$#%]').hasMatch(password)) strength += 0.25;

    return strength;
  }

  // Get password strength color and text - create account screen
  Color _getStrengthColor(double strength) {
    if (strength == 0.0) return AppColors.disable;
    if (strength <= 0.25) return AppColors.errorMain;
    if (strength <= 0.50) return Colors.orange;
    if (strength <= 0.75) return AppColors.infoMain;
    return AppColors.successMain;
  }

  // Get password strength text - create account screen
  String _getStrengthText(double strength) {
    if (strength == 0.0) return '';
    if (strength <= 0.25) return 'Weak';
    if (strength <= 0.50) return 'Fair';
    if (strength <= 0.75) return 'Good';
    return 'Strong';
  }

  // Get password requirements - create account screen
  List<Map<String, dynamic>> getPasswordRequirements(String password) {
    return [
      {'text': 'At least 8 characters', 'isMet': password.length >= 8},
      {'text': 'Contains uppercase letter', 'isMet': RegExp(r'[A-Z]').hasMatch(password)},
      {'text': 'Contains number', 'isMet': RegExp(r'[0-9]').hasMatch(password)},
      {'text': 'Contains special character', 'isMet': RegExp(r'[&$#%]').hasMatch(password)},
    ];
  }

  // ==================== IDENTIFY SCREEN (DOCTOR) ====================

  void verifyCredentials() {
    bool hasRequiredDocuments = false;

    switch (identify.value) {
      case 1: // Professional license required
        hasRequiredDocuments = idImage.value != null && degreeImage.value != null;
        if (hasRequiredDocuments && professionalNumber.text.isEmpty) {
          isProfessionalNumberError.value = true;
          step4.value = false;
          return;
        }
        isProfessionalNumberError.value = false;
        break;
      case 2: // ID and degree required
        hasRequiredDocuments = idImage.value != null && degreeImage.value != null;
        break;
      default: // Only degree required
        hasRequiredDocuments = degreeImage.value != null;
        break;
    }

    step4.value = hasRequiredDocuments;
  }

  // ==================== INFORMATION SCREEN ====================

  // showMissingFieldsDialog - information screen
  void showMissingFieldsDialog(bool skipDisable) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset(AppImages.warning),
              ),
              const SizedBox(height: 15),
              Text(
                "missing_fields".tr,
                style: const TextStyle(fontFamily: AppFontStyleTextStrings.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                "missing_description".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFontStyleTextStrings.regular,
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 40,
                  width: 160,
                  margin: const EdgeInsets.fromLTRB(0, 10, 6, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.primaryText,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "check".tr,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontFamily: AppFontStyleTextStrings.medium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Check for missing information - information screen
  void checkMissingInformation() {
    if (userType.value == _patientUserType) {
      if (_hasRequiredPatientInfo()) {
        Get.toNamed(Routes.addAvatarScreen);
      } else {
        showMissingFieldsDialog(true);
      }
    }
  }

  // Check if all required patient information is filled - information screen
  bool _hasRequiredPatientInfo() {
    return fullName.text.isNotEmpty &&
        age.value > 0 &&
        gender.value.isNotEmpty &&
        height.value > 0 &&
        weight.value > 0 &&
        bloodGroup.value.isNotEmpty &&
        medicalHistory.text.isNotEmpty &&
        _insuranceRequiredInfo() &&
        address.text.isNotEmpty;
  }

  // Check if all required insurance information is filled - information screen
  bool _insuranceRequiredInfo() {
    final insuranceTypeValue = insuranceType.value;
    if (insuranceTypeValue.contains('insurance_type_option_1'.tr)) {
      return insuranceNumber.text.isNotEmpty;
    } else if (insuranceTypeValue.contains('insurance_type_option_2'.tr)) {
      return insuranceNumber.text.isNotEmpty &&
          mainInsurance.text.isNotEmpty &&
          entitledInsurance.text.isNotEmpty;
    } else {
      return insuranceNumber.text.isNotEmpty &&
          registry.text.isNotEmpty &&
          registryAddress.text.isNotEmpty &&
          validFrom.value != null;
    }
  }

  // ==================== CREATING ACCOUNT SCREEN ====================

  void startProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: _progressInterval), (timer) {
      if (progress.value >= 1.0) {
        timer.cancel();
      } else {
        progress.value += _progressIncrement;
      }
    });
  }

  // Start account creation progress
  void startAccountCreationProgress() {
    progress.value = 0.0; // Reset progress
    _progressTimer?.cancel(); // Cancel any existing timer

    _progressTimer = Timer.periodic(const Duration(milliseconds: _progressInterval), (timer) {
      if (progress.value >= 1.0) {
        timer.cancel();
        _onProgressComplete();
      } else {
        progress.value += _progressIncrement;
      }
    });
  }

  // Handle progress completion
  void _onProgressComplete() {
    if (success.value == true) {
      _navigateToNextScreen();
    } else {
      _showErrorMessage();
    }
  }

  // Navigate to next screen based on user type
  void _navigateToNextScreen() {
    final isPatient = userType.value == _patientUserType;
    final route = isPatient ? Routes.accountSuccessScreen : Routes.accountSubmitScreen;
    debugPrint('Navigating to route: $route');
    Get.offAllNamed(route);
  }

  // Show error message
  void _showErrorMessage() {
    Get.snackbar(
      'Error',
      error.value,
      backgroundColor: AppColors.white,
      colorText: AppColors.errorMain,
    );
  }

  // ==================== CREATE ACCOUNT API ====================

  // Create account
  Future<void> createAccount() async {
    buttonLoading.value = true;
    try {
      var uri = Uri.parse('${Apis.api}register');
      var response = http.MultipartRequest(
        'POST',
        uri,
      );
      response.headers.addAll({'Content-Type': 'multipart/form-data', 'Accept': 'application/json'});

      // Add common fields
      response.fields.addAll({
        'phone': phoneNumber.text,
        'countryCode': selectedCountry.value.dialCode,
        'userType': userType.value.toString(),
        'email': email.text.trim(),
        'password': password.text,
      });

      // Add user type specific fields
      if (userType.value == _doctorUserType) {
        _addDoctorFields(response);
        await _addDoctorFiles(response);
      } else {
        _addPatientFields(response);
      }

      // Add avatar if exists
      if (avatarImage.value != null) {
        var avatarFile = await http.MultipartFile.fromPath(
          'avatar',
          avatarImage.value!.path,
          filename: avatarImage.value!.path.split('/').last,
        );
        response.files.add(avatarFile);
      }

      //print request details for debugging

      // debugPrint('Request URI: ${response.url}');
      // debugPrint('Request Fields: ${response.fields}');
      // debugPrint('Request Files: ${response.files}');

      var streamedResponse = await response.send();
      var responseBody = await streamedResponse.stream.bytesToString();
      var data = jsonDecode(responseBody);

      //print response details for debugging
      // debugPrint('Response Status Code: ${streamedResponse.statusCode}');
      // debugPrint('Response Body: $data');
      // debugPrint('Response Headers: ${streamedResponse.headers}');

      if (streamedResponse.statusCode == _createdStatusCode) {
        success.value = true;
        if (data['token'] != null) {
          storeToken(data['token']);
        }
      } else {
        _handleCreateAccountError(data);
      }
    } catch (error) {
      this.error.value = 'network_error'.tr;
      success.value = false;
      if (kDebugMode) {
        print('Create account error: $error');
      }
    } finally {
      buttonLoading.value = false;
    }
  }

  void _addDoctorFields(http.MultipartRequest response) {
    response.fields.addAll({
      'identity': identify.value.toString(),
      'professionalNumber': professionalNumber.text,
    });
  }

  Future<void> _addDoctorFiles(http.MultipartRequest response) async {
    if (idImage.value != null) {
      var idFile = await http.MultipartFile.fromPath(
        'idCard',
        idImage.value!.path,
        filename: idImage.value!.path.split('/').last,
      );
      response.files.add(idFile);
    }

    if (degreeImage.value != null) {
      var degreeFile = await http.MultipartFile.fromPath(
        'medicalDegree',
        degreeImage.value!.path,
        filename: degreeImage.value!.path.split('/').last,
      );
      response.files.add(degreeFile);
    }
  }

  void _addPatientFields(http.MultipartRequest response) {
    response.fields.addAll({
      'name': fullName.text,
      'address': address.text,
      'age': age.value.toString(),
      'gender': gender.value,
      'height': height.value.toInt().toString(),
      'weight': weight.value.toInt().toString(),
      'bloodGroup': bloodGroup.value,
      'medicalHistory': medicalHistory.text,
      'insuranceType': insuranceType.value,
    });

    _addInsuranceFields(response);
  }

  void _addInsuranceFields(http.MultipartRequest response) {
    if (insuranceType.value.contains('insurance_type_option_1'.tr)) {
      response.fields['insuranceNumber'] = insuranceNumber.text;
      if (assuranceType.value.isNotEmpty) response.fields['assuranceType'] = assuranceType.value;
    } else if (insuranceType.value.contains('insurance_type_option_2'.tr)) {
      response.fields['insuranceNumber'] = insuranceNumber.text;

      if (assuranceType.value.isNotEmpty) response.fields['assuranceType'] = assuranceType.value;

      response.fields['mainInsurance'] = mainInsurance.text;
      response.fields['entitledInsurance'] = entitledInsurance.text;
    } else {
      response.fields['insuranceRegistry'] = registry.text;
      response.fields['insuranceRegisteredAddress'] = registryAddress.text;
      response.fields['insuranceValidFrom'] = validFrom.value?.toIso8601String() ?? '';
    }
  }

  void _handleCreateAccountError(Map<String, dynamic> data) {
    error.value = '';
    if (data['message'] is List) {
      for (var errorMsg in data['message']) {
        error.value += '$errorMsg\n';
      }
    } else if (data['message'] is String) {
      error.value = data['message'];
    } else {
      error.value = 'create_account_error'.tr;
    }
    success.value = false;
  }

  // ==================== UTILITY METHODS ====================

  void clearErrors() {
    _resetValidationErrors();
    error.value = '';
  }

  Future<void> storeToken(String token) async {
    if (StorageService.checkData(key: LocalStorageKeys.token)) {
      StorageService.removeData(key: LocalStorageKeys.token);
    }
    StorageService.writeBoolData(key: LocalStorageKeys.isTokenExist, value: true);
    StorageService.writeStringData(key: LocalStorageKeys.token, value: token);
  }

  void clear() {
    // Reset form data
    selectedCountry.value = Country.unitedStates;
    phoneNumber.clear();
    verifyCode.value = '';
    userType.value = _patientUserType;
    avatarImage.value = null;
    email.clear();
    password.clear();

    // Reset doctor fields
    identify.value = 1;
    idImage.value = null;
    degreeImage.value = null;
    professionalNumber.clear();

    // Reset patient fields
    fullName.clear();
    age.value = 18;
    gender.value = '';
    height.value = 1.0;
    weight.value = 40;
    bloodGroup.value = '';
    medicalHistory.clear();
    insuranceType.value = 'Public';
    insuranceNumber.clear();
    assuranceType.value = '';
    address.clear();
    mainInsurance.clear();
    entitledInsurance.clear();

    // Reset error states
    clearErrors();
    emailErrorText.value = 'email_error_blank'.tr;
    passwordErrorText.value = 'password_error_blank'.tr;
    verifyError.value = false;
    isPasswordVisible.value = false;
    termAndCondition.value = false;

    // Reset step states
    step.value = false;
    step2.value = false;
    step3.value = false;
    isPicked.value = 0;
    step4.value = false;
    success.value = false;
  }
}
