import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/preview/widget_jawaban.dart/preview_opsi_gambar.dart';
import 'package:flutter/material.dart';

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
