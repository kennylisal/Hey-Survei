import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GambarSoal extends StatelessWidget {
  GambarSoal({
    super.key,
    required this.urlGambar,
  });
  String urlGambar;
  String urlCadangan =
      "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/eksp%2F065908a0-7e?alt=media&token=7c910ea2-982a-4772-a65a-edb639f94cb9";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 4),
          height: 210,
          width: 378,
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          child: CachedNetworkImage(
            filterQuality: FilterQuality.medium,
            imageUrl: (urlGambar == "" || urlGambar == "urlGambar")
                ? urlCadangan
                : urlGambar,
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
    );
  }
}
