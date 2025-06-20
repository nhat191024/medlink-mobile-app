import 'package:medlink/utils/app_imports.dart';

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
        Get.snackbar(
          'Invalid File Type',
          'Please select a JPG or PNG image',
          snackPosition: SnackPosition.TOP,
          colorText: AppColors.errorMain,
        );
        return;
      }

      if (!isValidSize) {
        Get.snackbar(
          'File Too Large',
          'Image size should be less than 5MB',
          snackPosition: SnackPosition.TOP,
          colorText: AppColors.errorMain,
        );
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
