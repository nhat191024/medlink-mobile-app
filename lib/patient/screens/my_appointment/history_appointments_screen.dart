import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/controllers/my_appointments_controller.dart';

class PatientHistoryAppointmentsScreen extends GetView<PatientMyAppointmentsControllers> {
  PatientHistoryAppointmentsScreen({super.key});

  final PatientMyAppointmentsControllers controllers = Get.put(PatientMyAppointmentsControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Obx(() {
            if (controllers.historyQuantity.value == 0) {
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
                      itemCount: controllers.historyAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = controllers.historyAppointments.toList()[index];
                        return GestureDetector(
                          onTap: () {
                            controller.buildHistoryAppointmentDetail(context, appointment);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            shadowColor: AppColors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 12, 12, 10),
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
                                          fit: controllers.checkIfDefaultAvatar(appointment.avatar)
                                              ? BoxFit.scaleDown
                                              : BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: Get.width * 0.4),
                                            child: Text(
                                              appointment.doctorName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: AppFontStyleTextStrings.bold,
                                                color: AppColors.primaryText,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          Text(
                                            appointment.medicalCategory,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontFamily: AppFontStyleTextStrings.regular,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      if (appointment.status == "waiting") ...[
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                                          decoration: BoxDecoration(
                                            color: AppColors.otherColor3,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(AppImages.checkBroken),
                                              const SizedBox(width: 5),
                                              Text(
                                                "waiting".tr,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: AppFontStyleTextStrings.medium,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else if (appointment.status == "completed") ...[
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                                          decoration: BoxDecoration(
                                            color: AppColors.infoMain,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(AppImages.checkBroken),
                                              const SizedBox(width: 5),
                                              Text(
                                                "complete_btn".tr,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: AppFontStyleTextStrings.medium,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else if (appointment.status == "rejected") ...[
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary400,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(AppImages.xCircle),
                                              const SizedBox(width: 5),
                                              Text(
                                                "rejected".tr,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: AppFontStyleTextStrings.medium,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else ...[
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                                          decoration: BoxDecoration(
                                            color: AppColors.disable,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(AppImages.cancel),
                                              const SizedBox(width: 5),
                                              Text(
                                                "cancelled".tr,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: AppFontStyleTextStrings.medium,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                            controllers.formatPrice(appointment.price),
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
                                                      "${controllers.hoursUntilAppointment(appointment).toStringAsFixed(0)} ${"hours_left".tr}",
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
                                          if (appointment.meetType.contains("Khám tại nhà")) ...[
                                            Flexible(
                                              child: Text(
                                                appointment.address,
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppFontStyleTextStrings.regular,
                                                  color: AppColors.primaryText,
                                                ),
                                              ),
                                            ),
                                          ] else if (appointment.meetType.contains(
                                            "Khám tại phòng khám",
                                          )) ...[
                                            Flexible(
                                              child: Text(
                                                appointment.officeAddress,
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppFontStyleTextStrings.regular,
                                                  color: AppColors.primaryText,
                                                ),
                                              ),
                                            ),
                                          ] else ...[
                                            Flexible(
                                              child: Text(
                                                appointment.link,
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppFontStyleTextStrings.regular,
                                                  color: AppColors.primaryText,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 10),
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
