import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/data_utility.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';

class PreviewOpsiGambar extends StatelessWidget {
  PreviewOpsiGambar({
    super.key,
    required this.controller,
    required this.urlGambar,
  });
  PertanyaanController controller;
  String urlGambar;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          child: Row(
            children: [
              DataUtility().mapIcon[controller.getTipeSoal()]!,
              const SizedBox(width: 6),
              (constraints.maxWidth > 300)
                  ? Container(
                      height: 81,
                      width: 144,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: Colors.grey.shade300,
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
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) {
                          return const Icon(
                            Icons.error,
                            size: 48,
                            color: Colors.red,
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(width: 8),
              const SizedBox(width: 20),
              IconButton(
                disabledColor: Colors.grey.shade400,
                icon: const Icon(
                  Icons.remove_circle_outline,
                  size: 30,
                ),
                onPressed: null,
              )
            ],
          ),
        );
      },
    );
  }
}
