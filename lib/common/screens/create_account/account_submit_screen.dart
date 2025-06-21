import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';

class AccountSubmitScreen extends GetView<CreateAccountController> {
  const AccountSubmitScreen({super.key});

  // Constants
  static const double _logoContainerSize = 200.0;
  static const double _progressIndicatorSize = 150.0;
  static const double _logoRadius = 50.0;
  static const double _logoSize = 60.0;
  static const double _strokeWidth = 8.0;
  static const double _progressValue = 1.0;
  static const double _buttonHeight = 48.0;
  static const double _buttonWidth = 150.0;
  static const double _buttonRadius = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.otherColor1,
      resizeToAvoidBottomInset: false,
      body: Column(children: [Expanded(child: _buildContent())]),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSubmitIcon(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 10),
          _buildDescription(),
          const SizedBox(height: 20),
          _buildOkButton(),
        ],
      ),
    );
  }

  Widget _buildSubmitIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [_buildBackgroundEllipse(), _buildProgressIndicator(), _buildClockIcon()],
    );
  }

  Widget _buildBackgroundEllipse() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: _logoContainerSize,
      width: _logoContainerSize,
      child: Image.asset(AppImages.ellipse2, fit: BoxFit.cover),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      height: _progressIndicatorSize,
      width: _progressIndicatorSize,
      child: CircularProgressIndicator(
        value: _progressValue,
        strokeWidth: _strokeWidth,
        backgroundColor: AppColors.otherColor2,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.otherColor2),
      ),
    );
  }

  Widget _buildClockIcon() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: _logoRadius,
      child: Image.asset(AppImages.clock, width: _logoSize),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'account_submit_title'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: AppFontStyleTextStrings.bold,
          color: AppColors.otherColor2,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'account_submit_description'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.primaryText,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
      ),
    );
  }

  Widget _buildOkButton() {
    return GestureDetector(
      onTap: _handleOkPressed,
      child: Container(
        height: _buttonHeight,
        width: _buttonWidth,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_buttonRadius),
          color: AppColors.primaryText,
        ),
        alignment: Alignment.center,
        child: Text(
          'ok_btn'.tr,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
      ),
    );
  }

  // Event handlers
  void _handleOkPressed() {
    HapticFeedback.selectionClick();
    Get.offAllNamed(Routes.accountSuccessScreen);
  }
}
