import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/setting_controller.dart';

import 'package:medlink/components/button/plus.dart';

class LogoutScreen extends GetView<SettingControllers> {
  LogoutScreen({super.key});

  @override
  final SettingControllers controller = Get.put(SettingControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary50,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        height: 200,
                        width: 200,
                        child: Image.asset(AppImages.ellipse1, fit: BoxFit.cover),
                      ),
                      const SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: 100,
                          strokeWidth: 8,
                          backgroundColor: AppColors.primary600,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary600),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        child: Image.asset(AppImages.logo, width: 40),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Text(
                      'logout_confirm'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: AppFontStyleTextStrings.bold,
                        color: AppColors.primary600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Text(
                      'logout_description'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryText,
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButtonPlus(
                    onTap: () {
                      Get.back();
                    },
                    btnText: 'keep_stay'.tr,
                    width: Get.width / 1.6,
                    height: Get.height / 15,
                    bottomPadding: 5,
                  ),
                  CustomButtonPlus(
                    onTap: () {
                      controller.logout();
                    },
                    btnText: 'logout_btn'.tr,
                    width: Get.width / 1.6,
                    height: Get.height / 15,
                    color: AppColors.primary50,
                    borderColor: AppColors.primaryText,
                    textColor: AppColors.primaryText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
