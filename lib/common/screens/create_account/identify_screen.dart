import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';
import 'package:medlink/components/button/default.dart';
import 'package:medlink/components/widget/circular_progress_step.dart';

class IdentifyScreen extends GetView<CreateAccountController> {
  const IdentifyScreen({super.key});
  // Constants
  static const int _currentStep = 5;
  static const int _totalSteps = 7;
  static const double _optionHeight = 60.0;
  static const double _borderRadius = 14.0;

  // Identity options data
  static const List<Map<String, dynamic>> _identityOptions = [
    {
      'id': 'doctor',
      'icon': AppImages.stethoscopeRed,
      'text': 'doctor',
      'iconSize': 30.0,
      'spacing': 15.0,
    },
    {'id': 'pharmacy', 'icon': AppImages.firstAidBg, 'text': 'pharmacy', 'iconSize': 38.0, 'spacing': 15.0}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildHeaderContent(),
          const SizedBox(height: 20),
          _buildIdentityOptions(),
        ],
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        SvgPicture.asset(AppImages.whoAreYou, height: 60, width: 60),
        const SizedBox(height: 16),
        Text(
          'identity_title'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontFamily: AppFontStyleTextStrings.bold),
        ),
      ],
    );
  }

  Widget _buildIdentityOptions() {
    return Column(
      children: _identityOptions.map((option) => _buildIdentityOption(option)).toList(),
    );
  }

  Widget _buildIdentityOption(Map<String, dynamic> option) {
    final String id = option['id'];
    final String icon = option['icon'];
    final String text = option['text'];
    final double iconSize = option['iconSize'];
    final double spacing = option['spacing'];

    return Obx(
      () => InkWell(
        onTap: () => _handleIdentitySelection(id),
        child: Container(
          height: _optionHeight,
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(
              color: controller.identify.value == id ? AppColors.primary600 : AppColors.dividers,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(icon, height: iconSize, width: iconSize),
              SizedBox(width: spacing),
              Text(
                text.tr,
                style: const TextStyle(fontSize: 16, fontFamily: AppFontStyleTextStrings.regular),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      color: Colors.white,
      child: Column(
        children: [
          CustomButtonDefault(onTap: _handleContinue, btnText: "continue_btn".tr, isDisabled: false),
        ],
      ),
    );
  }

  // Event handlers
  void _handleIdentitySelection(String identityId) {
    HapticFeedback.lightImpact();
    controller.identify.value = identityId;
  }

  void _handleContinue() {
    HapticFeedback.selectionClick();
    Get.toNamed(Routes.licenseScreen);
  }
}
