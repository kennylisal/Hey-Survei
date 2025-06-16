import 'package:aplikasi_admin/features/master_barrel/widgets/active_banned_row.dart';
import 'package:aplikasi_admin/features/master_component/field_container.dart';
import 'package:aplikasi_admin/features/master_component/header_master.dart';
import 'package:aplikasi_admin/features/master_component/loading_tengah.dart';
import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:aplikasi_admin/features/master_survei/survei_controller.dart';
import 'package:aplikasi_admin/utils/hover_builder.dart';
import 'package:aplikasi_admin/utils/web_pagination.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HalamanSurvei extends StatefulWidget {
  HalamanSurvei({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<HalamanSurvei> createState() => _HalamanSurveiState();
}

class _HalamanSurveiState extends State<HalamanSurvei> {
  final controller = TextEditingController();
  List<SurveiData> listData = [];
  List<SurveiData> listDataSimpanan = [];
  List<SurveiData> listDataTampilan = [];

  int jumlahHalaman = 0;
  int jumlahItemPerhalaman = 10;
  int ctrPagination = 1;

  String kataSearch = "";

  SurveiData? pilihan = null;

  @override
  void initState() {
    Future(() async {
      listData = await MasterSurveiController().getAllSurvei(context);
      listDataSimpanan = listData;
      setPagination();
      setState(() {});
    });
    super.initState();
  }

  setPagination() {
    if (listDataSimpanan.isEmpty) {
      jumlahHalaman = 0;
      ctrPagination = 0;
      isiHasilDitampilkan(0);
    } else {
      jumlahHalaman = (listDataSimpanan.length ~/ jumlahItemPerhalaman) +
          ((listDataSimpanan.length % jumlahItemPerhalaman > 0) ? 1 : 0);
      print(
          "isi hasil ditampilkan ->  lbh 1 || jumlah halaman -> $jumlahHalaman");
      isiHasilDitampilkan(1);
      ctrPagination = 1;
    }
  }

  isiHasilDitampilkan(int nomorHalaman) {
    if (nomorHalaman != 0) {
      int index = nomorHalaman - 1;
      int awal = index * jumlahItemPerhalaman;
      int jumlah = 0;
      if ((awal + jumlahItemPerhalaman) >= listDataSimpanan.length) {
        jumlah = listDataSimpanan.length;
      } else {
        jumlah = nomorHalaman * jumlahItemPerhalaman;
      }

      print("ini awal -> $awal || ini jumlah -> $jumlah");
      List<SurveiData> temp = listDataSimpanan.sublist(awal, jumlah);
      listDataTampilan = temp;
    }
    setState(() {});
  }

  siapkanData() {
    setState(() {
      kataSearch = controller.text;
      listDataSimpanan = listData
          .where((element) => element.judul.toLowerCase().contains(kataSearch))
          .toList();
    });
  }

  updateSurvei() {
    int indexList = listData
        .indexWhere((element) => element.id_survei == pilihan!.id_survei);
    int indexTampilan = listDataTampilan
        .indexWhere((element) => element.id_survei == pilihan!.id_survei);

    listDataTampilan[indexTampilan] = pilihan!;
    listData[indexList] = pilihan!;
    setState(() {});
  }

  List<TableRow> generateTableRow(BuildContext context) {
    List<TableRow> temp = [];

    for (var element in listDataTampilan) {
      temp.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            element.judul,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "${element.jumlahPartisipan} / ${element.batasPartisipan}",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              element.status,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
            )),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: AktifBannedRow(
            onPressedAktifkan: () async {
              bool hasil = await MasterSurveiController()
                  .setSurveiStatus(context, element.id_survei, 'aktif');
              if (hasil) {
                setState(() {
                  element.status = 'aktif';
                });
              }
            },
            onPressedBanned: () async {
              bool hasil = await MasterSurveiController()
                  .setSurveiStatus(context, element.id_survei, 'banned');
              if (hasil) {
                setState(() {
                  element.status = 'banned';
                });
              }
            },
          ),
        )
      ]));
    }
    return temp;
  }

  final controllerJudul = TextEditingController();
  final controllerDeskripsi = TextEditingController();
  final controllerPartisipan = TextEditingController();
  final controllerTgl = TextEditingController();
  final controllerHarga = TextEditingController();

  contentGenerator() {
    if (listData.isNotEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderMaster(
              constraints: widget.constraints,
              controller: controller,
              hintText: "Cari Survei",
              onSubmitted: (value) {
                siapkanData();
                setPagination();
              },
              onTap: () {
                siapkanData();
                setPagination();
              },
              onTapReset: () {
                controller.text = "";
                siapkanData();
                setPagination();
              },
              textJudul: "Master Survei",
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Container(
              width: widget.constraints.maxWidth * 1,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FractionColumnWidth(0.35),
                    1: FractionColumnWidth(0.15),
                    2: FractionColumnWidth(0.1),
                    3: FractionColumnWidth(0.1),
                    4: FractionColumnWidth(0.3),
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
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20))),
                          child: Center(
                              child: Text(
                            "Judul",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
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
                            "Partisipan",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                          )),
                        ),
                        Container(
                          height: 40,
                          color: Colors.blueAccent.shade100,
                          child: Center(
                              child: Text(
                            "Status",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
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
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20))),
                          child: Center(
                              child: Text(
                            "Aksi",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
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
              ),
            ),
            const SizedBox(height: 14),
            WebPagination(
              onPageChanged: (value) {
                setState(() {
                  ctrPagination = value;
                  isiHasilDitampilkan(ctrPagination);
                });
              },
              currentPage: ctrPagination,
              totalPage: jumlahHalaman,
              displayItemCount: 5,
            ),
            const SizedBox(height: 14),
          ],
        ),
      );
    } else {
      return const LoadingTengah();
    }
  }

  @override
  Widget build(BuildContext context) {
    return contentGenerator();
  }
}
