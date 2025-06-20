import 'package:medlink/utils/app_imports.dart';

class CircularProgressStep extends StatelessWidget {
  final int step;
  final int totalSteps;
  final double topPadding;

  const CircularProgressStep({
    super.key,
    required this.step,
    required this.totalSteps,
    this.topPadding = 40,
  });

  @override
  Widget build(BuildContext context) {
    double progress = step / totalSteps;
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.fromLTRB(0, topPadding, 15, 0),
      decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              color: AppColors.primary600,
              backgroundColor: AppColors.primary100,
            ),
          ),
          Text(
            '$step',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primary600,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
        ],
      ),
    );
  }
}
