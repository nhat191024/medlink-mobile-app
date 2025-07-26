import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

import 'package:medlink/components/widget/grid_category.dart';

class SearchCategoryScreen extends GetView<SearchHeathCareController> {
  SearchCategoryScreen({super.key});

  final SearchHeathCareController controllers = Get.put(SearchHeathCareController());

  static const double _headerPaddingTop = 40.0;
  static const double _headerPaddingHorizontal = 20.0;
  static const double _headerPaddingBottom = 15.0;
  static const double _searchBarHeight = 50.0;
  static const double _searchBarBorderRadius = 50.0;
  static const double _searchBarBorderWidth = 0.5;
  static const double _searchIconSize = 15.0;
  static const double _titleFontSize = 18.0;
  static const double _sectionTitleFontSize = 14.0;
  static const double _spacingSmall = 10.0;
  static const double _spacingMedium = 15.0;
  static const double _spacingLarge = 20.0;
  static const double _gridSpacing = 6.0;
  static const int _gridCrossAxisCount = 2;
  static const double _gridAspectRatio = 1.0;
  static const int _categorySelectionDelaySeconds = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: buildSearchCategoryView(),
    );
  }

  Widget buildSearchCategoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildHeaderSection(), _buildCategoriesSection()],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        _headerPaddingHorizontal,
        _headerPaddingTop,
        _headerPaddingHorizontal,
        _headerPaddingBottom,
      ),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: _spacingSmall),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "what_are_you_looking_for".tr,
      style: const TextStyle(
        color: AppColors.primaryText,
        fontSize: _titleFontSize,
        fontFamily: AppFontStyleTextStrings.bold,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: _searchBarHeight,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(_searchBarBorderRadius),
        border: Border.all(
          color: controller.searchFocusNode.hasFocus
              ? AppColors.primaryText
              : AppColors.transparentColor,
          width: _searchBarBorderWidth,
        ),
      ),
      child: TextField(
        focusNode: controller.searchFocusNode,
        controller: controller.searchController,
        decoration: InputDecoration(
          prefixIcon: SvgPicture.asset(
            AppImages.searchIcon,
            height: _searchIconSize,
            width: _searchIconSize,
            fit: BoxFit.scaleDown,
          ),
          hintText: "search_by_name".tr,
          hintStyle: const TextStyle(color: AppColors.disable),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(_spacingLarge, _spacingLarge, _spacingLarge, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildSectionTitle(), _buildCategoriesGrid()],
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      "suggest_main".tr,
      style: const TextStyle(
        color: AppColors.primaryText,
        fontSize: _sectionTitleFontSize,
        fontFamily: AppFontStyleTextStrings.regular,
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Expanded(
      child: Obx(
        () => GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: _spacingMedium),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _gridCrossAxisCount,
            crossAxisSpacing: _gridSpacing,
            mainAxisSpacing: _gridSpacing,
            childAspectRatio: _gridAspectRatio,
          ),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) => _buildCategoryItem(index),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    final item = controller.categories[index];
    return Obx(
      () => GridCategory(
        onTap: () => _onCategoryTap(item),
        name: getCategoryName(item['name']),
        icon: item['image'],
        isSelected: controller.selectedCategory == item['name'],
        numberOfResults: item['result'],
      ),
    );
  }

  String getCategoryName(String name) {
    switch (name) {
      case "Doctors":
        return "doctors".tr;
      case "Hospitals":
        return "hospitals".tr;
      case "Pharmacy":
        return "pharmacies".tr;
      case "Ambulance":
        return "ambulances".tr;
      default:
        return name;
    }
  }

  void _onCategoryTap(Map<String, dynamic> item) {
    controller.fetchDoctor();
    controller.selectedCategory.value = item['name'];
    Future.delayed(Duration(seconds: _categorySelectionDelaySeconds), () {
      Get.toNamed(Routes.searchDoctorScreen);
    });
  }
}
