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
  PhoneNumberTextFieldState createState() => PhoneNumberTextFieldState();
}

class PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
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
                Text(widget.selectedCountry.flag, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 10),
                Text(
                  widget.selectedCountry.dialCode,
                  style: const TextStyle(fontSize: 16, fontFamily: AppFontStyleTextStrings.regular),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_drop_down, size: 30),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => Container(
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
                      : AppColors.border,
                ),
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
            ),
          ),
        ),
      ],
    );
  }
}
