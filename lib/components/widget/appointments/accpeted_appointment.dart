import 'package:medlink/model/appointment_model.dart';
import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/components/button/default.dart';

class AcceptedAppointment extends StatelessWidget {
  final AppointmentModel appointment;
  final Function(String) formatDate;
  final Function(String) checkIfDefaultAvatar;

  const AcceptedAppointment({
    super.key,
    required this.appointment,
    required this.formatDate,
    required this.checkIfDefaultAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: Get.width,
          // height: Get.height * 0.8,
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
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
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
                            width: double.infinity, // Takes full width
                            child: Text(
                              appointment.address,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: AppFontStyleTextStrings.medium,
                                color: AppColors.primaryText,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, // Adjust number of lines as needed
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
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
                                  const CircleAvatar(
                                    radius: 2.0,
                                    backgroundColor: AppColors.secondaryText,
                                  ),
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
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  // padding: const EdgeInsets.fromLTRB(20, 15, 40, 15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
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
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: const EdgeInsets.fromLTRB(15, 15, 35, 15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: AppColors.primary50,
                          shape: BoxShape.circle,
                        ),
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: CustomButtonDefault(
                    onTap: () {},
                    btnText: 'add_to_calendar'.tr,
                    image: AppImages.calendarPlus,
                    isDisabled: true,
                  ),
                ),
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
