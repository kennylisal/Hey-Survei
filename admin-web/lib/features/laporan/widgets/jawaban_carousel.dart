import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PilihanCarousel extends StatelessWidget {
  PilihanCarousel({
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
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      decoration: BoxDecoration(
        border: (isJawaban)
            ? Border.all(width: 2.5, color: Colors.lightBlue)
            : null,
      ),
      width: double.infinity,
      child: Row(
        children: [
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
          ),
          SizedBox(width: 20),
          if (isJawaban)
            Text(
              "Jawaban Pilihan",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17,
                  color: Colors.black,
                  wordSpacing: 1.2,
                  fontWeight: FontWeight.w400),
            ),
        ],
      ),
    );
  }
}
