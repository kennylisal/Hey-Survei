import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanCheckBoxZ extends StatefulWidget {
  JawabanCheckBoxZ(
      {super.key, required this.controller, required this.dataCheckBox});
  PertanyaanController controller;
  DataCheckBox dataCheckBox;
  @override
  State<JawabanCheckBoxZ> createState() => _JawabanCheckBoxZState();
}

class _JawabanCheckBoxZState extends State<JawabanCheckBoxZ> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final data in widget.dataCheckBox.listOpsi)
          CheckboxListTile(
            title: Text(data.pilihan),
            value: widget.dataCheckBox.mapCheck[data.idPilihan],
            onChanged: (value) {
              setState(() {
                widget.controller.gantiCheckBox(value!, data.idPilihan);
              });
            },
          )
      ],
    );
  }
}
