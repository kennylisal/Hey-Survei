import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survei_aplikasi/features/form_klasik/models/data_pertanyaan.dart';

class JawabanAngkaZ extends StatelessWidget {
  JawabanAngkaZ({super.key, required this.dataAngka});
  final DataAngka dataAngka;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      margin: const EdgeInsets.all(4),
      child: TextField(
        controller: dataAngka.textEditingController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(hintText: "Jawaban Numeric"),
      ),
    );
  }
}
