import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/utils/common_imports.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Sử dụng controller đã tạo ở trên
class WebViewScreen extends GetView<WebViewController> {
  String get qrPageUrl => Get.arguments['qrPageUrl'] ?? '';

  WebViewScreen({super.key});

  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(qrPageUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              useHybridComposition: true,
              allowsInlineMediaPlayback: true,
            ),
            pullToRefreshController: controller.pullToRefreshController,
            onWebViewCreated: (webViewController) {
              controller.setWebViewController(webViewController);
            },
            onLoadStart: (webViewController, url) {
              final urlString = url.toString();
              controller.updateCurrentUrl(urlString);
              
              // Kiểm tra deep link ngay khi bắt đầu load
              if (controller.handleDeepLink(urlString)) {
                return;
              }
            },
            onLoadStop: (webViewController, url) async {
              controller.updateCurrentUrl(url.toString());
              controller.pullToRefreshController?.endRefreshing();
            },
            onProgressChanged: (webViewController, progress) {
              controller.updateProgress(progress);
            },
            shouldOverrideUrlLoading: (webViewController, navigationAction) async {
              final url = navigationAction.request.url.toString();
              
              // Xử lý deep link cho payment result
              if (controller.handleDeepLink(url)) {
                return NavigationActionPolicy.CANCEL;
              }
              
              // Cho phép các URL khác
              return NavigationActionPolicy.ALLOW;
            },
            onConsoleMessage: (webViewController, consoleMessage) {
              debugPrint("Console: ${consoleMessage.message}");
            },
            onPermissionRequest: (webViewController, request) async {
              return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
            onDownloadStartRequest: (webViewController, downloadStartRequest) async {
              debugPrint("Downloading file: ${downloadStartRequest.url}");
            },
          ),
          Obx(
            () => controller.progress.value < 1.0
                ? LinearProgressIndicator(value: controller.progress.value)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
