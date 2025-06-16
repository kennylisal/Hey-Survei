import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/data_utility.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';

class PreviewOpsiJawaban extends StatelessWidget {
  PreviewOpsiJawaban({
    super.key,
    required this.controller,
    required this.hint,
    required this.textEditingController,
  });
  String hint;
  TextEditingController textEditingController;
  PertanyaanController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: Row(
        children: [
          DataUtility().mapIcon[controller.getTipeSoal()]!,
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
              onPressed: null)
        ],
      ),
    );
  }
}
