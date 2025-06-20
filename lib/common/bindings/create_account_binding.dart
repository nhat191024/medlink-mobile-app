import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';

class CreateAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAccountController>(
      () => CreateAccountController(),
    );
  }
}
