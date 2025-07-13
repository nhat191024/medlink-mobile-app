import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/doctor/controllers/settings/work_schedules_controller.dart';

import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/widget/dashed_divider.dart';

class WorkSchedulesScreen extends GetView<WorkSchedulesController> {
  const WorkSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary600));
        }
        return _buildContent();
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 60,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
            ),
          ),
          const Spacer(),
          Text(
            'work_schedule_title'.tr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: controller.weeklySchedule.keys.map((day) {
              return _buildDaySchedule(day);
            }).toList(),
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildDaySchedule(String day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDayHeader(day),
        _buildTimeSlotsList(day),
        const SizedBox(height: 10),
        _buildAddTimeButton(day),
        const DashedDivider(color: AppColors.dividers, height: 2),
      ],
    );
  }

  Widget _buildDayHeader(String day) {
    return Row(
      children: [
        Obx(
          () => Transform.scale(
            scale: 1.4,
            child: Checkbox(
              value: controller.weeklySchedule[day]?.isActive.value,
              onChanged: (bool? newValue) {
                controller.weeklySchedule[day]?.isActive.value = newValue!;
                if (!newValue!) {
                  controller.removeAllTimeSlotInDay(day);
                }
              },
              activeColor: AppColors.primary600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ),
        Text(day, style: const TextStyle(fontSize: 16, fontFamily: AppFontStyleTextStrings.bold)),
        const Spacer(),
        _buildAllDayRadio(day),
      ],
    );
  }

  Widget _buildAllDayRadio(String day) {
    return Obx(
      () => SizedBox(
        width: 110,
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: controller.weeklySchedule[day]!.isActive.value
                  ? controller.weeklySchedule[day]!.isAllDay.value
                  : false,
              onChanged: (value) {
                controller.weeklySchedule[day]!.isAllDay.value = value ?? false;
              },
              activeColor: AppColors.primary600,
              toggleable: true,
            ),
            Text("all_day".tr),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsList(String day) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.weeklySchedule[day]?.timeSlots.length ?? 0,
        itemBuilder: (context, index) {
          final timeSlot = controller.weeklySchedule[day]!.timeSlots[index];
          return _buildTimeSlotRow(day, index, timeSlot);
        },
      ),
    );
  }

  Widget _buildTimeSlotRow(String day, int index, dynamic timeSlot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
      child: Row(
        children: [
          Expanded(child: _buildTimeField(timeSlot.startTime, isStartTime: true)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(width: 10, child: Divider(thickness: 1, color: AppColors.primaryText)),
          ),
          Expanded(
            child: _buildTimeField(
              timeSlot.endTime,
              isStartTime: false,
              startTime: timeSlot.startTime.value,
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              AppImages.trash,
              colorFilter: const ColorFilter.mode(AppColors.secondaryText, BlendMode.srcIn),
            ),
            onPressed: () => controller.removeTimeSlot(day, index),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(dynamic timeObservable, {required bool isStartTime, String? startTime}) {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final formattedTime = controller.formatTimeOfDay(pickedTime);

          if (isStartTime) {
            timeObservable.value = formattedTime;
          } else {
            if (controller.isEndTimeValid(startTime!, formattedTime)) {
              timeObservable.value = formattedTime;
            } else {
              Get.snackbar('Error', 'End time cannot be earlier than start time');
            }
          }
        }
      },
      child: Obx(
        () => Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getTimeDisplayText(timeObservable.value, isStartTime),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _getTimeDisplayText(String timeValue, bool isStartTime) {
    if (isStartTime) {
      return timeValue.contains('From') ? "From" : timeValue.substring(0, 5);
    } else {
      return timeValue.contains('To') ? "To" : timeValue.substring(0, 5);
    }
  }

  Widget _buildAddTimeButton(String day) {
    return Obx(
      () => controller.weeklySchedule[day]!.isActive.value
          ? TextButton(
              onPressed: () => controller.weeklySchedule[day]!.isAllDay.value
                  ? null
                  : controller.addTimeSlot(day, 'From', 'To'),
              child: Text(
                'add_time'.tr,
                style: const TextStyle(
                  color: AppColors.primary600,
                  fontFamily: AppFontStyleTextStrings.bold,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButtonPlus(
          onTap: () => Get.back(),
          btnText: "cancel".tr,
          width: Get.width / 2.5,
          rightPadding: 5,
          color: AppColors.white,
          textColor: AppColors.primaryText,
          borderColor: AppColors.primaryText,
        ),
        CustomButtonPlus(
          onTap: () => controller.saveWorkSchedule(),
          btnText: "save".tr,
          width: Get.width / 2.5,
          leftPadding: 5,
        ),
      ],
    );
  }
}
