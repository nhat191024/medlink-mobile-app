import 'package:medlink/utils/app_imports.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final TextInputType? keyboardType;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final String hintText;
  final Color hintTextColor;
  final String errorText;
  final RxBool isError;
  final bool needErrorText;
  final RxBool obscureText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Widget? suffixIcon;
  final VoidCallback? onPress;
  final bool? isRequire;
  final Color backgroundColor;
  final String? suffixText;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.labelColor = AppColors.secondaryText,
    this.keyboardType,
    this.leftPadding = 20,
    this.rightPadding = 20,
    this.topPadding = 0,
    required this.hintText,
    this.hintTextColor = AppColors.disable,
    required this.errorText,
    required this.isError,
    this.needErrorText = true,
    required this.obscureText,
    required this.controller,
    required this.onChanged,
    this.suffixIcon,
    this.onPress,
    this.isRequire = false,
    this.backgroundColor = AppColors.background,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: labelText,
              style: TextStyle(
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.bold,
                color: labelColor,
              ),
              children: isRequire == true
                  ? [
                      const TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 5),
          Obx(
            () => TextField(
              obscureText: obscureText.value,
              keyboardType: keyboardType,
              controller: controller,
              onChanged: (value) {
                onChanged(value);
              },
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: hintTextColor),
                contentPadding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isError.value ? AppColors.errorMain : AppColors.dividers,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isError.value ? AppColors.errorMain : AppColors.dividers,
                    width: 1,
                  ),
                ),
                errorText: needErrorText
                    ? isError.value
                          ? errorText
                          : null
                    : null,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isError.value ? AppColors.errorMain : AppColors.primaryText,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: backgroundColor == AppColors.background ? isError.value : true,
                fillColor: isError.value ? AppColors.errorLight : backgroundColor,
                suffixIcon: suffixIcon != null
                    ? IconButton(onPressed: onPress, icon: suffixIcon!)
                    : null,
                suffix: Text(
                  suffixText ?? '',
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                ),
                alignLabelWithHint: true,
                isDense: true,
                suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
