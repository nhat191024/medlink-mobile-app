import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';


class PatientBottomTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientBottomNavController>(
      () => PatientBottomNavController(),
    );
  }
}
