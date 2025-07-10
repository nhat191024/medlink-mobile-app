import 'package:medlink/common/utils/common_imports.dart';
import 'package:medlink/utils/app_imports.dart';

class WebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebViewController>(() => WebViewController());
  }
}
