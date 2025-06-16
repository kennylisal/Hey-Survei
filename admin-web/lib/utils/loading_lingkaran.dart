import 'package:flutter/material.dart';

class LoadingLingkaran extends StatelessWidget {
  LoadingLingkaran(
      {super.key, this.height = 100, this.width = 100, this.strokeWidth = 14});
  double height;
  double width;
  double strokeWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: height,
      width: width,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
      ),
    );
  }
}
