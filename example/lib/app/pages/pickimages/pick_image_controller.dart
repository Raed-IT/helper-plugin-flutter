import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/helper.dart';

class PickImageController extends GetxController with ImagePickerMixin {
  @override
  void onInit() {
    imageCount = 5;
    super.onInit();
  }

  Future<void> getImagesForApi() async {
    // if use multi images picker use get imageS
    // await getImages();

    //  if use single image picjer use getImage ();
    // await getImage();

    //usage for Dio only
    // dio.FormData data = dio.FormData.fromMap({
    //   data her .......
    // });
    // data.files.addAll(await getImages());
  }
}
