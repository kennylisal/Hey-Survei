import 'package:flutter/material.dart';

class JawabanTeksLaporan extends StatelessWidget {
  JawabanTeksLaporan({super.key, required this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 17,
            color: Colors.black,
            wordSpacing: 1.2,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
