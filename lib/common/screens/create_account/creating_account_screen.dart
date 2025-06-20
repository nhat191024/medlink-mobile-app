import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';

class CreatingAccountScreen extends GetView<CreateAccountController> {
  const CreatingAccountScreen({super.key});

  // Constants
  static const double _logoContainerSize = 200.0;
  static const double _progressIndicatorSize = 150.0;
  static const double _logoRadius = 50.0;
  static const double _logoSize = 60.0;
  static const double _strokeWidth = 8.0;

  @override
  Widget build(BuildContext context) {
    // Start progress when screen builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startAccountCreationProgress();
    });

    return Scaffold(
      backgroundColor: AppColors.primary50,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const SafeArea(
      child: Row(
        children: [
          ComeBackButton(backgroundColor: AppColors.white),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressSection(),
          const SizedBox(height: 20),
          _buildPercentageText(),
          const SizedBox(height: 10),
          _buildTitle(),
          const SizedBox(height: 5),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Stack(
      alignment: Alignment.center,
      children: [_buildBackgroundImage(), _buildProgressIndicator(), _buildLogoAvatar()],
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      height: _logoContainerSize,
      width: _logoContainerSize,
      child: Image.asset(AppImages.ellipse1, fit: BoxFit.cover),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      height: _progressIndicatorSize,
      width: _progressIndicatorSize,
      child: Obx(
        () => CircularProgressIndicator(
          value: controller.progress.value,
          strokeWidth: _strokeWidth,
          backgroundColor: AppColors.primary100,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary600),
        ),
      ),
    );
  }

  Widget _buildLogoAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: _logoRadius,
      child: Image.asset(AppImages.logo, width: _logoSize, height: _logoSize),
    );
  }

  Widget _buildPercentageText() {
    return Obx(
      () => Text(
        '${(controller.progress.value * 100).round()}%',
        style: const TextStyle(
          fontSize: 28,
          fontFamily: AppFontStyleTextStrings.bold,
          color: AppColors.primary600,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'creating_account_title'.tr,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: AppFontStyleTextStrings.bold,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'creating_account_description'.tr,
      style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
    );
  }
}
