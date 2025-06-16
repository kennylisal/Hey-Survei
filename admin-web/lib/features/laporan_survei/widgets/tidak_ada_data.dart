import 'package:flutter/material.dart';

class TidakAdaData extends StatelessWidget {
  const TidakAdaData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 115),
        Center(
          child: Image.asset(
            'assets/no-data-katalog.png',
            height: 360,
          ),
        ),
        Text(
          "Masukkan Tanggal pencarian untuk melihat hasil",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 33, color: Colors.black),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
