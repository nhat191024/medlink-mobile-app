import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/setting_controller.dart';

import 'package:medlink/components/widget/settings/setting_title.dart';

class MessageSettingScreen extends GetView<SettingControllers> {
  const MessageSettingScreen({super.key});

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
              'message_setting'.tr,
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
                      title: 'message_delivery'.tr,
                      description: 'message_delivery_description'.tr,
                      value: controller.message.value,
                      onChanged: (value) {
                        controller.message.value = value;
                        value
                            ? controller.updateSetting("message", 1)
                            : controller.updateSetting("message", 0);
                      },
                    ),
                    SettingTile(
                      icon: AppImages.gift,
                      title: 'message_appearance'.tr,
                      description: 'message_appearance_description'.tr,
                      value: controller.customMessage.value,
                      onChanged: (value) {
                        controller.customMessage.value = value;
                        value
                            ? controller.updateSetting("customMessage", 1)
                            : controller.updateSetting("customMessage", 0);
                      },
                    ),
                    SettingTile(
                      icon: AppImages.messageNotifySquare,
                      title: 'message_privacy'.tr,
                      description: 'message_privacy_description'.tr,
                      value: controller.messagePrivacy.value,
                      onChanged: (value) {
                        controller.messagePrivacy.value = value;
                        value
                            ? controller.updateSetting("messagePrivacy", 1)
                            : controller.updateSetting("messagePrivacy", 0);
                      },
                    ),
                    SettingTile(
                      icon: AppImages.confettiIcon,
                      title: 'message_backup'.tr,
                      description: 'message_backup_description'.tr,
                      value: controller.messageBackup.value,
                      onChanged: (value) {
                        controller.messageBackup.value = value;
                        value
                            ? controller.updateSetting("messageBackup", 1)
                            : controller.updateSetting("messageBackup", 0);
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
