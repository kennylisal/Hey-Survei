import 'package:aplikasi_admin/features/formV2/model/data_soal.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:flutter/material.dart';

class PreviewJawabanSlider extends StatelessWidget {
  PreviewJawabanSlider({
    super.key,
    required this.controller,
    required this.dataSlider,
  });
  final DataSlider dataSlider;
  final PertanyaanController controller;
  @override
  Widget build(BuildContext context) {
    List angkaDropmax = [2, 3, 4, 5, 6, 7, 8, 9, 10];
    List angkaDropmin = [0, 1];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              DropdownButton(
                value: dataSlider.min,
                items: [
                  for (int i in angkaDropmin)
                    DropdownMenuItem(
                      value: i,
                      child: Text(i.toString()),
                    ),
                ],
                onChanged: (value) {
                  // controller.updateMinSlider(value!);
                  // if (formController.isCabangShown()) {
                  //   formController.refreshUI();
                  // }
                },
              ),
              const SizedBox(width: 12),
              const Text("Sampai"),
              const SizedBox(width: 12),
              DropdownButton(
                value: dataSlider.max,
                items: [
                  for (int i in angkaDropmax)
                    DropdownMenuItem(
                      value: i,
                      child: Text(i.toString()),
                    ),
                ],
                onChanged: (value) {
                  // controller.updateMaxSlider(value!);
                  // if (formController.isCabangShown()) {
                  //   formController.refreshUI();
                  // }
                },
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(dataSlider.min.toString()),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 350,
                child: TextField(
                  readOnly: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  controller: dataSlider.labelMin,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    hintText: "Label Nilai Min (Opsional)",
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(dataSlider.max.toString()),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 350,
                child: TextField(
                  readOnly: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  controller: dataSlider.labelMax,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    hintText: "Label Nilai Max (Opsional)",
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
