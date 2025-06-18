import 'package:medlink/common/utils/common_imports.dart';
import 'package:medlink/utils/app_imports.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
