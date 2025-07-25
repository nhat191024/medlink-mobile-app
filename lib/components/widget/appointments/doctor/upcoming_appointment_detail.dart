import 'package:medlink/model/appointment_model.dart';
import 'package:medlink/utils/app_imports.dart';

class UpcomingAppointmentDetail extends StatelessWidget {
  final AppointmentModel appointment;
  final int index;
  final Function(String) formatDate;
  final Function(String) checkIfDefaultAvatar;
  final Function(AppointmentModel) hoursUntilAppointment;
  final Function(int price) formatPrice;
  final Function(BuildContext, AppointmentModel, int, String, bool, bool) showBlurDialog;

  const UpcomingAppointmentDetail({
    super.key,
    required this.appointment,
    required this.index,
    required this.formatDate,
    required this.checkIfDefaultAvatar,
    required this.hoursUntilAppointment,
    required this.formatPrice,
    required this.showBlurDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: Get.width,
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
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
                                fit: checkIfDefaultAvatar(appointment.avatar)
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
                                    appointment.patientName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppFontStyleTextStrings.bold,
                                      color: AppColors.primaryText,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'ID${appointment.id}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: AppFontStyleTextStrings.regular,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            _buildTimeToAppointment(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "patient_profile".tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppFontStyleTextStrings.bold,
                                  color: AppColors.primary600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.background,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(AppImages.phoneCall),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.background,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(AppImages.messageSquare),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.dividers, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
                        child: _buildAppointmentInfo(),
                      ),
                    ],
                  ),
                ),
                _buildMedicalProblem(),
                _buildPatientInfo(),
                _buildBillDetail(),
                _buildPaymentInfo(),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: const Offset(0, 45),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeToAppointment() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: AppColors.primary600,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppImages.clockCounter),
          const SizedBox(width: 5),
          Text(
            '${hoursUntilAppointment(appointment).toStringAsFixed(1)}h',
            style: const TextStyle(
              fontSize: 13,
              fontFamily: AppFontStyleTextStrings.medium,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(AppImages.headPhone),
                        const SizedBox(width: 5),
                        Text(
                          'service'.tr,
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
                      appointment.meetType,
                      style: const TextStyle(color: AppColors.primaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
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
                      formatDate(appointment.date),
                      style: const TextStyle(color: AppColors.primaryText),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(AppImages.clock3),
                        const SizedBox(width: 5),
                        Text(
                          'duration'.tr,
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
                      '${appointment.duration} ${'minutes'.tr}',
                      style: const TextStyle(color: AppColors.primaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(AppImages.alarm),
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
                    const SizedBox(height: 3),
                    Text(appointment.time, style: const TextStyle(color: AppColors.primaryText)),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (appointment.service.contains('Home')) ...[
                  SvgPicture.asset(AppImages.mapPinLine),
                  const SizedBox(width: 5),
                  Text(
                    'location'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: AppFontStyleTextStrings.regular,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ] else if (appointment.service.contains('Clinic')) ...[
                  SvgPicture.asset(AppImages.building),
                  const SizedBox(width: 5),
                  Text(
                    'location'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: AppFontStyleTextStrings.regular,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ] else ...[
                  SvgPicture.asset(AppImages.link),
                  const SizedBox(width: 5),
                  Text(
                    'meeting_link'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: AppFontStyleTextStrings.regular,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ],
            ),
            if (appointment.service.contains('Clinic')) ...[
              const SizedBox(height: 5),
              Text(appointment.officeAddress, style: const TextStyle(color: AppColors.primaryText)),
            ] else ...[
              const SizedBox(height: 5),
              Text(
                appointment.address == "" ? appointment.patientAddress : appointment.address,
                style: const TextStyle(color: AppColors.primaryText),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMedicalProblem() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'medical_problem'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            appointment.medicalProblem,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.medium,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      padding: const EdgeInsets.fromLTRB(20, 15, 40, 20),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'patient_info'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SvgPicture.asset(AppImages.userProfile),
              const SizedBox(width: 3),
              Text(
                'full_name_label'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          Text(
            appointment.patientName,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.medium,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset(
                AppImages.phoneCall,
                colorFilter: const ColorFilter.mode(AppColors.secondaryText, BlendMode.srcIn),
              ),
              const SizedBox(width: 3),
              Text(
                'telephone'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          Text(
            appointment.phone,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.medium,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset(AppImages.email),
              const SizedBox(width: 3),
              Text(
                'email_label'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          Text(
            appointment.email,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.medium,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetail() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Text(appointment.meetType, style: const TextStyle(color: AppColors.secondaryText)),
                const Spacer(),
                Text(
                  formatPrice(appointment.price),
                  style: const TextStyle(color: AppColors.primaryText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Text('tax_vat'.tr, style: const TextStyle(color: AppColors.secondaryText)),
                const Spacer(),
                Text(
                  formatPrice(appointment.tax),
                  style: const TextStyle(color: AppColors.primaryText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.dividers, thickness: 1),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: Row(
              children: [
                Text(
                  'total'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppFontStyleTextStrings.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const Spacer(),
                Text(
                  formatPrice(appointment.total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppFontStyleTextStrings.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      padding: const EdgeInsets.fromLTRB(15, 15, 35, 15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
            child: SvgPicture.asset(AppImages.bankCard),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.patientName,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    if (appointment.payType.contains('credit'))
                      TextSpan(
                        text: "${"card.tr"} ",
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: AppFontStyleTextStrings.regular,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    TextSpan(
                      text: appointment.payType,
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
                appointment.provider,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.secondaryText,
                ),
              ),
              if (appointment.payType.contains('credit')) ...[
                const SizedBox(height: 5),
                Text(
                  '${"expire".tr} ${appointment.cardExpireDate}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: AppFontStyleTextStrings.regular,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showBlurDialog(context, appointment, index, "rejected", true, true);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primary400,
                ),
                alignment: Alignment.center,
                child: Text(
                  "reject".tr,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontFamily: AppFontStyleTextStrings.medium,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: GestureDetector(
              onTap: () {
                showBlurDialog(context, appointment, index, "cancelled", true, false);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.disable,
                ),
                alignment: Alignment.center,
                child: Text(
                  "cancel".tr,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontFamily: AppFontStyleTextStrings.medium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
