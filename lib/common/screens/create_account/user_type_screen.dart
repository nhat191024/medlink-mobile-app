import 'dart:ui';

import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';
import 'package:medlink/components/widget/circular_progress_step.dart';

class UserTypeScreen extends GetView<CreateAccountController> {
  const UserTypeScreen({super.key});

  // Constants
  static const int _currentStep = 3;
  static const int _totalSteps = 7;
  static const String _doctorUserType = 'healthcare';
  static const String _patientUserType = 'patient';
  static const double _imageBgHeightRatio = 0.5;
  static const double _cardHeight = 0.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.border,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildHeader(),
          _buildAppTitle(),
          _buildBackgroundImage(),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Row(
          children: [
            ComeBackButton(),
            Spacer(),
            CircularProgressStep(step: _currentStep, totalSteps: _totalSteps),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Positioned(
      top: Get.height * 0.18,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'user_type_title'.tr,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'app_name'.tr,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned(
      top: 80,
      left: 40,
      right: 0,
      child: Container(
        height: Get.height * _imageBgHeightRatio,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.doctorNurse),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
  Widget _buildBottomSheet() {
    return Positioned(
      top: Get.height * 0.54,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: Get.height * 0.46,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.color3.withValues(alpha: 0.5),
            ),
            child: Column(
              children: [
                _buildSheetHeader(),
                const SizedBox(height: 30),
                Expanded(child: _buildUserTypeCards()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: Row(
        children: [
          Text(
            "user_type_subtitle".tr,
            style: const TextStyle(
              fontSize: 28,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
          const Spacer(),
          _buildStethoscopeIcon(),
        ],
      ),
    );
  }

  Widget _buildStethoscopeIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.WHITE,
        boxShadow: [
          BoxShadow(
            color: AppColors.BLACK.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: SvgPicture.asset(
        AppImages.stethoscope,
        height: 60,
        width: 60,
        fit: BoxFit.scaleDown,
      ),
    );
  }
  Widget _buildUserTypeCards() {
    return Row(
      children: [
        Expanded(child: _buildDoctorCard()),
        const SizedBox(width: 12),
        Expanded(child: _buildPatientCard()),
      ],
    );
  }

  Widget _buildDoctorCard() {
    return Obx(
      () => _buildUserTypeCard(
        userType: _doctorUserType,
        isSelected: controller.userType.value == _doctorUserType,
        icon: AppImages.firstAid,
        title: 'user_type_doctor_title'.tr,
        subtitle: "user_type_doctor_subtitle".tr,
        onTap: () => _handleUserTypeSelection(_doctorUserType),
      ),
    );
  }

  Widget _buildPatientCard() {
    return Obx(
      () => _buildUserTypeCard(
        userType: _patientUserType,
        isSelected: controller.userType.value == _patientUserType,
        icon: AppImages.pill,
        title: 'user_type_patient_title'.tr,
        subtitle: "user_type_patient_subtitle".tr,
        onTap: () => _handleUserTypeSelection(_patientUserType),
      ),
    );
  }  // User type card builder
  Widget _buildUserTypeCard({
    required String userType,
    required bool isSelected,
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: '$title - $subtitle',
      hint: isSelected ? 'Selected' : 'Tap to select',
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: Get.width / 2 - 18,
          height: Get.height * _cardHeight,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary600 : AppColors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                  ? AppColors.primary600.withValues(alpha: 0.3)
                  : AppColors.BLACK.withValues(alpha: 0.1),
                spreadRadius: isSelected ? 2 : 1,
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardIcon(icon, isSelected),
                const SizedBox(height: 16),
                _buildCardTitle(title, isSelected),
                const SizedBox(height: 8),
                _buildCardDivider(),
                const SizedBox(height: 8),
                _buildCardSubtitle(subtitle, isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardIcon(String icon, bool isSelected) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.white : AppColors.primary50,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SvgPicture.asset(
          icon,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildCardTitle(String title, bool isSelected) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: isSelected ? AppColors.white : AppColors.primary600,
        fontSize: 16,
        fontFamily: AppFontStyleTextStrings.bold,
      ),
    );
  }

  Widget _buildCardDivider() {
    return const Divider(
      color: AppColors.primary400,
      thickness: 2,
      indent: 0,
      endIndent: 60,
    );
  }

  Widget _buildCardSubtitle(String subtitle, bool isSelected) {
    return Expanded(
      child: Text(
        subtitle,
        style: TextStyle(
          color: isSelected ? AppColors.white : AppColors.primaryText,
          fontSize: 18,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Event handlers
  void _handleUserTypeSelection(String userType) {
    HapticFeedback.selectionClick();
    controller.userType.value = userType;

    // Add slight delay for visual feedback
    Future.delayed(const Duration(milliseconds: 200), () {
      Get.toNamed(Routes.createAccountScreen);
    });
  }
}
