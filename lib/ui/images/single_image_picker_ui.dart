import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SingleImagePickerComponent extends StatelessWidget {
  Rxn<File?> image = Rxn();
  void Function()? onPicker;
  void Function(Rxn<File?> image) syncImage;
  Widget? imagePickerUi;
  Widget? deleteIcon;
  Widget? Function(File image) imageViewUi;

  SingleImagePickerComponent(
      {required this.image,
      required this.onPicker,
      required this.syncImage,
      required this.imagePickerUi,
      required this.imageViewUi,
      required this.deleteIcon,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (image.value == null)
          ? GestureDetector(
              onTap: onPicker,
              child: imagePickerUi ??
                  DottedBorder(
                    // color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
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
                              // color: AppColors.ORANG_APP_COLOR.withOpacity(.5),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text(" انقر لاختيار صورة  "),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            )
          : Stack(
              children: [
                imageViewUi (image.value!) ??
                    Container(
                      padding: EdgeInsets.all(6.sp),
                      height: 150.h,
                      width: Get.width,
                      child: Card(
                        elevation: 4,
                        child: Image.file(image.value!),
                      ),
                    ),
                GestureDetector(
                  onTap: () => image.value = null,
                  child: deleteIcon ??
                      Padding(
                        padding: EdgeInsets.all(18.sp),
                        child: Icon(Icons.delete),
                      ),
                ),
              ],
            ),
    );
  }
}
