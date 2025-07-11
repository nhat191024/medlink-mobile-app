import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/doctor/screens/home_screen.dart';
import 'package:medlink/doctor/controllers/home_controller.dart';

class DoctorBottomNavController extends GetxController {
  final DoctorHomeController controllers = Get.put(DoctorHomeController());
  var selectedIndex = 0.obs;

  final List<Widget> screens = [
    DoctorHomeScreen(),
    // MessagesScreen(),
    // DoctorMyAppointmentsScreen(),
    // SettingScreen(),
  ];

  Widget get currentScreen => screens[selectedIndex.value];

  void changeIndex(int index) {
    selectedIndex.value = index;
    controllers.currentIndex = index;
  }
}
