import 'package:medlink/utils/app_imports.dart';
import 'dart:ui';

class ButtonWithBottomModal extends StatelessWidget {
  final String label;
  final List<String> list;
  final Function(String) onChanged;
  final String? defaultSelect;
  final Color backgroundColor;
  final double width;
  final double height;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;

  final RxString selectedType = ''.obs;
  final RxString savedType = ''.obs;

  ButtonWithBottomModal({
    super.key,
    required this.label,
    required this.list,
    required this.onChanged,
    this.defaultSelect,
    this.backgroundColor = AppColors.background,
    this.width = 40,
    this.height = 40,
    this.leftPadding = 20,
    this.rightPadding = 20,
    this.topPadding = 0,
  }) {
    if (defaultSelect != null) {
      selectedType.value = defaultSelect!;
      savedType.value = defaultSelect!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: Row(
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
                                      'Submit',
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
                            ),
                            const Divider(color: AppColors.dividers, thickness: 2),
                            ...list.map(
                              (type) => Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    color: type == selectedType.value
                                        ? AppColors.primary50
                                        : Colors.transparent,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      type,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppFontStyleTextStrings.regular,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    trailing: type == selectedType.value
                                        ? const Icon(Icons.check, color: AppColors.primary600)
                                        : const SizedBox.shrink(),
                                    tileColor: type == selectedType.value
                                        ? AppColors.primary50
                                        : Colors.transparent,
                                    onTap: () {
                                      if (type == selectedType.value) {
                                        selectedType.value = '';
                                      } else {
                                        selectedType.value = type;
                                      }
                                    },
                                  ),
                                ),
                              ),
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
                          child: Container(color: Colors.black.withOpacity(0.1)),
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: backgroundColor,
              ),
              child: SvgPicture.asset(AppImages.inside),
            ),
          ),
        ],
      ),
    );
  }
}
