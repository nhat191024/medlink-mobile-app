import 'package:medlink/utils/app_imports.dart';

class GridCategory extends StatelessWidget {
  final String name;
  final String icon;
  final bool isSelected;
  final int numberOfResults;
  final Function() onTap;

  const GridCategory({
    super.key,
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.numberOfResults,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary600 : AppColors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? AppColors.white : AppColors.primary50,
              radius: 28,
              child: SvgPicture.asset(
                icon,
                colorFilter: const ColorFilter.mode(AppColors.primary600, BlendMode.srcIn),
                height: 30,
                width: 30,
                fit: BoxFit.fill,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primary600,
                      fontSize: 16,
                      fontFamily: AppFontStyleTextStrings.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$numberOfResults results',
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primaryText,
                      fontSize: 13,
                      fontFamily: AppFontStyleTextStrings.regular,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
