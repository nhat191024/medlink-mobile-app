import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:medlink/utils/app_imports.dart';

import 'package:medlink/common/controllers/setting_controller.dart';

import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/widget/dashed_divider.dart';
import 'package:medlink/components/field/text.dart';

class DoctorWalletHeader extends StatelessWidget {
  final SettingControllers controller;
  DoctorWalletHeader({super.key, required this.controller});

  final expireFormatter = MaskTextInputFormatter(mask: '##/##', filter: {"#": RegExp(r'[0-9]')});

  final cardNumFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildHeaderContainer(), _buildHeaderContent()]);
  }

  Widget _buildHeaderContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: Get.height,
      decoration: const BoxDecoration(
        color: AppColors.primary600,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Positioned(
      top: 30,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_buildWalletIcon(), _buildBalanceInfo(), const Spacer(), _buildExpandButton()],
        ),
      ),
    );
  }

  Widget _buildWalletIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      padding: const EdgeInsets.all(12),
      child: SvgPicture.asset(AppImages.walletIcon),
    );
  }

  Widget _buildBalanceInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'my_balance_wallet'.tr,
          style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            '${controller.balance.value} ${"currency".tr}',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandButton() {
    return IconButton(
      onPressed: _showWalletBottomSheet,
      icon: const Icon(Icons.arrow_forward_sharp, color: AppColors.white),
    );
  }

  void _showWalletBottomSheet() {
    Get.bottomSheet(_buildBottomSheetContent(), isScrollControlled: true);
  }

  Widget _buildBottomSheetContent() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildBottomSheetBackground(),
        _buildBottomSheetHeader(),
        _buildBottomSheetBody(),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildBottomSheetBackground() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary600,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
    );
  }

  Widget _buildBottomSheetHeader() {
    return Positioned(
      top: Get.height * 0.1,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'my_balance_wallet'.tr,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.regular,
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                '${controller.balance.value} ${"currency".tr}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontFamily: AppFontStyleTextStrings.bold,
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButtonPlus(
          onTap: () => _withdrawModal(Get.context!, 'withdraw'.tr),
          btnText: "withdraw".tr,
          color: AppColors.white,
          textColor: AppColors.primaryText,
          width: Get.width * 0.75,
          height: 44,
          topPadding: 20,
          leftPadding: 0,
          rightPadding: 5,
        ),
        GestureDetector(
          onTap: () => _addBalanceModal(Get.context!, 'add_balance'.tr),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: SvgPicture.asset(AppImages.plus, width: 28, height: 28, fit: BoxFit.fill),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheetBody() {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: Get.width,
            margin: EdgeInsets.only(top: Get.height * 0.27),
            decoration: const BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (controller.transactionHistories.isEmpty) _buildEmptyState(),
                    if (controller.transactionHistories.isNotEmpty)
                      _buildTransactionHistorySection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            SvgPicture.asset(AppImages.wallet, width: 60, height: 70, fit: BoxFit.fill),
            const SizedBox(height: 20),
            if (controller.balance.value > 0)
              Text(
                'no_transaction_history'.tr,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 20,
                  fontFamily: AppFontStyleTextStrings.bold,
                ),
              )
            else
              Text(
                'no_balance'.tr,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 20,
                  fontFamily: AppFontStyleTextStrings.bold,
                ),
              ),
            const SizedBox(height: 10),
            Text(
              "${"no_balance_description_1".tr} ${controller.balance.value} ${"currency".tr}\n${"no_balance_description_2".tr}",
              style: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButtonPlus(
              onTap: () => _addBalanceModal(Get.context!, 'add_balance'.tr),
              svgImage: AppImages.plus,
              btnText: "add_balance".tr,
              fontFamily: AppFontStyleTextStrings.regular,
              textSize: 14,
              width: Get.width * 0.4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistorySection() {
    return Column(
      children: [
        _buildTransactionHistoryHeader(),
        const DashedDivider(color: AppColors.dividers, height: 2),
        _buildTransactionList(),
      ],
    );
  }

  Widget _buildTransactionHistoryHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "transaction_history".tr,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontFamily: AppFontStyleTextStrings.bold,
              fontSize: 16,
            ),
          ),
          _buildDateFilterButton(),
        ],
      ),
    );
  }

  Widget _buildDateFilterButton() {
    return GestureDetector(
      onTap: _showDatePicker,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.calendarIcon,
              colorFilter: const ColorFilter.mode(AppColors.primaryText, BlendMode.srcIn),
            ),
            const SizedBox(width: 5),
            Obx(
              () => Text(
                DateFormat('MMMM yyyy').format(controller.filterDate.value),
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.regular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.transactionHistories.length,
      itemBuilder: (context, index) {
        final transaction = controller.transactionHistories[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(dynamic transaction) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: transaction.type == 2 ? AppColors.primary50 : AppColors.infoLight,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              transaction.type == 2 ? AppImages.cardUp : AppImages.fileDown,
              colorFilter: ColorFilter.mode(
                transaction.type == 2 ? AppColors.primary600 : AppColors.infoMain,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.name,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.medium,
                ),
              ),
              Text(
                transaction.type == 2 ? '-${transaction.amount} EUR' : '+${transaction.amount} EUR',
                style: TextStyle(
                  color: transaction.type == 2 ? AppColors.primary600 : AppColors.infoMain,
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.medium,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            transaction.date,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 13,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        offset: const Offset(0, 45),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controller.filterDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.filterDate.value = pickedDate;
    }
  }

  Future<Object?> _addBalanceModal(BuildContext context, String label) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            controller.withdrawAmount.clear();
            controller.selectedBank.value = 0;
          }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: Colors.transparent,
            child: FractionallySizedBox(
              heightFactor: 1.2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: AppFontStyleTextStrings.bold,
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.dividers, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        children: [
                          CustomTextField(
                            labelText: "enter_amount".tr,
                            hintText: "enter".tr,
                            errorText: "",
                            isError: controller.isRechargeAmountError,
                            obscureText: false.obs,
                            keyboardType: TextInputType.number,
                            controller: controller.rechargeAmount,
                            onChanged: (value) {},
                            rightPadding: 0,
                            leftPadding: 0,
                            isRequire: false,
                          ),
                          const SizedBox(height: 15),
                          _buildBankSelectBox(false),
                          CustomButtonPlus(
                            onTap: () {
                              _addNewBankAccount(context);
                            },
                            btnText: "add_new_bank".tr,
                            color: AppColors.white,
                            textColor: AppColors.primaryText,
                            borderColor: AppColors.primaryText,
                            borderRadius: 16,
                            height: 55,
                            topPadding: 20,
                            bottomPadding: 0,
                            leftPadding: 0,
                            rightPadding: 0,
                          ),
                          CustomButtonPlus(
                            onTap: () {
                              controller.rechargeWallet();
                            },
                            btnText: "add".tr,
                            color: AppColors.primaryText,
                            textColor: AppColors.white,
                            height: 55,
                            topPadding: 20,
                            bottomPadding: 0,
                            leftPadding: 0,
                            rightPadding: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankSelectBox(bool isWithdraw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isWithdraw ? "to_account".tr : "from".tr,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.bold,
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.only(top: 0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.bankAccounts.length,
          itemBuilder: (context, index) {
            final bank = controller.bankAccounts[index];
            if (isWithdraw && bank['id'] == 1) return SizedBox.shrink();
            return Obx(
              () => GestureDetector(
                onTap: () {
                  controller.selectedBank.value = bank['id'];
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    color: controller.selectedBank.value == bank['id']
                        ? AppColors.errorLight
                        : AppColors.transparentColor,
                    border: Border.all(
                      color: controller.selectedBank.value == bank['id']
                          ? AppColors.errorMain
                          : AppColors.dividers,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bank['bank'],
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.bold,
                            ),
                          ),
                          Text(
                            bank['number'],
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.regular,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Transform.scale(
                        scale: 1.3,
                        child: Radio(
                          value: bank['id'],
                          activeColor: AppColors.errorMain,
                          groupValue: controller.selectedBank.value,
                          onChanged: (value) {
                            controller.selectedBank.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future _addNewBankAccount(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            controller.isCardNameError.value = false;
            controller.isCardNumberError.value = false;
            controller.isCardExpiryError.value = false;
            controller.isCardCvvError.value = false;
          }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                        child: Text(
                          "add_new_bank".tr,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: AppFontStyleTextStrings.bold,
                          ),
                        ),
                      ),
                      const Divider(color: AppColors.dividers, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.dividers, width: 1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: _buildTextField(
                                      'cardholder_name'.tr,
                                      'cardholder_hint'.tr,
                                      TextInputType.text,
                                      controller.cardName,
                                      false,
                                      controller.isCardNameError,
                                    ),
                                  ),
                                  const Divider(color: AppColors.dividers, thickness: 1, height: 1),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: _buildTextField(
                                      'card_number'.tr,
                                      'card_number_hint'.tr,
                                      TextInputType.number,
                                      controller.cardNumber,
                                      true,
                                      controller.isCardNumberError,
                                    ),
                                  ),
                                  const Divider(color: AppColors.dividers, thickness: 1, height: 1),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 8),
                                          child: _buildTextField(
                                            'expire_date'.tr,
                                            "mm/yy",
                                            TextInputType.datetime,
                                            controller.cardExpiry,
                                            true,
                                            controller.isCardExpiryError,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 67,
                                        child: VerticalDivider(
                                          color: AppColors.dividers,
                                          thickness: 1,
                                          width: 2,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 8),
                                          child: _buildTextField(
                                            'cvv'.tr,
                                            'cvv_hint'.tr,
                                            TextInputType.datetime,
                                            controller.cardCvv,
                                            true,
                                            controller.isCardCvvError,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                children: [
                                  Obx(
                                    () => GestureDetector(
                                      onTap: () {
                                        controller.saveBankInfo.value =
                                            !controller.saveBankInfo.value;
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 40,
                                        height: 25,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: controller.saveBankInfo.value
                                              ? Colors.red
                                              : Colors.grey.withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: AnimatedAlign(
                                          duration: const Duration(milliseconds: 200),
                                          alignment: controller.saveBankInfo.value
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            width: 20,
                                            height: 18,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "save_card".tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppFontStyleTextStrings.regular,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomButtonPlus(
                              onTap: () {
                                controller.checkCardInfo();
                              },
                              btnText: "add".tr,
                              color: AppColors.primaryText,
                              textColor: AppColors.white,
                              height: 55,
                              topPadding: 20,
                              bottomPadding: 0,
                              leftPadding: 0,
                              rightPadding: 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Object?> _withdrawModal(BuildContext context, String label) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => Material(
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) {
              controller.withdrawAmount.clear();
              controller.selectedBank.value = 0;
            }
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: FractionallySizedBox(
              heightFactor: 1.65,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: AppFontStyleTextStrings.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'submit'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: AppFontStyleTextStrings.bold,
                                decoration: TextDecoration.underline,
                                color: AppColors.primary600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.dividers, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    AppImages.walletIcon,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'maximum_withdraw'.tr,
                                      style: const TextStyle(
                                        color: AppColors.primaryText,
                                        fontSize: 14,
                                        fontFamily: AppFontStyleTextStrings.regular,
                                      ),
                                    ),
                                    Text(
                                      "${controller.balance} EUR",
                                      style: const TextStyle(
                                        color: AppColors.primary600,
                                        fontSize: 18,
                                        fontFamily: AppFontStyleTextStrings.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            labelText: "how_many_withdraw".tr,
                            hintText: "enter".tr,
                            errorText: "",
                            isError: false.obs,
                            obscureText: false.obs,
                            keyboardType: TextInputType.number,
                            controller: controller.withdrawAmount,
                            onChanged: (value) {},
                            rightPadding: 0,
                            leftPadding: 0,
                          ),
                          const SizedBox(height: 15),
                          _buildBankSelectBox(true),
                          CustomButtonPlus(
                            onTap: () {
                              _addNewBankAccount(context);
                            },
                            btnText: "add_new_bank".tr,
                            color: AppColors.white,
                            textColor: AppColors.primaryText,
                            borderColor: AppColors.primaryText,
                            borderRadius: 16,
                            height: 55,
                            topPadding: 20,
                            bottomPadding: 0,
                            leftPadding: 0,
                            rightPadding: 0,
                          ),
                          CustomButtonPlus(
                            onTap: () {},
                            btnText: "withdraw".tr,
                            color: AppColors.primaryText,
                            textColor: AppColors.white,
                            height: 55,
                            topPadding: 20,
                            bottomPadding: 0,
                            leftPadding: 0,
                            rightPadding: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String placeholder,
    TextInputType keyboardType,
    TextEditingController controller,
    bool needFormatter,
    RxBool isError,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isError.value ? AppColors.errorMain : AppColors.secondaryText,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ),
        Obx(
          () => TextField(
            keyboardType: keyboardType,
            controller: controller,
            inputFormatters: [
              if (needFormatter) ...[
                if (keyboardType == TextInputType.number) FilteringTextInputFormatter.digitsOnly,
                if (label.toLowerCase().contains('cvv')) LengthLimitingTextInputFormatter(3),
                if (label.toLowerCase().contains('card')) cardNumFormatter,
                if (label.toLowerCase().contains('expire')) expireFormatter,
              ],
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                isError.value = false;
              }
            },
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                color: isError.value ? AppColors.errorMain : AppColors.secondaryText,
              ),
              contentPadding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
              isDense: true,
              border: InputBorder.none,
            ),
            style: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
