import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LaunchUrl extends StatelessWidget {
  final Function() onTap;

  const LaunchUrl({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
        ),
        child: Text(
          'Перейти',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
