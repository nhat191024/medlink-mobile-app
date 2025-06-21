import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';
import 'package:medlink/components/button/default.dart';
import 'package:medlink/components/widget/circular_progress_step.dart';
import 'package:medlink/components/field/image_upload.dart';
import 'package:medlink/components/field/text.dart';

class LicenseScreen extends GetView<CreateAccountController> {
  const LicenseScreen({super.key});

  // Constants
  static const int _currentStep = 6;
  static const int _totalSteps = 7;
  static const double _iconSize = 45.0;
  static const double _headerPadding = 5.0;
  static const String _doctorIdentity = 'doctor';
  static const String _pharmacyIdentity = 'pharmacy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildBody()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildHeaderContent(),
          const SizedBox(height: 10),
          _buildDescription(),
          _buildUploadSections(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        ComeBackButton(topPadding: _headerPadding),
        Spacer(),
        CircularProgressStep(
          topPadding: _headerPadding,
          step: _currentStep,
          totalSteps: _totalSteps,
        ),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        SvgPicture.asset(AppImages.stethoscope, height: _iconSize, width: _iconSize),
        const SizedBox(height: 10),
        Text(
          'license_title'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontFamily: AppFontStyleTextStrings.bold),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      "license_description".tr,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: AppFontStyleTextStrings.regular,
        color: AppColors.secondaryText,
      ),
    );
  }

  Widget _buildUploadSections() {
    return Column(
      children: [
        _buildIdCardUpload(),
        const SizedBox(height: 20),
        _buildDegreeUpload(),
        _buildProfessionalNumberField(),
      ],
    );
  }

  Widget _buildIdCardUpload() {
    final shouldShowIdCard = _shouldShowIdCardUpload();

    if (!shouldShowIdCard) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 20),
        ImageUploadField(
          labelText: "id_card".tr,
          labelColor: AppColors.secondaryText,
          hintText: "upload".tr,
          selectedImage: controller.idImage,
          isRequire: true,
          isValidate: false,
          onChanged: _handleImageUploadChange,
        ),
      ],
    );
  }

  Widget _buildDegreeUpload() {
    return ImageUploadField(
      labelText: _getDegreeUploadLabel(),
      labelColor: AppColors.secondaryText,
      hintText: "upload".tr,
      selectedImage: controller.degreeImage,
      isRequire: true,
      isValidate: false,
      onChanged: _handleImageUploadChange,
    );
  }

  Widget _buildProfessionalNumberField() {
    final shouldShowProfessionalNumber = _shouldShowProfessionalNumber();

    if (!shouldShowProfessionalNumber) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 20),
        CustomTextField(
          labelText: "professional_number".tr,
          labelColor: AppColors.secondaryText,
          errorText: "professional_number_error".tr,
          isRequire: true,
          hintText: "professional_number_hint".tr,
          obscureText: false.obs,
          controller: controller.professionalNumber,
          onChanged: _handleProfessionalNumberChange,
          isError: controller.isProfessionalNumberError,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      color: Colors.white,
      child: Column(children: [_buildFooterInfo(), _buildContinueButton()]),
    );
  }

  Widget _buildFooterInfo() {
    return Text(
      "license_info".tr,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 13,
        fontFamily: AppFontStyleTextStrings.regular,
        color: AppColors.secondaryText,
      ),
    );
  }

  Widget _buildContinueButton() {
    return Obx(
      () => CustomButtonDefault(
        onTap: _handleContinue,
        btnText: "continue_btn".tr,
        isDisabled: !controller.step4.value,
      ),
    );
  }

  // Helper methods
  bool _shouldShowIdCardUpload() {
    return controller.identify.value == _doctorIdentity ||
        controller.identify.value == _pharmacyIdentity;
  }

  bool _shouldShowProfessionalNumber() {
    return controller.identify.value == _doctorIdentity;
  }

  String _getDegreeUploadLabel() {
    return controller.identify.value == _doctorIdentity
        ? "medical_degree".tr
        : "exploitation_license".tr;
  }

  // Event handlers
  void _handleImageUploadChange(dynamic value) {
    controller.verifyCredentials();
  }

  void _handleProfessionalNumberChange(String value) {
    controller.professionalNumber.text = value;
    controller.verifyCredentials();
  }

  void _handleContinue() {
    HapticFeedback.selectionClick();
    Get.toNamed(Routes.addAvatarScreen);
  }
}
