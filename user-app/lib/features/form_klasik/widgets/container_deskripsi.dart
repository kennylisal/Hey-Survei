// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DeskripsiSurvei extends StatelessWidget {
  const DeskripsiSurvei({
    Key? key,
    required this.deskripsi,
  }) : super(key: key);
  final String deskripsi;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white),
      child: Column(
        children: [
          Text(
            "Deskripsi ",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(deskripsi, style: Theme.of(context).textTheme.displayLarge!),
        ],
      ),
    );
  }
}
