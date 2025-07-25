import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/button/default.dart';

import 'package:medlink/components/field/text_area.dart';

class SupportModal extends StatelessWidget {
  final String appointmentId;
  final String name;
  final String avatar;
  final TextEditingController supportMessage;
  final RxBool isSupportMessageError;
  final Function() clearSupport;
  final Function(String id) sendSupportMessage;

  const SupportModal({
    super.key,
    required this.appointmentId,
    required this.name,
    required this.avatar,
    required this.supportMessage,
    required this.isSupportMessageError,
    required this.clearSupport,
    required this.sendSupportMessage,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          clearSupport();
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: Get.width,
              height: Get.height * 0.5,
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
                  children: [_buildHeader(), _buildFeedbackSection(), _buildActionButtons(context)],
                ),
              ),
            ),
            _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            'send_appointment_support'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: AppFontStyleTextStrings.bold,
              color: AppColors.errorMain,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'send_appointment_support_description'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      children: [
        const SizedBox(width: 15),
        CustomTextArea(
          labelText: "write_support_message".tr,
          hintText: "message_placeholder".tr,
          minLines: 5,
          maxLines: 10,
          errorText: "",
          isError: isSupportMessageError,
          obscureText: false.obs,
          controller: supportMessage,
          onChanged: (value) {
            if (value.isNotEmpty) {
              isSupportMessageError.value = false;
            } else {
              isSupportMessageError.value = true;
            }
          },
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        CustomButtonDefault(
          onTap: () {
            if (supportMessage.text.isEmpty) {
              isSupportMessageError.value = true;
            } else {
              sendSupportMessage(appointmentId);
            }
          },
          bottomPadding: 15,
          btnText: 'send_support'.tr,
          isDisabled: false,
        ),
        CustomButtonPlus(
          onTap: () {
            Navigator.pop(context);
            clearSupport();
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
    return Positioned(
      top: -15,
      left: (Get.width - 30) / 2,
      child: GestureDetector(
        onTap: () {
          Get.back();
          clearSupport();
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
    );
  }
}
