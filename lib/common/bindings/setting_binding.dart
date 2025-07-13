import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingControllers>(() => SettingControllers());
  }
}
