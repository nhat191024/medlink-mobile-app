import 'package:medlink/utils/app_imports.dart';

class CustomSearchScreenAppBar extends StatelessWidget {
  final String title;
  final String title1;
  final TextEditingController textController;
  final Animation<Color> valueColor;
  final Function(String) onSubmitted;
  final VoidCallback onPressed;
  final VoidCallback? onPressed1;
  final bool? isBackArrow;

  const CustomSearchScreenAppBar({
    super.key,
    required this.title,
    required this.title1,
    required this.textController,
    required this.valueColor,
    required this.onSubmitted,
    required this.onPressed,
    this.isBackArrow,
    this.onPressed1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            gradient: LinearGradient(
              colors: [AppColors.color1, AppColors.color2],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          height: 125 + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 15),
                    (isBackArrow ?? false)
                        ? InkWell(
                            onTap: onPressed1,
                            child: Image.asset(AppImages.backIcon, height: 25, width: 22),
                          )
                        : const SizedBox(),
                    SizedBox(width: (isBackArrow ?? false) ? 10 : 0),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: AppFontStyleTextStrings.regular,
                        color: AppColors.WHITE,
                      ),
                    ),
                    AppTextWidgets.mediumText(text: title1, color: AppColors.WHITE, size: 25),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.WHITE,
                        ),
                        child: TextField(
                          controller: textController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.WHITE),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'search_doctor_name'.tr,
                            hintStyle: TextStyle(
                              fontFamily: AppFontStyleTextStrings.regular,
                              color: AppColors.LIGHT_GREY_TEXT,
                              fontSize: 13,
                            ),
                            suffixIcon: SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    valueColor: valueColor,
                                  ),
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.WHITE),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.WHITE),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppColors.WHITE),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onSubmitted: onSubmitted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: onPressed,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.WHITE,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(child: Image.asset(AppImages.searchIcon)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
