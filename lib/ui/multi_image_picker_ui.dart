import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MultiImagePickerComponent extends StatelessWidget {
  RxList<File> images = RxList([]);
  void Function()? onPicker;
  void Function(RxList<File> images) syncImages;
  Color? primaryColor;
  Color? secondaryColor;
  Color? elevationColor;
  int imageCount;

  MultiImagePickerComponent(
      {required this.images,
        required this.onPicker,
        this.elevationColor,
        this.secondaryColor,
        this.primaryColor,
        required this.imageCount,
        required this.syncImages,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => (images.isEmpty)
          ? GestureDetector(
        onTap: onPicker,
        child: DottedBorder(
          color: primaryColor ?? Colors.black.withOpacity(0.7),
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
                    color: secondaryColor ?? Colors.black26,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Text(" انقر لرفع عدة صور  $imageCount  صورة "),
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
                  "الصور المختارة ",
                  style: TextStyle(
                      color:
                      primaryColor ?? Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold),
                ),
              ),
              if (images.length < imageCount)
                MaterialButton(
                  onPressed: onPicker,
                  child: Text(
                    "اختر المزيد ",
                    style: TextStyle(
                        color: secondaryColor ?? Colors.black26,
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
                    Card(
                      shadowColor: elevationColor ?? Colors.black12,
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
                    GestureDetector(
                      onTap: () {
                        images.removeAt(index);
                        syncImages(images);
                      },
                      child: Container(
                        height: 25.sp,
                        width: 25.sp,
                        decoration: BoxDecoration(
                          color: secondaryColor ?? Colors.black26,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(02958)),
                        ),
                        child: Center(
                          child: Icon(
                            size: 15.sp,
                            Icons.delete,
                            color: primaryColor ??
                                Colors.black.withOpacity(0.7),
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
