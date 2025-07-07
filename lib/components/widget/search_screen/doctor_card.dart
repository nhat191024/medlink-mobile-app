import 'package:medlink/model/work_schedule_model.dart';
import 'package:medlink/patient/utils/patient_imports.dart';
import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/components/button/plus.dart';

import 'package:medlink/model/service_model.dart';

class DoctorCard extends StatelessWidget {
  final int index;
  final List<ServiceModel> services;
  final WorkScheduleModel workSchedule;
  final SearchHeathCareController controller;

  const DoctorCard({
    super.key,
    required this.index,
    required this.services,
    required this.workSchedule,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final String avatar = controller.doctorList[index].avatar ?? '';
    final String name = controller.doctorList[index].name ?? '';
    final bool isPopular = controller.doctorList[index].isPopular ?? false;
    final String speciality = controller.doctorList[index].specialty ?? '';
    final double rating = controller.doctorList[index].rating ?? 0.0;
    final String location = controller.doctorList[index].location ?? '';
    final int minPrice = controller.doctorList[index].minPrice ?? 0;
    final bool isAvailable = controller.doctorList[index].isAvailable ?? false;
    final RxBool isFavorite = controller.doctorList[index].isFavorite ?? RxBool(false);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(100),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  avatar,
                  //TODO revoke this after change the default avatar
                  fit: controller.checkIfDefaultAvatar(avatar) ? BoxFit.cover : BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. $name",
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontFamily: AppFontStyleTextStrings.medium,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (isPopular) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary600,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            "popular".tr,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontFamily: AppFontStyleTextStrings.medium,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        speciality,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 12,
                          fontFamily: AppFontStyleTextStrings.regular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(0, 10),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 12,
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "location".tr,
                                style: const TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 12,
                                  fontFamily: AppFontStyleTextStrings.regular,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 80, // Đặt chiều rộng tối đa cho location
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 14,
                                    fontFamily: AppFontStyleTextStrings.medium,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 30,
                            child: VerticalDivider(color: AppColors.border, thickness: 1),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "price_from".tr,
                                style: const TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 12,
                                  fontFamily: AppFontStyleTextStrings.regular,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$$minPrice",
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 14,
                                  fontFamily: AppFontStyleTextStrings.medium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 30,
                            child: VerticalDivider(color: AppColors.border, thickness: 1),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "schedule".tr,
                                style: const TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 12,
                                  fontFamily: AppFontStyleTextStrings.regular,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isAvailable ? "available".tr : "busy".tr,
                                style: TextStyle(
                                  color: isAvailable ? AppColors.successMain : AppColors.errorMain,
                                  fontSize: 14,
                                  fontFamily: AppFontStyleTextStrings.medium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtonPlus(
                        onTap: () => {},
                        // buildBookingModal(context, index, services, timeSlots),
                        btnText: 'book_appointment'.tr,
                        textSize: 14,
                        fontFamily: AppFontStyleTextStrings.medium,
                        leftPadding: 0,
                        rightPadding: 0,
                        bottomPadding: 10,
                        width: Get.width * 0.6,
                        svgImage: AppImages.calendarIcon,
                        isDisabled: !(controller.doctorList[index].isAvailable ?? false),
                      ),
                      const SizedBox(width: 10),
                      //TODO: make this a button so it can be react
                      Obx(
                        () => CircleAvatar(
                          backgroundColor: controller.doctorList[index].isFavorite!.value
                              ? AppColors.primary600
                              : AppColors.white,
                          radius: 24,
                          child: SvgPicture.asset(
                            isFavorite.value ? AppImages.heartIcon : AppImages.heart,
                            height: 30,
                            width: 30,
                            colorFilter: ColorFilter.mode(
                              controller.doctorList[index].isFavorite!.value
                                  ? AppColors.white
                                  : AppColors.primary600,
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
