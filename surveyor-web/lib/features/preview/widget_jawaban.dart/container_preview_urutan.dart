import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/preview/widget_jawaban.dart/preview_opsi_jawaban.dart';

class PreviewContainerUrutan extends StatelessWidget {
  PreviewContainerUrutan({
    super.key,
    required this.controller,
    required this.listOpsi,
  });
  final PertanyaanController controller;
  final List<PreviewOpsiJawaban> listOpsi;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...listOpsi,
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
