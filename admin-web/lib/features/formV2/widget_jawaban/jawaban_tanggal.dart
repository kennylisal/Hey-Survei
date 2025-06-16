import 'package:flutter/material.dart';

class JawabanTanggal extends StatelessWidget {
  const JawabanTanggal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tanggal/ Bulan/ Tahun",
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.black, fontSize: 18),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.date_range_sharp,
            size: 24,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
