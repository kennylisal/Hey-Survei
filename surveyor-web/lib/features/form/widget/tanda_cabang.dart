import 'package:flutter/material.dart';

class TandaCabang extends StatelessWidget {
  const TandaCabang({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
        margin: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Text(
          "Soal Cabang",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 29, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
      ),
    );
  }
}
