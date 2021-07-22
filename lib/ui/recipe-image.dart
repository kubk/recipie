import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecipeImage extends StatelessWidget {
  final String? imageUrl;
  final double height;

  const RecipeImage({Key? key, required this.imageUrl, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container();
    }

    if (imageUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        height: height,
        fit: BoxFit.fitHeight,
        placeholder: (context, url) => Container(
          height: height,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Container(
        height: height,
        child: Image.file(File(imageUrl!)),
      );
    }
  }
}
