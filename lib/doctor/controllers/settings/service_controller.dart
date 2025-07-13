import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/model/service_model.dart';
import 'package:http/http.dart' as http;

class ServiceController extends GetxController {
  final token = StorageService.readData(key: LocalStorageKeys.token);
  RxBool isLoading = false.obs;

  final RxList<ServiceModel> services = <ServiceModel>[].obs;

  //service information
  final List<String> serviceDurationList = ['15 minutes', '30 minutes', '45 minutes', '1 hour'];
  final List<String> bufferTimeList = ['5 minutes', '10 minutes', '15 minutes', '20 minutes'];
  final List<String> seatsList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  late TextEditingController serviceNameController = TextEditingController();
  late TextEditingController servicePriceController = TextEditingController();
  late TextEditingController serviceDescriptionController = TextEditingController();
  var serviceDuration = ''.obs;
  var bufferTime = ''.obs;
  var seats = ''.obs;
  final RxBool isServiceActive = false.obs;

  RxBool isServicePriceError = false.obs;
  RxBool isServiceDurationError = false.obs;
  RxBool isBufferTimeError = false.obs;
  RxBool isSeatsError = false.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    var response = await get(
      Uri.parse('${Apis.api}services'),
      headers: {'Authorization': 'Bearer $token'},
    );

    var data = jsonDecode(response.body);
    var servicesData = data['services'] as List;
    for (var i = 0; i < servicesData.length; i++) {
      services.add(ServiceModel.fromJson(data['services'][i]));
    }

    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  bool validateService() {
    if (servicePriceController.text.isEmpty) {
      isServicePriceError.value = true;
      return false;
    } else if (serviceDuration.value.isEmpty) {
      isServiceDurationError.value = true;
      return false;
    } else if (bufferTime.value.isEmpty) {
      isBufferTimeError.value = true;
      return false;
    } else if (seats.value.isEmpty) {
      isSeatsError.value = true;
      return false;
    }
    return true;
  }

  Future<void> editService(int id, int index) async {
    if (!validateService()) return;
    clear();
    isLoading.value = true;

    var isActive = isServiceActive.value ? 1 : 0;

    final uri = Uri.parse('${Apis.api}services/edit');
    final response = http.MultipartRequest("POST", uri);
    response.headers['Authorization'] = 'Bearer $token';
    response.headers['Accept'] = 'application/json';
    response.headers['Content-Type'] = 'application/json';

    response.fields.addAll({
      'id': id.toString(),
      'price': servicePriceController.text.toString(),
      'duration': extractNumber(serviceDuration.value),
      'buffer_time': extractNumber(bufferTime.value),
      'seat': seats.value,
      'is_active': isActive.toString(),
    });

    var streamedResponse = await response.send();
    var responseBody = await streamedResponse.stream.bytesToString();
    var json = jsonDecode(responseBody);

    if (streamedResponse.statusCode == 200) {
      if (index != -1) updateService(index, id);
      Get.back();
      Get.snackbar(
        'Success',
        'Service saved successfully',
        colorText: AppColors.successMain,
        backgroundColor: AppColors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to save service',
        colorText: AppColors.errorMain,
        backgroundColor: AppColors.white,
      );
      debugPrint('Error: ${json['message']}');
    }
    isLoading.value = false;
  }

  // Future<void> delete(index, id) async {
  //   var response = await get(
  //     Uri.parse('${Apis.api}setting/delete_service/$id'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   var data = jsonDecode(response.body);

  //   if (response.statusCode == 200) {
  //     services.removeAt(index);
  //     Get.snackbar('Success', 'Service deleted successfully');
  //   } else {
  //     Get.snackbar('Error', data['message']);
  //   }
  // }

  // Future<void> addService() async {
  //   isLoading.value = true;

  //   var isActive = isServiceActive.value ? 1 : 0;

  //   var response = await post(
  //     Uri.parse('${Apis.api}setting/add_doctor_service'),
  //     headers: {'Authorization': 'Bearer $token'},
  //     body: {
  //       'icon': 'icon',
  //       'name': serviceNameController.text,
  //       'price': servicePriceController.text,
  //       'description': serviceDescriptionController.text,
  //       'duration': extractNumber(serviceDuration.value),
  //       'buffer_time': extractNumber(bufferTime.value),
  //       'seat': seats.value,
  //       'is_active': isActive.toString(),
  //     },
  //   );

  //   if (response.statusCode == 201) {
  //     services.add(ServiceModel.fromJson(jsonDecode(response.body)['service']));
  //     Get.back();
  //     Get.snackbar('Success', 'Service added successfully');
  //   } else {
  //     Get.snackbar('Error', 'Failed to add service');
  //   }
  //   isLoading.value = false;
  // }

  void toggleSwitch() {
    isServiceActive.value = !isServiceActive.value;
  }

  void updateService(int index, int id) {
    services[index] = ServiceModel(
      id: id,
      icon: services[index].icon,
      name: serviceNameController.text,
      description: serviceDescriptionController.text,
      price: int.parse(servicePriceController.text),
      duration: int.parse(extractNumber(serviceDuration.value)),
      bufferTime: int.parse(extractNumber(bufferTime.value)),
      seat: seats.value,
      isActive: isServiceActive.value,
    );
  }

  void setServiceData(ServiceModel service) {
    serviceNameController.text = service.name;
    serviceDescriptionController.text = service.description;
    servicePriceController.text = service.price.toString();
    serviceDuration.value = '${service.duration} minutes';
    bufferTime.value = '${service.bufferTime} minutes';
    seats.value = service.seat;
    isServiceActive.value = service.isActive;
  }

  void clearServiceData() {
    serviceNameController.clear();
    serviceDescriptionController.clear();
    servicePriceController.clear();
    serviceDuration.value = '';
    bufferTime.value = '';
    seats.value = '';
    isServiceActive.value = false;
  }

  String extractNumber(String input) {
    final RegExp regex = RegExp(r'\d+');
    final Match? match = regex.firstMatch(input);
    if (match != null) {
      return match.group(0)!;
    }
    return '';
  }

  void clear() {
    isServicePriceError.value = false;
    isServiceDurationError.value = false;
    isBufferTimeError.value = false;
    isSeatsError.value = false;
  }
}
