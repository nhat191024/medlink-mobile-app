import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/utils/common_imports.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}