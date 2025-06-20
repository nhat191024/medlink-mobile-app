import 'package:medlink/utils/app_imports.dart';

class ComeBackButton extends StatelessWidget {
  final double topPadding;
  final Color backgroundColor;
  const ComeBackButton({
    super.key,
    this.topPadding = 40,
    this.backgroundColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          width: 45,
          height: 45,
          margin: EdgeInsets.fromLTRB(15, topPadding, 0, 0),
          decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
          child: const Center(child: Icon(Icons.arrow_back, color: AppColors.primaryText)),
        ),
      ),
    );
  }
}
