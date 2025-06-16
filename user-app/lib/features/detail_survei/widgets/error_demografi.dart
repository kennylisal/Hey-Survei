import 'package:flutter/material.dart';

class ErrorDemografi extends StatelessWidget {
  ErrorDemografi({super.key, required this.pesan});
  String pesan;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
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
        Text(
          "Mohon maaf",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            pesan,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 19,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16),
        const SizedBox(height: 20),
      ],
    );
  }
}
