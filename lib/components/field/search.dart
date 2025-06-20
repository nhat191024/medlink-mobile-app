import 'package:medlink/utils/app_imports.dart';

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
        border: Border.all(color: _isFocused ? Colors.black : Colors.transparent, width: 1),
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
                  icon: const Icon(Icons.cancel, size: 30, color: AppColors.secondaryText),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onSearch('');
                    setState(() {});
                  },
                )
              : const SizedBox.shrink(),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColors.secondaryText),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}
