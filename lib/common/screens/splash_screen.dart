import 'dart:ui';
import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  static const double _imageBgHeightRatio = 0.6;
  static const double _contentTopRatio = 0.54;
  static const double _contentHeightRatio = 0.46;
  static const double _socialIconSize = 50.0;
  static const double _logoSize = 80.0;

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      body: SafeArea(child: Obx(() => _buildBody(context))),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return _buildLoadingOverlay();
    }

    if (controller.errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    return _buildSplashContent(context);
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'loading'.tr,
                style: const TextStyle(fontSize: 16, fontFamily: AppFontStyleTextStrings.medium),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'error_occurred'.tr,
              style: const TextStyle(fontSize: 18, fontFamily: AppFontStyleTextStrings.semiBold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.regular,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.BLACK,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('retry'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplashContent(BuildContext context) {
    return Stack(children: [_buildBackgroundImage(), _buildMainContent(), _buildLogo()]);
  }

  Widget _buildBackgroundImage() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: Get.height * _imageBgHeightRatio,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.splashBg), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      top: Get.height * _contentTopRatio,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: Get.height * _contentHeightRatio,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.color3.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 25),
                  _buildActionButtons(),
                  const SizedBox(height: 14),
                  _buildOrDivider(),
                  const SizedBox(height: 15),
                  _buildSocialButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'splash_title'.tr,
      style: const TextStyle(fontSize: 28, fontFamily: AppFontStyleTextStrings.semiBold),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [_buildLoginButton(), const SizedBox(height: 24), _buildSignUpButton()],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Get.toNamed(Routes.loginScreen),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.BLACK,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Text(
          'login'.tr,
          style: const TextStyle(fontSize: 16, fontFamily: AppFontStyleTextStrings.bold),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Get.offNamed(Routes.telephoneScreen),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.WHITE,
          foregroundColor: AppColors.BLACK,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: const BorderSide(color: AppColors.BLACK),
          ),
        ),
        child: Text(
          'sign_up'.tr,
          style: const TextStyle(fontSize: 16, fontFamily: AppFontStyleTextStrings.bold),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.greyShade3, thickness: 1, indent: 10, endIndent: 10),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or'.tr,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.greyShade3, thickness: 1, indent: 10, endIndent: 10),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Platform.isIOS) ...[_buildSocialButton(AppImages.appleIcon), const SizedBox(width: 20)],
        _buildSocialButton(AppImages.googleIcon),
        const SizedBox(width: 20),
        _buildSocialButton(AppImages.linkedinIcon),
      ],
    );
  }

  Widget _buildSocialButton(String iconPath) {
    return Container(
      width: _socialIconSize,
      height: _socialIconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.WHITE,
        boxShadow: [
          BoxShadow(
            color: AppColors.BLACK.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            // TODO: Implement social login
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(iconPath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Positioned(
      top: 60,
      right: 20,
      child: Container(
        width: _logoSize,
        height: _logoSize,
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          AppImages.logo,
          fit: BoxFit.contain, // Use contain to avoid cropping
        ),
      ),
    );
  }
}
