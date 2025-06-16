import 'package:aplikasi_admin/features/formV2/data_utility.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:flutter/material.dart';

class OpsiJawaban extends StatelessWidget {
  OpsiJawaban({
    super.key,
    required this.controller,
    required this.formController,
    required this.hint,
    required this.textEditingController,
    required this.idOpsi,
  });
  PertanyaanController controller;
  FormController formController;

  String hint;
  TextEditingController textEditingController;
  String idOpsi;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: Row(
        children: [
          InkWell(
            onTap: (!controller.isCabang())
                ? () {
                    formController.tambahSoalCabang(
                      idOpsi,
                      controller.getIdSoal(),
                      textEditingController.text,
                      context,
                    );
                  }
                : null,
            child: DataUtility().mapIcon[controller.getTipeSoal()],
          ),
          const SizedBox(width: 8),
          Flexible(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: hint,
                border: const UnderlineInputBorder(),
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
              controller.hapusOpsi(idOpsi, controller.getTipeSoal());
              if (formController.isCabangShown()) {
                formController.refreshUI();
              }
            },
          )
        ],
      ),
    );
  }
}
