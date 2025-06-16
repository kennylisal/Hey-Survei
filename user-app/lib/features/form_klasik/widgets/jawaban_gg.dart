import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanGambarGandaZ extends StatefulWidget {
  JawabanGambarGandaZ({
    super.key,
    required this.dataGG,
    required this.controller,
  });
  PertanyaanController controller;
  DataGambarGanda dataGG;
  @override
  State<JawabanGambarGandaZ> createState() => _JawabanGambarGandaZState();
}

class _JawabanGambarGandaZState extends State<JawabanGambarGandaZ> {
  String urlCadangan =
      "https://firebasestorage.googleapis.com/v0/b/hei-survei-v1.appspot.com/o/eksp%2F065908a0-7e?alt=media&token=7c910ea2-982a-4772-a65a-edb639f94cb9";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final dataOpsi in widget.dataGG.listUrlGambar)
          Container(
            margin: const EdgeInsets.only(bottom: 13, left: 16),
            child: Row(
              children: [
                Radio(
                  value: dataOpsi,
                  groupValue: widget.dataGG.pilihan,
                  onChanged: (value) {
                    setState(() {
                      widget.controller.gantiGambarGanda(dataOpsi);
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.controller.gantiGambarGanda(dataOpsi);
                    });
                  },
                  child: Container(
                    height: 105,
                    width: 186.5,
                    decoration: BoxDecoration(border: Border.all(width: 2)),
                    child: CachedNetworkImage(
                      filterQuality: FilterQuality.medium,
                      imageUrl: (dataOpsi.pilihan == "")
                          ? urlCadangan
                          : dataOpsi.pilihan,
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
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) {
                        return const Icon(
                          Icons.error,
                          size: 42,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}
