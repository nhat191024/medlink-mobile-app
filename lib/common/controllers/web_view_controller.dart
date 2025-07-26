import 'package:medlink/utils/app_imports.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class WebViewController extends GetxController {
  InAppWebViewController? webViewController;
  RxDouble progress = 0.0.obs;
  RxString currentUrl = "".obs;
  int? transactionId;
  String? userType;

  String? get _token => StorageService.readData(key: LocalStorageKeys.token);

  // PullToRefreshController cũng có thể được quản lý ở đây
  PullToRefreshController? pullToRefreshController;

  @override
  void onInit() {
    super.onInit();
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: AppColors.primary600),
      onRefresh: () async {
        if (webViewController != null) {
          await webViewController!.reload();
        }
      },
    );
  }

  void setData(int id, String type) {
    transactionId = id;
    userType = type;
  }

  void setWebViewController(InAppWebViewController controller) {
    webViewController = controller;
  }

  void updateProgress(int newProgress) {
    progress.value = newProgress / 100;
  }

  void updateCurrentUrl(String url) {
    currentUrl.value = url;
  }

  void reloadWebView() {
    webViewController?.reload();
  }

  // Xử lý deep link khi thanh toán hoàn tất
  bool handleDeepLink(String url) {
    debugPrint("WebView URL: $url");

    final uri = Uri.parse(url);
    final parameters = <String, String>{};

    uri.queryParameters.forEach((key, value) {
      parameters[key] = value;
    });

    if (url.startsWith('app://medlinkapp/payment-result')) {
      debugPrint("Payment completed, navigating to result screen");

      final uri = Uri.parse(url);
      final parameters = <String, String>{};

      uri.queryParameters.forEach((key, value) {
        parameters[key] = value;
      });

      Get.offNamed(Routes.paymentResultScreen, arguments: parameters);
      return true;
    } else if (url.startsWith('app://medlinkapp/back')) {
      final cancel = parameters['cancel'];
      debugPrint("Back deep link detected, navigating back");

      if (cancel == 'false') {
        debugPrint("Recharge confirmed, transaction ID: $transactionId");
        confirmRechage();
      }

      debugPrint(userType);

      if (userType == 'patient') {
        Get.toNamed(Routes.patientHomeScreen);
      } else if (userType == 'healthcare') {
        Get.toNamed(Routes.doctorHomeScreen);
      }

      return true;
    }

    if (url.startsWith('app://medlinkapp/')) {
      debugPrint("Medlink deep link detected: $url");
      return true;
    }

    return false;
  }

  Future<void> confirmRechage() async {
    try {
      final url = Uri.parse('${Apis.api}wallet/recharge');
      final response = http.MultipartRequest("POST", url);

      response.headers['Authorization'] = 'Bearer $_token';
      response.headers['Content-Type'] = 'application/json';
      response.headers['Accept'] = 'application/json';

      response.fields['transaction_id'] = transactionId.toString();

      var streamedResponse = await response.send();
      var responseBody = await streamedResponse.stream.bytesToString();
      var json = jsonDecode(responseBody);
      if (streamedResponse.statusCode == 200) {
        debugPrint('Recharge successful');
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
}
