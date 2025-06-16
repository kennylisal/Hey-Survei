import 'package:flutter/material.dart';

class BelumAdaRespon extends StatelessWidget {
  const BelumAdaRespon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "Belum ada respon dari partisipan yang diterima",
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
