import 'package:flutter/material.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/katalog/widgets/gambar_survei_kartu.dart';
import 'package:hei_survei/features/profile/models/sejarah_penambahan.dart';
import 'package:hei_survei/features/transaksi/widget_order.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:intl/intl.dart';

class KartuSPP extends StatelessWidget {
  KartuSPP({
    super.key,
    required this.isSmall,
    required this.sejarah,
  });
  SejarahPenambahanPoin sejarah;
  bool isSmall;
  DecorationImage gambarKlasik = const DecorationImage(
    image: AssetImage('assets/logo-klasik.png'),
    fit: BoxFit.fill,
  );

  DecorationImage gambarKartu = const DecorationImage(
    image: AssetImage('assets/logo-kartu.png'),
    fit: BoxFit.fill,
  );

  Widget generateFoto() {
    if (sejarah.survei.gambarSurvei == "") {
      return Container(
        height: 80,
        width: 100,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          border: Border.all(
            width: 2.75,
            color: (sejarah.survei.isKlasik)
                ? Colors.redAccent
                : Colors.greenAccent,
          ),
          image: (sejarah.survei.isKlasik) ? gambarKlasik : gambarKartu,
        ),
      );
    } else {
      return Container(
        height: 102,
        width: 130,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          border: Border.all(
            width: 2.75,
            color: Colors.black,
          ),
        ),
        child: GambarSurveiKartu(urlGamabr: sejarah.survei.gambarSurvei),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print(constraints.maxWidth);
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 10),
        // height: 100,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 247, 247, 247),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2.5,
              color: Colors.greenAccent.shade700,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ContainerText(
                  textJudul: "Poin yang Didapat",
                  text: CurrencyFormat.convertToIdr(sejarah.tambahPoin, 2),
                  width: 175,
                ),
                const SizedBox(width: 14),
                if (constraints.maxWidth > 420)
                  // if (!isSmall)
                  ContainerText(
                    textJudul: "Tanggal Transaksi",
                    text: DateFormat('dd-MMMM-yyyy')
                        .format(sejarah.tglPenambahan),
                    width: 175,
                  ),
              ],
            ),
            const SizedBox(height: 7.5),
            if (constraints.maxWidth < 420)
              ContainerText(
                textJudul: "Tanggal Transaksi",
                text: DateFormat('dd-MMMM-yyyy').format(sejarah.tglPenambahan),
                width: 175,
              ),
            const SizedBox(height: 7.5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                generateFoto(),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: (constraints.maxWidth > 342)
                          ? constraints.maxWidth * 0.450
                          : constraints.maxWidth * 0.225,
                      child: Text(
                        sejarah.survei.judul,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 90,
                      width: (constraints.maxWidth > 342)
                          ? constraints.maxWidth * 0.450
                          : constraints.maxWidth * 0.225,
                      child: Text(
                        sejarah.survei.deskripsi,
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 15,
                                ),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
