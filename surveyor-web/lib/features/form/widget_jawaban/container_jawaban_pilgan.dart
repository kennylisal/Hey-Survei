import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/data_utility.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/widget_jawaban/opsi_jawaban.dart';
import 'package:hei_survei/features/form/widget_jawaban/opsi_lainnya.dart';

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
