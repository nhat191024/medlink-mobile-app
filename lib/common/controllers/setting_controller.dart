import 'package:medlink/utils/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medlink/model/transaction_history_model.dart';

class SettingControllers extends GetxController {
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
  // WALLET & TRANSACTIONS
  //============================================================================
  final RxInt balance = 0.obs;
  final RxList<TransactionHistoryModel> transactionHistories = <TransactionHistoryModel>[].obs;
  final filterDate = DateTime.now().obs;
  final RxInt selectedBank = 0.obs;
  final TextEditingController rechargeAmount = TextEditingController();
  final RxBool isRechargeAmountError = false.obs;
  final TextEditingController withdrawAmount = TextEditingController();
  final RxBool iswithdrawAmountError = false.obs;
  final RxBool isLoadingWallet = false.obs;

  //============================================================================
  // CARD INFORMATION
  //============================================================================
  final TextEditingController cardName = TextEditingController();
  final RxBool isCardNameError = false.obs;
  final TextEditingController cardNumber = TextEditingController();
  final RxBool isCardNumberError = false.obs;
  final TextEditingController cardExpiry = TextEditingController();
  final RxBool isCardExpiryError = false.obs;
  final TextEditingController cardCvv = TextEditingController();
  final RxBool isCardCvvError = false.obs;

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
    await fetchTransactionHistory();
    await loadInfo();
    isLoading.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    _disposeControllers();
    cardName.dispose();
    cardNumber.dispose();
    cardExpiry.dispose();
    cardCvv.dispose();
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

