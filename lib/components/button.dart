import 'package:medlink/utils/app_imports.dart';
import 'dart:ui';

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
        onPressed: isDisabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: !isDisabled ? AppColors.border : AppColors.primaryText,
          minimumSize: Size(Get.width, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: iconColor ?? AppColors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
            ],
            if (image != null) ...[
              SvgPicture.asset(
                image!,
                colorFilter: imageColor != null ? ColorFilter.mode(imageColor!, BlendMode.srcIn) : null,
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

class CustomButtonPlus extends StatelessWidget {
  final VoidCallback onTap;
  final String btnText;
  final double? width;
  final double? height;
  final double leftPadding;
  final double topPadding;
  final double rightPadding;
  final double bottomPadding;
  final bool isDisabled;
  final bool isLoading;
  final Color color;
  final Color borderColor;
  final Color shadowColor;
  final Color textColor;
  final double textSize;
  final String fontFamily;
  final double borderRadius;
  final IconData? icon;
  final ImageProvider<Object>? image;
  final String? svgImage;
  final Color? iconColor;
  final Color? imageColor;

  const CustomButtonPlus({
    super.key,
    required this.onTap,
    required this.btnText,
    this.width,
    this.height,
    this.leftPadding = 20,
    this.topPadding = 10,
    this.rightPadding = 20,
    this.bottomPadding = 20,
    this.isDisabled = false,
    this.isLoading = false,
    this.color = AppColors.primaryText,
    this.borderColor = AppColors.border,
    this.shadowColor = Colors.transparent,
    this.textColor = AppColors.white,
    this.textSize = 16,
    this.fontFamily = AppFontStyleTextStrings.bold,
    this.borderRadius = 50,
    this.icon,
    this.image,
    this.svgImage,
    this.iconColor,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, bottomPadding),
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? AppColors.border : color,
          foregroundColor: textColor,
          minimumSize: Size(width ?? Get.width, height ?? 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shadowColor: shadowColor,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: iconColor ?? AppColors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (image != null) ...[
                    Image(
                      image: image!,
                      height: 24,
                      width: 24,
                      color: imageColor,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (svgImage != null) ...[
                    SvgPicture.asset(
                      svgImage!,
                      colorFilter: ColorFilter.mode(imageColor ?? AppColors.white, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    btnText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ComeBackButton extends StatelessWidget {
  final double topPadding;
  final Color backgroundColor;
  const ComeBackButton({super.key, this.topPadding = 40, this.backgroundColor = AppColors.background});

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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ),
    );
  }
}

class AttachPhotoButton extends StatelessWidget {
  final Rx<File?> selectedImage;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  AttachPhotoButton({
    super.key,
    required this.selectedImage,
    this.onTap,
    this.width = 140,
    this.height = 48,
  });

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final String extension = pickedFile.path.split('.').last.toLowerCase();
      final bool isValidExtension = ['jpg', 'jpeg', 'png'].contains(extension);
      final bool isValidSize = await file.length() < 5 * 1024 * 1024; // 5MB

      if (!isValidExtension) {
        Get.snackbar('Invalid File Type', 'Please select a JPG or PNG image', snackPosition: SnackPosition.TOP, colorText: AppColors.errorMain);
        return;
      }

      if (!isValidSize) {
        Get.snackbar('File Too Large', 'Image size should be less than 5MB', snackPosition: SnackPosition.TOP, colorText: AppColors.errorMain);
        return;
      }

      selectedImage.value = file;
      if (onTap != null) {
        onTap!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.primary600,
        ),
        alignment: Alignment.center,
        child: const Text(
          "Attach photo",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
      ),
    );
  }
}

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
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24.0),
                          ),
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
                            const Divider(
                              color: AppColors.dividers,
                              thickness: 2,
                            ),
                            ...list.map(
                              (type) => Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    color: type == selectedType.value ? AppColors.primary50 : Colors.transparent,
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
                                        ? const Icon(
                                            Icons.check,
                                            color: AppColors.primary600,
                                          )
                                        : const SizedBox.shrink(),
                                    tileColor: type == selectedType.value ? AppColors.primary50 : Colors.transparent,
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
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
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
