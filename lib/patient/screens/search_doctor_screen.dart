import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

import 'package:medlink/components/widget/search_screen/doctor_card.dart';
import 'package:medlink/components/widget/search_screen/doctor_detail.dart';

import 'package:medlink/model/work_schedule_model.dart';

class SearchDoctorScreen extends GetView<SearchHeathCareController> {
  const SearchDoctorScreen({super.key});

  // Constants for better maintainability
  static const double _searchPaddingTop = 40.0;
  static const double _searchPaddingHorizontal = 20.0;
  static const double _searchPaddingBottom = 15.0;
  static const double _searchBarHeight = 50.0;
  static const double _searchBarBorderRadius = 50.0;
  static const double _searchBarBorderWidth = 0.5;
  static const double _searchIconSize = 15.0;
  static const double _categoryHeight = 40.0;
  static const double _categorySpacing = 6.0;
  static const double _categoryIconSize = 18.0;
  static const double _categoryFontSize = 14.0;
  static const double _categoryBorderRadius = 20.0;
  static const double _titleFontSize = 18.0;
  static const double _backIconSize = 24.0;
  static const double _contentPadding = 20.0;
  static const double _listPaddingTop = 10.0;
  static const double _listPaddingBottom = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: buildSearchDoctorView(),
    );
  }

  Widget buildSearchDoctorView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildSearchSection(), _buildContentSection()],
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _searchPaddingHorizontal,
        _searchPaddingTop,
        _searchPaddingHorizontal,
        _searchPaddingBottom,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildSearchBar()]),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: _searchBarHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
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

  Widget _buildContentSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildCategoriesFilter(), _buildHeader(), _buildResultsList()],
      ),
    );
  }

  Widget _buildCategoriesFilter() {
    return Padding(
      padding: EdgeInsets.only(left: _contentPadding),
      child: SizedBox(
        height: _categoryHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (context, index) => _buildCategoryItem(index),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    final item = controller.categories[index];
    return Padding(
      padding: EdgeInsets.only(right: _categorySpacing, left: index == 0 ? 0 : 0),
      child: Obx(
        () => ElevatedButton.icon(
          onPressed: () => _onCategorySelected(item['name']),
          icon: _buildCategoryIcon(item),
          label: _buildCategoryLabel(item['name']),
          style: _getCategoryButtonStyle(item['name']),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(Map<String, dynamic> item) {
    return SvgPicture.asset(
      item['image'],
      height: _categoryIconSize,
      width: _categoryIconSize,
      colorFilter: ColorFilter.mode(
        controller.selectedCategory.value == item['name']
            ? AppColors.primary600
            : AppColors.primaryText,
        BlendMode.srcIn,
      ),
    );
  }

  Widget _buildCategoryLabel(String name) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: _categoryFontSize,
        fontFamily: AppFontStyleTextStrings.medium,
      ),
    );
  }

  ButtonStyle _getCategoryButtonStyle(String categoryName) {
    final isSelected = controller.selectedCategory.value == categoryName;
    return ElevatedButton.styleFrom(
      shadowColor: AppColors.transparentColor,
      backgroundColor: AppColors.white,
      foregroundColor: isSelected ? AppColors.primary600 : AppColors.primaryText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_categoryBorderRadius),
        side: BorderSide(color: isSelected ? AppColors.primary600 : AppColors.transparentColor),
      ),
    );
  }

  void _onCategorySelected(String categoryName) {
    controller.selectedCategory.value = categoryName;
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_contentPadding, _contentPadding, _contentPadding, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildHeaderTitle(), const Spacer(), _buildBackButton()],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Obx(() {
      final selectedCategory = controller.selectedCategory.value;
      String titleKey;

      if (selectedCategory.contains("Doctors")) {
        titleKey = "browse_doctors_nearby";
      } else if (selectedCategory.contains("Hospitals")) {
        titleKey = "browse_hospitals_nearby";
      } else if (selectedCategory.contains("Pharmacy")) {
        titleKey = "browse_pharmacy_nearby";
      } else if (selectedCategory.contains("Ambulance")) {
        titleKey = "emergency_lines";
      } else {
        titleKey = "browse_doctors_nearby"; // default
      }

      return Text(
        titleKey.tr,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: _titleFontSize,
          fontFamily: AppFontStyleTextStrings.bold,
        ),
      );
    });
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: SvgPicture.asset(AppImages.inside, height: _backIconSize, width: _backIconSize),
    );
  }

  Widget _buildResultsList() {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, _listPaddingTop, 0, _listPaddingBottom),
          itemCount: _getItemCount(),
          itemBuilder: (context, index) => _buildListItem(context, index),
        ),
      ),
    );
  }

  int _getItemCount() {
    final selectedCategory = controller.selectedCategory.value;

    if (selectedCategory == "Doctors") {
      return controller.doctorList.length + (controller.isDoctorLoading.value ? 1 : 0);
    } else if (selectedCategory == "Hospitals") {
      return controller.hospital.length;
    } else if (selectedCategory == "Pharmacy") {
      return controller.pharmacy.length;
    } else {
      return controller.ambulance.length;
    }
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (controller.isDoctorLoading.value && index == controller.doctorList.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: const Center(child: CircularProgressIndicator(color: AppColors.primary600)),
      );
    }

    final selectedCategory = controller.selectedCategory.value;

    switch (selectedCategory) {
      case "Doctors":
        return _buildDoctorItem(context, index);
      case "Hospitals":
        return _buildHospitalItem(index);
      case "Pharmacy":
        return _buildPharmacyItem(index);
      case "Ambulance":
        return _buildAmbulanceItem(index);
      default:
        return Container();
    }
  }

  Widget _buildDoctorItem(BuildContext context, int index) {
    final doctor = controller.doctorList[index];
    return GestureDetector(
      onTap: () => _navigateToDoctorDetail(context, doctor, index),
      // onTap: () {},
      child: DoctorCard(
        index: index,
        services: doctor.services ?? [],
        workSchedule: doctor.workSchedule ?? WorkScheduleModel(),
        controller: controller,
      ),
    );
  }

  Widget _buildHospitalItem(int index) {
    // TODO: Implement hospital card
    // final hospital = controller.hospital[index];
    // return HospitalAndPharmacyCard(
    //   avatar: hospital.avatar,
    //   name: hospital.name,
    //   address: hospital.address,
    //   rating: hospital.rating.toDouble(),
    //   isAvailable: hospital.isAvailable,
    //   isFavorite: hospital.isFavorite,
    // );
    return Container(); // Placeholder
  }

  Widget _buildPharmacyItem(int index) {
    // TODO: Implement pharmacy card
    // final pharmacy = controller.pharmacy[index];
    // return HospitalAndPharmacyCard(
    //   avatar: pharmacy.avatar,
    //   name: pharmacy.name,
    //   address: pharmacy.address,
    //   rating: pharmacy.rating.toDouble(),
    //   isAvailable: pharmacy.isAvailable,
    //   isFavorite: pharmacy.isFavorite,
    // );
    return Container(); // Placeholder
  }

  Widget _buildAmbulanceItem(int index) {
    // TODO: Implement ambulance card
    // final ambulance = controller.ambulance[index];
    // return AmbulanceCard(
    //   name: ambulance.name,
    //   address: ambulance.address,
    //   phone: ambulance.phone,
    // );
    return Container(); // Placeholder
  }

  void _navigateToDoctorDetail(BuildContext context, doctor, index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorDetail(
          index: index,
          avatar: doctor.avatar,
          fullName: doctor.name,
          speciality: doctor.specialty,
          introduce: doctor.introduce,
          city: doctor.location,
          rating: doctor.rating.toString(),
          totalRate: doctor.totalRate,
          isAvailable: doctor.isAvailable,
          languages: doctor.languages,
          services: doctor.services,
          latitude: doctor.latitude,
          longitude: doctor.longitude,
          testimonials: doctor.testimonials,
          topReviews: doctor.topReviews,
          timeSlots: doctor.workSchedule,
        ),
      ),
    );
  }
}
