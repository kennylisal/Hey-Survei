import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/state/controller_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/quill_soal.dart';

class FormKartuXFoto extends StatelessWidget {
  FormKartuXFoto({
    super.key,
    required this.controller,
    required this.index,
    required this.isCabang,
    required this.totalSoal,
  });
  PertanyaanController controller;
  int index;
  int totalSoal;
  bool isCabang;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.isWajib())
                Text("*Wajib",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
              if (!isCabang)
                Text(
                  "${index + 1} / $totalSoal",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ],
          ),
          QuilSoal(
            quillController: controller.getQuillController(),
          ),
          controller.generateWidgetJawaban()
        ],
      ),
    );
  }
}
