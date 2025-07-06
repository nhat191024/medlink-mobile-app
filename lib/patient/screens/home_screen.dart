import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/controllers/home_controller.dart';
import 'package:medlink/components/button/plus.dart';
import 'package:medlink/components/field/search.dart';

class PatientHomeScreen extends GetView<PatientHomeController> {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return _buildErrorView();
          }

          return SingleChildScrollView(child: Column(children: [_buildHeader(), _buildContent()]));
        }),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(controller.errorMessage.value),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: controller.refreshData, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildUserAvatar(),
          const SizedBox(width: 16),
          Expanded(child: _buildUserInfo()),
          _buildNotificationIcon(),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Stack(
      children: [
        Obx(
          () => Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              controller.avatar.value,
              fit: controller.checkIfDefaultAvatar(controller.avatar.value)
                  ? BoxFit.scaleDown
                  : BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(color: AppColors.primary600, shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              onPressed: () => Get.toNamed(Routes.profileScreen),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.userName.value,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 16,
              fontFamily: AppFontStyleTextStrings.bold,
            ),
          ),
          Text(
            controller.location.value,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.notificationScreen),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        padding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(AppImages.bell),
            Obx(
              () => controller.isHaveNotificationUnread.value
                  ? const Positioned(
                      top: 4,
                      right: 0,
                      child: CircleAvatar(backgroundColor: AppColors.errorMain, radius: 4),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchBar(),
          _buildMenuItems(),
          _buildEventsSection(),
          _buildFavoriteDoctorsSection(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: searchDoctor,
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(50)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                AppImages.searchIcon,
                height: 32,
                width: 32,
                fit: BoxFit.scaleDown,
              ),
            ),
            const Text("Search by name", style: TextStyle(color: AppColors.disable, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildMenuItem(AppImages.faceMark, "Doctors"),
          buildMenuItem(AppImages.firstAid, "Hospital"),
          buildMenuItem(AppImages.firstAidKit, "Pharmacy", color: AppColors.primary600),
          buildMenuItem(AppImages.heartBeat, "Ambulance"),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    return Column(
      children: [_buildSectionHeader("Event", 4), _buildEventCard(), const SizedBox(height: 30)],
    );
  }

  Widget _buildFavoriteDoctorsSection() {
    return Column(children: [_buildSectionHeader("Favorite doctors", 4), _buildDoctorCards()]);
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$title ",
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.bold,
                ),
              ),
              TextSpan(
                text: "($count)",
                style: const TextStyle(
                  color: AppColors.disable,
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.regular,
                ),
              ),
            ],
          ),
        ),
        const TextButton(
          onPressed: null,
          child: Text(
            'See all',
            style: TextStyle(
              color: AppColors.primary600,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard() {
    return Center(
      child: SizedBox(
        width: Get.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main event card
            _buildMainEventCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainEventCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary600,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.navigate_before, size: 22, color: Colors.white),
          Expanded(child: _buildEventContent()),
          const Icon(Icons.navigate_next, size: 22, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildEventContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildDoctorInfo(), _buildAppointmentDetails()],
    );
  }

  Widget _buildDoctorInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 24, backgroundImage: AssetImage(AppImages.demoAvt)),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Dr. Esther Howard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: AppFontStyleTextStrings.medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Podiatrist",
                    style: TextStyle(fontSize: 12, color: AppColors.white.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  "100 €",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "at Office",
                style: TextStyle(fontSize: 12, color: AppColors.white.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          _buildDateTimeRow(),
          const SizedBox(height: 8),
          const Text(
            "- 4 hours left -",
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
              color: AppColors.primary600,
              fontStyle: FontStyle.italic,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: SvgPicture.asset(
              AppImages.clock2,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: const Text("Opening"),
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 14),
              backgroundColor: AppColors.successMain,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateTimeColumn("Date", AppImages.calendarIcon, "Fri, 30 Aug 2024"),
        const SizedBox(height: 30, child: VerticalDivider(color: AppColors.border, thickness: 1)),
        _buildDateTimeColumn("Time", AppImages.clock3, "10:00 AM - 12:00 PM"),
      ],
    );
  }

  Widget _buildDateTimeColumn(String label, String icon, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: AppFontStyleTextStrings.regular,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFontStyleTextStrings.medium,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCards() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildDoctorCard(), _buildDoctorCard()],
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildDoctorCardHeader(), _buildDoctorCardFooter()],
      ),
    );
  }

  Widget _buildDoctorCardHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cartilaginologist',
            style: TextStyle(
              fontSize: 12,
              fontFamily: AppFontStyleTextStrings.regular,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Dr. Esther Howard',
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 22),
                SizedBox(width: 4),
                Text('4.5', style: TextStyle(fontSize: 12, color: AppColors.primaryText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCardFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primary600,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              '\$50',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(AppImages.doctor2, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(String icon, String title, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset(
            icon,
            fit: BoxFit.contain,
            width: 38,
            colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 13,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
      ],
    );
  }

  Future searchDoctor() {
    return Get.bottomSheet(
      Stack(clipBehavior: Clip.none, children: [_buildSearchBottomSheet(), _buildCloseButton()]),
      isScrollControlled: true,
    );
  }

  Widget _buildSearchBottomSheet() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchTextField(
              controller: controller.searchController,
              color: AppColors.white,
              hintText: "Search by name",
              onSearch: (String query) {},
            ),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [_buildSearchHeader(), ...List.generate(5, (index) => _buildSearchResultCard())],
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "84 results found nearby",
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 14,
              fontFamily: AppFontStyleTextStrings.regular,
            ),
          ),
          Row(
            children: [
              SvgPicture.asset(
                AppImages.mapPinLine,
                height: 20,
                width: 20,
                colorFilter: const ColorFilter.mode(AppColors.primaryText, BlendMode.srcIn),
              ),
              const Text(
                "Paris, France",
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14,
                  fontFamily: AppFontStyleTextStrings.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(children: [_buildSearchResultHeader(), _buildSearchResultDetails()]),
    );
  }

  Widget _buildSearchResultHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            CircleAvatar(radius: 24, backgroundImage: AssetImage(AppImages.demoAvt)),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. Esther Howard",
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontFamily: AppFontStyleTextStrings.medium,
                  ),
                ),
                SizedBox(height: 4),
                Text("Podiatrist", style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.15),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 22),
              SizedBox(width: 4),
              Text('4.5', style: TextStyle(fontSize: 12, color: AppColors.primaryText)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultDetails() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: [_buildSearchResultInfo(), _buildSearchResultActions()]),
    );
  }

  Widget _buildSearchResultInfo() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location", style: TextStyle(fontSize: 14, color: AppColors.secondaryText)),
            SizedBox(height: 5),
            Text("Paris", style: TextStyle(fontSize: 14, color: AppColors.primaryText)),
          ],
        ),
        SizedBox(height: 30, child: VerticalDivider(color: AppColors.border, thickness: 1)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price from", style: TextStyle(fontSize: 14, color: AppColors.secondaryText)),
            SizedBox(height: 5),
            Text("\$50", style: TextStyle(fontSize: 14, color: AppColors.primaryText)),
          ],
        ),
        SizedBox(height: 30, child: VerticalDivider(color: AppColors.border, thickness: 1)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Schedule", style: TextStyle(fontSize: 14, color: AppColors.secondaryText)),
            SizedBox(height: 5),
            Text("Available", style: TextStyle(fontSize: 14, color: AppColors.successMain)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchResultActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButtonPlus(
          onTap: () {},
          btnText: 'Book appointment',
          leftPadding: 0,
          rightPadding: 0,
          bottomPadding: 10,
          width: 240,
          svgImage: AppImages.calendarIcon,
          isDisabled: false,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: SvgPicture.asset(AppImages.heart),
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        offset: const Offset(0, 45),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
