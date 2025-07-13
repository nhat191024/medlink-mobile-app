import 'package:medlink/model/service_model.dart';
import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/doctor/controllers/settings/service_controller.dart';

import 'package:medlink/components/button/default.dart';
import 'package:medlink/components/field/text.dart';
import 'package:medlink/components/field/bottom_modal_select.dart';

class MyServiceScreen extends GetView<ServiceController> {
  const MyServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 45, 20, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                  ),
                ),
                const Spacer(),
                Text(
                  'my_services_title'.tr,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: AppFontStyleTextStrings.bold,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator(color: AppColors.primary600)),
              );
            }
            return buildContent(context);
          }),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];
            return GestureDetector(
              onTap: () {
                controller.setServiceData(service);
                Get.bottomSheet(_serviceModal(service, index), isScrollControlled: true);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary50,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  service.icon,
                                  width: 30,
                                  height: 30,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primary600,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppFontStyleTextStrings.bold,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        "${"price".tr} ${service.price} €",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppFontStyleTextStrings.regular,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                decoration: BoxDecoration(
                                  color: service.isActive ? AppColors.infoMain : AppColors.disable,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  service.isActive ? "active".tr : "disable".tr,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: AppFontStyleTextStrings.medium,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _serviceModal(ServiceModel services, int index) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          controller.clear();
          controller.clearServiceData();
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Text(
                  controller.serviceNameController.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: AppFontStyleTextStrings.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                // const SizedBox(height: 10),
                // const SizedBox(height: 20),
                // CustomTextField(
                //   labelText: 'Service name',
                //   hintText: 'name',
                //   errorText: '',
                //   isError: false.obs,
                //   obscureText: false.obs,
                //   controller: controller.serviceNameController,
                //   onChanged: (value) {},
                //   isRequire: true,
                //   backgroundColor: AppColors.white,
                // ),
                // const SizedBox(height: 20),
                // CustomTextField(
                //   labelText: 'Service description',
                //   hintText: 'description',
                //   errorText: '',
                //   isError: false.obs,
                //   obscureText: false.obs,
                //   controller: controller.serviceDescriptionController,
                //   onChanged: (value) {},
                //   isRequire: true,
                //   backgroundColor: AppColors.white,
                // ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: '${"price".tr} (€)',
                  hintText: 'amount'.tr,
                  errorText: "price_required".tr,
                  isError: controller.isServicePriceError,
                  obscureText: false.obs,
                  controller: controller.servicePriceController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.isServicePriceError.value = true;
                    } else {
                      controller.isServicePriceError.value = false;
                    }
                  },
                  backgroundColor: AppColors.white,
                  suffixText: 'EUR',
                ),
                const SizedBox(height: 20),
                CustomSelectWithBottomModal(
                  label: "duration".tr,
                  list: controller.serviceDurationList,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.isServiceDurationError.value = true;
                    } else {
                      controller.isServiceDurationError.value = false;
                      controller.serviceDuration.value = value;
                    }
                  },
                  isError: controller.isServiceDurationError,
                  errorText: 'duration_required'.tr,
                  hintText: "choose".tr,
                  defaultSelect: services.duration.toString(),
                  backgroundColor: AppColors.white,
                ),
                const SizedBox(height: 20),
                CustomSelectWithBottomModal(
                  label: "Buffer time",
                  list: controller.bufferTimeList,
                  onChanged: (value) {
                    controller.bufferTime.value = value;
                  },
                  isError: controller.isBufferTimeError,
                  errorText: 'buffer_time_required'.tr,
                  hintText: "choose".tr,
                  defaultSelect: services.bufferTime.toString(),
                  backgroundColor: AppColors.white,
                ),
                const SizedBox(height: 20),
                CustomSelectWithBottomModal(
                  label: "no_of_seats".tr,
                  list: controller.seatsList,
                  onChanged: (value) {
                    controller.seats.value = value;
                  },
                  isError: controller.isSeatsError,
                  errorText: 'seats_required'.tr,
                  hintText: "choose".tr,
                  defaultSelect: services.seat,
                  backgroundColor: AppColors.white,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Row(
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.toggleSwitch();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 40,
                            height: 25,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: controller.isServiceActive.value
                                  ? AppColors.primary600
                                  : AppColors.disable,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: controller.isServiceActive.value
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 20,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "work_availability".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: AppFontStyleTextStrings.regular,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                  child: CustomButtonDefault(
                    onTap: () {
                      controller.editService(services.id, index);
                    },
                    btnText: 'save_changes'.tr,
                    isDisabled: false,
                    bottomPadding: 0,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: const Offset(0, 45),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  controller.clear();
                  controller.clearServiceData();
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
