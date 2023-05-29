import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/helper.dart';

import '../../utilitis/media_model.dart';
import 'images_view_gallery.dart';

// ignore: must_be_immutable
class MultiImagePickerComponent extends StatelessWidget with ApiHelperMixin {
  RxList<File> images = RxList([]);
  void Function()? onPicker;
  void Function(RxList<File> images) syncImages;
  Color? pickerWidgetColor;
  int imageCount;
  Widget? Function(int imagesCount) imagePickerUi;
  Widget? Function(File image) imageCardUi;
  Widget? deleteIcon;
  List<MediaModel> imagesUrls = const [];

  MultiImagePickerComponent(
      {required this.images,
      required this.onPicker,
      required this.imagesUrls,
      required this.imageCount,
      required this.syncImages,
      required this.imagePickerUi,
      required this.imageCardUi,
      this.pickerWidgetColor,
      this.deleteIcon,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (imagesUrls.isEmpty) ? buildLocalFile() : buildNetworkImages();
  }

  Widget buildNetworkImages() {
    return Column(
      children: [
        Stack(
          children: [
            CachedNetworkImage(
              imageUrl: "${imagesUrls[0].url}",
              width: Get.width,
              height: 200.h,
            ),
            Container(
              color: Colors.black45,
              width: Get.width,
              height: 200.h,
              child: Row(
                children: [
                  Icon(Icons.image),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${imagesUrls.length}"),
                  )
                ],
              ),
            )
          ],
        ),
        if (imagesUrls.length < imageCount) buildLocalFile()
      ],
    );
  }

  Widget buildLocalFile() {
    return Obx(
      () => (images.isEmpty)
          ? GestureDetector(
              onTap: onPicker,
              child: imagePickerUi(imageCount) ??
                  DottedBorder(
                    color: pickerWidgetColor ?? Colors.black.withOpacity(0.7),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                      child: Container(
                        height: 150.h,
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 50.sp,
                              color: pickerWidgetColor ?? Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text(
                                  " انقر لرفع عدة صور  $imageCount  صورة ",
                                  style: TextStyle(
                                      color:
                                          pickerWidgetColor ?? Colors.black)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Text(
                        "الصور المختارة ${images.length}/${imageCount}",
                        style: TextStyle(
                            color: pickerWidgetColor ?? Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (images.length < imageCount)
                      MaterialButton(
                        onPressed: onPicker,
                        child: Text(
                          "اختر المزيد ",
                          style: TextStyle(
                              color: pickerWidgetColor ?? Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 150.h,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewGallery(
                                    images: images
                                        .map((element) => FileImage(element))
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                            child: imageCardUi(images[index]) ??
                                Card(
                                  shadowColor: Colors.black12,
                                  elevation: 3,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(0),
                                    ),
                                  ),
                                  child: Container(
                                    height: Get.height,
                                    width: 160.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(images[index]),
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                          GestureDetector(
                            onTap: () {
                              images.removeAt(index);
                              syncImages(images);
                            },
                            child: deleteIcon ??
                                Container(
                                  height: 25.sp,
                                  width: 25.sp,
                                  decoration: BoxDecoration(
                                    color: pickerWidgetColor ?? Colors.black26,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(02958)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      size: 15.sp,
                                      Icons.delete,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
