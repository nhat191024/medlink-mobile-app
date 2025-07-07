import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';

class SearchDoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchHeathCareController>(() => SearchHeathCareController());
  }
}
