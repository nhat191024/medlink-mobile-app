import 'package:medlink/utils/app_imports.dart';

class CustomButtonDefault extends StatelessWidget {
  final VoidCallback onTap;
  final String btnText;
  final double leftPadding;
  final double topPadding;
  final double rightPadding;
  final double bottomPadding;
  final bool isDisabled;
  final Color color;
  final IconData? icon;
  final String? image;
  final Color? iconColor;
  final Color? imageColor;

  const CustomButtonDefault({
    super.key,
    required this.onTap,
    required this.btnText,
    this.leftPadding = 20,
    this.topPadding = 10,
    this.rightPadding = 20,
    this.bottomPadding = 20,
    this.isDisabled = false,
    this.color = AppColors.primaryText,
    this.icon,
    this.image,
    this.iconColor,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, bottomPadding),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? AppColors.border : AppColors.primaryText,
          minimumSize: Size(Get.width, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor ?? AppColors.white, size: 24),
              const SizedBox(width: 8),
            ],
            if (image != null) ...[
              SvgPicture.asset(
                image!,
                colorFilter: imageColor != null
                    ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
                    : null,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              btnText,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontFamily: AppFontStyleTextStrings.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
