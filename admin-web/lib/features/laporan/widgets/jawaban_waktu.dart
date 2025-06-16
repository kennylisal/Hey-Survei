import 'package:flutter/material.dart';

class JawabanWaktu extends StatelessWidget {
  JawabanWaktu({
    super.key,
    required this.jam,
    required this.menit,
  });
  int jam;
  int menit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
      child: Row(
        children: [
          Text(
            "Waktu : ",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 19.5,
                color: Colors.black,
                wordSpacing: 1.5,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 8),
          Text(
            jam.toString(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 24,
                color: Colors.black,
                wordSpacing: 1.5,
                fontWeight: FontWeight.bold),
          ),
          Text(
            " : ",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 24,
                color: Colors.black,
                wordSpacing: 1.5,
                fontWeight: FontWeight.bold),
          ),
          Text(
            menit.toString(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 24,
                color: Colors.black,
                wordSpacing: 1.5,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
