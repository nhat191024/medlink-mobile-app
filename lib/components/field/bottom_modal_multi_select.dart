import 'dart:ui';
import 'package:medlink/utils/app_imports.dart';

class CustomMultiSelectWithBottomModal extends StatelessWidget {
  final String label;
  final bool? isRequire;
  final List<String> list;
  final Function(List<String>) onChanged;
  final String hintText;
  final RxBool isError;
  final List<String>? defaultSelections;
  final Color backgroundColor;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;

  final RxList<String> selectedTypes = <String>[].obs;
  final RxList<String> savedTypes = <String>[].obs;

  CustomMultiSelectWithBottomModal({
    super.key,
    required this.label,
    this.isRequire = false,
    required this.list,
    required this.onChanged,
    required this.hintText,
    this.defaultSelections,
    required this.isError,
    this.backgroundColor = AppColors.background,
    this.leftPadding = 20,
    this.rightPadding = 20,
    this.topPadding = 0,
  }) {
    if (defaultSelections != null) {
      selectedTypes.addAll(defaultSelections!);
      savedTypes.addAll(defaultSelections!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, 0),
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
                                      savedTypes.value = List.from(selectedTypes);
                                      onChanged(selectedTypes);
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
                            ),
                            const Divider(color: AppColors.dividers, thickness: 2),
                            ...list.map(
                              (type) => Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    color: selectedTypes.contains(type)
                                        ? Colors.red.shade100
                                        : Colors.transparent,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      type,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppFontStyleTextStrings.regular,
                                        color: selectedTypes.contains(type)
                                            ? AppColors.primary600
                                            : AppColors.primaryText,
                                      ),
                                    ),
                                    trailing: selectedTypes.contains(type)
                                        ? const Icon(Icons.check, color: AppColors.primary600)
                                        : const SizedBox.shrink(),
                                    tileColor: selectedTypes.contains(type)
                                        ? AppColors.primary50
                                        : Colors.transparent,
                                    onTap: () {
                                      if (selectedTypes.contains(type)) {
                                        selectedTypes.remove(type);
                                      } else {
                                        selectedTypes.add(type);
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
            child: Obx(
              () => Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isError.value ? AppColors.errorMain : AppColors.dividers,
                    width: 1,
                  ),
                  color: isError.value ? AppColors.errorLight : backgroundColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          savedTypes.isEmpty ? hintText : savedTypes.join(', '),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: AppFontStyleTextStrings.regular,
                            color: AppColors.primaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 35, color: AppColors.primaryText),
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
