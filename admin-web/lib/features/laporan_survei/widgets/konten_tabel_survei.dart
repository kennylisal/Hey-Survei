import 'package:aplikasi_admin/features/laporan_survei/widgets/tombol_print.dart';
import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:aplikasi_admin/utils/currency_format.dart';
import 'package:aplikasi_admin/utils/pdf_laporan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KontenTabelLaporanSurvei extends StatelessWidget {
  KontenTabelLaporanSurvei({
    super.key,
    required this.listData,
    required this.tglAkhir,
    required this.tglAwal,
  });
  List<SurveiData> listData;
  String tglAwal;
  String tglAkhir;
  List<TableRow> generateTableRow(BuildContext context) {
    List<TableRow> temp = [];
    for (var element in listData) {
      temp.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.only(top: 16, left: 12),
          child: Text(
            element.judul,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 16, left: 12),
          child: Text(
            element.emailUser,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: (element.emailUser == "AdminHeiSurvei")
                      ? Colors.blue
                      : Colors.black,
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${DateFormat('dd-MMMM-yyyy').format(element.tanggalPenerbitan)}',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "${element.jumlahPartisipan} / ${element.batasPartisipan}",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              (element.isKlasik) ? "Klasik" : "Kartu",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              CurrencyFormat.convertToIdr(element.harga, 2),
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
      ]));
    }
    return temp;
  }

  String totalKeuntunganStr() {
    int ctr = 0;
    for (var element in listData) {
      ctr += element.harga;
    }
    return CurrencyFormat.convertToIdr(ctr, 2);
  }

  int totalKeuntungan() {
    int ctr = 0;
    for (var element in listData) {
      ctr += element.harga;
    }
    return ctr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 600,
      width: 1300,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Daftar Survei",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FractionColumnWidth(0.31),
                1: FractionColumnWidth(0.195),
                2: FractionColumnWidth(0.15),
                3: FractionColumnWidth(0.075),
                4: FractionColumnWidth(0.1),
                5: FractionColumnWidth(0.17),
              },
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(20),
                width: 2,
              ),
              children: [
                TableRow(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(20))),
                      child: Center(
                          child: Text(
                        "Judul",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                    ),
                    Container(
                      color: Colors.blueAccent.shade100,
                      height: 40,
                      child: Center(
                          child: Text(
                        "Penerbit",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                    ),
                    Container(
                      color: Colors.blueAccent.shade100,
                      height: 40,
                      child: Center(
                          child: Text(
                        "Tanggal",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                    ),
                    Container(
                      color: Colors.blueAccent.shade100,
                      height: 40,
                      child: Center(
                          child: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 30,
                      )),
                    ),
                    Container(
                      height: 40,
                      color: Colors.blueAccent.shade100,
                      child: Center(
                          child: Text(
                        "Tipe",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(20))),
                      child: Center(
                          child: Text(
                        "Biaya",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                      )),
                    ),
                  ],
                ),
                ...generateTableRow(context),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class HeaderLaporanX extends StatelessWidget {
  HeaderLaporanX(
      {super.key,
      required this.listData,
      required this.tglAkhir,
      required this.tglAwal});
  List<SurveiData> listData;
  String tglAwal;
  String tglAkhir;
  String totalKeuntunganStr() {
    int ctr = 0;
    for (var element in listData) {
      ctr += element.harga;
    }
    return CurrencyFormat.convertToIdr(ctr, 2);
  }

  int totalKeuntungan() {
    int ctr = 0;
    for (var element in listData) {
      ctr += element.harga;
    }
    return ctr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Survei : ${listData.length}",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Keuntungan : " + totalKeuntunganStr(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TombolPrint(
                onPressed: () async {
                  final hasil = await PdfLaporan().generatePdfSurvei(
                      listData, totalKeuntungan(), tglAwal, tglAkhir, 9);
                  if (!hasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal proses laporan")));
                  }
                },
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 4.5, color: Colors.black))),
          ),
        ],
      ),
    );
  }
}
