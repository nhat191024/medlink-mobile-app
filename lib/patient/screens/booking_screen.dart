import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

import 'package:medlink/model/work_schedule_model.dart';
import 'package:medlink/model/service_model.dart';

import 'package:medlink/components/widget/appbar/circular_progress_indicator_with_text.dart';

import 'package:medlink/patient/screens/booking/step_one.dart';
import 'package:medlink/patient/screens/booking/step_two.dart';
import 'package:medlink/patient/screens/booking/step_three.dart';

class BookingSceen extends GetView<BookingController> {
  const BookingSceen({super.key});

  // Add getter for searchHeathCareController
  SearchHeathCareController get searchHeathCareController => Get.find<SearchHeathCareController>();

  // Get doctorIndex from arguments
  int get doctorIndex => Get.arguments['doctorIndex'] ?? 0;

  // Get services from doctorList
  List<ServiceModel> get services =>
      searchHeathCareController.doctorList[doctorIndex].services ?? [];

  // Get timeSlots from doctorList
  WorkScheduleModel get timeSlots =>
      searchHeathCareController.doctorList[doctorIndex].workSchedule ?? WorkScheduleModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'book_appointment'.tr,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 20,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: _handleBackAction,
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor info header
                    _buildDoctorHeader(),
                    const SizedBox(height: 24),

                    // Step content based on current step
                    Obx(() => _buildStepContent()),
                  ],
                ),
              ),
            ),
          ),
          // Continue button at bottom
          _buildContinueButton(),
        ],
      ),
    );
  }

  void _handleBackAction() {
    if (controller.step.value > 1) {
      controller.step.value = controller.step.value - 1;
    } else {
      Get.back();
    }
  }

  Widget _buildDoctorHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(25),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              searchHeathCareController.doctorList[doctorIndex].avatar ?? '',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. ${searchHeathCareController.doctorList[doctorIndex].name}",
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 18,
                    fontFamily: AppFontStyleTextStrings.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  searchHeathCareController.doctorList[doctorIndex].specialty ?? '',
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.medium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: CircularProgressIndicatorWithText(currentStep: controller.step, totalSteps: 3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (controller.step.value) {
      case 1:
        return StepOne(controller: controller, services: services, timeSlots: timeSlots);
      case 2:
        return StepTwo(controller: controller);
      case 3:
        return StepThree(controller: controller, searchController: searchHeathCareController);
      default:
        return StepOne(controller: controller, services: services, timeSlots: timeSlots);
    }
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 8)],
      ),
      child: SafeArea(
        child: Obx(
          () => ElevatedButton(
            onPressed: _getContinueButtonAction(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary600,
              disabledBackgroundColor: AppColors.disable,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              _getContinueButtonText(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontFamily: AppFontStyleTextStrings.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback? _getContinueButtonAction() {
    switch (controller.step.value) {
      case 1:
        return controller.selectedService.value != -1 && controller.selectedTime.value.isNotEmpty
            ? () => controller.step.value = 2
            : null;
      case 2:
        return controller.medicalProblemText.value.isNotEmpty
            ? () => controller.step.value = 3
            : null;
      case 3:
        return () {
          if (controller.selectedMethod.value == 999) {
            Get.snackbar(
              'Warning',
              'Please select a payment method',
              colorText: AppColors.errorMain,
            );
          } else {
            controller.bookAppointment(doctorIndex);
          }
        };
      default:
        return null;
    }
  }

  String _getContinueButtonText() {
    switch (controller.step.value) {
      case 1:
        return 'continue'.tr;
      case 2:
        return 'continue'.tr;
      case 3:
        return 'confirm_payment'.tr;
      default:
        return 'continue'.tr;
    }
  }
}
