import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/button/default.dart';

import 'package:medlink/components/field/star.dart';
import 'package:medlink/components/field/text_area.dart';

class ReviewModal extends StatelessWidget {
  final String appointmentId;
  final String name;
  final String avatar;
  final String speciality;
  final TextEditingController feedback;
  final RxBool isFeedbackError;
  final RxBool isRecommend;
  final RxDouble rating;
  final Function() clearFeedback;
  final Function(String id) reviewAppointment;

  const ReviewModal({
    super.key,
    required this.appointmentId,
    required this.name,
    required this.avatar,
    required this.speciality,
    required this.feedback,
    required this.isFeedbackError,
    required this.isRecommend,
    required this.rating,
    required this.clearFeedback,
    required this.reviewAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          clearFeedback();
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: Get.width,
            height: Get.height * 0.9,
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  _buildDoctorInfo(),
                  _buildRatingSection(),
                  _buildFeedbackSection(),
                  _buildRecommendSection(),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'give_feedback'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: AppFontStyleTextStrings.bold,
            color: AppColors.errorMain,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${'consultation'.tr} $name ${'is_over'.tr}',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.regular,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorInfo() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          margin: const EdgeInsets.fromLTRB(0, 25, 0, 15),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(100),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(avatar, fit: BoxFit.cover),
        ),
        Text(
          "Dr. $name",
          style: const TextStyle(
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.bold,
            color: AppColors.primaryText,
          ),
        ),
        Text(
          speciality,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: AppFontStyleTextStrings.regular,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: StarReview(
        onChanged: (value) {
          rating.value = value;
        },
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      children: [
        const SizedBox(width: 15),
        CustomTextArea(
          labelText: "write_feedback".tr,
          hintText: "comment".tr,
          minLines: 5,
          maxLines: 10,
          errorText: "",
          isError: isFeedbackError,
          obscureText: false.obs,
          controller: feedback,
          onChanged: (value) {
            if (value.isNotEmpty) {
              isFeedbackError.value = false;
            } else {
              isFeedbackError.value = true;
            }
          },
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildRecommendSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${'recommend'.tr} $name ${'to_friend'.tr}',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.medium,
              color: AppColors.primaryText,
            ),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Radio<bool>(
                    value: true,
                    groupValue: isRecommend.value,
                    onChanged: (value) {
                      isRecommend.value = value!;
                    },
                    activeColor: AppColors.primary600,
                    toggleable: true,
                  ),
                ),
                Text(
                  "yes".tr,
                  style: const TextStyle(fontFamily: AppFontStyleTextStrings.regular, fontSize: 16),
                ),
                const SizedBox(width: 20),
                Transform.scale(
                  scale: 1.2,
                  child: Radio<bool>(
                    value: false,
                    groupValue: isRecommend.value,
                    onChanged: (value) {
                      isRecommend.value = value!;
                    },
                    activeColor: AppColors.primary600,
                    toggleable: true,
                  ),
                ),
                Text(
                  "no".tr,
                  style: const TextStyle(fontFamily: AppFontStyleTextStrings.regular, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        CustomButtonDefault(
          onTap: () {
            if (feedback.text.isEmpty) {
              isFeedbackError.value = true;
            } else {
              reviewAppointment(appointmentId);
            }
          },
          bottomPadding: 15,
          btnText: 'send_feedback'.tr,
          isDisabled: false,
        ),
        CustomButtonPlus(
          onTap: () {
            Navigator.pop(context);
            clearFeedback();
          },
          topPadding: 0,
          leftPadding: 20,
          rightPadding: 20,
          btnText: 'later'.tr,
          textSize: 16,
          fontFamily: AppFontStyleTextStrings.bold,
          textColor: AppColors.primaryText,
          color: AppColors.transparentColor,
          borderColor: AppColors.primaryText,
          isDisabled: false,
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        offset: const Offset(0, 85),
        child: GestureDetector(
          onTap: () {
            Get.back();
            clearFeedback();
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
