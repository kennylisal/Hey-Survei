import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GambarSurveiKartu extends StatelessWidget {
  GambarSurveiKartu({super.key, required this.urlGamabr});
  String urlGamabr;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: urlGamabr,
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          );
        },
        placeholder: (context, url) => Padding(
          padding: const EdgeInsets.all(9.0),
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) {
          print(error);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 30, color: Colors.red),
              Text(
                "Gambar Gagal Dimuat",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 18,
                      color: Colors.red,
                    ),
              )
            ],
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }
}
