import 'package:flutter/material.dart';

class SurveiTidakDitemukan extends StatelessWidget {
  const SurveiTidakDitemukan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Mohon maaf",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          "Survei Tidak Ditemukan",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.indigo.shade200.withOpacity(0.5),
          ),
          child: Image.asset(
            'assets/logo-maaf.png',
            height: 180,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
