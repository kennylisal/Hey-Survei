import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanPilganZ extends StatefulWidget {
  JawabanPilganZ({
    super.key,
    required this.dataPilgan,
    required this.controller,
  });
  DataPilgan dataPilgan;
  PertanyaanController controller;
  @override
  State<JawabanPilganZ> createState() => _JawabanPilganZState();
}

class _JawabanPilganZState extends State<JawabanPilganZ> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final pilihan in widget.dataPilgan.listPilihan)
          RadioListTile(
            title: Text(pilihan.pilihan),
            value: pilihan,
            groupValue: widget.dataPilgan.pilihan,
            onChanged: (value) {
              widget.controller.gantiPilgan(value!);
              setState(() {});
            },
          )
      ],
    );
  }
}
