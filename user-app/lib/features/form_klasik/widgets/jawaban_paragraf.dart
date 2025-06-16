import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';

class JawabanParagrafZ extends StatelessWidget {
  JawabanParagrafZ({
    super.key,
    required this.dataTeks,
  });
  DataTeks dataTeks;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      margin: const EdgeInsets.all(4),
      child: TextField(
        controller: dataTeks.textController,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        decoration: InputDecoration(
            hintText: "Jawaban",
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.blue))),
      ),
    );
  }
}
