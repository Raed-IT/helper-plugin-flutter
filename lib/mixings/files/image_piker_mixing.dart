import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:helper_plugin/utilitis/helper_functions.dart';
import 'package:helper_plugin/utilitis/media_model.dart';

import '../../ui/images/multi_image_picker_ui.dart';
import '../../ui/images/single_image_picker_ui.dart';

mixin ImagePickerMixin {
  RxList<File> images = RxList([]);
  Rxn<File> image = Rxn();

  bool get isEmptyImages => images.isEmpty;

  bool get isEmptyImage => image.value == null;

  Future<MapEntry<String, dio.MultipartFile>> getImage(
      {String key = "image"}) async {
    return MapEntry(
      key,
      await dio.MultipartFile.fromFile(
          await compressFile(
            file: image.value!,
          ).then((value) => value!.path),
          filename: image.value!.path.split('/').last),
    );
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

  Future<void> picker({
    bool isMultiFiles = true,
    required int imageCount,
  }) async {
    // if (realImageCount != null) {
    //   //set image count if using image url and decrement image count from main image count
    //   imageCount = realImageCount;
    // }
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: isMultiFiles, type: FileType.image);
    if (result != null) {
      if (isMultiFiles) {
        //take only  required item fro compete images list length to imageCount
        List<PlatformFile> pikerImages = result.files.take(imageCount).toList();
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
    print ("dfdfdfdfdf");
    String path = file.path;
    List<String> listInputPath = path.split("/");
    List<String> listOutputPath =
        listInputPath.sublist(0, listInputPath.length - 1);
    listOutputPath.add("conpresser_${listInputPath.last}");

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      listOutputPath.join("/"),
      quality: 30,
    );
    print(
        "befor compress${file.lengthSync()}   path  ==>  ${file.path} ");
    print(
        "after compress ${await result?.length()}    path==>${listOutputPath.join("/")}");
    return result?.path != null ? File(result!.path) : file;
    // File compressedFile = await FlutterNativeImage.compressImage(file.path,
    //     quality: 30, percentage: 80);
    // return compressedFile;
    // return compressedFile?.path != null ? File(compressedFile!.path) : file;
  }

  //syncImages todo sync image/s from ui to controller
  Widget buildPickerImagesWidget({
    required BuildContext context,
    required int imageCount,
    List<MediaModel> imagesUrls = const [],
    Widget? Function(int imagesCount)? imagePickerUi,
    Widget? Function(File image)? imageCardUi,
    Widget? deleteIcon,
    Color? pickerWidgetColor,
    Function(MediaModel img)? onDeleteNetworkImage,
    BorderRadiusGeometry? borderRadiusNetworkCard,
    BoxFit? fitNetworkImage,
    double? heightNetworkImage,
    double? widthNetworkImage,
    bool isDeletableNetworkImage = false,
  }) {
    return MultiImagePickerComponent(
      onDeleteNetworkImage: (img) {
        if (onDeleteNetworkImage != null) {
          onDeleteNetworkImage(img);
        }
      },
      isDeletableNetworkImage: isDeletableNetworkImage,
      borderRadiusNetworkCard: borderRadiusNetworkCard,
      fitNetworkImage: fitNetworkImage,
      heightNetworkImage: heightNetworkImage,
      widthNetworkImage: widthNetworkImage,
      mainContext: context,
      imagesUrls: imagesUrls,
      pickerWidgetColor: pickerWidgetColor,
      images: images,
      deleteIcon: deleteIcon,
      imageCount: imageCount,
      syncImages: (imgs) {
        images = imgs;
      },
      onPicker: (count) {
        picker(imageCount: count);
      },
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
      onPicker: () => picker(isMultiFiles: false, imageCount: 1),
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
