import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/formV2/widget_jawaban/opsi_gambar.dart';
import 'package:flutter/material.dart';

class ContainerGG extends StatelessWidget {
  ContainerGG({
    super.key,
    required this.controller,
    required this.listOpsi,
    required this.formController,
  });
  final PertanyaanController controller;
  final List<OpsiGambar> listOpsi;
  final FormController formController;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("opsi jawaban"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
              ),
              onPressed: () {
                controller.tambahOpsiGG(controller.getTipeSoal());
                if (formController.isCabangShown() ||
                    controller.isPertanyaanKartu()) {
                  formController.refreshUI();
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
