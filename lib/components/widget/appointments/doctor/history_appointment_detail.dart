import 'package:medlink/model/appointment_model.dart';
import 'package:medlink/utils/app_imports.dart';

class HistoryAppointmentDetail extends StatelessWidget {
  final AppointmentModel appointment;
  final Function(String) formatDate;
  final Function(String) checkIfDefaultAvatar;
  final Function(int) formatPrice;

  const HistoryAppointmentDetail({
    super.key,
    required this.appointment,
    required this.formatDate,
    required this.checkIfDefaultAvatar,
    required this.formatPrice,
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
                      _PatientHeader(
                        appointment: appointment,
                        checkIfDefaultAvatar: checkIfDefaultAvatar,
                      ),
                      const _PatientActions(),
                      const Divider(color: AppColors.dividers, thickness: 1),
                      _AppointmentInfo(appointment: appointment, formatDate: formatDate),
                    ],
                  ),
                ),
                if (appointment.status == "rejected")
                  _ReasonCard(title: 'reason_to_reject'.tr, reason: appointment.reason),
                if (appointment.status == "cancelled")
                  _ReasonCard(title: 'reason_to_cancel'.tr, reason: appointment.reason),
                _MedicalProblem(medicalProblem: appointment.medicalProblem),
                _PatientInfo(appointment: appointment),
                _BillDetail(appointment: appointment, formatPrice: formatPrice),
                _PaymentInfo(appointment: appointment),
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
}

// Status Badge Widget
class _StatusBadge extends StatelessWidget {
  final AppointmentModel appointment;

  const _StatusBadge({required this.appointment});

  @override
  Widget build(BuildContext context) {
    if (appointment.status == "waiting") {
      return Container(
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
      );
    } else if (appointment.status == "completed") {
      return Container(
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
      );
    } else if (appointment.status == "rejected") {
      return Container(
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
      );
    } else {
      return Container(
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
      );
    }
  }
}

// Patient Header Widget
class _PatientHeader extends StatelessWidget {
  final AppointmentModel appointment;
  final Function(String) checkIfDefaultAvatar;

  const _PatientHeader({required this.appointment, required this.checkIfDefaultAvatar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
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
          _StatusBadge(appointment: appointment),
        ],
      ),
    );
  }
}

// Patient Actions Widget
class _PatientActions extends StatelessWidget {
  const _PatientActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: SvgPicture.asset(AppImages.phoneCall),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: SvgPicture.asset(AppImages.messageSquare),
          ),
        ],
      ),
    );
  }
}

// Appointment Info Widget
class _AppointmentInfo extends StatelessWidget {
  final AppointmentModel appointment;
  final Function(String) formatDate;

  const _AppointmentInfo({required this.appointment, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppointmentInfoColumn(
                items: [
                  _AppointmentInfoItem(
                    icon: AppImages.headPhone,
                    label: 'service'.tr,
                    value: appointment.meetType,
                  ),
                  _AppointmentInfoItem(
                    icon: AppImages.calendarIcon,
                    label: 'date'.tr,
                    value: formatDate(appointment.date),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              _AppointmentInfoColumn(
                items: [
                  _AppointmentInfoItem(
                    icon: AppImages.clock3,
                    label: 'duration'.tr,
                    value: '${appointment.duration} ${'minutes'.tr}',
                  ),
                  _AppointmentInfoItem(
                    icon: AppImages.clock2,
                    label: 'time'.tr,
                    value: appointment.time,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          _LocationInfo(appointment: appointment),
        ],
      ),
    );
  }
}

// Appointment Info Column Widget
class _AppointmentInfoColumn extends StatelessWidget {
  final List<_AppointmentInfoItem> items;

  const _AppointmentInfoColumn({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(padding: const EdgeInsets.only(bottom: 20), child: item))
          .toList(),
    );
  }
}

// Appointment Info Item Widget
class _AppointmentInfoItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _AppointmentInfoItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: AppFontStyleTextStrings.regular,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: AppColors.primaryText)),
      ],
    );
  }
}

// Location Info Widget
class _LocationInfo extends StatelessWidget {
  final AppointmentModel appointment;

  const _LocationInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 5),
        Text(
          appointment.service.contains('Clinic')
              ? appointment.officeAddress
              : (appointment.address == "" ? appointment.patientAddress : appointment.address),
          style: const TextStyle(color: AppColors.primaryText),
        ),
      ],
    );
  }
}

// Reason Card Widget
class _ReasonCard extends StatelessWidget {
  final String title;
  final String reason;

  const _ReasonCard({required this.title, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      padding: const EdgeInsets.fromLTRB(20, 15, 40, 15),
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            reason,
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
}

// Medical Problem Widget
class _MedicalProblem extends StatelessWidget {
  final String medicalProblem;

  const _MedicalProblem({required this.medicalProblem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      padding: const EdgeInsets.fromLTRB(20, 15, 40, 15),
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
            medicalProblem,
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
}

// Patient Info Widget
class _PatientInfo extends StatelessWidget {
  final AppointmentModel appointment;

  const _PatientInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
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
          _PatientInfoItem(
            icon: AppImages.userProfile,
            label: 'full_name_label'.tr,
            value: appointment.patientName,
          ),
          const SizedBox(height: 12),
          _PatientInfoItem(
            icon: AppImages.phoneCall,
            label: 'telephone'.tr,
            value: appointment.phone,
            iconColor: AppColors.secondaryText,
          ),
          const SizedBox(height: 12),
          _PatientInfoItem(
            icon: AppImages.email,
            label: 'email_label'.tr,
            value: appointment.email,
          ),
        ],
      ),
    );
  }
}

// Patient Info Item Widget
class _PatientInfoItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color? iconColor;

  const _PatientInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: iconColor != null ? ColorFilter.mode(iconColor!, BlendMode.srcIn) : null,
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: AppFontStyleTextStrings.regular,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}

// Bill Detail Widget
class _BillDetail extends StatelessWidget {
  final AppointmentModel appointment;
  final Function(int price) formatPrice;

  const _BillDetail({required this.appointment, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
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
          _BillRow(label: appointment.meetType, amount: formatPrice(appointment.price)),
          const SizedBox(height: 10),
          _BillRow(label: 'tax_vat'.tr, amount: formatPrice(appointment.tax)),
          const SizedBox(height: 10),
          const Divider(color: AppColors.dividers, thickness: 1),
          const SizedBox(height: 10),
          _BillRow(label: 'total'.tr, amount: formatPrice(appointment.total), isTotal: true),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

// Bill Row Widget
class _BillRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;

  const _BillRow({required this.label, required this.amount, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontFamily: isTotal ? AppFontStyleTextStrings.bold : AppFontStyleTextStrings.regular,
              color: isTotal ? AppColors.primaryText : AppColors.secondaryText,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontFamily: isTotal ? AppFontStyleTextStrings.bold : AppFontStyleTextStrings.regular,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// Payment Info Widget
class _PaymentInfo extends StatelessWidget {
  final AppointmentModel appointment;

  const _PaymentInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
