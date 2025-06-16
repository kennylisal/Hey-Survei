import 'package:flutter/material.dart';

class PilihanUrutan extends StatelessWidget {
  PilihanUrutan({
    super.key,
    required this.text,
    required this.nomor,
  });
  String text;
  String nomor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      width: double.infinity,
      child: Row(
        children: [
          //sharp dan outlined
          Text(
            ("$nomor."),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17,
                color: Colors.black,
                wordSpacing: 1.5,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17,
                color: Colors.black,
                wordSpacing: 1.5,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
