import 'package:flutter/material.dart';

class JawabanAngka extends StatelessWidget {
  JawabanAngka({
    super.key,
    required this.nilai,
  });
  int nilai;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
      child: RichText(
          text: TextSpan(
              text: 'Nilai : ',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 20,
                    color: Colors.black,
                    wordSpacing: 1.25,
                  ),
              children: [
            TextSpan(
              text: nilai.toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 23,
                    color: Colors.black,
                    wordSpacing: 1.25,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ])),
    );
  }
}
