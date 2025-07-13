import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/doctor/controllers/my_appointments_controller.dart';

import 'package:medlink/doctor/screens/my_appointments/new_appointments_screen.dart';
import 'package:medlink/doctor/screens/my_appointments/upcoming_appointments_screen.dart';
import 'package:medlink/doctor/screens/my_appointments/history_appointments_screen.dart';

class DoctorMyAppointmentsScreen extends GetView<DoctorMyAppointmentsControllers> {
  final DoctorMyAppointmentsControllers myAppointmentsControllers = Get.put(
    DoctorMyAppointmentsControllers(),
  );

  DoctorMyAppointmentsScreen({super.key}) {
    _initializeListeners();
  }

  void _initializeListeners() {
    controller.searchController.addListener(() {
      controller.appointmentFilter(controller.searchController.text);
    });

    controller.tabController.addListener(() {
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
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              AppointmentTabContent(controller: myAppointmentsControllers),
            ],
          ),
          AppointmentSuggestions(controller: controller),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        children: [
          AppointmentSearchBar(controller: controller),
          AppointmentTabBar(controller: myAppointmentsControllers),
        ],
      ),
    );
  }
}

class AppointmentSearchBar extends StatelessWidget {
  final DoctorMyAppointmentsControllers controller;

  const AppointmentSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isSearching.value ? _buildSearchField() : _buildHeaderWithSearchButton();
    });
  }

  Widget _buildSearchField() {
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
                hintText: "search_2".tr,
                hintStyle: const TextStyle(color: AppColors.secondaryText),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
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
              controller.searchController.clear();
            },
            child: const Icon(Icons.close, color: Colors.black, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderWithSearchButton() {
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
          onTap: () {
            controller.isSearching.value = true;
          },
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
}

class AppointmentTabBar extends StatelessWidget {
  final DoctorMyAppointmentsControllers controller;

  const AppointmentTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller.tabController,
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
        Obx(() => Tab(text: '${"new".tr} (${controller.newQuantity.value})')),
        Obx(() => Tab(text: '${"Upcoming".tr} (${controller.upcomingQuantity.value})')),
        Obx(() => Tab(text: '${"History".tr} (${controller.historyQuantity.value})')),
      ],
    );
  }
}

class AppointmentSuggestions extends StatelessWidget {
  final DoctorMyAppointmentsControllers controller;

  const AppointmentSuggestions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isSearching.value &&
          controller.suggestions.isNotEmpty &&
          controller.showSuggestions.value) {
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
                  title: Text(suggestion.patientName),
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppFontStyleTextStrings.regular,
                    fontSize: 16,
                  ),
                  onTap: () {
                    controller.searchController.text = suggestion.patientName;
                    controller.appointmentFilter(suggestion.patientName);
                    controller.showSuggestions.value = false;
                    controller.suggestions.clear();
                  },
                );
              },
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}

class AppointmentTabContent extends StatelessWidget {
  final DoctorMyAppointmentsControllers controller;

  const AppointmentTabContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TabBarView(
              controller: controller.tabController,
              children: [
                DoctorNewAppointmentsScreen(),
                UpcomingAppointmentsScreen(),
                HistoryAppointmentsScreen(),
              ],
            ),
          );
        }
      }),
    );
  }
}
