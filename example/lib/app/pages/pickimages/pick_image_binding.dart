import 'package:get/get.dart';
import 'package:helper_plugin_example/app/pages/pickimages/pick_image_controller.dart';

class PickImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PickImageController());
  }
}
