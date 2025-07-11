import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';
import 'package:intl/intl.dart';

import 'package:medlink/components/button/default.dart';
import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/widget/dashed_divider.dart';

import 'package:medlink/model/work_schedule_model.dart';
import 'package:medlink/model/language_model.dart';
import 'package:medlink/model/service_model.dart';
import 'package:medlink/model/top_review_model.dart';
import 'package:medlink/model/testimonials_model.dart';
import 'package:medlink/model/doctor_model.dart';

class DoctorDetail extends StatelessWidget {
  final int index;
  final String avatar;
  final String fullName;
  final String speciality;
  final String introduce;
  final String city;
  final String rating;
  final int totalRate;
  final bool isAvailable;
  final List<LanguageModel> languages;
  final List<ServiceModel> services;
  final String latitude;
  final String longitude;
  final List<TestimonialsModel> testimonials;
  final List<TopReviewModel> topReviews;
  final WorkScheduleModel timeSlots;

  DoctorDetail({
    super.key,
    required this.index,
    required this.avatar,
    required this.fullName,
    required this.speciality,
    required this.introduce,
    required this.city,
    required this.rating,
    required this.totalRate,
    required this.isAvailable,
    required this.languages,
    required this.services,
    required this.latitude,
    required this.longitude,
    required this.testimonials,
    required this.topReviews,
    required this.timeSlots,
  });

  // Factory constructor to create from DoctorModel
  factory DoctorDetail.fromDoctorModel(
    int index,
    DoctorModel doctor, {
    List<ServiceModel>? servicesList,
    List<TestimonialsModel>? testimonialsList,
    List<TopReviewModel>? topReviewsList,
  }) {
    return DoctorDetail(
      index: index,
      avatar: doctor.avatar ?? '',
      fullName: doctor.name ?? '',
      speciality: doctor.specialty ?? '',
      introduce: doctor.introduce ?? '',
      city: doctor.location ?? '',
      rating: doctor.rating?.toString() ?? '0.0',
      totalRate: doctor.totalRate ?? 0,
      isAvailable: doctor.isAvailable ?? false,
      languages: doctor.languages ?? [],
      services: servicesList ?? [],
      latitude: doctor.latitude ?? '',
      longitude: doctor.longitude ?? '',
      testimonials: testimonialsList ?? [],
      topReviews: topReviewsList ?? [],
      timeSlots: doctor.workSchedule ?? WorkScheduleModel(),
    );
  }

  final SearchHeathCareController controller = Get.find<SearchHeathCareController>();

