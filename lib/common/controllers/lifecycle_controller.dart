import 'package:medlink/utils/app_imports.dart';

class LifecycleController extends GetxController with WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        // The application is inactive (moving to the background or an incoming call)
        break;
      case AppLifecycleState.paused:
        // The application is paused (running in the background)
        break;
      case AppLifecycleState.resumed:
        // The application is resumed (returning to the foreground)
        break;
      case AppLifecycleState.detached:
        // The application is detached from the app manager
        break;
      case AppLifecycleState.hidden:
        // The application is hidden
        break;
    }
  }
}
