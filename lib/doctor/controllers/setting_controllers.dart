import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/model/transaction_history_model.dart';
import 'package:intl/intl.dart';

class DoctorSettingControllers extends GetxController with GetSingleTickerProviderStateMixin {
  //============================================================================
  // USER INFORMATION
  //============================================================================
  final RxBool saveBankInfo = false.obs;

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
  // WALLET & TRANSACTIONS
  //============================================================================
  final RxString balance = '0.00'.obs;
  final RxList<TransactionHistoryModel> transactionHistories = <TransactionHistoryModel>[].obs;
  final filterDate = DateTime.now().obs;
  final RxInt selectedBank = 0.obs;
  final TextEditingController withdrawAmount = TextEditingController();

  //============================================================================
  // SETTINGS
  //============================================================================

  //============================================================================
  // LOADING STATES
  //============================================================================
  final RxBool isLoading = false.obs;
  final RxBool isLoadingWallet = false.obs;

  //============================================================================
  // PRIVATE PROPERTIES
  //============================================================================
  String? get _token => StorageService.readData(key: LocalStorageKeys.token);

  //============================================================================
  // LIFECYCLE METHODS
  //============================================================================
  @override
  void onInit() async {
    fetchWalletBalance();
    fetchTransactionHistory();
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
    cardName.dispose();
    cardNumber.dispose();
    cardExpiry.dispose();
    cardCvv.dispose();
    withdrawAmount.dispose();
  }

  //============================================================================
  // USER INFORMATION METHODS
  //============================================================================

  bool checkIfDefaultAvatar(String avatar) {
    avatar = avatar.split('/').last;
    return avatar.contains('default.png');
  }

  //============================================================================
  // WALLET & TRANSACTION METHODS
  //============================================================================
  Future<void> fetchWalletBalance() async {
    isLoadingWallet.value = true;
    try {
      final response = await get(
        Uri.parse('${Apis.api}wallet/balance'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        balance.value = data['balance'].toStringAsFixed(2);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wallet balance');
    } finally {
      isLoadingWallet.value = false;
    }
  }

  Future<void> fetchTransactionHistory() async {
    isLoadingWallet.value = true;
    try {
      final response = await get(
        Uri.parse('${Apis.api}wallet/transactions'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      final data = jsonDecode(response.body);

      transactionHistories.clear();
      if (response.statusCode == 200 && data['transactions'] != null) {
        for (var item in data['transactions']) {
          transactionHistories.add(
            TransactionHistoryModel(
              id: item['id'],
              type: int.parse(item['type'].toString()),
              name: item['reason'],
              amount: item['amount'].toDouble(),
              date: DateFormat('dd/MM/yyyy').format(DateTime.parse(item['created_at'])),
            ),
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load transaction history');
    } finally {
      isLoadingWallet.value = false;
    }
  }

  //============================================================================
  // BANK ACCOUNT DATA
  //============================================================================
  //TODO - Replace with actual API call to fetch bank accounts
  final List<Map<String, dynamic>> bankAccounts = [
    {
      'id': 1,
      'bank': 'Bank of America',
      'number': '**** **** **** 1234',
      'expiry': '12/2023',
      'name': 'John Doe',
    },
    {
      'id': 2,
      'bank': 'Chase Bank',
      'number': '**** **** **** 5678',
      'expiry': '12/2023',
      'name': 'John Doe',
    },
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
  // UTILITY METHODS
  //============================================================================
  void clearCardForm() {
    cardName.clear();
    cardNumber.clear();
    cardExpiry.clear();
    cardCvv.clear();
    isCardNameError.value = false;
    isCardNumberError.value = false;
    isCardExpiryError.value = false;
    isCardCvvError.value = false;
  }

  void filterTransactionsByDate(DateTime date) {
    filterDate.value = date;
    // Add logic to filter transactions by date
  }
}
