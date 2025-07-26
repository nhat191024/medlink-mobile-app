import 'dart:ui';
import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/model/appointment_model.dart';
import 'package:medlink/components/field/text_area.dart';

class BlurDialog {
  static void show(
    BuildContext context,
    AppointmentModel appointment,
    int index,
    String status,
    bool isUpcoming,
    bool isReject,
    Function(AppointmentModel, int, String, bool) onAcceptReject,
    TextEditingController rejectReason,
    RxBool rejectError,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: Get.width * 0.9,
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(AppImages.reject),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      isReject ? 'reject_confirm'.tr : 'cancel_confirm'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: AppFontStyleTextStrings.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => CustomTextArea(
                        labelText: "give_reason".tr,
                        hintText: "description".tr,
                        isRequire: true,
                        errorText: "error",
                        isError: rejectError.value.obs,
                        obscureText: false.obs,
                        controller: rejectReason,
                        leftPadding: 5,
                        rightPadding: 5,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            rejectError.value = true;
                          } else {
                            rejectError.value = false;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            rejectReason.text = "";
                            rejectError.value = false;
                            Get.back();
                          },
                          child: Container(
                            height: 40,
                            width: 130,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.background,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isReject ? "cancel".tr : "no".tr,
                              style: const TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 14,
                                fontFamily: AppFontStyleTextStrings.medium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            if (rejectReason.text.isNotEmpty) {
                              onAcceptReject(appointment, index, status, isUpcoming);
                              rejectError.value = false;
                              Get.back();
                            } else {
                              rejectError.value = true;
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 130,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.primary600,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isReject ? "reject".tr : "yes".tr,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontFamily: AppFontStyleTextStrings.medium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
