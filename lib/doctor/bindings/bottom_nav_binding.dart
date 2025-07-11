import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/doctor/controllers/bottom_nav_controller.dart';

class DoctorBottomTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorBottomNavController>(() => DoctorBottomNavController());
  }
}
