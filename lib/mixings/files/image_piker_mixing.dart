import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:helper_plugin/utilitis/media_model.dart';

import '../../ui/images/multi_image_picker_ui.dart';
import '../../ui/images/single_image_picker_ui.dart';

mixin ImagePickerMixin {
  RxList<File> images = RxList([]);
  Rxn<File> image = Rxn();
  int imageCount = 3;

  bool get isEmptyImages => images.isEmpty;

  bool get isEmptyImage => image.value == null;

  Future<dio.FormData> getImage({String key = "image"}) async {
    dio.FormData formData = dio.FormData.fromMap({
      key: await dio.MultipartFile.fromFile(
          await compressFile(
            file: image.value!,
          ).then((value) => value!.path),
          filename: image.value!.path.split('/').last),
    });
    return formData;
  }

  Future<List<MapEntry<String, dio.MultipartFile>>> getImages(
      {String key = "images"}) async {
    List<MapEntry<String, dio.MultipartFile>> imagesFiles = [];
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        imagesFiles.add(MapEntry(
          "$key[$i]",
          await dio.MultipartFile.fromFile(
              await compressFile(
                file: images[i],
              ).then((value) => value!.path),
              filename: images[i].path.split('/').last),
        ));
      }
    }
    return imagesFiles;
  }

  Future<void> picker({bool isMultiFiles = true}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: isMultiFiles, type: FileType.image);
    if (result != null) {
      if (isMultiFiles) {
        //take only  required item fro compete images list length to imageCount
        List<PlatformFile> pikerImages =
            result.files.take(imageCount - images.length).toList();
        if (images.isEmpty) {
          for (PlatformFile img in pikerImages) {
            images.add(File("${img.path}"));
          }
        } else {
          for (PlatformFile imgP in pikerImages) {
            bool addImage = true;
            for (File imgFile in images.toList()) {
              if (imgP.path!.split("-").last == imgFile.path.split("-").last) {
                addImage = false;
              }
            }
            if (addImage) {
              images.add(
                File("${imgP.path}"),
              );
            } else {
              if (pikerImages.length > 1) {
                Fluttertoast.showToast(
                    msg: " احد الصور موجوده بالفعل ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0.sp);
              } else {
                Fluttertoast.showToast(
                    msg: "الصورة موجوده بالفعل ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0.sp);
              }
            }
          }
        }
      } else {
        image.value = File(result.files[0].path!);
      }
    }
  }

  Future<File?> compressFile({
    required File file,
  }) async {
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 30, percentage: 80);
    return compressedFile;
  }

  //syncImages todo sync image/s from ui to controller
  Widget buildPickerImagesWidget({
    required BuildContext context,
    List<MediaModel> imagesUrls = const [],
    Widget? Function(int imagesCount)? imagePickerUi,
    Widget? Function(File image)? imageCardUi,
    Widget? deleteIcon,
    Color? pickerWidgetColor,
  }) {
    return MultiImagePickerComponent(
      mainContext: context,
      imagesUrls: imagesUrls,
      pickerWidgetColor: pickerWidgetColor,
      images: images,
      deleteIcon: deleteIcon,
      imageCount: imageCount,
      syncImages: (imgs) {
        images = imgs;
      },
      onPicker: () => picker(),
      imagePickerUi: imagePickerUi ?? (imagesCount) => null,
      imageCardUi: imageCardUi ?? (File image) => null,
    );
  }

  Widget buildPickerImageWidget(
      {Widget? imagePickerUi,
      Widget? Function(File img)? imageViewUi,
      Widget? deleteIcon}) {
    return SingleImagePickerComponent(
      imagePickerUi: imagePickerUi,
      imageViewUi: imageViewUi ??
          (img) {
            //return null widget
            return null;
          },
      syncImage: (image) {
        image = image;
      },
      image: image,
      onPicker: () => picker(isMultiFiles: false),
      deleteIcon: deleteIcon,
    );
  }

  void restImages() {
    images.value = [];
  }

  void restImage() {
    image.value = null;
  }
}
