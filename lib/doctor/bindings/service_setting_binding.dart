import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/doctor/controllers/settings/service_controller.dart';

class ServiceSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceController>(() => ServiceController());
  }
}