  // Constants for better maintainability
  static const double _headerPadding = 20.0;
  static const double _avatarMarginTop = 80.0;
  static const double _avatarSize = 120.0;
  static const double _avatarBorderRadius = 100.0;
  static const double _containerBorderRadius = 18.0;
  static const double _largeBorderRadius = 24.0;
  static const double _containerMarginHorizontal = 20.0;
  static const double _containerPadding =15.0;
  static const double _spacingSmall = 5.0;
  static const double _spacingMedium = 10.0;
  static const double _spacingLarge = 15.0;
  static const double _spacingExtraLarge = 20.0;
  static const double _headerFontSize = 18.0;
  static const double _titleFontSize = 16.0;
  static const double _bodyFontSize = 14.0;
  static const double _smallFontSize = 12.0;
  static const double _timeSlotWidth = 70.0;
  static const double _timeSlotHeight = 45.0;
  static const double _ratingIconSize = 20.0;
  static const double _serviceIconSize = 30.0;
  static const double _favoriteIconSize = 30.0;
  static const double _favoriteButtonRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    // Initialize selected date if not already set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSelectedDate();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {}
        },
        child: SingleChildScrollView(child: Stack(children: [_buildMainContent(), _buildHeader()])),
      ),
    );
  }

  void _initializeSelectedDate() {
    if (controller.selectedDate.value.isEmpty) {
      final currentMonth = DateFormat('MMM').format(DateTime.now());

      // Find first available date
      for (final date in controller.listDate) {
        final timeSlots = this.timeSlots.getTimeSlotsForDate(currentMonth, date);
        if (timeSlots != null && timeSlots.any((slot) => slot.isAvailable == true)) {
          controller.selectedDate.value = date;
          break;
        }
      }
    }
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDoctorProfile(),
        _buildInfoCards(),
        _buildLanguageCard(),
        _buildServiceSection(),
        _buildScheduleSection(),
        _buildLocationSection(),
        if (testimonials.isNotEmpty) _buildTestimonialsSection(),
        if (testimonials.isNotEmpty) _buildBookingButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_headerPadding, 40, _headerPadding, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildBackButton(), _buildFavoriteButton()],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => {
        controller.selectedDate.value = '',
        controller.selectedTime.value = '',
        Get.back(),
      },
      child: Container(
        padding: const EdgeInsets.all(_spacingMedium),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.arrow_back, color: AppColors.primaryText, size: 25),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return CircleAvatar(
      backgroundColor: AppColors.white,
      radius: _favoriteButtonRadius,
      child: SvgPicture.asset(
        AppImages.heart,
        height: _favoriteIconSize,
        width: _favoriteIconSize,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildDoctorProfile() {
    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: _avatarMarginTop),
            height: _avatarSize,
            width: _avatarSize,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(_avatarBorderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              avatar,
              fit: controller.checkIfDefaultAvatar(avatar) ? BoxFit.none : BoxFit.cover,
            ),
          ),
          SizedBox(height: _spacingLarge),
          Text(
            fullName,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: _headerFontSize,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
          Text(
            speciality,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: _bodyFontSize,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
          SizedBox(height: _spacingLarge),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Get.width * 0.9),
            child: Text(
              introduce,
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: _bodyFontSize,
                fontFamily: AppFontStyleTextStrings.regular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        _containerMarginHorizontal,
        _spacingLarge,
        _containerMarginHorizontal,
        _spacingMedium,
      ),
      padding: EdgeInsets.fromLTRB(
        _containerPadding,
        _spacingLarge,
        _containerPadding,
        _spacingLarge,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_containerBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoColumn(
            city.length > 11 ? '${city.substring(0, 11)}...' : city,
            'location'.tr,
            AppColors.primaryText,
          ),
          _buildInfoColumn(
            rating == '0.0' ? 'not_rated'.tr : rating,
            'rating'.tr,
            AppColors.primaryText,
            needDivider: true,
            isRating: true,
            rateCount: totalRate,
          ),
          _buildInfoColumn(
            isAvailable ? 'available'.tr : 'busy'.tr,
            'schedule'.tr,
            isAvailable ? AppColors.successMain : AppColors.errorMain,
            needDivider: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        _containerMarginHorizontal,
        0,
        _containerMarginHorizontal,
        _spacingMedium,
      ),
      padding: EdgeInsets.fromLTRB(40, _spacingLarge, 40, _spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_containerBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var language in languages) ...[
            if (languages.indexOf(language) != 0)
              const SizedBox(
                height: 30,
                child: VerticalDivider(color: AppColors.border, thickness: 1),
              ),
            _buildLanguageItem(language.name ?? ''),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            _containerMarginHorizontal,
            _spacingLarge,
            _containerMarginHorizontal,
            0,
          ),
          child: Text(
            'service'.tr,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: _titleFontSize,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
            _containerMarginHorizontal,
            _spacingLarge,
            _containerMarginHorizontal,
            _spacingExtraLarge,
          ),
          padding: EdgeInsets.fromLTRB(_containerPadding, 0, _containerPadding, 0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(_largeBorderRadius),
          ),
          child: _buildServiceList(services),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            _containerMarginHorizontal,
            _spacingLarge,
            _containerMarginHorizontal,
            0,
          ),
          child: Text(
            'available_time'.tr,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: _titleFontSize,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
            _containerMarginHorizontal,
            _spacingLarge,
            _containerMarginHorizontal,
            _spacingExtraLarge,
          ),
          padding: EdgeInsets.fromLTRB(0, _spacingMedium, 0, 0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(_largeBorderRadius),
          ),
          child: _buildSchedule(),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            _containerMarginHorizontal,
            _spacingExtraLarge,
            _containerMarginHorizontal,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'location'.tr,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: _titleFontSize,
                  fontFamily: AppFontStyleTextStrings.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.allReviewScreen);
                },
                child: Text(
                  'view_direction'.tr,
                  style: const TextStyle(
                    color: AppColors.primary600,
                    decoration: TextDecoration.underline,
                    fontSize: _bodyFontSize,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
            _containerMarginHorizontal,
            _spacingLarge,
            _containerMarginHorizontal,
            _spacingExtraLarge,
          ),
          padding: EdgeInsets.fromLTRB(
            _containerPadding,
            _spacingLarge,
            _containerPadding,
            _spacingLarge,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(_largeBorderRadius),
          ),
          child: Image.asset(AppImages.mapDemo),
        ),
      ],
    );
  }

  Widget _buildTestimonialsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _containerMarginHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'testimonials'.tr,
                style: const TextStyle(
                  fontSize: _titleFontSize,
                  fontFamily: AppFontStyleTextStrings.bold,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: _spacingMedium),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.allReviewScreen);
                },
                child: Text(
                  'view_all_review'.tr,
                  style: const TextStyle(
                    color: AppColors.primary600,
                    decoration: TextDecoration.underline,
                    fontSize: _bodyFontSize,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _spacingMedium),
          for (var testimonial in testimonials) ...[
            _buildRatingRow(
              testimonial.start ?? 0,
              testimonial.title ?? '',
              double.tryParse(testimonial.fraction ?? '0') ?? 0.0,
            ),
          ],
          SizedBox(height: _spacingMedium),
          ..._buildReviewCards(),
        ],
      ),
    );
  }

  List<Widget> _buildReviewCards() {
    return topReviews
        .map(
          (review) => Container(
            margin: EdgeInsets.only(bottom: _spacingMedium),
            padding: EdgeInsets.fromLTRB(
              _containerPadding,
              _spacingLarge,
              _containerPadding,
              _spacingLarge,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(_largeBorderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReviewHeader(review),
                SizedBox(height: _spacingExtraLarge),
                Text(
                  review.review ?? '',
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: _bodyFontSize,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildReviewHeader(TopReviewModel review) {
    return Row(
      children: [
        CircleAvatar(radius: 25, backgroundImage: Image.network(review.avatar ?? '').image),
        SizedBox(width: _spacingMedium),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.name ?? '',
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: _bodyFontSize,
                fontFamily: AppFontStyleTextStrings.medium,
              ),
            ),
            Text(
              controller.formatDate(review.createdAt ?? ''),
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: _smallFontSize,
                fontFamily: AppFontStyleTextStrings.regular,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 2, 10, 2),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: _ratingIconSize + 2),
              const SizedBox(width: 4),
              Text(
                review.rate?.toString() ?? '0',
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: _bodyFontSize,
                  fontFamily: AppFontStyleTextStrings.medium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingButton() {
    return Obx(() {
      final hasSelectedTime = controller.selectedTime.value.isNotEmpty;
      return CustomButtonDefault(
        onTap: () {
          if (hasSelectedTime) {
            // buildBookingModal(context, index, services, timeSlots);
          }
        },
        btnText: "book_appointment".tr,
        isDisabled: !hasSelectedTime,
        topPadding: _spacingMedium,
      );
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topText,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: _smallFontSize,
                fontFamily: AppFontStyleTextStrings.regular,
              ),
            ),
            const SizedBox(height: 4),
            isRating
                ? Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: _ratingIconSize),
                      const SizedBox(width: 4),
                      Text(
                        bottomText,
                        style: TextStyle(
                          color: color,
                          fontSize: _bodyFontSize,
                          fontFamily: AppFontStyleTextStrings.medium,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($rateCount)',
                        style: const TextStyle(
                          color: AppColors.disable,
                          fontSize: _smallFontSize,
                          fontFamily: AppFontStyleTextStrings.regular,
                        ),
                      ),
                    ],
                  )
                : Text(
                    bottomText,
                    style: TextStyle(
                      color: color,
                      fontSize: _bodyFontSize,
                      fontFamily: AppFontStyleTextStrings.medium,
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageItem(String language) {
    return Row(
      children: [
        SvgPicture.asset(language.contains("English") ? AppImages.english : AppImages.vietnamese),
        SizedBox(width: _spacingMedium),
        Text(
          language,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: _bodyFontSize,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
      ],
    );
  }

  Widget _buildSchedule() {
    return Column(
      children: [
        _buildScheduleHeader(),
        _buildDateSelector(),
        _buildTimeSlots(),
        _buildAllSchedulesButton(),
      ],
    );
  }

  Widget _buildScheduleHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _spacingExtraLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.currentMonthYear,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: _headerFontSize,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        _buildNavigationButton(Icons.arrow_back_ios, () {}),
        SizedBox(width: _spacingMedium),
        _buildNavigationButton(Icons.arrow_forward_ios, () {}),
      ],
    );
  }

  Widget _buildNavigationButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, color: AppColors.primaryText, size: 20),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, _spacingMedium, 0, _spacingExtraLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(controller.listDay.length, (index) {
            final date = controller.listDate[index];
            final currentMonth = DateFormat('MMM').format(DateTime.now());
            final dayTimeSlots = timeSlots.getTimeSlotsForDate(currentMonth, date);
            final isAvailable =
                dayTimeSlots != null && dayTimeSlots.any((slot) => slot.isAvailable == true);
            final isSelected = date == controller.selectedDate.value;

            return Expanded(
              child: GestureDetector(
                onTap: isAvailable
                    ? () {
                        controller.selectedDate.value = date;
                        // Clear selected time when changing date
                        controller.selectedTime.value = '';
                      }
                    : null,
                child: Column(
                  children: [
                    Text(
                      controller.listDay[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary600
                            : (isAvailable ? AppColors.secondaryText : AppColors.disable),
                        fontFamily: AppFontStyleTextStrings.medium,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.listDate[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary600
                            : (isAvailable ? AppColors.secondaryText : AppColors.disable),
                        fontFamily: AppFontStyleTextStrings.regular,
                        fontSize: _smallFontSize,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Divider(
                      color: isSelected ? AppColors.primary600 : AppColors.dividers,
                      height: 1,
                      thickness: isSelected ? 2 : 1,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildTimeSlots() {
    return Obx(() {
      // Get current month
      final currentMonth = DateFormat('MMM').format(DateTime.now());

      // Get selected date from controller
      final selectedDate = controller.selectedDate.value;

      // Get time slots for the selected date from WorkScheduleModel
      final dayTimeSlots = timeSlots.getTimeSlotsForDate(currentMonth, selectedDate);

      if (dayTimeSlots == null || dayTimeSlots.isEmpty) {
        return Container(
          padding: EdgeInsets.all(_spacingLarge),
          child: Text(
            'No available time slots for this date',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: _bodyFontSize,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      return Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: dayTimeSlots.map((timeSlot) {
          String time = timeSlot.time ?? '';
          bool isAvailable = timeSlot.isAvailable ?? false;
          bool isSelected = time == controller.selectedTime.value;
          return _buildTimeSlot(time, isAvailable, isSelected);
        }).toList(),
      );
    });
  }

  Widget _buildTimeSlot(String time, bool isAvailable, bool isSelected) {
    return GestureDetector(
      onTap: isAvailable ? () => controller.selectedTime.value = time : null,
      child: Container(
        width: _timeSlotWidth,
        height: _timeSlotHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary600
              : (isAvailable ? AppColors.white : AppColors.background),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary600
                : (isAvailable ? AppColors.border : AppColors.background),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: _buildTimeSlotContent(time, isAvailable, isSelected),
      ),
    );
  }

  Widget _buildTimeSlotContent(String time, bool isAvailable, bool isSelected) {
    final timeParts = time.split(' ');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          timeParts[0],
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isAvailable ? AppColors.primaryText : AppColors.disable),
            fontSize: 13,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
        if (timeParts.length > 1)
          Text(
            timeParts[1],
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isAvailable ? AppColors.primaryText : AppColors.disable),
              fontSize: 10,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
      ],
    );
  }

  Widget _buildAllSchedulesButton() {
    return Padding(
      padding: EdgeInsets.only(top: _spacingMedium, bottom: _spacingLarge),
      child: CustomButtonPlus(
        onTap: () {},
        btnText: "all_schedules_available".tr,
        textSize: _bodyFontSize,
        fontFamily: AppFontStyleTextStrings.medium,
        textColor: AppColors.primaryText,
        borderColor: AppColors.primaryText,
        color: AppColors.white,
        width: Get.width * 0.35,
        topPadding: 0,
        bottomPadding: 0,
      ),
    );
  }

  Widget _buildServiceList(List<ServiceModel> services) {
    return Column(
      children: [
        for (var service in services) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(0, _spacingLarge, 0, _spacingLarge),
            child: Row(
              children: [
                _buildServiceIcon(),
                SizedBox(width: _spacingMedium + 2),
                _buildServiceInfo(service),
                const Spacer(),
                _buildServicePrice(service),
              ],
            ),
          ),
          if (services.indexOf(service) != services.length - 1)
            const DashedDivider(color: AppColors.dividers, height: 2),
        ],
      ],
    );
  }

  Widget _buildServiceIcon() {
    return Container(
      padding: EdgeInsets.all(_spacingMedium),
      decoration: const BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
      child: SvgPicture.asset(
        AppImages.home2,
        width: _serviceIconSize,
        height: _serviceIconSize,
        colorFilter: const ColorFilter.mode(AppColors.primary600, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildServiceInfo(ServiceModel service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service.name ?? '',
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: _bodyFontSize,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
        SizedBox(height: _spacingSmall / 2.5),
        Text(
          service.description ?? '',
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: _smallFontSize,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
      ],
    );
  }

  Widget _buildServicePrice(ServiceModel service) {
    return Text(
      '\$${service.price ?? 0}',
      style: const TextStyle(
        color: AppColors.primaryText,
        fontSize: _bodyFontSize,
        fontFamily: AppFontStyleTextStrings.bold,
      ),
    );
  }

  Widget _buildRatingRow(int stars, String label, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '$stars',
                style: const TextStyle(
                  fontSize: _bodyFontSize,
                  fontFamily: AppFontStyleTextStrings.medium,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.star, color: Colors.amber, size: _ratingIconSize),
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
          SizedBox(width: _spacingMedium),
          Text(
            label,
            style: const TextStyle(
              fontSize: _bodyFontSize,
              color: AppColors.secondaryText,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ],
      ),
    );
  }
}
