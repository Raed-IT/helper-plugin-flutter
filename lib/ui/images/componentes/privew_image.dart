import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/utilitis/helper_functions.dart';
import 'package:helper_plugin/utilitis/media_model.dart';

// import 'package:image_downloader/image_downloader.dart';
import 'package:photo_browser/photo_browser.dart';

Future<void> previewImage(
    {required List<MediaModel> imagesUrls,
    required BuildContext context,
    bool deletable = false,
    Function(MediaModel img)? onDelete}) async {
  PhotoBrowser photoBrowser = PhotoBrowser(
    scrollPhysics: const BouncingScrollPhysics(),
    allowPullDownToPop: false,
    allowShrinkPhoto: true,
    allowTapToPop: false,
    filterQuality: FilterQuality.high,
    allowSwipeDownToPop: false,
    positionBuilders: imagesUrls
        .map(
          (e) => (context, curIndex, totalNum) {
            return Positioned(
              bottom: 10.h,
              child: SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    GestureDetector(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.save,
                            size: 30,
                            color: Colors.white,
                          ),
                          Text(
                            "حفظ الصورة ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onTap: () async {
                        try {
                          FileDownloader.downloadFile(
                              url: "${imagesUrls[curIndex].url}",
                              name: "${imagesUrls[curIndex].id}",
                              onDownloadCompleted: (String path) {
                                printHelper(
                                    "don download file path => ${path}");
                              },
                              onDownloadError: (String error) {
                                printHelper("error download file ${error}");
                              });
                        } catch (e) {
                          Fluttertoast.showToast(msg: "حدث خطاء ما ");
                        }
                      },
                    ),
                    (deletable)
                        ? SizedBox(
                            width: 50.w,
                          )
                        : Container(),
                    (deletable)
                        ? GestureDetector(
                            onTap: () {
                              onDelete!(imagesUrls[curIndex]);
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Text(
                                  "حذف الصورة ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    (deletable)
                        ? SizedBox(
                            width: 10.w,
                          )
                        : Container(),
                    (deletable) ? Container() : Expanded(child: Container()),
                  ],
                ),
              ),
            );
          },
        )
        .toList(),
    positions: (BuildContext context) => <Positioned>[
      Positioned(
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    ],
    imageUrlBuilder: (int index) {
      return "${imagesUrls[index].url}";
    },
    itemCount: imagesUrls.length,
    initIndex: 0,
  );
  photoBrowser.push(context);
}
