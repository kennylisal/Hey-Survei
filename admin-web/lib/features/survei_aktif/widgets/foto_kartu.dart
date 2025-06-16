import 'package:flutter/material.dart';

class FotoKartu extends StatelessWidget {
  const FotoKartu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 148,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 5,
            color: Colors.greenAccent,
          ),
          image: const DecorationImage(
            image: AssetImage('assets/logo-kartu.png'),
            fit: BoxFit.fill,
          )),
    );
  }
}
