import 'package:flutter/material.dart';

class TidakAdaData extends StatelessWidget {
  const TidakAdaData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        Center(
          child: Image.asset(
            'assets/no-data-katalog.png',
            height: 300,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Masukkan perncarian lain",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
