import 'package:get/get.dart';
import 'package:helper_plugin/helper.dart';

class PickImageController extends GetxController with ImagePickerMixin{
  @override
  void onInit() {
    imageCount=5;
    super.onInit();
  }
}