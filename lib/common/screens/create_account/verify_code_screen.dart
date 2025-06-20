import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';
import 'package:medlink/components/widget/circular_progress_step.dart';
import 'package:medlink/components/button/default.dart';

class VerifyCodeScreen extends GetView<CreateAccountController> {
  const VerifyCodeScreen({super.key});

  // Constants
  static const int _codeLength = 4;
  static const int _currentStep = 2;
  static const int _totalSteps = 7;

  @override
  Widget build(BuildContext context) {
    // Start timer when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startResendTimer();
    });

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildBody(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        ComeBackButton(),
        Spacer(),
        CircularProgressStep(
          step: _currentStep,
          totalSteps: _totalSteps,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeaderContent(),
            const SizedBox(height: 40),
            _buildPinInput(),
            const Spacer(),
            _buildResendSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        SvgPicture.asset(
          AppImages.sms,
          height: 50,
          width: 50,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 16),
        Text(
          'verify_title'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Text(
            "${controller.selectedCountry.value.dialCode} ${controller.phoneNumber.text}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppFontStyleTextStrings.bold,
              color: AppColors.infoMain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Obx(
        () => Pinput(
          length: _codeLength,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          separatorBuilder: (index) => const SizedBox(width: 16),
          defaultPinTheme: _getDefaultPinTheme(),
          focusedPinTheme: _getFocusedPinTheme(),
          errorPinTheme: _getErrorPinTheme(),
          keyboardType: TextInputType.number,
          onChanged: _handleCodeChange,
          forceErrorState: controller.verifyError.value,
          errorText: controller.verifyError.value ? 'wrong'.tr : null,
          errorBuilder: _buildErrorWidget,
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Obx(
        () => controller.isResendEnabled.value
            ? _buildResendButton()
            : _buildCountdownText(),
      ),
    );
  }

  Widget _buildResendButton() {
    return TextButton(
      onPressed: controller.resendVerificationCode,
      child: Text(
        "resend_code".tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          decoration: TextDecoration.underline,
          fontSize: 16,
          color: AppColors.primary600,
          fontFamily: AppFontStyleTextStrings.bold,
        ),
      ),
    );
  }

  Widget _buildCountdownText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "resend_code_after".tr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.secondaryText,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
        const SizedBox(width: 4),
        Obx(
          () => Text(
            "${controller.remainingSeconds.value.toString().padLeft(2, '0')}s",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryText,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(
        () => CustomButtonDefault(
          onTap: _handleVerify,
          btnText: 'verify_btn'.tr,
          isDisabled: !controller.step2.value, // Button enabled when code is complete
        ),
      ),
    );
  }

  // Pin theme methods
  PinTheme _getDefaultPinTheme() {
    return PinTheme(
      width: 48,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 24,
        fontFamily: AppFontStyleTextStrings.regular,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.dividers),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  PinTheme _getFocusedPinTheme() {
    return PinTheme(
      width: 48,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 24,
        fontFamily: AppFontStyleTextStrings.regular,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryText, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  PinTheme _getErrorPinTheme() {
    return PinTheme(
      width: 48,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 24,
        fontFamily: AppFontStyleTextStrings.regular,
      ),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        border: Border.all(color: AppColors.errorMain, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }  // Event handlers
  void _handleCodeChange(String value) {
    controller.verifyCode.value = value;
    controller.step2.value = value.length == _codeLength;
    
    // Clear error when user starts typing
    if (controller.verifyError.value && value.isNotEmpty) {
      controller.verifyError.value = false;
    }
    
    // Auto-verify when code is complete
    if (value.length == _codeLength) {
      // Add haptic feedback
      HapticFeedback.lightImpact();
      Future.delayed(const Duration(milliseconds: 300), () {
        controller.verify();
      });
    }
  }

  void _handleVerify() {
    if (controller.step2.value) {
      HapticFeedback.selectionClick();
      controller.verify();
    }
  }

  Widget _buildErrorWidget(String? context, String? error) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.errorMain,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            'wrong'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.errorMain,
              fontFamily: AppFontStyleTextStrings.medium,
            ),
          ),
        ],
      ),
    );
  }
}
