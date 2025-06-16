import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PilihanGG extends StatelessWidget {
  PilihanGG({
    super.key,
    required this.urlImage,
    required this.isJawaban,
  });
  String urlImage;
  bool isJawaban;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      width: double.infinity,
      child: Row(
        children: [
          (isJawaban) ? Icon(Icons.circle_sharp) : Icon(Icons.circle_outlined),
          const SizedBox(width: 8),
          Container(
            height: 100,
            width: 180,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: Colors.grey.shade300,
            ),
            child: CachedNetworkImage(
              filterQuality: FilterQuality.medium,
              imageUrl: urlImage,
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
          )
        ],
      ),
    );
  }
}
