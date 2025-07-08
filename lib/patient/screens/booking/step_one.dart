import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

import 'package:intl/intl.dart';

import 'package:medlink/model/work_schedule_model.dart';
import 'package:medlink/model/service_model.dart';

class StepOne extends StatelessWidget {
  final BookingController controller;
  final List<ServiceModel> services;
  final WorkScheduleModel timeSlots;

  const StepOne({
    super.key,
    required this.controller,
    required this.services,
    required this.timeSlots,
  });

  // Constants for better maintainability
  static const double _largeBorderRadius = 24.0;
  static const double _containerMarginHorizontal = 20.0;
  static const double _spacingMedium = 10.0;
  static const double _spacingLarge = 15.0;
  static const double _spacingExtraLarge = 20.0;
  static const double _headerFontSize = 18.0;
  static const double _titleFontSize = 16.0;
  static const double _bodyFontSize = 14.0;
  static const double _smallFontSize = 12.0;
  static const double _timeSlotWidth = 70.0;
  static const double _timeSlotHeight = 45.0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSelectedDate();
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceList(services),
        const SizedBox(height: _spacingLarge),
        _buildScheduleSection(),
      ],
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

  Widget _buildServiceList(List<ServiceModel> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'choose_services'.tr,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: services.map((service) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    controller.selectedService.value = services.indexOf(service);
                  },
                  child: Obx(
                    () => Container(
                      width: Get.width * 0.38,
                      padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                      decoration: BoxDecoration(
                        color: controller.selectedService.value == services.indexOf(service)
                            ? AppColors.primary600
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: controller.selectedService.value == services.indexOf(service)
                                  ? AppColors.white
                                  : AppColors.primary50,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              service.icon ?? '',
                              width: 38,
                              height: 38,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary600,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 0, 0, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name ?? '',
                                  style: TextStyle(
                                    color:
                                        controller.selectedService.value ==
                                            services.indexOf(service)
                                        ? AppColors.white
                                        : AppColors.primaryText,
                                    fontSize: 13,
                                    fontFamily: AppFontStyleTextStrings.regular,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${service.price ?? 0} €',
                                  style: TextStyle(
                                    color:
                                        controller.selectedService.value ==
                                            services.indexOf(service)
                                        ? AppColors.white
                                        : AppColors.primaryText,
                                    fontSize: 16,
                                    fontFamily: AppFontStyleTextStrings.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
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
            0,
            _spacingLarge,
            _containerMarginHorizontal,
            _spacingMedium,
          ),
          child: Text(
            'choose_time'.tr,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: _titleFontSize,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, _spacingMedium, 0, _spacingExtraLarge),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(_largeBorderRadius),
          ),
          child: _buildSchedule(),
        ),
      ],
    );
  }

  Widget _buildSchedule() {
    return Column(children: [_buildScheduleHeader(), _buildDateSelector(), _buildTimeSlots()]);
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
}
