import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/preview_opsi_gambar.dart';

class PreviewContainerGG extends StatelessWidget {
  PreviewContainerGG({
    super.key,
    required this.controller,
    required this.listOpsi,
  });
  final PertanyaanController controller;
  final List<PreviewOpsiGambar> listOpsi;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: listOpsi,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
