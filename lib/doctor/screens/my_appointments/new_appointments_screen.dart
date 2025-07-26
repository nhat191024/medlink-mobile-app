import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/doctor/controllers/my_appointments_controller.dart';
import 'package:medlink/components/widget/appointments/doctor/new_appointment_detail.dart';
import 'package:medlink/components/button/plus.dart';

class DoctorNewAppointmentsScreen extends GetView<DoctorMyAppointmentsControllers> {
  const DoctorNewAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary600));
            } else if (controller.newQuantity.value == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppImages.calendar),
                    const SizedBox(height: 25),
                    Text(
                      'no_appointment'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: AppFontStyleTextStrings.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                      child: Text(
                        'no_appointment_description'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: AppFontStyleTextStrings.regular,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: controller.newAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = controller.newAppointments[index];
                        return GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              NewAppointmentDetail(
                                appointment: appointment,
                                index: index,
                                formatDate: controller.formatDate,
                                checkIfDefaultAvatar: controller.checkIfDefaultAvatar,
                                showBlurDialog: controller.showBlurDialog,
                                acceptRejectAppointment: controller.acceptRejectAppointment,
                                formatPrice: controller.formatPrice,
                                openCalendar: controller.openCalendar,
                              ),
                              isScrollControlled: true,
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            shadowColor: AppColors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary50,
                                          shape: BoxShape.circle,
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.network(
                                          appointment.avatar,
                                          fit: controller.checkIfDefaultAvatar(appointment.avatar)
                                              ? BoxFit.scaleDown
                                              : BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointment.patientName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: AppFontStyleTextStrings.bold,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                          Text(
                                            'ID - ${appointment.id}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontFamily: AppFontStyleTextStrings.regular,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(color: AppColors.dividers, thickness: 1),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: AppColors.background,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(AppImages.home2),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            appointment.meetType,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppFontStyleTextStrings.regular,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const CircleAvatar(
                                            radius: 3.0,
                                            backgroundColor: Colors.black,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            controller.formatPrice(appointment.price),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppFontStyleTextStrings.bold,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: AppColors.background,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(AppImages.clock2),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                appointment.date,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppFontStyleTextStrings.regular,
                                                  color: AppColors.primaryText,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.otherColor3,
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      "${controller.hoursUntilAppointment(appointment).toStringAsFixed(0)} ${"hours_left".tr}",
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontFamily: AppFontStyleTextStrings.medium,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    appointment.time,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: AppFontStyleTextStrings.regular,
                                                      color: AppColors.primaryText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: AppColors.background,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(AppImages.mapPinLine),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Text(
                                              appointment.patientAddress,
                                              softWrap: true,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: AppFontStyleTextStrings.regular,
                                                color: AppColors.primaryText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomButtonPlus(
                                            onTap: () {
                                              controller.showBlurDialog(
                                                context,
                                                appointment,
                                                index,
                                                "rejected",
                                                false,
                                                true,
                                              );
                                            },
                                            height: 42,
                                            width: Get.width * 0.4,
                                            color: AppColors.primary600,
                                            btnText: 'decline'.tr,
                                            fontFamily: AppFontStyleTextStrings.medium,
                                            textSize: 14,
                                            textColor: AppColors.white,
                                            topPadding: 0,
                                            bottomPadding: 0,
                                            leftPadding: 0,
                                            rightPadding: 0,
                                          ),
                                          CustomButtonPlus(
                                            onTap: () {
                                              controller.acceptRejectAppointment(
                                                appointment,
                                                index,
                                                "upcoming",
                                                false,
                                              );
                                            },
                                            height: 42,
                                            width: Get.width * 0.4,
                                            borderColor: AppColors.primaryText,
                                            btnText: 'accept'.tr,
                                            fontFamily: AppFontStyleTextStrings.medium,
                                            textSize: 14,
                                            topPadding: 0,
                                            bottomPadding: 0,
                                            leftPadding: 0,
                                            rightPadding: 0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}
