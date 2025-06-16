import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/widget_jawaban/opsi_gambar.dart';

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
                  print(controller.getTipePertanyaan());
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
