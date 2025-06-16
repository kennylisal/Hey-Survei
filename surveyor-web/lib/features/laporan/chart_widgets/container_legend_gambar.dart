import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GambarLegendChart extends StatelessWidget {
  GambarLegendChart({
    super.key,
    required this.urlGambar,
  });
  String urlGambar;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 4),
      height: 80,
      width: 118,
      decoration: BoxDecoration(
        border: Border.all(width: 1),
      ),
      child: CachedNetworkImage(
        filterQuality: FilterQuality.medium,
        imageUrl: urlGambar,
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) {
          return const Icon(
            Icons.error,
            size: 48,
            color: Colors.red,
          );
        },
      ),
    );
  }
}
