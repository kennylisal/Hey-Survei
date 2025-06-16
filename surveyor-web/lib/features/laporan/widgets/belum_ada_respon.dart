import 'package:flutter/material.dart';

class BelumAdaRespon extends StatelessWidget {
  const BelumAdaRespon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.blue.shade300, shape: BoxShape.circle),
            child: Image.asset(
              'assets/logo-maaf.png',
              height: 375,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "Belum ada respon dari partisipan",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
