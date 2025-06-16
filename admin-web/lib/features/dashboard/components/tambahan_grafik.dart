import 'package:flutter/material.dart';

class TambahanGrafik extends StatelessWidget {
  TambahanGrafik({
    super.key,
    required this.judul,
    required this.kontenAngka,
    required this.warnaKotak,
  });
  String judul;
  String kontenAngka;
  Color warnaKotak;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(judul,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                )),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
              //color: Colors.indigo.shade100,
              color: warnaKotak,
              borderRadius: BorderRadius.circular(16)),
          child: Text(
            kontenAngka,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.black, fontSize: 22),
          ),
        ),
      ],
    );
  }
}
