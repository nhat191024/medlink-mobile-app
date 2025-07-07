import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

class PatientBottomNavController extends GetxController {
  final PatientHomeController controllers = Get.put(PatientHomeController());
  var selectedIndex = 0.obs;

  final List<Widget> screens = [
    PatientHomeScreen(),
    SearchCategoryScreen(),
    // MessagesScreen(),
    // PatientMyAppointmentsScreen(),
    // SettingScreen(),
  ];

  Widget get currentScreen => screens[selectedIndex.value];

  void changeIndex(int index) {
    selectedIndex.value = index;
    controllers.currentIndex = index;
  }
}
