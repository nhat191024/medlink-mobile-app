import 'package:medlink/utils/app_imports.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final String hintText;
  final Color hintTextColor;
  final String errorText;
  final RxBool isError;
  final bool needErrorText;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool? isRequire;
  final Color backgroundColor;
  final IconData? suffixIcon;

  const CustomDatePicker({
    super.key,
    required this.labelText,
    this.labelColor = AppColors.secondaryText,
    this.leftPadding = 20,
    this.rightPadding = 20,
    this.topPadding = 0,
    required this.hintText,
    this.hintTextColor = AppColors.disable,
    required this.errorText,
    required this.isError,
    this.needErrorText = true,
    required this.onDateSelected,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.isRequire = false,
    this.backgroundColor = AppColors.background,
    this.suffixIcon,
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
            () => GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                decoration: BoxDecoration(
                  color: isError.value ? AppColors.errorLight : backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isError.value ? AppColors.errorMain : AppColors.dividers,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                            : hintText,
                        style: TextStyle(
                          color: selectedDate != null
                              ? AppColors.primaryText
                              : hintTextColor,
                          fontSize: 16,
                          fontFamily: AppFontStyleTextStrings.regular,
                        ),
                      ),
                    ),
                    Icon(
                      suffixIcon ?? Icons.calendar_today,
                      color: AppColors.primaryText,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (needErrorText && isError.value) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                errorText,
                style: const TextStyle(
                  color: AppColors.errorMain,
                  fontSize: 12,
                  fontFamily: AppFontStyleTextStrings.regular,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary600,
              onPrimary: AppColors.WHITE,
              onSurface: AppColors.primaryText,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary600,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }
}
