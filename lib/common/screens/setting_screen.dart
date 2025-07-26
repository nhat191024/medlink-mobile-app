import 'dart:ui';

import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/setting_controller.dart';

import 'package:medlink/components/widget/settings/doctor_wallet_header.dart';

class SettingScreen extends GetView<SettingControllers> {
  SettingScreen({super.key});

  final SettingControllers controllers = Get.put(SettingControllers());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: AppColors.background,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Obx(
                        () => Container(
                          height: 64,
                          width: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.primary50,
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: controller.avatar.value.isEmpty
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary600,
                                      ),
                                    ),
                                  ),
                                )
                              : Image.network(
                                  controller.avatar.value,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primary600,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 32,
                                      color: AppColors.secondaryText,
                                    );
                                  },
                                ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primary600,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                            onPressed: () {
                              Get.toNamed(Routes.profileScreen);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.username.value,
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 16,
                                  fontFamily: AppFontStyleTextStrings.bold,
                                ),
                                maxLines: 2,
                              ),
                              if (controller.identity.contains("doctor"))
                                Text(
                                  controller.specialty.value,
                                  style: const TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 14,
                                    fontFamily: AppFontStyleTextStrings.regular,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.notificationScreen);
                    },
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(12),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(AppImages.bell),
                          if (controller.isHaveNotificationUnread.value)
                            const Positioned(
                              top: 4,
                              right: 0,
                              child: CircleAvatar(backgroundColor: AppColors.errorMain, radius: 4),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: AppColors.background,
            body: Stack(
              children: [
                DoctorWalletHeader(controller: controller),
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: Get.width,
                        margin: EdgeInsets.only(top: 100),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 25, 0, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Text(
                                    'general'.tr,
                                    style: const TextStyle(
                                      color: AppColors.secondaryText,
                                      fontFamily: AppFontStyleTextStrings.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _buildListItem(
                                  'my_profile'.tr,
                                  AppImages.userProfile2,
                                  AppColors.primaryText,
                                  () {
                                    Get.toNamed(Routes.profileScreen);
                                  },
                                ),
                                if (controller.userType.value == 'healthcare')
                                  _buildListItem(
                                    'working_schedule'.tr,
                                    AppImages.briefcase,
                                    AppColors.primaryText,
                                    () {
                                      Get.toNamed(Routes.workSchedulesScreen);
                                    },
                                  ),
                                if (controller.userType.value == 'healthcare') ...[
                                  if (controller.identity.contains("doctor"))
                                    _buildListItem(
                                      'my_services'.tr,
                                      AppImages.firstAidKit,
                                      AppColors.primaryText,
                                      () {
                                        Get.toNamed(Routes.myServiceScreen);
                                      },
                                    ),
                                ] else ...[
                                  _buildListItem(
                                    'favorite_doctor'.tr,
                                    AppImages.heart,
                                    AppColors.primaryText,
                                    () {},
                                  ),
                                ],
                                if (controller.userType.value == 'healthcare') ...[
                                  _buildListItem(
                                    'patient_records'.tr,
                                    AppImages.file,
                                    AppColors.primaryText,
                                    () {
                                      Get.toNamed(Routes.patientListRecordScreen);
                                    },
                                  ),
                                ] else ...[
                                  _buildListItem(
                                    'medical_records'.tr,
                                    AppImages.file,
                                    AppColors.primaryText,
                                    () {},
                                  ),
                                ],
                                if (controller.userType.value == 'healthcare')
                                  _buildListItem(
                                    'marketing'.tr,
                                    AppImages.megaphone,
                                    AppColors.primaryText,
                                    () {},
                                    isDisabled: true,
                                  ),
                                _buildListItem(
                                  'change_password'.tr,
                                  AppImages.lockOpened,
                                  AppColors.primaryText,
                                  () {
                                    Get.toNamed(Routes.changePasswordScreen);
                                  },
                                ),
                                _buildListItem(
                                  'change_language'.tr,
                                  AppImages.translate,
                                  AppColors.primaryText,
                                  () {
                                    _languagePick(
                                      context,
                                      'select_language'.tr,
                                      controller.languages,
                                      controller.flag,
                                      controller.language,
                                    );
                                  },
                                ),
                                const Divider(color: AppColors.dividers, thickness: 1),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  child: Text(
                                    'more_setting'.tr,
                                    style: const TextStyle(
                                      color: AppColors.secondaryText,
                                      fontFamily: AppFontStyleTextStrings.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _buildListItem(
                                  'notification_setting'.tr,
                                  AppImages.bellRinging,
                                  AppColors.primaryText,
                                  () {
                                    Get.toNamed(Routes.notificationsSettingScreen);
                                  },
                                ),
                                _buildListItem(
                                  'message_setting'.tr,
                                  AppImages.messageSquare,
                                  AppColors.primaryText,
                                  () {
                                    Get.toNamed(Routes.messageSettingScreen);
                                  },
                                ),
                                _buildListItem(
                                  'support'.tr,
                                  AppImages.question,
                                  AppColors.primaryText,
                                  () {
                                    Get.toNamed(Routes.supportScreen);
                                  },
                                ),
                                _buildListItem(
                                  'privacy_policy'.tr,
                                  AppImages.shieldCheck,
                                  AppColors.primaryText,
                                  () {},
                                  isDisabled: true,
                                ),
                                const Divider(color: AppColors.dividers, thickness: 1),
                                _buildListItem(
                                  'logout'.tr,
                                  AppImages.logout,
                                  AppColors.primary600,
                                  iconColor: AppColors.errorMain,
                                  () {
                                    Get.toNamed(Routes.logoutScreen);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Loading overlay
                if (controller.isLoading.value)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary600),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    String title,
    String icon,
    Color textColor,
    VoidCallback onTap, {
    bool isDisabled = false,
    Color iconColor = AppColors.primaryText,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(isDisabled ? AppColors.disable : iconColor, BlendMode.srcIn),
      ),
      horizontalTitleGap: 0,
      minVerticalPadding: 0,
      title: Text(
        title,
        style: TextStyle(
          color: isDisabled ? AppColors.disable : textColor,
          fontSize: 16,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
      ),
      onTap: isDisabled ? null : onTap,
    );
  }

  Future<Object?> _languagePick(
    BuildContext context,
    String label,
    List list,
    List flag,
    RxString currentLanguage,
  ) {
    var selectedLanguage = currentLanguage;
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: AppFontStyleTextStrings.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            currentLanguage.value = selectedLanguage.value;
                            Navigator.pop(context);
                          },
                          child: Text(
                            'save'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: AppFontStyleTextStrings.bold,
                              decoration: TextDecoration.underline,
                              color: AppColors.primary600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.dividers, thickness: 1),
                  ...list.map(
                    (type) => Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: type == selectedLanguage.value
                              ? Colors.red.shade100
                              : Colors.transparent,
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              SvgPicture.asset(
                                flag[list.indexOf(type)],
                                width: 25,
                                height: 25,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                type,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppFontStyleTextStrings.regular,
                                  color: type == selectedLanguage.value
                                      ? AppColors.primary600
                                      : AppColors.primaryText,
                                ),
                              ),
                            ],
                          ),
                          trailing: type == selectedLanguage.value
                              ? const Icon(Icons.check, color: AppColors.primary600)
                              : const SizedBox.shrink(),
                          tileColor: type == selectedLanguage.value
                              ? AppColors.primary50
                              : Colors.transparent,
                          onTap: () {
                            selectedLanguage.value = type;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withValues(alpha: 0.1)),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ],
        );
      },
    );
  }
}
