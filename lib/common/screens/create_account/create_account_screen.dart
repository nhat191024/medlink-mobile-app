import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';
import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/widget/circular_progress_step.dart';
import 'package:medlink/components/field/text.dart';

class CreateAccountScreen extends GetView<CreateAccountController> {
  const CreateAccountScreen({super.key});

  // Constants
  static const int _currentStep = 4;
  static const int _totalSteps = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: SingleChildScrollView(child: _buildBody())),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const SafeArea(
      child: Row(
        children: [
          ComeBackButton(),
          Spacer(),
          CircularProgressStep(step: _currentStep, totalSteps: _totalSteps),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildHeaderContent(),
        const SizedBox(height: 30),
        _buildEmailField(),
        const SizedBox(height: 20),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        SvgPicture.asset(AppImages.key, height: 50, width: 50),
        const SizedBox(height: 16),
        Text(
          'create_account_title'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontFamily: AppFontStyleTextStrings.bold),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Obx(
      () => CustomTextField(
        labelText: "email_label".tr,
        errorText: controller.emailErrorText.value,
        hintText: "email_hint".tr,
        keyboardType: TextInputType.emailAddress,
        obscureText: false.obs,
        controller: controller.email,
        onChanged: _handleEmailChange,
        isError: controller.isEmailError,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => CustomTextField(
            labelText: 'password_label'.tr,
            controller: controller.password,
            onChanged: _handlePasswordChange,
            keyboardType: TextInputType.visiblePassword,
            hintText: 'password_hint'.tr,
            errorText: controller.passwordErrorText.value,
            isError: controller.isPasswordError.value.obs,
            obscureText: (!controller.isPasswordVisible.value).obs,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                color: AppColors.primaryText,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildPasswordStrengthIndicator(),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: controller.passwordStrength.value,
                    backgroundColor: AppColors.dividers,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      controller.passwordStrengthColor.value,
                    ),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.passwordStrengthText.value,
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.passwordStrengthColor.value,
                    fontFamily: AppFontStyleTextStrings.medium,
                  ),
                ),
              ],
            ),
            if (controller.password.text.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildPasswordRequirements(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    List<Map<String, dynamic>> requirements = controller.getPasswordRequirements(
      controller.password.text,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: requirements
            .map((requirement) => _buildRequirementRow(requirement['text'], requirement['isMet']))
            .toList(),
      ),
    );
  }

  Widget _buildRequirementRow(String requirement, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isMet ? AppColors.successMain : AppColors.secondaryText,
        ),
        const SizedBox(width: 8),
        Text(
          requirement,
          style: TextStyle(
            fontSize: 11,
            color: isMet ? AppColors.successMain : AppColors.secondaryText,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildTermsAndConditions(), const SizedBox(height: 16), _buildContinueButton()],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: controller.termAndCondition.value,
              onChanged: _handleTermsChange,
              activeColor: AppColors.primary600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              side: const BorderSide(width: 1.5, color: AppColors.border),
            ),
          ),
        ),
        _buildTermsText(),
      ],
    );
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 12,
          fontFamily: AppFontStyleTextStrings.regular,
          height: 1.4,
        ),
        children: [
          TextSpan(text: 'agree_terms'.tr),
          TextSpan(
            text: 'terms'.tr,
            style: const TextStyle(
              color: AppColors.infoMain,
              decoration: TextDecoration.underline,
              fontSize: 13,
              fontFamily: AppFontStyleTextStrings.regular,
              height: 1.4,
            ),
            recognizer: TapGestureRecognizer()..onTap = _handleTermsTap,
          ),
          TextSpan(
            text: 'and'.tr,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 13,
              fontFamily: AppFontStyleTextStrings.regular,
              height: 1.4,
            ),
          ),
          TextSpan(
            text: 'privacy'.tr,
            style: const TextStyle(
              color: AppColors.infoMain,
              decoration: TextDecoration.underline,
              fontSize: 13,
              fontFamily: AppFontStyleTextStrings.regular,
              height: 1.4,
            ),
            recognizer: TapGestureRecognizer()..onTap = _handlePrivacyTap,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Obx(
      () => CustomButtonPlus(
        onTap: _handleContinue,
        btnText: "continue_btn".tr,
        isDisabled: !controller.step3.value,
        isLoading: controller.buttonLoading.value,
      ),
    );
  }

  // Event handlers
  void _handleEmailChange(String value) {
    // Clear errors when user starts typing
    if (controller.isEmailError.value) {
      controller.isEmailError.value = false;
      controller.emailErrorText.value = '';
    }
    controller.verifyAccount();
  }

  void _handlePasswordChange(String value) {
    // Clear errors when user starts typing
    if (controller.isPasswordError.value) {
      controller.isPasswordError.value = false;
      controller.passwordErrorText.value = '';
    }
    // Update password strength
    controller.updatePasswordStrength(value);
    controller.verifyAccount();
  }

  void _handleTermsChange(bool? value) {
    HapticFeedback.lightImpact();
    controller.termAndCondition.value = value ?? false;
    controller.verifyAccount();
  }

  void _handleContinue() {
    if (controller.step3.value) {
      HapticFeedback.selectionClick();
      controller.checkIfEmailExists();
    }
  }

  void _handleTermsTap() {
    HapticFeedback.lightImpact();
    // Navigate to terms and conditions
    // Get.toNamed('/terms-and-conditions');
  }

  void _handlePrivacyTap() {
    HapticFeedback.lightImpact();
    // Navigate to privacy policy
    // Get.toNamed('/privacy-policy');
  }
}
