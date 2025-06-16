import 'package:flutter/material.dart';

class TampilanTeksPointer extends StatelessWidget {
  TampilanTeksPointer({
    super.key,
    required this.soal,
    required this.jawaban,
  });
  String soal;
  String jawaban;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.only(top: 2),
            child: Text(soal.substring(0, soal.length - 2),
                style: Theme.of(context).textTheme.titleMedium!)),
        Container(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              "Jawaban : $jawaban",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
