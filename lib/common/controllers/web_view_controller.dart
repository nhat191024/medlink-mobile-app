import 'package:medlink/utils/app_imports.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewController extends GetxController {
  InAppWebViewController? webViewController;
  RxDouble progress = 0.0.obs;
  RxString currentUrl = "".obs;

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
    
    if (url.startsWith('app://medlinkapp/payment-result')) {
      debugPrint("Payment completed, navigating to result screen");
      
      final uri = Uri.parse(url);
      final parameters = <String, String>{};
      
      uri.queryParameters.forEach((key, value) {
        parameters[key] = value;
      });
      
      Get.offNamed(Routes.paymentResultScreen, arguments: parameters);
      return true;
    }
    
    if (url.startsWith('app://medlinkapp/')) {
      debugPrint("Medlink deep link detected: $url");
      return true;
    }
    
    return false;
  }
}
