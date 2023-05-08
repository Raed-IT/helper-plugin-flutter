import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:helper_plugin_example/app/pages/pickimages/pick_image_controller.dart';

class PickImageScreen extends GetView<PickImageController> {
  const PickImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("pick image example "),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Text("multiple images ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp)),
          ),

          //you cane use button for picker

          // MaterialButton(
          //   onPressed: () {
          //     // controller.picker(isMultiFiles: true);
          //   },
          //   child: const Text("pick image "),
          // ),

          Padding(
            padding: EdgeInsets.all(20.sp),
            child: controller.buildPickerImagesWidget(
              imageCardUi: (img){
               return Image.file(img);
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Text("single  image picker  ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp)),
          ),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: controller.buildPickerImageWidget(),
          ),
        ],
      ),
    );
  }
}
