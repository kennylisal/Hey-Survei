import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/form_klasik/state/state_pertanyaan.dart';
import 'package:survei_aplikasi/features/form_klasik/widgets/quill_soal.dart';

class PembatasSoal extends StatelessWidget {
  PembatasSoal({super.key, required this.state});
  PembatasState state;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Bagian :",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(width: 3),
              Text(
                state.textPembatas,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ],
          ),
          QuilSoal(quillController: state.documentQuill),
        ],
      ),
    );
  }
}
