import 'package:flutter/material.dart';

class AktifBannedRow extends StatelessWidget {
  AktifBannedRow({
    super.key,
    required this.onPressedAktifkan,
    required this.onPressedBanned,
  });
  Function() onPressedAktifkan;
  Function() onPressedBanned;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: ElevatedButton(
              onPressed: onPressedAktifkan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              ),
              child: Text(
                "Aktifkan",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              )),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: ElevatedButton(
              onPressed: onPressedBanned,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              ),
              child: Text(
                "Matikan",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              )),
        ),
      ],
    );
  }
}
