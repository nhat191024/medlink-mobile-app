import 'package:medlink/utils/app_imports.dart';

class DoctorMyAppointmentsTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController doctorMyAppointmentsTabController;

  @override
  void onInit() {
    super.onInit();
    doctorMyAppointmentsTabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    doctorMyAppointmentsTabController.dispose();
    super.onClose();
  }
}
