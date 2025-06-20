import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';

class AccountSuccessScreen extends GetView<CreateAccountController> {
  const AccountSuccessScreen({super.key});

  // Constants
  static const Duration _redirectDelay = Duration(seconds: 5);
  static const String _patientUserType = 'patient';
  static const double _backgroundImageHeight = 0.55;
  static const double _logoContainerSize = 200.0;
  static const double _progressIndicatorSize = 150.0;
  static const double _logoRadius = 50.0;
  static const double _logoSize = 60.0;
  static const double _strokeWidth = 8.0;
  static const double _progressValue = 1.0;

  @override
  Widget build(BuildContext context) {
    _startRedirectTimer();

    return Scaffold(
      backgroundColor: AppColors.successLight,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [_buildBackgroundImage(context), _buildContent()]),
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight * _backgroundImageHeight;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: Image.asset(AppImages.confetti, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSuccessIcon(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 10),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [_buildBackgroundEllipse(), _buildProgressIndicator(), _buildPartyIcon()],
    );
  }

  Widget _buildBackgroundEllipse() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: _logoContainerSize,
      width: _logoContainerSize,
      child: Image.asset(AppImages.ellipse3, fit: BoxFit.cover),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      height: _progressIndicatorSize,
      width: _progressIndicatorSize,
      child: CircularProgressIndicator(
        value: _progressValue,
        strokeWidth: _strokeWidth,
        backgroundColor: AppColors.successMain,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.successMain),
      ),
    );
  }

  Widget _buildPartyIcon() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: _logoRadius,
      child: Image.asset(AppImages.party, width: _logoSize),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'account_success_title'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: AppFontStyleTextStrings.bold,
          color: AppColors.successMain,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Text(
        'account_success_description'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.primaryText,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
      ),
    );
  }

  // Event handlers
  void _startRedirectTimer() {
    Timer(_redirectDelay, () {
      _redirectToNextScreen();
    });
  }

  void _redirectToNextScreen() {
    final isPatient = controller.userType.value == _patientUserType;
    controller.clear();

    if (isPatient) {
      Get.offAllNamed(Routes.splashScreen);
    } else {
      // Uncomment the following line when the patient home screen is ready
      // Get.offAllNamed(Routes.patientHomeScreen);
    }
  }
}
