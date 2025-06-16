import 'package:flutter/material.dart';

class PilihanPilgan extends StatelessWidget {
  PilihanPilgan({
    super.key,
    required this.isJawaban,
    required this.text,
  });
  bool isJawaban;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      width: double.infinity,
      child: Row(
        children: [
          //sharp dan outlined
          (isJawaban) ? Icon(Icons.circle_sharp) : Icon(Icons.circle_outlined),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17,
                color: (isJawaban) ? Colors.red : Colors.black,
                wordSpacing: 1.5,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
