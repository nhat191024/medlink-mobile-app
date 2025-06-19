import 'dart:ui';
import 'package:medlink/utils/app_imports.dart';

class PhoneNumberTextField extends StatefulWidget {
  final bool isBlack;
  final Function(String)? onChanged;
  final Country selectedCountry;
  final VoidCallback? onCountryTap;
  final TextEditingController? controller;
  final Color color;
  final RxBool isError; // Changed to RxBool

  const PhoneNumberTextField({
    super.key,
    required this.isBlack,
    required this.selectedCountry,
    required this.onCountryTap,
    this.onChanged,
    this.controller,
    this.color = AppColors.background,
    required this.isError,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PhoneNumberTextFieldState createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  late TextEditingController _controller;

  final maskFormatter = MaskTextInputFormatter(
    mask: '### ### ###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });

    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onCountryTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              border: Border(
                top: BorderSide(color: isFocused ? AppColors.primaryText : AppColors.border),
                bottom: BorderSide(color: isFocused ? AppColors.primaryText : AppColors.border),
                left: BorderSide(color: isFocused ? AppColors.primaryText : AppColors.border),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 6),
                Text(
                  widget.selectedCountry.flag,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.selectedCountry.dialCode,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() => Container(
                height: 50,
                decoration: BoxDecoration(
                  color: widget.isError.value ? AppColors.errorLight : widget.color,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  border: Border.all(
                      color: widget.isError.value
                          ? AppColors.errorMain
                          : isFocused
                              ? AppColors.primaryText
                              : AppColors.border),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [maskFormatter],
                  onChanged: (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'number'.tr,
                    hintStyle: const TextStyle(color: AppColors.disable),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final String hintText;
  final Color color;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText = 'Search...',
    this.color = AppColors.background,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    widget.controller.addListener(() {
      setState(() {});
      widget.onSearch(widget.controller.text);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isFocused ? Colors.white : widget.color,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: _isFocused ? Colors.black : Colors.transparent,
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          prefixIcon: SvgPicture.asset(
            AppImages.searchIcon,
            height: 15,
            width: 15,
            fit: BoxFit.scaleDown,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    size: 30,
                    color: AppColors.secondaryText,
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onSearch('');
                    setState(() {});
                  },
                )
              : const SizedBox.shrink(),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.secondaryText,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}

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
        Get.snackbar('Invalid File Type', 'Please select a JPG or PNG image', snackPosition: SnackPosition.TOP, colorText: AppColors.errorMain);
        return;
      }

      if (!_isValidFileSize(selectedFile)) {
        Get.snackbar('File Too Large', 'Image size should be less than 5MB', snackPosition: SnackPosition.TOP, colorText: AppColors.errorMain);
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
                        style: TextStyle(
                          color: Colors.red,
                        ),
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                selectedImage.value!,
                                fit: BoxFit.cover,
                              ),
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
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
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
                                      const SizedBox(width: 5), // Thêm khoảng cách giữa ảnh và văn bản
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
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
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

class CustomSlider extends StatelessWidget {
  final String label;
  final bool? isRequire;
  final String? secondLabelText;
  final RxDouble? secondLabelValueDouble;
  final RxInt? secondLabelValueInt;
  final String? secondSubLabelText;
  final double min;
  final double max;
  final RxDouble currentValue;
  final Function(double) onChanged;

  const CustomSlider({
    super.key,
    required this.label,
    this.isRequire = false,
    this.secondLabelText = '',
    this.secondLabelValueDouble,
    this.secondLabelValueInt,
    this.secondSubLabelText,
    required this.min,
    required this.max,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: AppFontStyleTextStrings.bold,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        if (isRequire == true)
                          const TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.bold,
                              color: AppColors.errorMain,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (secondLabelText != null)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: secondLabelText,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.regular,
                              color: AppColors.disable,
                            ),
                          ),
                          TextSpan(
                            text: secondLabelValueDouble != null ? secondLabelValueDouble!.value.toString() : secondLabelValueInt!.value.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.bold,
                              color: AppColors.primary600,
                            ),
                          ),
                          if (secondSubLabelText != null)
                            TextSpan(
                              text: secondSubLabelText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: AppFontStyleTextStrings.bold,
                                color: AppColors.primary600,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            SliderTheme(
              data: const SliderThemeData(
                trackHeight: 5,
                thumbColor: AppColors.primary600,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                  elevation: 6,
                  pressedElevation: 2,
                ),
                activeTrackColor: AppColors.primary600,
                inactiveTrackColor: AppColors.dividers,
                overlayColor: AppColors.white,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(
                min: min,
                max: max,
                value: currentValue.value,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSelectWithBottomModal extends StatelessWidget {
  final String label;
  final bool? isRequire;
  final List<String> list;
  final Function(String) onChanged;
  final String hintText;
  final RxBool isError;
  final String? defaultSelect;
  final Color backgroundColor;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final String? errorText; // Add this line

  final RxString selectedType = ''.obs;
  final RxString savedType = ''.obs;

  CustomSelectWithBottomModal({
    super.key,
    required this.label,
    this.isRequire = false,
    required this.list,
    required this.onChanged,
    required this.hintText,
    this.defaultSelect,
    required this.isError,
    this.backgroundColor = AppColors.background,
    this.leftPadding = 20,
    this.rightPadding = 20,
    this.topPadding = 0,
    this.errorText, // Add this line
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
                        style: TextStyle(
                          color: Colors.red,
                        ),
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
                            const Divider(
                              color: AppColors.dividers,
                              thickness: 2,
                            ),
                            ...list.map(
                              (type) => Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    color: type == selectedType.value ? Colors.red.shade100 : Colors.transparent,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      type,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppFontStyleTextStrings.regular,
                                        color: type == selectedType.value ? AppColors.primary600 : AppColors.primaryText,
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
                                      selectedType.value = type;
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
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 35,
                      color: AppColors.primaryText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => isError.value && errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Text(
                      errorText!,
                      style: const TextStyle(
                        color: AppColors.errorMain,
                        fontSize: 12,
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

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
                        style: TextStyle(
                          color: Colors.red,
                        ),
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
                            const Divider(
                              color: AppColors.dividers,
                              thickness: 2,
                            ),
                            ...list.map(
                              (type) => Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    color: selectedTypes.contains(type) ? Colors.red.shade100 : Colors.transparent,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      type,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppFontStyleTextStrings.regular,
                                        color: selectedTypes.contains(type) ? AppColors.primary600 : AppColors.primaryText,
                                      ),
                                    ),
                                    trailing: selectedTypes.contains(type)
                                        ? const Icon(
                                            Icons.check,
                                            color: AppColors.primary600,
                                          )
                                        : const SizedBox.shrink(),
                                    tileColor: selectedTypes.contains(type) ? AppColors.primary50 : Colors.transparent,
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
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 35,
                      color: AppColors.primaryText,
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
                        style: TextStyle(
                          color: Colors.red,
                        ),
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
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
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
                            const Divider(
                              color: AppColors.dividers,
                              thickness: 2,
                            ),
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
                                              color: type == selectedType.value ? AppColors.primary50 : Colors.transparent,
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(
                                                color: type == selectedType.value ? AppColors.primary600 : AppColors.dividers,
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
                                                    color: type == selectedType.value ? AppColors.primary600 : AppColors.primaryText,
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
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
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
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.dividers,
                  width: 1,
                ),
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
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 35,
                    color: AppColors.primaryText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextArea extends StatelessWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final String hintText;
  final String errorText;
  final RxBool isError;
  final RxBool obscureText;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final Function(String) onChanged;
  final Widget? suffixIcon;
  final VoidCallback? onPress;
  final bool? isRequire;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;

  const CustomTextArea({
    super.key,
    required this.labelText,
    this.keyboardType,
    required this.hintText,
    required this.errorText,
    required this.isError,
    required this.obscureText,
    required this.controller,
    this.minLines = 4,
    this.maxLines = 5,
    required this.onChanged,
    this.suffixIcon,
    this.onPress,
    this.isRequire = false,
    this.leftPadding = 20,
    this.rightPadding = 20,
    this.topPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: labelText,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFontStyleTextStrings.bold,
                color: AppColors.secondaryText,
              ),
              children: isRequire == true
                  ? [
                      const TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 5),
          Obx(
            () => CardView(
              borderRadius: 14,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: isError.value ? AppColors.errorMain : AppColors.dividers),
                  borderRadius: BorderRadius.circular(14),
                  color: isError.value ? AppColors.errorLight : AppColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: const TextStyle(color: AppColors.disable),
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        minLines: minLines,
                        maxLines: maxLines,
                        controller: controller,
                        onChanged: (value) {
                          onChanged(value);
                        },
                      ),
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

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final TextInputType? keyboardType;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final String hintText;
  final Color hintTextColor;
  final String errorText;
  final RxBool isError;
  final bool needErrorText;
  final RxBool obscureText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Widget? suffixIcon;
  final VoidCallback? onPress;
  final bool? isRequire;
  final Color backgroundColor;
  final String? suffixText;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.labelColor = AppColors.secondaryText,
    this.keyboardType,
    this.leftPadding = 20,
    this.rightPadding = 20,
    this.topPadding = 0,
    required this.hintText,
    this.hintTextColor = AppColors.disable,
    required this.errorText,
    required this.isError,
    this.needErrorText = true,
    required this.obscureText,
    required this.controller,
    required this.onChanged,
    this.suffixIcon,
    this.onPress,
    this.isRequire = false,
    this.backgroundColor = AppColors.background,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, 0),
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
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 5),
          Obx(
            () => TextField(
              obscureText: obscureText.value,
              keyboardType: keyboardType,
              controller: controller,
              onChanged: (value) {
                onChanged(value);
              },
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: hintTextColor),
                contentPadding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isError.value ? AppColors.errorMain : AppColors.dividers,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isError.value ? AppColors.errorMain : AppColors.dividers,
                    width: 1,
                  ),
                ),
                errorText: needErrorText
                    ? isError.value
                        ? errorText
                        : null
                    : null,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isError.value ? AppColors.errorMain : AppColors.primaryText, width: 1),
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: backgroundColor == AppColors.background ? isError.value : true,
                fillColor: isError.value ? AppColors.errorLight : backgroundColor,
                suffixIcon: suffixIcon != null ? IconButton(onPressed: onPress, icon: suffixIcon!) : null,
                suffix: Text(
                  suffixText ?? '',
                  style: const TextStyle(color: AppColors.primaryText, fontSize: 16, fontFamily: AppFontStyleTextStrings.regular),
                ),
                alignLabelWithHint: true,
                isDense: true,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final Widget? child;
  final double? borderRadius;
  final Color? background;
  final EdgeInsetsGeometry? padding;

  const CardView({
    super.key,
    this.child,
    this.borderRadius,
    this.background,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(
          borderRadius != null ? borderRadius! : 0.0,
        ),
      ),
      child: child,
    );
  }
}

class StarReview extends StatelessWidget {
  final ValueChanged<double> onChanged;

  const StarReview({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: 0,
      minRating: 0.5,
      direction: Axis.horizontal,
      allowHalfRating: true,
      glow: false,
      unratedColor: AppColors.border,
      itemCount: 5,
      itemSize: 48,
      ratingWidget: RatingWidget(
        full: const Icon(
          Icons.star_rounded,
          color: Colors.amber,
        ),
        half: const Icon(
          Icons.star_half_rounded,
          color: Colors.amber,
        ),
        empty: const Icon(
          Icons.star_border_rounded,
          color: AppColors.border,
        ),
      ),
      onRatingUpdate: onChanged,
    );
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
