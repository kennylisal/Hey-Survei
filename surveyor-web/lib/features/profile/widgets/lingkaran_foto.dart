import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LingkaranFoto extends StatelessWidget {
  LingkaranFoto({
    super.key,
    required this.isEditable,
    required this.urlFoto,
    required this.onTap,
  });
  bool isEditable;
  String urlFoto;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 120,
          child: CachedNetworkImage(
            imageUrl: urlFoto,

            // "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/images%2Ffoto%20profil%20kosong.jpeg?alt=media&token=6be0619a-508e-44d8-857f-08c316ec3aeb",
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              );
            },
            placeholder: (context, url) => CircularProgressIndicator(),
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
        ),
        if (isEditable)
          InkWell(
            onTap: onTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.indigoAccent),
              child: const Icon(Icons.settings),
            ),
          )
      ],
    );
  }
}