    if (StorageService.checkData(key: 'balance')) {
      balance.value = int.parse(StorageService.readData(key: 'balance').toString());
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
        Get.snackbar('success'.tr, data['message']);
      }
    } catch (e) {
      Get.snackbar(
        'erorr'.tr,
        'failed_to_change_password'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
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
  // WALLET & TRANSACTION METHODS
  //============================================================================
  Future<void> fetchTransactionHistory() async {
    isLoadingWallet.value = true;
    try {
      final response = await get(
        Uri.parse('${Apis.api}wallet/transactions'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      final data = jsonDecode(response.body);

      transactionHistories.clear();
      if (response.statusCode == 200) {
        for (var item in data) {
          final transaction = TransactionHistoryModel.fromJson(item);
          transactionHistories.add(transaction);
        }
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_load_transactions_history'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
      debugPrint('Error loading transaction history: $e');
    } finally {
      isLoadingWallet.value = false;
    }
  }

  Future<void> rechargeWallet() async {
    try {
      if (!checkRechargeAmount()) return;

      final url = Uri.parse('${Apis.api}wallet/recharge-qr');
      final response = http.MultipartRequest("POST", url);

      response.headers['Authorization'] = 'Bearer $_token';
      response.headers['Content-Type'] = 'application/json';
      response.headers['Accept'] = 'application/json';

      response.fields['amount'] = rechargeAmount.text;

      var streamedResponse = await response.send();
      var responseBody = await streamedResponse.stream.bytesToString();
      var json = jsonDecode(responseBody);
      if (streamedResponse.statusCode == 200) {
        var data = json['data'];
        var checkoutUrl = data['qrCodeUrl'];

        debugPrint('userType: ${userType.value}');

        Get.toNamed(
          Routes.webViewScreen,
          arguments: {
            'qrPageUrl': checkoutUrl,
            'isRecharge': true,
            'transactionId': data['transactionId'],
            'userType': userType.value,
          },
        );
      } else {
        Get.snackbar(
          'error'.tr,
          json['message'] ?? 'failed_to_recharge_wallet'.tr,
          colorText: AppColors.errorMain,
          backgroundColor: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_recharge_wallet'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
    }
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
      Get.snackbar(
        'error'.tr,
        'failed_to_load_settings'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
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
      response.headers['Authorization'] = 'Bearer $_token';
      response.headers['Accept'] = 'application/json';
      response.headers['Content-Type'] = 'application/json';

      response.fields.addAll({'name': name, 'value': value.toString()});

      var streamedResponse = await response.send();

      if (streamedResponse.statusCode == 200) {
        //
      } else {
        Get.snackbar(
          'error'.tr,
          'failed_to_update_settings'.tr,
          colorText: AppColors.errorMain,
          backgroundColor: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_update_settings'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
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
        Get.snackbar(
          'success'.tr,
          'support_sent_successfully'.tr,
          colorText: AppColors.successMain,
          backgroundColor: AppColors.white,
        );
      } else {
        Get.snackbar(
          'error'.tr,
          'failed_to_send_support'.tr,
          colorText: AppColors.errorMain,
          backgroundColor: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_send_support'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
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
        Uri.parse('${Apis.api}logout'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        _clearUserData();
        Get.deleteAll();
        Get.toNamed(Routes.splashScreen);
      } else {
        Get.snackbar(
          'error'.tr,
          'failed_to_logout'.tr,
          colorText: AppColors.errorMain,
          backgroundColor: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_logout'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
    }
  }

  //============================================================================
  // BANK ACCOUNT DATA
  //============================================================================
  //TODO - Replace with actual API call to fetch bank accounts
  final List<Map<String, dynamic>> bankAccounts = [
    {'id': 1, 'bank': 'PayOs', 'number': 'Nạp qua mã QR', 'expiry': 'N/A', 'name': 'PayOs'},
  ];

  //============================================================================
  // CARD VALIDATION METHODS
  //============================================================================
  void checkCardInfo() {
    _validateCardName();
    _validateCardNumber();
    _validateCardExpiry();
    _validateCardCvv();
  }

  void _validateCardName() {
    isCardNameError.value = cardName.text.isEmpty;
  }

  void _validateCardNumber() {
    isCardNumberError.value = cardNumber.text.isEmpty;
  }

  void _validateCardExpiry() {
    isCardExpiryError.value = cardExpiry.text.isEmpty;
  }

  void _validateCardCvv() {
    isCardCvvError.value = cardCvv.text.isEmpty;
  }

  bool get isCardFormValid {
    return !isCardNameError.value &&
        !isCardNumberError.value &&
        !isCardExpiryError.value &&
        !isCardCvvError.value &&
        cardName.text.isNotEmpty &&
        cardNumber.text.isNotEmpty &&
        cardExpiry.text.isNotEmpty &&
        cardCvv.text.isNotEmpty;
  }

  //============================================================================
  // HELPER METHODS
  //============================================================================
  // void clearCardForm() {
  //   cardName.clear();
  //   cardNumber.clear();
  //   cardExpiry.clear();
  //   cardCvv.clear();
  //   isCardNameError.value = false;
  //   isCardNumberError.value = false;
  //   isCardExpiryError.value = false;
  //   isCardCvvError.value = false;
  // }

  void filterTransactionsByDate(DateTime date) {
    filterDate.value = date;
    // Add logic to filter transactions by date
  }

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

  void checkWithdrawAmount() {
    if (withdrawAmount.text.isEmpty) {
      iswithdrawAmountError.value = true;
      Get.snackbar(
        'error'.tr,
        'ammount_required'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
      return;
    }
    double amount = double.tryParse(withdrawAmount.text) ?? 0.0;
    if (amount > balance.value) {
      iswithdrawAmountError.value = true;
      Get.snackbar(
        'error'.tr,
        'insufficient_funds'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
    } else if (balance.value - amount <= 1000000) {
      iswithdrawAmountError.value = true;
      Get.snackbar(
        'error'.tr,
        'minimum_balance'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
    }
  }

  bool checkRechargeAmount() {
    if (rechargeAmount.text.isEmpty) {
      isRechargeAmountError.value = true;
      Get.snackbar(
        'error'.tr,
        'ammount_required'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
      return false;
    }
    double amount = double.tryParse(rechargeAmount.text) ?? 0.0;
    if (amount <= 0) {
      isRechargeAmountError.value = true;
      Get.snackbar(
        'error'.tr,
        'invalid_amount'.tr,
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
      return false;
    } else {
      isRechargeAmountError.value = false;
      return true;
    }
  }

  void debug(String text) {
    debugPrint(text);
  }

  String formatPrice(int price) {
    final formatted = NumberFormat('#,##0', 'en_US').format(price);
    return '$formatted ${"currency".tr}';
  }
}
