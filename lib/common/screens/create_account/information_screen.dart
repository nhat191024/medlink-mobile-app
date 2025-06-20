import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/button/comback.dart';
import 'package:medlink/components/button/default.dart';
import 'package:medlink/components/widget/circular_progress_step.dart';
import 'package:medlink/components/field/text.dart';
import 'package:medlink/components/field/text_area.dart';
import 'package:medlink/components/field/slider.dart';
import 'package:medlink/components/field/bottom_modal_select.dart';
import 'package:medlink/components/field/bottom_modal_select_2.dart';
import 'package:medlink/components/field/date_picker.dart';

class InformationScreen extends GetView<CreateAccountController> {
  const InformationScreen({super.key});

  // Constants
  static const int _currentStep = 5;
  static const int _totalSteps = 7;

  // Data lists
  List<String> get genders => ['gender_option_1'.tr, 'gender_option_2'.tr, 'gender_option_3'.tr];

  List<String> get bloodTypes => ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  List<String> get insuranceTypes => [
    'insurance_type_option_2'.tr,
    'insurance_type_option_1'.tr,
    'insurance_type_option_3'.tr,
  ];

  List<String> get assuranceTypes => [
    'assurances_type_option_1'.tr,
    'assurances_type_option_2'.tr,
    'assurances_type_option_3'.tr,
    'assurances_type_option_4'.tr,
    'assurances_type_option_5'.tr,
    'assurances_type_option_6'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: SingleChildScrollView(child: _buildBody())),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const SafeArea(
      child: Row(
        children: [
          ComeBackButton(),
          Spacer(),
          CircularProgressStep(step: _currentStep, totalSteps: _totalSteps),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        _buildHeaderContent(),
        const SizedBox(height: 30),
        _buildPersonalInformation(),
        const SizedBox(height: 20),
        _buildMedicalInformation(),
        const SizedBox(height: 20),
        _buildInsuranceSection(),
        const SizedBox(height: 20),
        _buildAddressField(),
        const SizedBox(height: 30),
        _buildContinueButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        Image.asset(AppImages.mailBox, height: 60, width: 50),
        const SizedBox(height: 16),
        Text(
          'complete_profile_title'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: AppFontStyleTextStrings.bold,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInformation() {
    return Column(
      children: [
        _buildFullNameField(),
        const SizedBox(height: 15),
        _buildAgeSlider(),
        const SizedBox(height: 15),
        _buildGenderSelector(),
        const SizedBox(height: 15),
        _buildHeightSlider(),
        const SizedBox(height: 15),
        _buildWeightSlider(),
      ],
    );
  }

  Widget _buildMedicalInformation() {
    return Column(
      children: [
        _buildBloodTypeSelector(),
        const SizedBox(height: 16),
        _buildMedicalHistoryField(),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return Column(
      children: [
        _buildInsuranceTypeSelector(),
        const SizedBox(height: 16),
        _buildInsuranceNumberField(),
        const SizedBox(height: 16),
        _buildConditionalInsuranceFields(),
      ],
    );
  }

  Widget _buildConditionalInsuranceFields() {
    return Obx(() {
      final isVietnameseInsurance = controller.insuranceType.value.contains(
        "insurance_type_option_3".tr,
      );

      if (isVietnameseInsurance) {
        return _buildVietNamInsurance();
      } else {
        return Column(
          children: [
            _buildAssuranceTypeSelector(),
            const SizedBox(height: 16),
            _buildPrivateInsuranceFields(),
          ],
        );
      }
    });
  }

  Widget _buildVietNamInsurance() {
    // Vietnamese insurance specific fields will be implemented here
    return Column(
      children: [
        _buildInsuranceRegistry(),
        const SizedBox(height: 16),
        _buildInsuranceRegistryAddress(),
        const SizedBox(height: 16),
        _buildInsuranceValidFrom(),
      ],
    );
  }

  Widget _buildFullNameField() {
    return CustomTextField(
      labelText: "full_name_label".tr,
      hintText: "full_name_hint".tr,
      errorText: "full_name_error".tr,
      isError: false.obs,
      isRequire: true,
      obscureText: false.obs,
      controller: controller.fullName,
      onChanged: _handleFullNameChange,
    );
  }

  Widget _buildAgeSlider() {
    return Obx(
      () => CustomSlider(
        label: 'age_label'.tr,
        isRequire: true,
        secondLabelText: "im".tr,
        secondLabelValueInt: controller.age,
        min: 1,
        max: 150,
        currentValue: controller.age.toDouble().obs,
        onChanged: _handleAgeChange,
      ),
    );
  }

  Widget _buildGenderSelector() {
    return CustomSelectWithBottomModal(
      label: 'gender_label'.tr,
      isRequire: true,
      list: genders,
      isError: false.obs,
      hintText: "choose".tr,
      backgroundColor: AppColors.white,
      onChanged: _handleGenderChange,
    );
  }

  Widget _buildHeightSlider() {
    return Obx(
      () => CustomSlider(
        label: 'height_label'.tr,
        isRequire: true,
        secondLabelText: "i'm".tr,
        secondSubLabelText: " m",
        secondLabelValueDouble: controller.height,
        min: 0.1,
        max: 3,
        currentValue: controller.height.toDouble().obs,
        onChanged: _handleHeightChange,
      ),
    );
  }

  Widget _buildWeightSlider() {
    return Obx(
      () => CustomSlider(
        label: 'weight_label'.tr,
        isRequire: true,
        secondLabelText: "im".tr,
        secondSubLabelText: " kg",
        secondLabelValueInt: controller.weight,
        min: 1,
        max: 200,
        currentValue: controller.weight.toDouble().obs,
        onChanged: _handleWeightChange,
      ),
    );
  }

  Widget _buildBloodTypeSelector() {
    return CustomSelectWithBottomModalStyle2(
      label: "blood_group_label".tr,
      list: bloodTypes,
      hintText: "choose".tr,
      isRequire: true,
      onChanged: _handleBloodTypeChange,
    );
  }

  Widget _buildMedicalHistoryField() {
    return CustomTextArea(
      labelText: "medical_history_label".tr,
      hintText: "medical_history_hint".tr,
      errorText: "medical_history_error".tr,
      isError: false.obs,
      isRequire: true,
      obscureText: false.obs,
      controller: controller.medicalHistory,
      onChanged: _handleMedicalHistoryChange,
    );
  }

  Widget _buildInsuranceTypeSelector() {
    return CustomSelectWithBottomModal(
      label: 'insurance_type_label'.tr,
      list: insuranceTypes,
      hintText: "Public",
      isError: false.obs,
      isRequire: true,
      defaultSelect: controller.insuranceType.value,
      backgroundColor: AppColors.white,
      onChanged: _handleInsuranceTypeChange,
    );
  }

  Widget _buildInsuranceNumberField() {
    return CustomTextField(
      labelText: "insurance_number_label".tr,
      hintText: "enter_number".tr,
      errorText: "insurance_error".tr,
      isError: false.obs,
      obscureText: false.obs,
      isRequire: true,
      controller: controller.insuranceNumber,
      onChanged: _handleInsuranceNumberChange,
    );
  }

  Widget _buildAssuranceTypeSelector() {
    return CustomSelectWithBottomModal(
      label: 'assurances_type'.tr,
      list: assuranceTypes,
      hintText: "choose".tr,
      isError: false.obs,
      backgroundColor: AppColors.white,
      onChanged: _handleAssuranceTypeChange,
    );
  }

  Widget _buildInsuranceRegistry() {
    return CustomTextField(
      labelText: "insurance_registry_label".tr,
      hintText: "insurance_registry_hint".tr,
      errorText: "insurance_registry_error".tr,
      isError: false.obs,
      obscureText: false.obs,
      isRequire: true,
      controller: controller.registry,
      onChanged: _handleInsuranceRegistryChange,
    );
  }

  Widget _buildInsuranceRegistryAddress() {
    return CustomTextField(
      labelText: "insurance_registry_address_label".tr,
      hintText: "insurance_registry_address_hint".tr,
      errorText: "insurance_registry_address_error".tr,
      isError: false.obs,
      obscureText: false.obs,
      isRequire: true,
      controller: controller.registryAddress,
      onChanged: _handleInsuranceRegistryAddressChange,
    );
  }

  Widget _buildInsuranceValidFrom() {
    return CustomDatePicker(
      labelText: "insurance_vaild_from_label".tr,
      hintText: "insurance_vaild_from_hint".tr,
      errorText: "insurance_valid_from_error".tr,
      isError: false.obs,
      isRequire: true,
      onDateSelected: _handleInsuranceValidFromChange,
      selectedDate: controller.validFrom.value,
    );
  }

  Widget _buildPrivateInsuranceFields() {
    return Obx(() {
      if (controller.insuranceType.value.contains('insurance_type_option_2'.tr)) {
        return Column(
          children: [
            CustomTextField(
              labelText: "main_insured".tr,
              hintText: "enter_number".tr,
              errorText: "main_insured_error".tr,
              isError: false.obs,
              obscureText: false.obs,
              isRequire: true,
              controller: controller.mainInsurance,
              onChanged: _handleMainInsuranceChange,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: "entitled_insured".tr,
              hintText: "enter_number".tr,
              errorText: "entitled_insured_error".tr,
              isError: false.obs,
              obscureText: false.obs,
              isRequire: true,
              controller: controller.entitledInsurance,
              onChanged: _handleEntitledInsuranceChange,
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildAddressField() {
    return CustomTextField(
      labelText: "address_label".tr,
      hintText: "address_hint".tr,
      errorText: "address_error".tr,
      isError: false.obs,
      isRequire: true,
      obscureText: false.obs,
      controller: controller.address,
      onChanged: _handleAddressChange,
    );
  }

  Widget _buildContinueButton() {
    return CustomButtonDefault(onTap: _handleContinue, btnText: "continue".tr, isDisabled: false);
  }

  // Event handlers
  void _handleFullNameChange(String value) {
    // Handle full name change
  }

  void _handleAgeChange(double value) {
    controller.age.value = value.toInt();
  }

  void _handleGenderChange(String selectedType) {
    controller.gender.value = selectedType;
  }

  void _handleHeightChange(double value) {
    double limitedValue = double.parse(value.toStringAsFixed(2));
    controller.height.value = limitedValue;
  }

  void _handleWeightChange(double value) {
    controller.weight.value = value.toInt();
  }

  void _handleBloodTypeChange(String selectedType) {
    controller.bloodGroup.value = selectedType;
  }

  void _handleMedicalHistoryChange(String value) {
    // Handle medical history change
  }

  void _handleInsuranceTypeChange(String selectedType) {
    controller.insuranceType.value = selectedType;
  }

  // Handle insurance registry change
  void _handleInsuranceRegistryChange(String value) {
    // Handle insurance registry change
  }

  // Handle insurance registry address change
  void _handleInsuranceRegistryAddressChange(String value) {
    // Handle insurance registry address change
  }

  // Handle insurance valid from date change
  void _handleInsuranceValidFromChange(DateTime date) {
    controller.validFrom.value = date;
  }

  void _handleInsuranceNumberChange(String value) {
    // Handle insurance number change
  }

  void _handleAssuranceTypeChange(String selectedType) {
    controller.assuranceType.value = selectedType;
  }

  void _handleMainInsuranceChange(String value) {
    // Handle main insurance change
  }

  void _handleEntitledInsuranceChange(String value) {
    // Handle entitled insurance change
  }

  void _handleAddressChange(String value) {
    // Handle address change
  }

  void _handleContinue() {
    controller.checkMissingInformation();
  }
}
