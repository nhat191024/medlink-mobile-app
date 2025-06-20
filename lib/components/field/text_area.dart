import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/components/widget/card_view.dart';

class CustomTextArea extends StatelessWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final String hintText;
  final String errorText;
  final RxBool isError;
  final RxBool obscureText;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final Function(String) onChanged;
  final Widget? suffixIcon;
  final VoidCallback? onPress;
  final bool? isRequire;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;

  const CustomTextArea({
    super.key,
    required this.labelText,
    this.keyboardType,
    required this.hintText,
    required this.errorText,
    required this.isError,
    required this.obscureText,
    required this.controller,
    this.minLines = 4,
    this.maxLines = 5,
    required this.onChanged,
    this.suffixIcon,
    this.onPress,
    this.isRequire = false,
    this.leftPadding = 20,
    this.rightPadding = 20,
    this.topPadding = 0,
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
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.bold,
                color: AppColors.secondaryText,
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
            () => CardView(
              borderRadius: 14,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isError.value ? AppColors.errorMain : AppColors.dividers,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  color: isError.value ? AppColors.errorLight : AppColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: const TextStyle(color: AppColors.disable),
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        minLines: minLines,
                        maxLines: maxLines,
                        controller: controller,
                        onChanged: (value) {
                          onChanged(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
