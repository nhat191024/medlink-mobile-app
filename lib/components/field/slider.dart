import 'package:medlink/utils/app_imports.dart';

class CustomSlider extends StatelessWidget {
  final String label;
  final bool? isRequire;
  final String? secondLabelText;
  final RxDouble? secondLabelValueDouble;
  final RxInt? secondLabelValueInt;
  final String? secondSubLabelText;
  final double min;
  final double max;
  final RxDouble currentValue;
  final Function(double) onChanged;

  const CustomSlider({
    super.key,
    required this.label,
    this.isRequire = false,
    this.secondLabelText = '',
    this.secondLabelValueDouble,
    this.secondLabelValueInt,
    this.secondSubLabelText,
    required this.min,
    required this.max,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: AppFontStyleTextStrings.bold,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        if (isRequire == true)
                          const TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.bold,
                              color: AppColors.errorMain,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (secondLabelText != null)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: secondLabelText,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.regular,
                              color: AppColors.disable,
                            ),
                          ),
                          TextSpan(
                            text: secondLabelValueDouble != null
                                ? secondLabelValueDouble!.value.toString()
                                : secondLabelValueInt!.value.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.bold,
                              color: AppColors.primary600,
                            ),
                          ),
                          if (secondSubLabelText != null)
                            TextSpan(
                              text: secondSubLabelText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: AppFontStyleTextStrings.bold,
                                color: AppColors.primary600,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            SliderTheme(
              data: const SliderThemeData(
                trackHeight: 5,
                thumbColor: AppColors.primary600,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                  elevation: 6,
                  pressedElevation: 2,
                ),
                activeTrackColor: AppColors.primary600,
                inactiveTrackColor: AppColors.dividers,
                overlayColor: AppColors.white,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(min: min, max: max, value: currentValue.value, onChanged: onChanged),
            ),
          ],
        ),
      ),
    );
  }
}
