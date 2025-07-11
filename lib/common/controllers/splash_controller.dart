import 'package:medlink/utils/app_imports.dart';

class SplashController extends GetxController {
  static const String _doctorUserType = 'healthcare';
  static const String _patientUserType = 'patient';

  static const Duration _requestTimeout = Duration(seconds: 8);
  static const Duration _splashDelay = Duration(milliseconds: 1500);

  final isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(_splashDelay);
      await _checkUserAuthentication();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _checkUserAuthentication() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = StorageService.readData(key: LocalStorageKeys.token);

      if (token == null || token.isEmpty) {
        return;
      }

      await _validateToken(token);
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _validateToken(String token) async {
    try {
      final response = await get(
        Uri.parse('${Apis.api}token-check'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        await _handleSuccessfulAuth(response);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
        return;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout. Please check your internet connection.');
    } on SocketException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  Future<void> _handleSuccessfulAuth(Response responseBody) async {
    try {
      var data = jsonDecode(responseBody.body);
      final String? userType = data['userType']?.toString();

      if (userType == _doctorUserType) {
        Get.offAllNamed(Routes.doctorHomeScreen);
      } else if (userType == _patientUserType) {
        Get.offAllNamed(Routes.patientHomeScreen);
      } else {
        throw Exception('Invalid user type received from server');
      }
    } catch (e) {
      throw Exception('Failed to parse server response');
    }
  }

  void _handleUnauthorized() {
    StorageService.removeData(key: LocalStorageKeys.token);
  }

  void _handleError(dynamic error) {
    isLoading.value = false;
    errorMessage.value = error.toString();

    debugPrint('SplashController Error: $error');

    return;
  }

  // Retry functionality
  void retry() {
    errorMessage.value = '';
    _checkUserAuthentication();
  }

  // getCC() {
  //   SharedPrefs.getUser().then((value) {
  //     if (value == null) return;
  //     ConnectyCubeSessionService.loginToCC(
  //       value,
  //       onTap: () => changeNotifier.updateString("Done"),
  //     );
  //   });
  // }
}
