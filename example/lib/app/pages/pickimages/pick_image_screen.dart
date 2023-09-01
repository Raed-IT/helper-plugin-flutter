import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/utilitis/media_model.dart';
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: Text("multiple images ",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp)),
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
                imageCount: 3,
                onDeleteNetworkImage: (img) {
                  print(img.id);
                },
                context: context,
                imagesUrls: [
                  MediaModel(
                      "https://images.unsplash.com/photo-1631193079266-4af74b218c86?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=800&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY4NTM1Njk0OA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1900",
                      1),
                  MediaModel(
                      "https://images.unsplash.com/photo-1631193079266-4af74b218c86?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=800&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY4NTM1Njk0OA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1900",
                      1),
                  MediaModel(
                      "https://images.unsplash.com/photo-1631193079266-4af74b218c86?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=800&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY4NTM1Njk0OA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1900",
                      1)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: Text("single  image picker  ",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp)),
            ),
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: controller.buildPickerImagesWidget(
                  context: context, imageCount: 5),
            ),
            MaterialButton(
              onPressed: () async {
                await controller.getImages();
              },
              child: Text("get images"),
            )
          ],
        ),
      ),
    );
  }
}
