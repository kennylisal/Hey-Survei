import 'package:flutter/material.dart';

class TidakMenjawab extends StatelessWidget {
  const TidakMenjawab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 42,
            color: Colors.yellow.shade800,
          ),
          const SizedBox(width: 20),
          Text(
            "Pengguna Tidak Memberi Jawaban",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 23.5,
                color: Colors.black,
                wordSpacing: 1,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
