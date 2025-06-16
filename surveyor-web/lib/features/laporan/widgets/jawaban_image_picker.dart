import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class JawabanImagePickerLaporan extends StatelessWidget {
  JawabanImagePickerLaporan({
    super.key,
    required this.urlGambar,
  });
  String urlGambar;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            height: 255,
            width: 450,
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
          ),
        ],
      ),
    );
  }
}
