import 'package:flutter/material.dart';

class PilihanKotakCentang extends StatelessWidget {
  PilihanKotakCentang({super.key, required this.isCentang, required this.text});
  bool isCentang;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      width: double.infinity,
      child: Row(
        children: [
          (isCentang)
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank),
          const SizedBox(width: 8),
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
