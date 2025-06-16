import 'package:aplikasi_admin/features/formV2/data_utility.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/preview/widget_jawaban.dart/preview_opsi_jawaban.dart';
import 'package:aplikasi_admin/features/preview/widget_jawaban.dart/preview_opsi_lainnya.dart';
import 'package:flutter/material.dart';

class ContainerPreviewPilgan extends StatelessWidget {
  ContainerPreviewPilgan({
    super.key,
    required this.controller,
    required this.islainnyaAktif,
    required this.listOpsi,
  });
  final List<PreviewOpsiJawaban> listOpsi;
  final bool islainnyaAktif;
  final PertanyaanController controller;
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
            if (islainnyaAktif)
              PreviewOpsiLainnya(
                iconPilihan: DataUtility().mapIcon[controller.getTipeSoal()]!,
              )
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
