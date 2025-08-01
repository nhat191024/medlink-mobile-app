import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

class PatientBottomNav extends GetView<PatientBottomNavController> {
  const PatientBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.currentScreen),
      bottomNavigationBar: Obx(() {
        return SizedBox(
          height: 75,
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  controller.selectedIndex.value == 0 ? AppImages.homeSelect : AppImages.home,
                ),
                label: 'dashboard'.tr,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  controller.selectedIndex.value == 1 ? AppImages.searchSelect : AppImages.searchUnselect,
                ),
                label: 'search_nav'.tr,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  controller.selectedIndex.value == 2 ? AppImages.messageSelect : AppImages.messageTyping,
                ),
                label: 'messages'.tr,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  controller.selectedIndex.value == 3 ? AppImages.calenderSelect : AppImages.calenderCheck,
                ),
                label: 'appointments'.tr,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  controller.selectedIndex.value == 4 ? AppImages.gearSixSelect : AppImages.gearSix,
                ),
                label: 'settings'.tr,
              ),
            ],
            selectedItemColor: AppColors.primary600,
            unselectedItemColor: AppColors.disable,
            selectedLabelStyle: const TextStyle(
              fontFamily: AppFontStyleTextStrings.regular,
              fontSize: 12,
              color: AppColors.primary600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: AppFontStyleTextStrings.regular,
              fontSize: 12,
              color: AppColors.disable,
            ),
            onTap: (index) {
              controller.changeIndex(index);
            },
          ),
        );
      }),
    );
  }
}
