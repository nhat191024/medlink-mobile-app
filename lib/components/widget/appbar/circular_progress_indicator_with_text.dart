import 'package:medlink/utils/app_imports.dart';

class CircularProgressIndicatorWithText extends StatelessWidget {
  final RxInt currentStep;
  final int totalSteps;

  const CircularProgressIndicatorWithText({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60.0,
          height: 60.0,
          child: Obx(
            () => TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: currentStep.value / totalSteps),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary600),
                  backgroundColor: AppColors.background,
                );
              },
            ),
          ),
        ),
        Obx(
          () => RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: currentStep.value.toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: AppFontStyleTextStrings.bold,
                    color: AppColors.primary600,
                  ),
                ),
                TextSpan(
                  text: '/$totalSteps',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontFamily: AppFontStyleTextStrings.regular,
                    color: AppColors.disable,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
