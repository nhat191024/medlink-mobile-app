import 'package:medlink/model/work_schedule_model.dart';
import 'package:medlink/model/doctor_model.dart';
import 'package:medlink/patient/utils/patient_imports.dart';
import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/components/button/plus.dart';

import 'package:medlink/model/service_model.dart';

class DoctorCard extends StatelessWidget {
  final int index;
  final List<ServiceModel> services;
  final WorkScheduleModel workSchedule;
  final SearchHeathCareController controller;

  const DoctorCard({
    super.key,
    required this.index,
    required this.services,
    required this.workSchedule,
    required this.controller,
  });

  // Constants for better maintainability
  static const double _cardMarginHorizontal = 20.0;
  static const double _cardMarginVertical = 10.0;
  static const double _cardPadding = 10.0;
  static const double _cardBorderRadius = 24.0;
  static const double _avatarSize = 50.0;
  static const double _avatarBorderRadius = 100.0;
  static const double _ratingContainerRadius = 50.0;
  static const double _ratingIconSize = 20.0;
  static const double _infoContainerBorderRadius = 18.0;
  static const double _verticalDividerHeight = 30.0;
  static const double _favoriteButtonRadius = 24.0;
  static const double _favoriteIconSize = 30.0;
  static const double _locationWidth = 80.0;
  static const double _titleFontSize = 14.0;
  static const double _subtitleFontSize = 12.0;
  static const double _popularFontSize = 10.0;
  static const double _spacingSmall = 3.0;
  static const double _spacingMedium = 5.0;
  static const double _spacingLarge = 10.0;

  // Get doctor data
  DoctorModel get _doctor => controller.doctorList[index];

  // Getter methods for doctor properties
  String get avatar => _doctor.avatar ?? '';
  String get name => _doctor.name ?? '';
  bool get isPopular => _doctor.isPopular ?? false;
  String get speciality => _doctor.specialty ?? '';
  double get rating => _doctor.rating ?? 0.0;
  String get location => _doctor.location ?? '';
  int get minPrice => _doctor.minPrice ?? 0;
  bool get isAvailable => _doctor.isAvailable ?? false;
  RxBool get isFavorite => _doctor.isFavorite ?? RxBool(false);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.fromLTRB(
        _cardMarginHorizontal,
        _cardMarginVertical,
        _cardMarginHorizontal,
        0,
      ),
      padding: EdgeInsets.all(_cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
      ),
      child: Column(children: [_buildDoctorHeader(), _buildDoctorInfo()]),
    );
  }

  Widget _buildDoctorHeader() {
    return Row(
      children: [
        _buildDoctorAvatar(),
        SizedBox(width: _spacingLarge),
        _buildDoctorDetails(),
        const Spacer(),
        _buildRatingContainer(),
      ],
    );
  }

  Widget _buildDoctorAvatar() {
    return Container(
      height: _avatarSize,
      width: _avatarSize,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(_avatarBorderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        avatar,
        fit: controller.checkIfDefaultAvatar(avatar) ? BoxFit.cover : BoxFit.cover,
      ),
    );
  }

  Widget _buildDoctorDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dr. $name",
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: _titleFontSize,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
        SizedBox(height: _spacingSmall),
        _buildSpecialtyRow(),
      ],
    );
  }

  Widget _buildSpecialtyRow() {
    return Row(
      children: [
        if (isPopular) ...[_buildPopularBadge(), SizedBox(width: _spacingMedium)],
        Text(
          speciality,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: _subtitleFontSize,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularBadge() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary600,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        "popular".tr,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: _popularFontSize,
          fontFamily: AppFontStyleTextStrings.medium,
        ),
      ),
    );
  }

  Widget _buildRatingContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_ratingContainerRadius),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 10),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.amber, size: _ratingIconSize),
          SizedBox(width: _spacingMedium),
          Text(
            rating.toString(),
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: _subtitleFontSize,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(_spacingMedium, _spacingLarge, _spacingMedium, _spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(_infoContainerBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildInfoRow(), _buildActionRow()],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_spacingLarge, _spacingLarge, _spacingLarge, _spacingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLocationInfo(),
          _buildVerticalDivider(),
          _buildPriceInfo(),
          _buildVerticalDivider(),
          _buildScheduleInfo(),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "location".tr,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: _subtitleFontSize,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          width: _locationWidth,
          child: Text(
            location,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: _titleFontSize,
              fontFamily: AppFontStyleTextStrings.medium,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return SizedBox(
      height: _verticalDividerHeight,
      child: const VerticalDivider(color: AppColors.border, thickness: 1),
    );
  }

  Widget _buildPriceInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "price_from".tr,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: _subtitleFontSize,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "\$$minPrice",
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: _titleFontSize,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "schedule".tr,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: _subtitleFontSize,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
        SizedBox(height: 4),
        Text(
          isAvailable ? "available".tr : "busy".tr,
          style: TextStyle(
            color: isAvailable ? AppColors.successMain : AppColors.errorMain,
            fontSize: _titleFontSize,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: _spacingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBookingButton(),
          SizedBox(width: _spacingLarge),
          _buildFavoriteButton(),
        ],
      ),
    );
  }

  Widget _buildBookingButton() {
    return CustomButtonPlus(
      onTap: () => Get.toNamed(Routes.bookingScreen, arguments: {'doctorIndex': index}),
      btnText: 'book_appointment'.tr,
      textSize: _titleFontSize,
      fontFamily: AppFontStyleTextStrings.medium,
      leftPadding: 0,
      rightPadding: 0,
      bottomPadding: _spacingLarge,
      width: Get.width * 0.6,
      svgImage: AppImages.calendarIcon,
      isDisabled: !isAvailable,
    );
  }

  Widget _buildFavoriteButton() {
    return Obx(
      () => CircleAvatar(
        backgroundColor: isFavorite.value ? AppColors.primary600 : AppColors.white,
        radius: _favoriteButtonRadius,
        child: SvgPicture.asset(
          isFavorite.value ? AppImages.heartIcon : AppImages.heart,
          height: _favoriteIconSize,
          width: _favoriteIconSize,
          colorFilter: ColorFilter.mode(
            isFavorite.value ? AppColors.white : AppColors.primary600,
            BlendMode.srcIn,
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
