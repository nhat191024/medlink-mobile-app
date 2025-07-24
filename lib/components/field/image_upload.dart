import 'package:medlink/utils/app_imports.dart';

class ImageUploadField extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final String hintText;
  final bool? isRequire;
  final bool isValidate;
  final Rx<File?> selectedImage;
  final Function(File?)? onChanged;

  ImageUploadField({
    super.key,
    required this.labelText,
    this.labelColor = AppColors.primaryText,
    required this.selectedImage,
    this.isRequire = false,
    required this.isValidate,
    this.onChanged,
    required this.hintText,
  });

  final ImagePicker _picker = ImagePicker();
  static const int _maxFileSize = 5 * 1024 * 1024; // 5MB in bytes
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png'];

  bool _isValidFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return _allowedExtensions.contains(extension);
  }

  bool _isValidFileSize(File file) {
    return file.lengthSync() <= _maxFileSize;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File selectedFile = File(pickedFile.path);

      if (!_isValidFileType(pickedFile.path)) {
        Get.snackbar(
          "invalid_file_type".tr,
          "please_select_file".tr,
          snackPosition: SnackPosition.TOP,
          colorText: AppColors.errorMain,
          backgroundColor: AppColors.white,
        );
        return;
      }

      if (!_isValidFileSize(selectedFile)) {
        Get.snackbar(
          'invalid_file_type'.tr,
          'image_size_limit'.tr,
          snackPosition: SnackPosition.TOP,
          colorText: AppColors.errorMain,
          backgroundColor: AppColors.white,
        );
        return;
      }

      selectedImage.value = selectedFile;
      if (onChanged != null) {
        onChanged!(selectedFile);
      }
    } else {
      if (onChanged != null) {
        onChanged!(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: labelText,
              style: TextStyle(
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.bold,
                color: labelColor,
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
          const SizedBox(height: 6),
          Obx(
            () => selectedImage.value != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 180,
                            height: 130,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(selectedImage.value!, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                selectedImage.value = null;
                                if (onChanged != null) {
                                  onChanged!(null);
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.close, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10), // Khoảng cách giữa ảnh và text
                      Expanded(
                        // Thêm Expanded để căn chỉnh text và ảnh về bên trái
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh về trái
                          children: [
                            isValidate
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(AppImages.verify),
                                      const SizedBox(
                                        width: 5,
                                      ), // Thêm khoảng cách giữa ảnh và văn bản
                                      const Text(
                                        "Validated",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.successMain,
                                          fontFamily: AppFontStyleTextStrings.regular,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'Waiting to validate...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFF09D2E),
                                      fontFamily: AppFontStyleTextStrings.regular,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Row(
                        children: [
                          Text(
                            hintText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: AppFontStyleTextStrings.regular,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: SvgPicture.asset(AppImages.upload),
                            onPressed: _pickImage,
                          ),
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
