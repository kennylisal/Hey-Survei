import 'package:flutter/material.dart';
import 'package:hei_survei/features/profile/models/sejarah_pembelian.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:intl/intl.dart';

class KartuPembelian extends StatelessWidget {
  KartuPembelian({
    super.key,
    required this.sejarah,
  });
  SejarahPembelian sejarah;
  DecorationImage gambarKlasik = const DecorationImage(
    image: AssetImage('assets/logo-klasik.png'),
    fit: BoxFit.fill,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2.5, color: Colors.black),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sejarah.namaSurvei,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
          Row(
            children: [
              Container(
                height: 80,
                width: 100,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2.75,
                    color: Colors.redAccent,
                  ),
                  image: gambarKlasik,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pembeli : ${sejarah.emailPembeli}",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 15,
                        ),
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tanggal: ${DateFormat('dd-MMMM-yyyy').format(sejarah.tglPembelian)}",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 15,
                        ),
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormat.convertToIdr(sejarah.pendapatan, 2),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.greenAccent.shade400,
                ),
                child: Text(
                  "Terbeli",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
