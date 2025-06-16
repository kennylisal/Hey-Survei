import 'package:flutter/material.dart';
import 'package:hei_survei/features/profile/models/sejarah_pencairan.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:intl/intl.dart';

class KartuSejarah extends StatelessWidget {
  KartuSejarah({super.key, required this.data});
  SejarahPencairan data;
  Color warnaBg() {
    if (data.aktif == "Sukses") {
      return Colors.green;
    } else if (data.aktif == "Diproses") {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 4, color: Colors.green.shade200),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Colors.green.shade200,
              spreadRadius: 2,
              blurRadius: 3,
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Pencarian poin sebesar ${CurrencyFormat.convertToIdr(data.jumlahPoin, 2)}",
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blue,
                ),
                child: Text(
                  data.aktif,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('dd-MMMM-yyyy').format(data.waktu_pengajuan),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
