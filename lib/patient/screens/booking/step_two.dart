import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/field/text_area.dart';
import 'package:medlink/components/field/text.dart';

class StepTwo extends StatelessWidget {
  final BookingController controller;
  const StepTwo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextArea(
          labelText: "summarize_medical".tr,
          hintText: "enter_history".tr,
          errorText: "",
          isError: controller.isMedicalProblemError,
          obscureText: false.obs,
          minLines: 16,
          maxLines: 16,
          isRequire: true,
          controller: controller.medicalProblem,
          leftPadding: 0,
          rightPadding: 0,
          onChanged: (value) {
            if (value.isEmpty) {
              controller.isMedicalProblemError.value = true;
            } else {
              controller.isMedicalProblemError.value = false;
            }
          },
        ),
        // TODO: add attach file feature
        CustomButtonPlus(
          onTap: () {},
          btnText: "attach_file".tr,
          textSize: 14,
          fontFamily: AppFontStyleTextStrings.medium,
          textColor: AppColors.primaryText,
          svgImage: AppImages.attachment,
          imageColor: AppColors.primaryText,
          color: AppColors.transparentColor,
          borderColor: AppColors.primaryText,
          leftPadding: 0,
          rightPadding: 0,
        ),
        CustomTextField(
          labelText: "note".tr,
          hintText: "enter".tr,
          errorText: "",
          isError: false.obs,
          obscureText: false.obs,
          controller: controller.note,
          onChanged: (value) {},
          leftPadding: 0,
          rightPadding: 0,
          backgroundColor: AppColors.white,
        ),
      ],
    );
  }
}
