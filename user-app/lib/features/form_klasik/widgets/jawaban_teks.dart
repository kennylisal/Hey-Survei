import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';

class JawabanTeksZ extends StatelessWidget {
  JawabanTeksZ({super.key, required this.dataTeks});
  DataTeks dataTeks;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      margin: const EdgeInsets.all(4),
      child: TextField(
        controller: dataTeks.textController,
        decoration: const InputDecoration(hintText: "Jawaban"),
      ),
    );
  }
}
