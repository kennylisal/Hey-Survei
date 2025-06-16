import 'package:flutter/material.dart';

class SudahDikerjakan extends StatelessWidget {
  const SudahDikerjakan({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 103, 131, 255),
            ),
            child: Image.asset(
              'assets/logo-maaf.png',
              height: 250.0,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            "Anda Sudah Mengerjakan Survei Ini",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
