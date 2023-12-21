import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:convert';
import 'dart:typed_data';

class ImageDetailScreen extends StatelessWidget {
  final int imageIndex;
  final String image1;
  final String image2;

  const ImageDetailScreen({
    Key? key,
    required this.imageIndex,
    required this.image1,
    required this.image2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String base64Image = (imageIndex == 1) ? image1 : image2;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: 'image$imageIndex',
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: base64Image.isNotEmpty
                  ? _photoView(base64Image)
                  : const Center(child: Text('No image available')),
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoView(String base64Image) {
    Uint8List bytes = base64Decode(base64Image);
    return PhotoView(
      imageProvider: MemoryImage(bytes),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 2.0,
      initialScale: PhotoViewComputedScale.contained,
    );
  }
}
