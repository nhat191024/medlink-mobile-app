import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/model/appointment_model.dart';
import 'package:medlink/components/button/default.dart';
import 'package:medlink/components/button/plus.dart';

class NewAppointmentDetail extends StatelessWidget {
  final AppointmentModel appointment;
  final int index;
  final Function(String) formatDate;
  final Function(String) checkIfDefaultAvatar;
  final Function(BuildContext, AppointmentModel, int, String, bool, bool) showBlurDialog;
  final Function(AppointmentModel, int, String, bool) acceptRejectAppointment;
  final VoidCallback openCalendar;

  const NewAppointmentDetail({
    super.key,
    required this.appointment,
    required this.index,
    required this.formatDate,
    required this.checkIfDefaultAvatar,
    required this.showBlurDialog,
    required this.acceptRejectAppointment,
    required this.openCalendar,
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
                // Main appointment info container
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
                      // Patient info header
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
                                Text(
                                  appointment.patientName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppFontStyleTextStrings.bold,
                                    color: AppColors.primaryText,
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
                          ],
                        ),
                      ),
                      // Patient profile and action buttons
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
                      // Appointment details
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left column
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Type
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppImages.headPhone),
                                            const SizedBox(width: 5),
                                            Text(
                                              'type'.tr,
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
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: AppFontStyleTextStrings.medium,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    // Date
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
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: AppFontStyleTextStrings.medium,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                // Right column
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Duration
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppImages.alarm),
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
                                          '${appointment.duration} ${"min".tr}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: AppFontStyleTextStrings.medium,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    // Time
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppImages.clock3),
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
                                        Text(
                                          appointment.time,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: AppFontStyleTextStrings.medium,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Address/Link section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (appointment.service.contains('Home')) ...[
                                      SvgPicture.asset(
                                        AppImages.mapPinLine,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.secondaryText,
                                          BlendMode.srcIn,
                                        ),
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
                                    ] else if (appointment.service.contains('Clinic')) ...[
                                      SvgPicture.asset(
                                        AppImages.building,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.secondaryText,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'clinic_address'.tr,
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
                                        'link'.tr,
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
                                  Text(
                                    appointment.officeAddress,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppFontStyleTextStrings.medium,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ] else ...[
                                  const SizedBox(height: 5),
                                  Text(
                                    appointment.address == ""
                                        ? appointment.link
                                        : appointment.address,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppFontStyleTextStrings.medium,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Action buttons
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButtonPlus(
                              onTap: () {
                                showBlurDialog(
                                  context,
                                  appointment,
                                  index,
                                  "rejected",
                                  false,
                                  true,
                                );
                              },
                              height: 42,
                              width: 155,
                              color: AppColors.white,
                              borderColor: AppColors.primaryText,
                              btnText: 'decline'.tr,
                              fontFamily: AppFontStyleTextStrings.medium,
                              textSize: 14,
                              textColor: AppColors.primaryText,
                              topPadding: 0,
                              bottomPadding: 0,
                              leftPadding: 0,
                              rightPadding: 10,
                            ),
                            CustomButtonPlus(
                              onTap: () {
                                acceptRejectAppointment(appointment, index, "upcoming", false);
                                // Show acceptance confirmation modal
                                Get.bottomSheet(
                                  NewAppointmentAcceptanceConfirmation(
                                    appointment: appointment,
                                    formatDate: formatDate,
                                    checkIfDefaultAvatar: checkIfDefaultAvatar,
                                    openCalendar: openCalendar,
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              height: 42,
                              width: 155,
                              borderColor: AppColors.primaryText,
                              btnText: 'accept'.tr,
                              fontFamily: AppFontStyleTextStrings.medium,
                              textSize: 14,
                              topPadding: 0,
                              bottomPadding: 0,
                              leftPadding: 10,
                              rightPadding: 0,
                            ),
                          ],
                        ),
                      ),
                      // Reschedule button
                      CustomButtonDefault(
                        onTap: () {
                          openCalendar();
                        },
                        btnText: 'reschedule'.tr,
                        leftPadding: 15,
                        rightPadding: 15,
                        bottomPadding: 15,
                        image: AppImages.calendarPlus,
                        isDisabled: true,
                      ),
                    ],
                  ),
                ),
                // Medical profile section
                _buildMedicalProfile(),
                // Patient info section
                _buildPatientInfo(),
                // Bill detail section
                _buildBillDetail(),
                // Payment method section
                _buildPaymentMethod(),
              ],
            ),
          ),
        ),
        // Close button
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

  Widget _buildMedicalProfile() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'medical_profile'.tr,
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
          // Full name
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
          // Phone
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
          // Email
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
                Text(
                  appointment.meetType,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.regular,
                    color: AppColors.secondaryText,
                  ),
                ),
                const Spacer(),
                Text(
                  '${appointment.price} EUR',
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
                  '${appointment.tax} EUR',
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
                    fontFamily: AppFontStyleTextStrings.regular,
                    color: AppColors.primaryText,
                  ),
                ),
                const Spacer(),
                Text(
                  '${appointment.total} EUR',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.bold,
                    color: AppColors.primary600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
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
}

class NewAppointmentAcceptanceConfirmation extends StatelessWidget {
  final AppointmentModel appointment;
  final Function(String) formatDate;
  final Function(String) checkIfDefaultAvatar;
  final VoidCallback openCalendar;

  const NewAppointmentAcceptanceConfirmation({
    super.key,
    required this.appointment,
    required this.formatDate,
    required this.checkIfDefaultAvatar,
    required this.openCalendar,
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
                // Success header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.checkCircle, width: 30),
                    const SizedBox(width: 10),
                    Text(
                      'accepted'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: AppFontStyleTextStrings.bold,
                        color: AppColors.successMain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Appointment summary
                _buildAppointmentSummary(),
                const SizedBox(height: 10),
                // Patient info
                _buildPatientInfo(),
                const SizedBox(height: 10),
                // Bill detail
                _buildBillDetail(),
                const SizedBox(height: 10),
                // Payment method
                _buildPaymentMethod(),
                // Add to calendar button
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: CustomButtonDefault(
                    onTap: () {
                      openCalendar();
                    },
                    btnText: 'add_to_calendar'.tr,
                    image: AppImages.calendarPlus,
                    isDisabled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Close button
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

  Widget _buildAppointmentSummary() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.meetType,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFontStyleTextStrings.medium,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 1,
                height: 30,
                color: AppColors.border,
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.clock3),
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
                    appointment.time,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFontStyleTextStrings.medium,
                      color: AppColors.primaryText,
                    ),
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
                  SvgPicture.asset(AppImages.mapPinLine),
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
              SizedBox(
                width: double.infinity,
                child: Text(
                  appointment.address,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.medium,
                    color: AppColors.primaryText,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  appointment.avatar,
                  fit: checkIfDefaultAvatar(appointment.avatar) ? BoxFit.scaleDown : BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
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
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        appointment.phone,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: AppFontStyleTextStrings.regular,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const CircleAvatar(radius: 2.0, backgroundColor: AppColors.secondaryText),
                      const SizedBox(width: 5),
                      Text(
                        appointment.email,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: AppFontStyleTextStrings.regular,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetail() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
            padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
            child: Row(
              children: [
                Text(
                  appointment.meetType,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.regular,
                    color: AppColors.secondaryText,
                  ),
                ),
                const Spacer(),
                Text(
                  '${appointment.price} EUR',
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
            padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
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
                  '${appointment.tax} EUR',
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
          const Divider(color: AppColors.dividers, thickness: 1),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 40, 15),
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
                  '${appointment.total} EUR',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.bold,
                    color: AppColors.primary600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
}
