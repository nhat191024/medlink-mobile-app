import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/messages_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(() => MessagesController());
  }
}
