import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/utils/common_imports.dart';
import 'package:medlink/components/button.dart';
import 'package:medlink/components/text_field.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [_buildBackButton(), _buildBody(context)]),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 45,
        height: 45,
        margin: const EdgeInsets.fromLTRB(20, 40, 0, 0),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.color3),
        child: const Center(child: Icon(Icons.arrow_back, color: AppColors.BLACK)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 80),
          _buildHeader(),
          const SizedBox(height: 40),
          _buildLoginForm(),
          const SizedBox(height: 15),
          _buildForgotPassword(),
          const SizedBox(height: 40),
          const Spacer(),
          _buildLoginButton(),
          Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SvgPicture.asset(AppImages.wavingHand, height: 50, width: 50),
        const SizedBox(height: 16),
        Text(
          'welcome_back'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontFamily: AppFontStyleTextStrings.bold),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [_buildEmailField(), const SizedBox(height: 20), _buildPasswordField()],
    );
  }

  Widget _buildEmailField() {
    return Obx(
      () => CustomTextField(
        labelText: 'login_label'.tr,
        leftPadding: 0,
        rightPadding: 0,
        controller: controller.loginInfo,
        onChanged: (value) {
          if (controller.isLoginError.value) {
            controller.isLoginError.value = false;
            controller.loginErrorText.value = '';
          }
        },
        keyboardType: TextInputType.emailAddress,
        hintText: 'login_hint'.tr,
        errorText: controller.loginErrorText.value,
        isError: controller.isLoginError.value.obs,
        obscureText: false.obs,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => CustomTextField(
        labelText: 'password_label'.tr,
        leftPadding: 0,
        rightPadding: 0,
        controller: controller.password,
        onChanged: (value) {
          // Clear errors on typing
          if (controller.isPasswordError.value) {
            controller.isPasswordError.value = false;
            controller.passwordErrorText.value = '';
          }
        },
        keyboardType: TextInputType.visiblePassword,
        hintText: 'password_hint'.tr,
        errorText: controller.passwordErrorText.value,
        isError: controller.isPasswordError.value.obs,
        obscureText: (!controller.isPasswordVisible.value).obs, // Fixed logic
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primaryText,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.forgetPasswordTelephoneScreen),
        child: Text(
          'forgot_password'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.semiBold,
            color: AppColors.RED,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => CustomButtonPlus(
        onTap: controller.login,
        btnText: 'login_btn'.tr,
        leftPadding: 10,
        rightPadding: 10,
        bottomPadding: 0,
        isLoading: controller.isLoading.value,
      ),
    );
  }
}
