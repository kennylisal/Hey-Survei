import 'package:aplikasi_admin/features/formV2/data_utility.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/formV2/widget_jawaban/opsi_jawaban.dart';
import 'package:aplikasi_admin/features/formV2/widget_jawaban/opsi_lainnya.dart';
import 'package:flutter/material.dart';

class ContainerJawabanPilgan extends StatelessWidget {
  ContainerJawabanPilgan({
    super.key,
    required this.listOpsi,
    required this.controller,
    required this.islainnyaAktif,
    required this.formController,
  });
  final List<OpsiJawaban> listOpsi;
  final bool islainnyaAktif;
  final PertanyaanController controller;
  FormController formController;
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
              OpsiLainnya(
                pertanyaanController: controller,
                iconPilihan: DataUtility().mapIcon[controller.getTipeSoal()]!,
                formController: formController,
              )
          ],
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
                controller.tambahOpsiPilgan(controller.getTipeSoal());

                if (formController.isCabangShown() ||
                    controller.isPertanyaanKartu()) {
                  formController.refreshUI();
                }
              },
            ),
            const SizedBox(width: 20),
            if (!islainnyaAktif)
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("jawaban lainnya"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                onPressed: () {
                  controller.setLainnya(true);

                  if (formController.isCabangShown() ||
                      controller.isPertanyaanKartu()) {
                    formController.refreshUI();
                  }
                },
              )
          ],
        )
      ],
    );
  }
}
