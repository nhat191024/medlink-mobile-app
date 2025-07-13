import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/doctor/controllers/settings/work_schedules_controller.dart';

class WorkingScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkSchedulesController>(() => WorkSchedulesController());
  }
}
