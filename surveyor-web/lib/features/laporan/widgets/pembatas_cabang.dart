import 'package:flutter/material.dart';

class PembatasCabang extends StatelessWidget {
  const PembatasCabang({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          "PERTANYAAN CABANG",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
