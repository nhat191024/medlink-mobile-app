import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/controllers/my_appointments_controller.dart';

import 'package:medlink/patient/screens/my_appointment/history_appointments_screen.dart';
import 'package:medlink/patient/screens/my_appointment/upcoming_appointments_screen.dart';

class PatientMyAppointmentsScreen extends GetView<PatientMyAppointmentsControllers> {
  final PatientMyAppointmentsControllers controllers = Get.put(PatientMyAppointmentsControllers());

  PatientMyAppointmentsScreen({super.key}) {
    controller.searchController.addListener(() {
      controller.appointmentFilter(controller.searchController.text);
    });

    controller.patientMyAppointmentsTabController.addListener(() {
      controller.appointmentFilter(controller.searchController.text);
    });

    controller.searchFocusNode.addListener(() {
      if (controller.searchFocusNode.hasFocus) {
        controller.showSuggestions.value = true;
      } else {
        Future.delayed(const Duration(milliseconds: 200), () {
          controller.showSuggestions.value = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: const ClassicHeader(),
        onRefresh: controller.onRefresh,
        onLoading: controller.onLoadMore,
        child: Stack(
          children: [
            Column(children: [_buildHeader(), _buildTabBarView()]),
            _buildSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        children: [
          Obx(() => controller.isSearching.value ? _buildSearchBar() : _buildTitleBar()),
          _buildTabBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: TextField(
              focusNode: controller.searchFocusNode,
              controller: controller.searchController,
              decoration: InputDecoration(
                prefixIcon: SvgPicture.asset(
                  AppImages.searchIcon,
                  height: 15,
                  width: 15,
                  fit: BoxFit.scaleDown,
                ),
                suffixIcon: Obx(() {
                  return controller.isFilterLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary600,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
                hintText: "search_2".tr,
                hintStyle: const TextStyle(color: AppColors.secondaryText),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildCloseButton() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          controller.isSearching.value = false;
          controller.clearSearch();
        },
        child: const Icon(Icons.close, color: Colors.black, size: 20),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'my_appointment'.tr,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: AppFontStyleTextStrings.bold,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => controller.isSearching.value = true,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(50),
            ),
            child: SvgPicture.asset(AppImages.searchIcon),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: controller.patientMyAppointmentsTabController,
      labelColor: AppColors.primary600,
      unselectedLabelColor: Colors.black,
      labelStyle: const TextStyle(
        fontFamily: AppFontStyleTextStrings.bold,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: AppFontStyleTextStrings.regular,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      indicatorColor: AppColors.primary600,
      indicatorWeight: 2,
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      tabs: [
        Obx(() => Tab(text: '${"Upcoming".tr} (${controller.upcomingQuantity.value})')),
        Obx(() => Tab(text: '${"History".tr} (${controller.historyQuantity.value})')),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TabBarView(
            controller: controller.patientMyAppointmentsTabController,
            children: [PatientUpcomingAppointmentsScreen(), PatientHistoryAppointmentsScreen()],
          ),
        );
      }),
    );
  }

  Widget _buildSuggestions() {
    return Obx(() {
      if (controller.isSearching.value &&
          controller.suggestions.isNotEmpty &&
          controller.showSuggestions.value &&
          !controller.isFilterLoading.value) {
        return Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: controller.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = controller.suggestions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(suggestion.doctorName),
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppFontStyleTextStrings.regular,
                    fontSize: 16,
                  ),
                  onTap: () {
                    controller.searchController.text = suggestion.doctorName;
                    controller.appointmentFilter(suggestion.doctorName);
                    controller.showSuggestions.value = false;
                    controller.suggestions.clear();
                  },
                );
              },
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
