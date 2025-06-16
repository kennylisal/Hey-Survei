import 'package:flutter/material.dart';

class TombolPrint extends StatelessWidget {
  TombolPrint({
    super.key,
    required this.onPressed,
  });
  Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 120),
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.description,
          size: 22,
          color: Colors.white,
        ),
        label: Text(
          "Print Laporan",
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          backgroundColor: Colors.indigoAccent.shade400,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
