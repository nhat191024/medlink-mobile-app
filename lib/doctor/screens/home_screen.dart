import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/doctor/controllers/home_controller.dart';

class DoctorHomeScreen extends GetView<DoctorHomeController> {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderSection(),
            Expanded(
              child: Obx(
                () => controller.isProfileSetuped.value
                    ? const _HomeContentView()
                    : const _SetupProfileView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends GetView<DoctorHomeController> {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _UserAvatarSection(),
          const SizedBox(width: 16),
          const Expanded(child: _UserInfoSection()),
          _NotificationBell(),
        ],
      ),
    );
  }
}

class _UserAvatarSection extends GetView<DoctorHomeController> {
  const _UserAvatarSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (controller.currentIndex == 0) Obx(() => _avatarContainer()),
        _profileNavigationButton(),
      ],
    );
  }

  Widget _avatarContainer() {
    return Container(
      height: 64,
      width: 64,
      decoration: const BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: _buildAvatarImage(),
    );
  }

  Widget _buildAvatarImage() {
    if (controller.avatar.value.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary600),
          ),
        ),
      );
    }

    return Image.network(
      controller.avatar.value,
      fit: controller.checkIfDefaultAvatar(controller.avatar.value)
          ? BoxFit.scaleDown
          : BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary600),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, size: 32, color: AppColors.secondaryText);
      },
    );
  }

  Widget _profileNavigationButton() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(color: AppColors.primary600, shape: BoxShape.circle),
        child: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
          onPressed: () => Get.toNamed(Routes.profileScreen),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}

class _UserInfoSection extends GetView<DoctorHomeController> {
  const _UserInfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Obx(() => _userNameAndSpecialty()), const SizedBox(height: 8), _statusBadge()],
    );
  }

  Widget _userNameAndSpecialty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.userName.value,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        if (controller.identity.contains("1"))
          Text(
            controller.specialty.value,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
      ],
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.errorMain,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            'close'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: AppFontStyleTextStrings.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends GetView<DoctorHomeController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.notificationScreen),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        padding: const EdgeInsets.all(12),
        child: Obx(
          () => Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(AppImages.bell),
              if (controller.isHaveNotificationUnread.value)
                const Positioned(
                  top: 3,
                  right: 0,
                  child: CircleAvatar(backgroundColor: AppColors.errorMain, radius: 5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupProfileView extends StatelessWidget {
  const _SetupProfileView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.calendar),
          const SizedBox(height: 20),
          Text(
            'nothing_to_measure'.tr,
            style: const TextStyle(fontSize: 20, fontFamily: AppFontStyleTextStrings.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: Text(
              'setup_profile'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
                fontFamily: AppFontStyleTextStrings.regular,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(Routes.profileScreen),
            icon: Image.asset(AppImages.edit),
            label: Text(
              'setup_profile_btn'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.medium,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContentView extends GetView<DoctorHomeController> {
  const _HomeContentView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.identity.contains("doctor")) const _AppointmentStatsSection(),
        const _ReviewSection(),
        const Spacer(),
        Image.asset(AppImages.banner),
      ],
    );
  }
}

class _AppointmentStatsSection extends GetView<DoctorHomeController> {
  const _AppointmentStatsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Row(
        children: [
          Expanded(
            child: _AppointmentCard(
              icon: AppImages.calenderCheck,
              title: 'new_booking'.tr,
              count: controller.booking,
              color: AppColors.primary600,
              onTap: () => Get.toNamed(Routes.doctorMyAppointmentScreen),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _AppointmentCard(
              icon: AppImages.calenderCheck,
              title: 'upcoming_booking'.tr,
              count: controller.upcoming,
              color: const Color(0xFFE48729),
              onTap: () => Get.toNamed(Routes.doctorMyAppointmentScreen),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String icon;
  final String title;
  final RxInt count;
  final Color color;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(5, 5, 16, 0),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: SvgPicture.asset(
                icon,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: 30,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 16,
                      fontFamily: AppFontStyleTextStrings.regular,
                    ),
                  ),
                  Obx(
                    () => Text(
                      count.toString(),
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontFamily: AppFontStyleTextStrings.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewSection extends GetView<DoctorHomeController> {
  const _ReviewSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.allReviewScreen),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xFFE48729), shape: BoxShape.circle),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.star, color: Colors.white, size: 36),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      '${controller.review}+ ${'new_rate'.tr}',
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 15,
                        fontFamily: AppFontStyleTextStrings.medium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'from_patients'.tr,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                      fontFamily: AppFontStyleTextStrings.regular,
                    ),
                  ),
                ],
              ),
              if (controller.reviewers.isNotEmpty) ...[
                const SizedBox(width: 30),
                const _ReviewerAvatarsStack(),
              ] else ...[
                const Spacer(),
                const _AvatarWidget(isLast: true),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewerAvatarsStack extends GetView<DoctorHomeController> {
  const _ReviewerAvatarsStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34 + (18 * 2),
      height: 34,
      child: Stack(clipBehavior: Clip.none, children: _buildAvatarList()),
    );
  }

  List<Widget> _buildAvatarList() {
    List<Widget> avatars = [];
    final reviewerCount = controller.reviewers.length;
    final maxDisplayCount = 4;

    for (var i = 0; i < maxDisplayCount; i++) {
      Widget avatar;

      if (i == maxDisplayCount - 1) {
        avatar = const _AvatarWidget(isLast: true);
      } else if (i < reviewerCount) {
        final reviewerAvatar = controller.reviewers[i];
        avatar = _AvatarWidget(imagePath: reviewerAvatar?.toString() ?? '');
      } else {
        break;
      }

      avatars.add(Positioned(left: i * 22.0, child: avatar));
    }

    return avatars;
  }
}

class _AvatarWidget extends StatelessWidget {
  final String imagePath;
  final bool isLast;

  const _AvatarWidget({this.imagePath = AppImages.btn, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.primary50,
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (isLast) {
      return ClipOval(
        child: Image.asset(
          imagePath,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person, size: 20, color: AppColors.secondaryText);
          },
        ),
      );
    }

    if (imagePath.isEmpty) {
      return const Icon(Icons.person, size: 20, color: AppColors.secondaryText);
    }

    return ClipOval(
      child: Image.network(
        imagePath,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary600),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 20, color: AppColors.secondaryText);
        },
      ),
    );
  }
}
