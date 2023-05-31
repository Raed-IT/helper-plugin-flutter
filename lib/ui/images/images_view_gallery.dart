import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// ignore: must_be_immutable
class ImageViewGallery extends StatelessWidget {
  List<ImageProvider> images = [];

  ImageViewGallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        enableRotation: false,
        reverse: false,
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            filterQuality: FilterQuality.high,
            maxScale: 2.0,
            minScale:0.5,
            imageProvider: images[index],
            initialScale: PhotoViewComputedScale.contained,
          );
        },
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ?? 1),
            ),
          ),
        ),
      ),
    );
  }
}
