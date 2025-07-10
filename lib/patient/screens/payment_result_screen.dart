import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/components/button/plus.dart';
import 'package:medlink/patient/controllers/booking_controller.dart';

class PaymentResultScreen extends GetView<BookingController> {
  const PaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final status = arguments?['status'] ?? 'success';
    final isSuccess = status == 'PAID';

    return Scaffold(
      backgroundColor: isSuccess ? AppColors.successLight : AppColors.errorLight,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            height: 140,
                            width: 140,
                            child: Image.asset(AppImages.ellipse3, fit: BoxFit.cover),
                          ),
                          SizedBox(
                            height: 110,
                            width: 110,
                            child: CircularProgressIndicator(
                              value: 4,
                              strokeWidth: 8,
                              backgroundColor: isSuccess
                                  ? AppColors.successMain
                                  : AppColors.errorMain,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isSuccess ? AppColors.successMain : AppColors.errorMain,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 40,
                            child: SvgPicture.asset(
                              isSuccess ? AppImages.confettiBall : AppImages.logo,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          isSuccess ? 'payment_success'.tr : 'payment_failed'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFontStyleTextStrings.bold,
                            color: isSuccess ? AppColors.successMain : AppColors.errorMain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          isSuccess
                              ? 'payment_success_description'.tr
                              : 'payment_failed_description'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryText,
                            fontFamily: AppFontStyleTextStrings.regular,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Add any additional payment details here if needed
                    ],
                  ),
                ),
              ),
              CustomButtonPlus(
                onTap: () {
                  Get.delete<BookingController>();
                  Get.offNamed(Routes.patientHomeScreen);
                },
                btnText: 'back_to_home'.tr,
                height: 54,
                leftPadding: 0,
                topPadding: 0,
                rightPadding: 0,
                bottomPadding: 10,
                color: AppColors.transparentColor,
                borderColor: AppColors.primaryText,
                textColor: AppColors.primaryText,
                textSize: 16,
                fontFamily: AppFontStyleTextStrings.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
