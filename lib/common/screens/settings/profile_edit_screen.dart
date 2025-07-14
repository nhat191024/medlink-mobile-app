import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/profile_controller.dart';

import 'package:medlink/common/screens/settings/profile_country_code_screen.dart';

import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/button/attach_photo.dart';
import 'package:medlink/components/field/text.dart';
import 'package:medlink/components/field/text_area.dart';
import 'package:medlink/components/field/bottom_modal_select.dart';
import 'package:medlink/components/field/bottom_modal_multi_select.dart';
import 'package:medlink/components/field/phone.dart';

class ProfileEditScreen extends GetView<ProfileController> {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            controller.avatarImage.value = null;
            if (controller.checkIfDefaultAvatar(controller.userData.value.avatar)) {
              controller.isDefaultAvatar.value = false;
              controller.userData.value.avatar = controller.oldAvatar.value;
            }
            if (controller.isEdit.value) {
              controller.isEdit.value = false;
              await controller.fetchUserData();
            } else {
              controller.clearError();
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          controller.avatarImage.value = null;
                          if (controller.checkIfDefaultAvatar(controller.userData.value.avatar)) {
                            controller.isDefaultAvatar.value = false;
                            controller.userData.value.avatar = controller.oldAvatar.value;
                          }
                          if (controller.isEdit.value) {
                            controller.isEdit.value = false;
                            await controller.fetchUserData();
                          } else {
                            controller.clearError();
                          }
                          Get.back();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: const Center(
                            child: Icon(Icons.arrow_back, color: AppColors.primaryText),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                color: AppColors.primary50,
                                borderRadius: BorderRadius.circular(
                                  controller.identity.contains("doctor") ? 100 : 16,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Obx(
                                () => controller.avatarImage.value == null
                                    ? Image.network(
                                        controller.userData.value.avatar,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(controller.avatarImage.value!, fit: BoxFit.cover),
                              ),
                            ),
                            if (!controller.checkIfDefaultAvatar(
                                  controller.userData.value.avatar,
                                ) &&
                                !controller.isDefaultAvatar.value)
                              Positioned(
                                top: controller.identity.contains("doctor") ? 8 : -8,
                                right: controller.identity.contains("doctor") ? 8 : -8,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.avatarImage.value = null;
                                    controller.userData.value.avatar =
                                        "https://ui-avatars.com/api/?name=${controller.userData.value.name}&background=random&size=512";
                                    controller.isDefaultAvatar.value = true;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        AttachPhotoButton(selectedImage: controller.avatarImage, height: 40),
                      ],
                    ),
                  ),
                  Obx(
                    () => Column(
                      children: [
                        CustomTextField(
                          controller: controller.fullName,
                          hintText: controller.identity.contains("doctor")
                              ? "full_name_hint_long".tr
                              : "full_name_hint_long_2".tr,
                          labelText: controller.identity.contains("doctor")
                              ? "full_name_label_long".tr
                              : "full_name_label_long_2".tr,
                          keyboardType: TextInputType.text,
                          errorText: "",
                          isError: controller.isFullnameError,
                          needErrorText: false,
                          obscureText: false.obs,
                          leftPadding: 0,
                          rightPadding: 0,
                          topPadding: 20,
                          backgroundColor: AppColors.white,
                          isRequire: true,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.isFullnameError.value = true;
                            } else {
                              controller.isFullnameError.value = false;
                            }
                          },
                        ),
                        if (controller.identity.contains("doctor"))
                          CustomTextField(
                            controller: controller.professionalNo,
                            hintText: "profession_label".tr,
                            labelText: "profession_hint".tr,
                            keyboardType: TextInputType.text,
                            errorText: "",
                            isError: controller.isProfessionalNoError,
                            needErrorText: false,
                            obscureText: false.obs,
                            leftPadding: 0,
                            rightPadding: 0,
                            topPadding: 20,
                            backgroundColor: AppColors.white,
                            isRequire: true,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                controller.isProfessionalNoError.value = true;
                              } else {
                                controller.isProfessionalNoError.value = false;
                              }
                            },
                          ),
                        if (controller.identity.contains("doctor"))
                          CustomSelectWithBottomModal(
                            hintText: "choose".tr,
                            label: "gender_label".tr,
                            isRequire: true,
                            list: [
                              "gender_option_1".tr,
                              "gender_option_2".tr,
                              "gender_option_3".tr,
                            ],
                            backgroundColor: AppColors.white,
                            defaultSelect: controller.gender.value,
                            isError: controller.isGenderError,
                            leftPadding: 0,
                            rightPadding: 0,
                            topPadding: 20,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                controller.isGenderError.value = true;
                              } else {
                                controller.isGenderError.value = false;
                                controller.gender.value = value;
                              }
                            },
                          ),
                        CustomTextArea(
                          labelText: "introduce".tr,
                          isRequire: true,
                          hintText: "introduce_hint".tr,
                          errorText: "",
                          isError: controller.isIntroduceError,
                          controller: controller.introduce,
                          obscureText: false.obs,
                          leftPadding: 0,
                          rightPadding: 0,
                          topPadding: 20,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.isIntroduceError.value = true;
                            } else {
                              controller.isIntroduceError.value = false;
                            }
                          },
                        ),
                        if (controller.identity.contains("doctor"))
                          CustomSelectWithBottomModal(
                            hintText: "choose".tr,
                            label: "medical_category".tr,
                            isRequire: true,
                            list: controller.medicalCategories,
                            backgroundColor: AppColors.white,
                            defaultSelect: controller.medicalCategory.value,
                            isError: controller.isMedicalCategoryError,
                            leftPadding: 0,
                            rightPadding: 0,
                            topPadding: 20,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                controller.isMedicalCategoryError.value = true;
                              } else {
                                controller.isMedicalCategoryError.value = false;
                                controller.medicalCategory.value = value;
                              }
                            },
                          ),
                        CustomMultiSelectWithBottomModal(
                          hintText: "choose".tr,
                          label: "language".tr,
                          isRequire: true,
                          list: const ["English", "Vietnamese"],
                          defaultSelections: controller.languages.map((lang) => lang.name).toList(),
                          backgroundColor: AppColors.white,
                          isError: controller.isLanguageError,
                          leftPadding: 0,
                          rightPadding: 0,
                          topPadding: 20,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.isLanguageError.value = true;
                            } else {
                              controller.isLanguageError.value = false;
                              if (value.length > 1) {
                                controller.language.value = value.join(",");
                              } else {
                                controller.language.value = value[0];
                              }
                            }
                          },
                        ),
                        CustomTextField(
                          controller: controller.officeAddress,
                          hintText: "office_address_hint".tr,
                          labelText: "office_address_label".tr,
                          keyboardType: TextInputType.text,
                          errorText: "",
                          isError: controller.isOfficeAddressError,
                          obscureText: false.obs,
                          needErrorText: false,
                          leftPadding: 0,
                          rightPadding: 0,
                          topPadding: 20,
                          backgroundColor: AppColors.white,
                          isRequire: true,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.isOfficeAddressError.value = true;
                            } else {
                              controller.isOfficeAddressError.value = false;
                            }
                          },
                        ),
                        CustomTextField(
                          controller: controller.country,
                          hintText: "country_label".tr,
                          labelText: "country_hint".tr,
                          keyboardType: TextInputType.text,
                          errorText: "",
                          isError: controller.isCountryError,
                          obscureText: false.obs,
                          needErrorText: false,
                          leftPadding: 0,
                          rightPadding: 0,
                          topPadding: 20,
                          backgroundColor: AppColors.white,
                          isRequire: true,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.isCountryError.value = true;
                            } else {
                              controller.isCountryError.value = false;
                            }
                          },
                        ),
                        CustomTextField(
                          controller: controller.city,
                          hintText: "city_label".tr,
                          labelText: "city_hint".tr,
                          keyboardType: TextInputType.text,
                          errorText: "",
                          isError: controller.isCityError,
                          obscureText: false.obs,
                          needErrorText: false,
                          leftPadding: 0,
                          rightPadding: 0,
                          topPadding: 20,
                          backgroundColor: AppColors.white,
                          isRequire: true,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.isCityError.value = true;
                            } else {
                              controller.isCityError.value = false;
                            }
                          },
                        ),
                        CustomTextField(
                          controller: controller.gps,
                          hintText: "GPS_hint".tr,
                          labelText: "GPS_label".tr,
                          keyboardType: TextInputType.text,
                          errorText: "",
                          isError: controller.isGpsError,
                          needErrorText: false,
                          obscureText: false.obs,
                          leftPadding: 0,
                          rightPadding: 0,
                          topPadding: 20,
                          backgroundColor: AppColors.white,
                          isRequire: true,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.isGpsError.value = true;
                            } else {
                              controller.isGpsError.value = false;
                            }
                          },
                        ),
                        if (controller.identity.contains("doctor"))
                          CustomTextField(
                            controller: controller.companyName,
                            hintText: "company_name_hint".tr,
                            labelText: "company_name_label".tr,
                            keyboardType: TextInputType.text,
                            errorText: "",
                            isError: controller.isCompanyNameError,
                            needErrorText: false,
                            obscureText: false.obs,
                            leftPadding: 0,
                            rightPadding: 0,
                            topPadding: 20,
                            backgroundColor: AppColors.white,
                            isRequire: true,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                controller.isCompanyNameError.value = true;
                              } else {
                                controller.isCompanyNameError.value = false;
                              }
                            },
                          ),
                        CustomTextField(
                          controller: controller.email,
                          hintText: "email_hint".tr,
                          labelText: "email_label".tr,
                          keyboardType: TextInputType.emailAddress,
                          errorText: "",
                          isError: controller.isEmailError,
                          obscureText: false.obs,
                          leftPadding: 0,
                          rightPadding: 0,
                          topPadding: 20,
                          backgroundColor: AppColors.white,
                          isRequire: true,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.isEmailError.value = true;
                            } else {
                              controller.isEmailError.value = false;
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'phone_number'.tr,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: AppFontStyleTextStrings.bold,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 5),
                            PhoneNumberTextField(
                              isError: false.obs,
                              controller: controller.phoneNumber,
                              isBlack: true,
                              color: AppColors.white,
                              selectedCountry: controller.selectedCountry.value,
                              onCountryTap: () async {
                                Country? country = await Get.to(
                                  () => const ProfileCountryCodeScreen(),
                                );
                                if (country != null) {
                                  controller.selectedCountry.value = country;
                                }
                              },
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButtonPlus(
                        onTap: () async {
                          await controller.fetchUserData();
                          Get.back(result: true);
                        },
                        btnText: "cancel".tr,
                        width: Get.width / 2.3,
                        rightPadding: 5,
                        leftPadding: 0,
                        color: AppColors.white,
                        textColor: AppColors.primaryText,
                        borderColor: AppColors.primaryText,
                      ),
                      CustomButtonPlus(
                        onTap: () {
                          if (controller.avatarImage.value != null) {
                            controller.isDefaultAvatar.value = false;
                          }
                          controller.updateProfile();
                        },
                        btnText: "save".tr,
                        width: Get.width / 2.3,
                        leftPadding: 5,
                        rightPadding: 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
