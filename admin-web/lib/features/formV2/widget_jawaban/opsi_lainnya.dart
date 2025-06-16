import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:flutter/material.dart';

class OpsiLainnya extends StatelessWidget {
  OpsiLainnya({
    super.key,
    required this.pertanyaanController,
    required this.iconPilihan,
    required this.formController,
  });
  final Widget iconPilihan;
  final PertanyaanController pertanyaanController;
  final FormController formController;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: Row(
        children: [
          iconPilihan,
          const SizedBox(width: 8),
          const Flexible(
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: "Lainnya",
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            disabledColor: Colors.grey.shade400,
            icon: const Icon(
              Icons.remove_circle_outline,
              size: 30,
            ),
            onPressed: () {
              pertanyaanController.setLainnya(false);
              formController.refreshUI();
            },
          ),
        ],
      ),
    );
  }
}
