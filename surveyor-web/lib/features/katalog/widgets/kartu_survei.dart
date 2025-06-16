import 'package:flutter/material.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/katalog/widgets/gambar_survei_kartu.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:hei_survei/utils/hover_builder.dart';
import 'package:intl/intl.dart';

class KartuSurvei extends StatelessWidget {
  KartuSurvei({
    super.key,
    required this.surveiData,
    required this.onTap,
  });

  SurveiData surveiData;
  Function() onTap;
  generateFoto() {
    if (surveiData.gambarSurvei == "") {
      return (surveiData.isKlasik) ? const FotoKlasik() : const FotoKartu();
    } else {
      return Container(
        height: 120,
        width: 148,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 3,
            color: Colors.black,
          ),
        ),
        child: GambarSurveiKartu(urlGamabr: surveiData.gambarSurvei),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (isHovered) => InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 400,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.only(
            top: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(21),
            border: Border.all(width: 3, color: Colors.black),
            boxShadow: [
              BoxShadow(
                color: (isHovered) ? Colors.grey : Colors.transparent,
                spreadRadius: 6,
                blurRadius: 3,
                offset: Offset(0, 6), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  surveiData.judul,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                      wordSpacing: 2,
                      letterSpacing: 1.25),
                ),
              ),
              SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.only(
                    left: 18, right: 16, top: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timelapse),
                        SizedBox(width: 4),
                        Text(
                          "${surveiData.durasi} menit",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('dd-MMMM-yyyy')
                          .format(surveiData.tanggalPenerbitan),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade800),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  direction: Axis.horizontal,
                  children: List.generate(
                    surveiData.kategori.length,
                    (index) {
                      return Text(
                        surveiData.kategori[index],
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      );
                    },
                  ),
                ),
              ),
              Divider(color: Colors.grey.shade800),
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                height: 125,
                child: Row(
                  children: [
                    generateFoto(),
                    // (surveiData.isKlasik)
                    //     ? const FotoKlasik()
                    //     : const FotoKartu(),
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(right: 0),
                        width: 215,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              surveiData.deskripsi,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      fontSize: 13,
                                      color: Colors.black,
                                      letterSpacing: 1.25,
                                      height: 1.6),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade800, height: 8),
              Container(
                padding: const EdgeInsets.only(
                    left: 18, right: 16, top: 2, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    JumlahPartisipanKatalog(
                      batasPartisipan: surveiData.batasPartisipan.toString(),
                      jumlahPartisipan: surveiData.jumlahPartisipan.toString(),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(surveiData.harga, 2),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JumlahPartisipanKatalog extends StatelessWidget {
  JumlahPartisipanKatalog({
    super.key,
    required this.jumlahPartisipan,
    required this.batasPartisipan,
  });
  String jumlahPartisipan;
  String batasPartisipan;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.person,
          size: 21,
        ),
        const SizedBox(width: 2),
        RichText(
            text: TextSpan(
                text: jumlahPartisipan,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
                children: [
              TextSpan(text: ' / '),
              TextSpan(text: batasPartisipan)
            ]))
      ],
    );
  }
}

class FotoKartu extends StatelessWidget {
  const FotoKartu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 148,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 5,
            color: Colors.greenAccent,
          ),
          image: const DecorationImage(
            image: AssetImage('assets/logo-kartu.png'),
            fit: BoxFit.fitWidth,
          )),
    );
  }
}

class FotoKlasik extends StatelessWidget {
  const FotoKlasik({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 148,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 5,
            color: Colors.redAccent,
          ),
          image: DecorationImage(
            image: const AssetImage('assets/logo-klasik.png'),
            fit: BoxFit.fill,
          )),
    );
  }
}
