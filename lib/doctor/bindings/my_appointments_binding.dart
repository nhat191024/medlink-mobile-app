import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/doctor/controllers/my_appointments_controller.dart';

class DoctorMyAppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorMyAppointmentsControllers>(() => DoctorMyAppointmentsControllers());
  }
}
