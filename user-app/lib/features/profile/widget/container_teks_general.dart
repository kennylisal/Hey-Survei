import 'package:flutter/material.dart';
import 'package:survei_aplikasi/features/profile/widget/halaman_ganti_pass.dart';

class ContainerTeks extends StatelessWidget {
  const ContainerTeks({
    super.key,
    required this.text,
    required this.iconData,
    required this.judul,
    required this.warnaTeks,
  });
  final String text;
  final IconData iconData;
  final String judul;
  final Color warnaTeks;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Text(
            judul,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 5),
        KotakTampilan(
          text: text,
          iconData: iconData,
          warnaTeks: warnaTeks,
        )
      ],
    );
  }
}
