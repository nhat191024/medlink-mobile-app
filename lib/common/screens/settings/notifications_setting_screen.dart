import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/setting_controller.dart';

import 'package:medlink/components/widget/settings/setting_title.dart';

class NotificationsSettingScreen extends GetView<SettingControllers> {
  const NotificationsSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 60,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
              ),
            ),
            const Spacer(),
            Text(
              'notification_setting'.tr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: AppFontStyleTextStrings.bold,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SettingTile(
                      icon: AppImages.megaphone,
                      title: 'system_notification'.tr,
                      description: 'system_notification_description'.tr,
                      value: controller.notification.value,
                      onChanged: (value) {
                        controller.notification.value = value;
                        value
                            ? controller.updateSetting("notification", 1)
                            : controller.updateSetting("notification", 0);
                      },
                    ),
                    SettingTile(
                      icon: AppImages.gift,
                      title: 'promotion_announcement'.tr,
                      description: 'promotion_announcement_description'.tr,
                      value: controller.promotion.value,
                      onChanged: (value) {
                        controller.promotion.value = value;
                        value
                            ? controller.updateSetting("promotion", 1)
                            : controller.updateSetting("promotion", 0);
                      },
                    ),
                    SettingTile(
                      icon: AppImages.messageNotifySquare,
                      title: 'sms_notification'.tr,
                      description: 'sms_notification_description'.tr,
                      value: controller.sms.value,
                      onChanged: (value) {
                        controller.sms.value = value;
                        value
                            ? controller.updateSetting("sms", 1)
                            : controller.updateSetting("sms", 0);
                      },
                    ),
                    SettingTile(
                      icon: AppImages.confettiIcon,
                      title: 'push_notification'.tr,
                      description: 'push_notification_description'.tr,
                      value: controller.appNotification.value,
                      onChanged: (value) {
                        controller.appNotification.value = value;
                        value
                            ? controller.updateSetting("appNotification", 1)
                            : controller.updateSetting("appNotification", 0);
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
