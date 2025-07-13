import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';
import 'package:medlink/components/button/default.dart';
import 'package:medlink/components/button/attach_photo.dart';
import 'package:medlink/components/widget/circular_progress_step.dart';

class AddAvatarScreen extends GetView<CreateAccountController> {
  const AddAvatarScreen({super.key});

  // Constants
  static const double _cardHeight = 0.62;
  static const double _cardWidth = 0.9;
  static const double _shadowHeight = 0.69;
  static const double _shadowWidth = 0.7;
  static const double _shadowTopOffset = 0.035;
  static const double _avatarSize = 140.0;
  static const double _borderRadius = 32.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
    return SafeArea(
      child: Row(
        children: [
          const ComeBackButton(backgroundColor: AppColors.white),
          const Spacer(),
          _buildSkipButton(),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: TextButton(
        onPressed: _handleSkip,
        child: Text(
          'skip'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.bold,
            color: AppColors.disable,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Obx(() {
      final isPatient = controller.userType.value.contains('patient');
      return CircularProgressStep(step: isPatient ? 7 : 6, totalSteps: isPatient ? 7 : 6);
    });
  }

  Widget _buildBody() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [_buildShadowCard(), _buildMainCard()],
      ),
    );
  }

  Widget _buildShadowCard() {
    return Container(
      height: Get.height * _shadowHeight,
      width: Get.width * _shadowWidth,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    );
  }

  Widget _buildMainCard() {
    return Positioned(
      top: Get.height * _shadowTopOffset,
      child: Container(
        height: Get.height * _cardHeight,
        width: Get.width * _cardWidth,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: _buildCardContent(),
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAvatarSection(),
        const SizedBox(height: 40),
        _buildTitle(),
        const SizedBox(height: 20),
        _buildDescription(),
        const SizedBox(height: 40),
        _buildAttachButton(),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [_buildAvatarContainer(), _buildRemoveButton()],
    );
  }

  Widget _buildAvatarContainer() {
    return Obx(() {
      final isPatient = controller.userType.value.contains('patient');
      return Container(
        height: _avatarSize,
        width: _avatarSize,
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(isPatient ? 100 : 16),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildAvatarImage(),
      );
    });
  }

  Widget _buildAvatarImage() {
    return Obx(() {
      final hasImage = controller.avatarImage.value != null;
      final isPatient = controller.userType.value.contains('patient');

      if (hasImage) {
        return Image.file(controller.avatarImage.value!, fit: BoxFit.cover);
      }

      return Image.asset(isPatient ? AppImages.avatar : AppImages.cover);
    });
  }

  Widget _buildRemoveButton() {
    return Obx(() {
      final hasImage = controller.avatarImage.value != null;

      if (!hasImage) return const SizedBox.shrink();

      return Positioned(
        top: 8,
        right: 5,
        child: GestureDetector(
          onTap: _handleRemoveImage,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            child: const Icon(Icons.close, color: Colors.white, size: 15),
          ),
        ),
      );
    });
  }

  Widget _buildTitle() {
    return Obx(() {
      final isPatient = controller.userType.value.contains('patient');
      return Text(
        isPatient ? 'add_avatar_title'.tr : 'add_cover_title'.tr,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: AppFontStyleTextStrings.bold,
          color: AppColors.primaryText,
        ),
      );
    });
  }

  Widget _buildDescription() {
    return Obx(() {
      final isPatient = controller.userType.value.contains('patient');
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          isPatient ? 'add_avatar_description'.tr : 'add_cover_description'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.regular,
            color: AppColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  Widget _buildAttachButton() {
    return AttachPhotoButton(selectedImage: controller.avatarImage);
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: AppColors.background,
      child: Column(
        children: [
          CustomButtonDefault(
            onTap: _handleComplete,
            btnText: "complete_btn".tr,
            isDisabled: false,
          ),
        ],
      ),
    );
  }

  // Event handlers
  void _handleSkip() {
    controller.createAccount();
    Get.toNamed(Routes.creatingAccountScreen);
  }

  void _handleComplete() {
    controller.createAccount();
    Get.toNamed(Routes.creatingAccountScreen);
  }

  void _handleRemoveImage() {
    controller.avatarImage.value = null;
  }
}
