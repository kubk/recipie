import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageSelect extends StatelessWidget {
  final Function() onTap;
  final double imageHeight;

  const ImageSelect({
    Key? key,
    required this.onTap,
    required this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          height: imageHeight,
          child: Center(
            child: Icon(Icons.add_a_photo, size: 48),
          ),
        ),
      ),
    );
  }
}
