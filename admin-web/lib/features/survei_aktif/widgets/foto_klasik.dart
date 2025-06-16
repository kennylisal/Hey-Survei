import 'package:flutter/material.dart';

class FotoKlasik extends StatelessWidget {
  const FotoKlasik({super.key});

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
            color: Colors.redAccent,
          ),
          image: DecorationImage(
            image: const AssetImage('assets/logo-klasik.png'),
            fit: BoxFit.fill,
          )),
    );
  }
}
