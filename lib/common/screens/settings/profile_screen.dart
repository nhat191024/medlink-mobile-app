import 'package:medlink/model/service_model.dart';
import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/profile_controller.dart';
import 'package:medlink/common/controllers/setting_controller.dart';
import 'package:medlink/doctor/controllers/home_controller.dart';

import 'package:medlink/components/button/default.dart';
import 'package:medlink/components/widget/dashed_divider.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({super.key});

  final SettingControllers settingControllers = Get.put(SettingControllers());

  DoctorHomeController? get homeControllers =>
      settingControllers.identity.contains("doctor") ? Get.put(DoctorHomeController()) : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: _onPopInvoked,
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary600))
              : SingleChildScrollView(
                  child: Stack(children: [_buildMainContent(), _buildHeader()]),
                ),
        ),
      ),
    );
  }

  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    if (didPop) {
      if (settingControllers.identity.contains("doctor")) {
        await homeControllers?.fetchData();
      }
      await settingControllers.loadInfo();
    }
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileHeader(),
        _buildStatsSection(),
        _buildInformationSection(),
        if (controller.identity.value.contains('doctor')) _buildServiceSection(),
        _buildContactSection(),
        if (controller.testimonials.isNotEmpty) _buildTestimonialsSection(),
        _buildEditButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Row(
        mainAxisAlignment: controller.identity.value.contains('doctor')
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        children: [
          if (controller.identity.value.contains('doctor'))
            Text(
              'profile'.tr,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 18,
                fontFamily: AppFontStyleTextStrings.bold,
              ),
            ),
          GestureDetector(
            onTap: _handleNavigateBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.close, color: AppColors.primaryText, size: 25),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          if (controller.identity.value.contains('doctor')) ...[const SizedBox(height: 80)],
          _buildAvatar(),
          const SizedBox(height: 15),
          Text(
            controller.userData.value.name,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
          if (controller.identity.value.contains('doctor'))
            Text(
              controller.userData.value.medicalCategory ?? '',
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.regular,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Obx(
      () => Container(
        height: controller.identity.value.contains('doctor') ? 120 : Get.height * 0.3,
        width: controller.identity.value.contains('doctor') ? 120 : Get.width,
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: controller.identity.value.contains('doctor')
              ? BorderRadius.circular(100)
              : BorderRadius.zero,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(controller.userData.value.avatar, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      padding: const EdgeInsets.fromLTRB(20, 15, 30, 15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoColumn(controller.userData.value.city, 'location'.tr, AppColors.primaryText),
          _buildInfoColumn(
            controller.avgTotal.toString(),
            'rating'.tr,
            needDivider: true,
            AppColors.primaryText,
            isRating: true,
            rateCount: controller.reviewCounts.value,
          ),
          _buildInfoColumn(
            controller.userData.value.isAvailable == true ? 'available'.tr : 'busy'.tr,
            'schedule'.tr,
            needDivider: true,
            controller.userData.value.isAvailable == true
                ? AppColors.successMain
                : AppColors.errorMain,
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('information'.tr),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroductionSection(),
              const SizedBox(height: 15),
              _buildLanguageSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntroductionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'introduce'.tr,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          controller.userData.value.introduce ?? '',
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'language'.tr,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var language in controller.languages) ...[
              _buildPrimary50Container(
                language.name,
                8,
                true,
                controller.getImageForLanguage(language.code),
              ),
              const SizedBox(width: 5),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Text(
            'service'.tr,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 16,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: _buildServiceList(controller.services),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('contact'.tr),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactItem(
                'telephone'.tr,
                controller.userData.value.phone,
                AppImages.phoneCall,
              ),
              const SizedBox(height: 15),
              _buildContactItem('email_label'.tr, controller.userData.value.email, AppImages.email),
              const SizedBox(height: 15),
              _buildContactItem(
                'location'.tr,
                controller.userData.value.officeAddress ?? '',
                AppImages.mapPinLine,
              ),
              const SizedBox(height: 15),
              Image.asset('assets/images/mapDemo.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(String label, String value, String iconPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextLabel(label, 20, true, iconPath),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTestimonialsHeader(),
        const SizedBox(height: 10),
        _buildTestimonialsList(),
        const SizedBox(height: 10),
        _buildReviewsList(),
      ],
    );
  }

  Widget _buildTestimonialsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'testimonials'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: AppFontStyleTextStrings.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _handleViewAllReviews,
                child: Text(
                  'view_all_review'.tr,
                  style: const TextStyle(
                    color: AppColors.primary600,
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (var testimonial in controller.testimonials) ...[
            _buildRatingRow(
              Get.context!,
              testimonial.star,
              testimonial.title,
              double.parse(testimonial.fraction),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return Column(
      children: [
        for (var review in controller.topReviews) ...[_buildReviewItem(review)],
      ],
    );
  }

  Widget _buildReviewItem(dynamic review) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 25, backgroundImage: Image.network(review.avatar).image),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.fullName,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontFamily: AppFontStyleTextStrings.medium,
                    ),
                  ),
                  Text(
                    controller.formatDate(review.createdAt),
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                      fontFamily: AppFontStyleTextStrings.regular,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.fromLTRB(8, 2, 10, 2),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 22.0),
                    const SizedBox(width: 4),
                    Text(
                      review.rate.toString(),
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14,
                        fontFamily: AppFontStyleTextStrings.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            review.review,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return CustomButtonDefault(
      onTap: _handleEditProfile,
      btnText: "edit_profile".tr,
      isDisabled: false,
      topPadding: 15,
      leftPadding: 20,
      rightPadding: 20,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 16,
          fontFamily: AppFontStyleTextStrings.bold,
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    String bottomText,
    String topText,
    Color color, {
    bool isRating = false,
    bool needDivider = false,
    int rateCount = 0,
  }) {
    return Row(
      children: [
        if (needDivider) ...[
          const SizedBox(height: 30, child: VerticalDivider(color: AppColors.border, thickness: 1)),
          const SizedBox(width: 10),
        ],
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Đặt alignment phù hợp
          children: [
            Text(
              topText,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 12,
                fontFamily: AppFontStyleTextStrings.regular,
              ),
            ),
            const SizedBox(height: 4),
            isRating
                ? Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20.0),
                      const SizedBox(width: 4),
                      Text(
                        bottomText,
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontFamily: AppFontStyleTextStrings.medium,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($rateCount)',
                        style: const TextStyle(
                          color: AppColors.disable,
                          fontSize: 12,
                          fontFamily: AppFontStyleTextStrings.regular,
                        ),
                      ),
                    ],
                  )
                : Text(
                    bottomText,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontFamily: AppFontStyleTextStrings.medium,
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrimary50Container(String text, double horizontal, bool isSvg, [String? image]) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null) ...[
            isSvg ? SvgPicture.asset(image) : Image.asset(image),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList(List<ServiceModel> services) {
    return Column(
      children: [
        for (var service in services) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppImages.home2,
                    width: 30,
                    height: 30,
                    colorFilter: const ColorFilter.mode(AppColors.primary600, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14,
                        fontFamily: AppFontStyleTextStrings.medium,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.description,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  controller.formatPrice(service.price),
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.bold,
                  ),
                ),
              ],
            ),
          ),
          if (services.indexOf(service) != services.length - 1)
            const DashedDivider(color: AppColors.dividers, height: 2),
        ],
      ],
    );
  }

  Widget _buildTextLabel(String text, double horizontal, bool isSvg, String image) {
    return Row(
      children: [
        isSvg
            ? SvgPicture.asset(
                image,
                width: 15,
                height: 15,
                fit: BoxFit.fill,
                colorFilter: const ColorFilter.mode(AppColors.secondaryText, BlendMode.srcIn),
              )
            : Image.asset(image),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(BuildContext context, int stars, String label, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '$stars',
                style: const TextStyle(fontSize: 14, fontFamily: AppFontStyleTextStrings.medium),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 6),
              SizedBox(
                width: Get.width * 0.6,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.border,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.secondaryText,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  void _handleNavigateBack() async {
    Get.back();
  }

  void _handleViewAllReviews() {
    Get.toNamed(Routes.allReviewScreen);
  }

  void _handleEditProfile() {
    controller.loadDataToEdit();
    Get.toNamed(Routes.profileEditScreen);
  }
}
