import 'package:flutter/material.dart';

class FotoStandarForm extends StatelessWidget {
  FotoStandarForm({
    super.key,
    required this.isKlasik,
  });
  bool isKlasik;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: 225,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 5,
            color: (isKlasik) ? Colors.greenAccent : Colors.redAccent,
          ),
          image: DecorationImage(
            image: (isKlasik)
                ? const AssetImage('assets/logo-klasik.png')
                : const AssetImage('assets/logo-klasik.png'),
            fit: BoxFit.fill,
          )),
    );
  }
}
