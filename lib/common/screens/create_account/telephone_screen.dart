import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';
import 'package:medlink/components/widget/circular_progress_step.dart';
import 'package:medlink/components/field/phone.dart';
import 'package:medlink/components/widget/country_code.dart';
import 'package:medlink/components/button/default.dart';

class TelephoneScreen extends GetView<CreateAccountController> {
  const TelephoneScreen({super.key});

  // Constants
  static const int _requiredPhoneLength = 11;
  static const int _currentStep = 1;
  static const int _totalSteps = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(child: Column(children: [_buildHeader(), _buildBody(), _buildFooter()])),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        ComeBackButton(),
        Spacer(),
        CircularProgressStep(step: _currentStep, totalSteps: _totalSteps),
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
            _buildPhoneNumberSection(),
            const Spacer(),
            _buildInfoText(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        SvgPicture.asset(AppImages.telephoneReceiver, height: 50, width: 50),
        const SizedBox(height: 16),
        Text(
          'enter_phone_number'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontFamily: AppFontStyleTextStrings.bold),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'phone_number'.tr,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.bold,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        _buildPhoneField(),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Obx(
      () => PhoneNumberTextField(
        isError: false.obs,
        color: AppColors.white,
        controller: controller.phoneNumber,
        isBlack: true,
        selectedCountry: controller.selectedCountry.value,
        onCountryTap: _handleCountrySelection,
        onChanged: _handlePhoneNumberChange,
      ),
    );
  }

  Widget _buildInfoText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Text(
            "info".tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(
        () => CustomButtonDefault(
          onTap: _handleContinue,
          btnText: 'continue_btn'.tr,
          isDisabled: !controller.step.value,
        ),
      ),
    );
  }

  // Event handlers
  Future<void> _handleCountrySelection() async {
    Country? country = await Get.to(() => const InputCountryCodeScreen());
    if (country != null) {
      controller.selectedCountry.value = country;
    }
  }

  void _handlePhoneNumberChange(String value) {
    controller.step.value = value.length >= _requiredPhoneLength;
  }

  void _handleContinue() {
    if (_isPhoneNumberValid()) {
      Get.toNamed(Routes.verifyScreen);
    }
  }

  // Validation methods
  bool _isPhoneNumberValid() {
    return controller.phoneNumber.text.length >= _requiredPhoneLength;
  }
}
