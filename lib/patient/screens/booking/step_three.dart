import 'dart:ui';

import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';
import 'package:medlink/model/service_model.dart';

import 'package:medlink/components/button/plus.dart';

import 'package:medlink/model/payment_method_model.dart';

class StepThree extends StatelessWidget {
  final BookingController controller;
  final SearchHeathCareController searchController;

  const StepThree({super.key, required this.controller, required this.searchController});

  // Get doctor index from arguments
  int get doctorIndex => Get.arguments['doctorIndex'] ?? 0;

  // Get selected service safely
  ServiceModel? get selectedService {
    final selectedIndex = controller.selectedService.value;
    final services = searchController.doctorList[doctorIndex].services;

    if (selectedIndex >= 0 && services != null && selectedIndex < services.length) {
      return services[selectedIndex];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildReviewSchedule(),
        const SizedBox(height: 10),
        _buildInformation(),
        const SizedBox(height: 15),
        _buildPaymentMethod(context),
      ],
    );
  }

  Widget _buildReviewSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'review_schedule'.tr,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [_buildScheduleHeader(), const SizedBox(height: 15), _buildScheduleDetails()],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'time&date'.tr,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => controller.step.value = 1,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(50),
            ),
            child: SvgPicture.asset(AppImages.pencilSimpleLine, height: 24, width: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateSection(),
        _buildDivider(),
        _buildTimeSection(),
        const SizedBox(width: 0),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppImages.calendarIcon),
            const SizedBox(width: 5),
            Text(
              'date'.tr,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: AppFontStyleTextStrings.regular,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          controller.convertDateFormat(
            "${controller.selectedDate.value} ${controller.currentMonthYear}",
          ),
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        SizedBox(height: 30, child: VerticalDivider(color: AppColors.border, thickness: 1)),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppImages.clock3,
              colorFilter: const ColorFilter.mode(AppColors.secondaryText, BlendMode.srcIn),
            ),
            const SizedBox(width: 5),
            Text(
              'time'.tr,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: AppFontStyleTextStrings.regular,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          "${controller.selectedTime.value} - ${controller.addMinutesToTime(controller.selectedTime.value, _getSelectedServiceDuration())}",
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  int _getSelectedServiceDuration() {
    return selectedService?.duration ?? 30;
  }

  Widget _buildInformation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInformationHeader(),
          const SizedBox(height: 15),
          _buildAddressInfo(),
          const SizedBox(height: 15),
          _buildGPSInfo(),
        ],
      ),
    );
  }

  Widget _buildInformationHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${selectedService?.name} service',
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => controller.step.value = 2,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(50),
            ),
            child: SvgPicture.asset(AppImages.pencilSimpleLine, height: 24, width: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppImages.mapPinLine,
              colorFilter: const ColorFilter.mode(AppColors.secondaryText, BlendMode.srcIn),
            ),
            const SizedBox(width: 5),
            Text(
              'address'.tr,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: AppFontStyleTextStrings.regular,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          "${controller.address.text}, ${controller.zipCode.text} ${controller.city.text}, ${controller.country.text}",
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildGPSInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppImages.mapPinLine,
              colorFilter: const ColorFilter.mode(AppColors.secondaryText, BlendMode.srcIn),
            ),
            const SizedBox(width: 5),
            Text(
              'gps_location'.tr,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: AppFontStyleTextStrings.regular,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          controller.gps.text,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBillDetail(),
        const SizedBox(height: 15),
        Text(
          'payment_method'.tr,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildChoosePayment(context),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildBillDetail({bool noHeader = false}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [if (!noHeader) _buildBillHeader(), _buildBillItems(), _buildBillTotal()],
      ),
    );
  }

  Widget _buildBillHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 40, 0),
          child: Text(
            'bill_detail'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
              color: AppColors.primaryText,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Divider(color: AppColors.dividers, thickness: 1),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBillItems() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              Text(
                selectedService?.name ?? 'Service',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                controller.formatPrice(selectedService?.price ?? 0),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              Text(
                'tax_vat'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                //10% of the service price
                controller.formatPrice(controller.calculateTax(selectedService?.price ?? 0)),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: AppColors.dividers, thickness: 1),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBillTotal() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: Row(
        children: [
          Text(
            'total'.tr,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppFontStyleTextStrings.regular,
              color: AppColors.primaryText,
            ),
          ),
          const Spacer(),
          Text(
            controller.formatPrice(controller.calculateTotal(selectedService?.price ?? 0)),
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.bold,
              color: AppColors.primary600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoosePayment(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Obx(() {
        if (controller.paymentMethods.isEmpty && !controller.isPaymentMethodsLoading.value) {
          controller.refreshPaymentMethodsIfNeeded();
        }

        return Column(
          children: [
            if (controller.selectedMethod.value == 999) ...[
              _buildNoPaymentMethodSelected(context),
            ] else ...[
              _buildSelectedPaymentMethod(),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildNoPaymentMethodSelected(BuildContext context) {
    return Column(
      children: [
        if (controller.isPaymentMethodsLoading.value)
          const CircularProgressIndicator(color: AppColors.primary600)
        else if (controller.paymentMethods.isEmpty)
          Text(
            "no_card".tr,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.disable,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          )
        else
          SvgPicture.asset(AppImages.card, height: 40, width: 40),
        const SizedBox(height: 10),
        if (!controller.isPaymentMethodsLoading.value)
          CustomButtonPlus(
            onTap: () {
              if (controller.paymentMethods.isEmpty) {
                // Handle add new card
              } else {
                _buildChooseMethodModal(context);
              }
            },
            btnText: controller.paymentMethods.isEmpty ? "add_new_card".tr : "choose_a_method".tr,
            textSize: 14,
            textColor: AppColors.primaryText,
            fontFamily: AppFontStyleTextStrings.medium,
            color: AppColors.transparentColor,
            borderColor: AppColors.primaryText,
            svgImage: AppImages.bankCard,
            imageColor: AppColors.primaryText,
            leftPadding: 20,
            rightPadding: 20,
            bottomPadding: 0,
          ),
      ],
    );
  }

  Widget _buildSelectedPaymentMethod() {
    final selectedPaymentMethod = controller.selectedPaymentMethod;
    if (selectedPaymentMethod == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
            child: selectedPaymentMethod.isCard
                ? SvgPicture.asset(AppImages.bankCard)
                : SvgPicture.asset(AppImages.money),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentMethodName(),
                const SizedBox(height: 5),
                _buildPaymentMethodDetails(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _buildChooseMethodModal(Get.context!),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(50),
              ),
              child: SvgPicture.asset(AppImages.pencilSimpleLine, height: 20, width: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodName() {
    final selectedPaymentMethod = controller.selectedPaymentMethod;
    if (selectedPaymentMethod == null) return const SizedBox();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Get.width * 0.5),
      child: Text(
        searchController.username.value,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: AppFontStyleTextStrings.bold,
          color: AppColors.primaryText,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodDetails() {
    final selectedPaymentMethod = controller.selectedPaymentMethod;
    if (selectedPaymentMethod == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              if (selectedPaymentMethod.isCard)
                TextSpan(
                  text: "${"card.tr"} ",
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: AppFontStyleTextStrings.regular,
                    color: AppColors.secondaryText,
                  ),
                ),
              TextSpan(
                text: selectedPaymentMethod.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          selectedPaymentMethod.provider,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: AppFontStyleTextStrings.regular,
            color: AppColors.secondaryText,
          ),
        ),
        if (selectedPaymentMethod.isCard) ...[
          const SizedBox(height: 5),
          Text(
            '${"expire".tr} ${selectedPaymentMethod.expiry}',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: AppFontStyleTextStrings.regular,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ],
    );
  }

  Future _buildChooseMethodModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {}
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildPaymentMethodModalHeader(), _buildPaymentMethodGrid()],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodModalHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Get.width * 0.5),
            child: Text(
              "choose_your_payment".tr,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: AppFontStyleTextStrings.bold,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryText.withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: SvgPicture.asset(AppImages.card, height: 34, width: 34),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodGrid() {
    final List<PaymentMethodModel> paymentMethods = controller.paymentMethods;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2 / 1.8,
      ),
      itemCount: paymentMethods.length + 1,
      itemBuilder: (context, index) {
        if (index == paymentMethods.length) {
          return _buildAddNewCardItem();
        } else {
          return _buildPaymentMethodItem(paymentMethods, index);
        }
      },
    );
  }

  Widget _buildAddNewCardItem() {
    return GestureDetector(
      onTap: () {
        // Handle add new card
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
        decoration: BoxDecoration(
          color: AppColors.dividers,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.border, width: 2, style: BorderStyle.values[1]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.transparentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.disable, width: 2),
                ),
                child: const Icon(Icons.add, color: AppColors.disable, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                "add_new_card".tr,
                style: const TextStyle(
                  color: AppColors.disable,
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(List<PaymentMethodModel> paymentMethods, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectedMethod.value = index;
        Get.back();
      },
      child: Obx(
        () => Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
          decoration: BoxDecoration(
            color: controller.selectedMethod.value == index
                ? AppColors.primary600
                : AppColors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(
                  paymentMethods[index].icon == "assets/icons/bank_card.svg" ? 14 : 10,
                ),
                decoration: BoxDecoration(
                  color: controller.selectedMethod.value == index
                      ? AppColors.white
                      : AppColors.primary50,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(paymentMethods[index].icon),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 0, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethods[index].name,
                      style: TextStyle(
                        color: controller.selectedMethod.value == index
                            ? AppColors.white
                            : AppColors.primary600,
                        fontSize: 16,
                        fontFamily: AppFontStyleTextStrings.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      paymentMethods[index].info,
                      style: TextStyle(
                        color: controller.selectedMethod.value == index
                            ? AppColors.white
                            : AppColors.secondaryText,
                        fontSize: 14,
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
