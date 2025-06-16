import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TampilanGambar extends StatefulWidget {
  const TampilanGambar({
    Key? key,
    required this.onPressed,
    required this.urlGambar,
  }) : super(key: key);
  final Function() onPressed;
  final String urlGambar;

  @override
  State<TampilanGambar> createState() => _TampilanGambarState();
}

class _TampilanGambarState extends State<TampilanGambar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 4),
          height: 180,
          width: 320,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
          ),
          child: CachedNetworkImage(
            filterQuality: FilterQuality.medium,
            imageUrl: widget.urlGambar,
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
        SizedBox(height: 6),
        Container(
            width: 248,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    Text(
                      "Pilih Gambar",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ))),
      ],
    );
  }
}
