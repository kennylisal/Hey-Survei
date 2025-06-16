import 'package:flutter/material.dart';
import 'package:hei_survei/utils/currency.dart';

class ContainerRingkasan extends StatelessWidget {
  ContainerRingkasan({
    super.key,
    required this.text,
    required this.judul,
    required this.icon,
  });
  String judul;
  String text;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            width: 1,
            color: Colors.blueGrey,
          ),
          borderRadius: BorderRadius.circular(17.5)),
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                judul,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 17.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class ContainerJumlahSoal extends StatelessWidget {
  ContainerJumlahSoal({
    super.key,
    required this.jumlahSoal,
    required this.hargaPertanyaan,
  });
  int jumlahSoal;
  int hargaPertanyaan;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            width: 1,
            color: Colors.blueGrey,
          ),
          borderRadius: BorderRadius.circular(17.5)),
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.content_paste,
                size: 24,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 10),
              Text(
                "Biaya pertanyaan : ",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 15.5,
                    ),
              ),
              Text(
                "$jumlahSoal pertanyaan",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            CurrencyFormat.convertToIdr(hargaPertanyaan, 2),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
