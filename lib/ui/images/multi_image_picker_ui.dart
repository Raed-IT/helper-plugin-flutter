import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/helper.dart';

import '../../utilitis/media_model.dart';
import 'componentes/privew_image.dart';
import 'images_view_gallery.dart';

// ignore: must_be_immutable
class MultiImagePickerComponent extends StatelessWidget with ApiHelperMixin {
  RxList<File> images = RxList([]);
  void Function(int imageCount) onPicker;
  void Function(RxList<File> images) syncImages;
  Color? pickerWidgetColor;
  int imageCount;
  Widget? Function(int imagesCount) imagePickerUi;
  Widget? Function(File image) imageCardUi;
  Widget? deleteIcon;
  List<MediaModel> imagesUrls = const [];
  BuildContext mainContext;
  BorderRadiusGeometry? borderRadiusNetworkCard;
  BoxFit? fitNetworkImage;
  double? heightNetworkImage;
  double? widthNetworkImage;
  Function(MediaModel img) onDeleteNetworkImage;
  bool isDeletableNetworkImage;

  MultiImagePickerComponent(
      {required this.images,
      required this.onDeleteNetworkImage,
      required this.mainContext,
      required this.onPicker,
      required this.imagesUrls,
      required this.imageCount,
      required this.syncImages,
      required this.imagePickerUi,
      required this.imageCardUi,
      this.pickerWidgetColor,
      this.deleteIcon,
      this.borderRadiusNetworkCard,
      this.widthNetworkImage,
      this.heightNetworkImage,
      this.fitNetworkImage,
      this.isDeletableNetworkImage = false,
      Key? key})
      : super(key: key) {
    if (imagesUrls.isNotEmpty && imageCount >= 0) {
      imageCount -= imagesUrls.length;
      print(imageCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (imagesUrls.isEmpty) ? buildLocalFile() : buildNetworkImages();
  }

  Widget buildNetworkImages() {
    print ("imagesUrls.length => ${imagesUrls.length}");
    print ("imageCount => $imageCount");
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            previewImage(
                deletable: isDeletableNetworkImage,
                context: mainContext,
                imagesUrls: imagesUrls,
                onDelete: (img) => onDeleteNetworkImage(img));
          },
          child: Stack(
            children: [
              CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadiusNetworkCard ??
                        BorderRadius.all(Radius.circular(20.sp)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: fitNetworkImage ?? BoxFit.cover,
                    ),
                  ),
                  height: heightNetworkImage ?? 200.h,
                  width: widthNetworkImage ?? Get.width,
                ),
                imageUrl: "${imagesUrls[0].url}",
                width: Get.width,
                height: 200.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: borderRadiusNetworkCard ??
                      BorderRadius.all(
                        Radius.circular(20.sp),
                      ),
                ),
                width: Get.width,
                height: 200.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 22.sp,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${imagesUrls.length}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        if (imagesUrls.length > imageCount && imageCount!=0)
          SizedBox(
            height: 20.h,
          ),
        if (imagesUrls.length > imageCount &&imageCount!=0) buildLocalFile()
      ],
    );
  }

  Widget buildLocalFile() {
    return Obx(
      () => (images.isEmpty)
          ? GestureDetector(
              onTap: () {
                onPicker(imageCount);
              },
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
                        " الصور المختارة ${images.length + imagesUrls.length} من ${imageCount + imagesUrls.length}",
                        style: TextStyle(
                            color: pickerWidgetColor ?? Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (images.length < imageCount)
                      MaterialButton(
                        onPressed: () => onPicker(imageCount),
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
