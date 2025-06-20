import 'dart:ui';
import 'package:medlink/utils/app_imports.dart';

class CustomSelectWithBottomModalStyle2 extends StatelessWidget {
  final String label;
  final bool? isRequire;
  final List<String> list;
  final Function(String) onChanged;
  final String hintText;

  CustomSelectWithBottomModalStyle2({
    super.key,
    required this.label,
    this.isRequire = false,
    required this.list,
    required this.onChanged,
    required this.hintText,
  });

  final RxString selectedType = ''.obs;
  final RxString savedType = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
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
          InkWell(
            onTap: () async {
              showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: true,
                barrierColor: Colors.transparent,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Material(
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                    savedType.value = selectedType.value;
                                    onChanged(selectedType.value);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppFontStyleTextStrings.bold,
                                      decoration: TextDecoration.underline,
                                      color: AppColors.primary600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: AppColors.dividers, thickness: 2),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double itemWidth = (constraints.maxWidth - 20) / 3;

                                return Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  alignment: WrapAlignment.center,
                                  children: list.map((type) {
                                    return SizedBox(
                                      width: itemWidth,
                                      child: Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            selectedType.value = type;
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: type == selectedType.value
                                                  ? AppColors.primary50
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(
                                                color: type == selectedType.value
                                                    ? AppColors.primary600
                                                    : AppColors.dividers,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  type,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: AppFontStyleTextStrings.regular,
                                                    color: type == selectedType.value
                                                        ? AppColors.primary600
                                                        : AppColors.primaryText,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                const Spacer(),
                                                Image.asset(AppImages.blood),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                transitionBuilder: (context, animation, secondaryAnimation, child) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(color: Colors.black.withValues(alpha: 0.5)),
                        ),
                      ),
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.dividers, width: 1),
              ),
              child: Row(
                children: [
                  Obx(
                    () => Text(
                      savedType.value.isEmpty ? hintText : savedType.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppFontStyleTextStrings.regular,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down, size: 35, color: AppColors.primaryText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
