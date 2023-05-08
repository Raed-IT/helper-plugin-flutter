import 'package:get/get.dart';
import 'package:helper_plugin_example/app/pages/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
