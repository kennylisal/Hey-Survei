import 'package:flutter/material.dart';

class JudulApp extends StatelessWidget {
  const JudulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 112,
          height: 84,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 57, 141, 236),
                Color.fromARGB(255, 46, 139, 245),
              ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
          child: Center(
            child: Text("Hei",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 55,
                    color: Colors.white)),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Survei",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 55, color: Colors.black),
        ),
      ],
    );
  }
}
