import 'package:flutter/material.dart';

class IconMenu extends StatelessWidget {
  IconMenu({
    super.key,
    required this.judul,
    required this.lokasiGambar,
    required this.height,
    required this.onTap,
    required this.isKecil,
  });
  final String judul;
  final String lokasiGambar;
  final double height;
  final Function() onTap;
  bool isKecil;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 223, 229, 255),
                  ),
                  child: Image.asset(
                    lokasiGambar,
                    height: height,
                  ),
                ),
                const SizedBox(height: 8),
                Text(judul,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: (isKecil) ? 10.5 : 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
