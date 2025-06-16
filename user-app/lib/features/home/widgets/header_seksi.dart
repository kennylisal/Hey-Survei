import 'package:flutter/material.dart';

class HeaderSeksi extends StatelessWidget {
  const HeaderSeksi({
    super.key,
    required this.judul,
  });
  final String judul;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 4),
      child: Text(
        judul,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
