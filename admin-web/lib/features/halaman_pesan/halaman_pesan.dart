// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:aplikasi_admin/features/master_component/header_master.dart';
import 'package:aplikasi_admin/features/master_component/loading_tengah.dart';
import 'package:aplikasi_admin/utils/backend.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HalamanPesan extends StatefulWidget {
  HalamanPesan({super.key, required this.constraints});
  BoxConstraints constraints;
  @override
  State<HalamanPesan> createState() => _HalamanPesanState();
}

class _HalamanPesanState extends State<HalamanPesan> {
  List<Laporan> listLaporan = [];
  List<Laporan> listTampilan = [];
  final controller = TextEditingController();
  final scrollController = ScrollController();
  String kataSearch = "";

  Future<List<Laporan>> getKeluhan() async {
    try {
      String query = """ 
     query Query {
  getKeluhanSurvei {
    code,status,data {
      email_pelapor,judulSurvei,laporan,tanggal,idSurvei
    }
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: {});
      if (data!['getKeluhanSurvei']['code'] == 200) {
        List<Object?> dataHasil = data["getKeluhanSurvei"]["data"];
        List<Laporan> temp = List.generate(dataHasil.length,
            (index) => Laporan.fromJson(json.encode(dataHasil[index])));
        return temp;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getDataAwal() async {
    listLaporan = await getKeluhan();
    listTampilan = listLaporan;
    setState(() {});
  }

  @override
  void initState() {
    getDataAwal();
    super.initState();
  }

  search() {
    setState(() {
      kataSearch = controller.text;
    });
  }

  List<TableRow> generateTableRow(BuildContext context) {
    List<TableRow> temp = [];
    listTampilan = listLaporan
        .where((element) => element.judul.toLowerCase().contains(kataSearch))
        .toList();
    for (var element in listTampilan) {
      temp.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.all(4),
          child: TextField(
            maxLines: 2,
            controller: TextEditingController(
                text: '${element.judul} / ${element.idSurvei}'),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.black,
                fontSize: 17,
                height: 1.65,
                letterSpacing: 0.875),
            decoration: InputDecoration(border: InputBorder.none),
          ),
          // Center(
          //     child: Text(
          //   overflow: TextOverflow.ellipsis,
          //   '${element.judul} / ${element.idSurvei}',
          //   style: Theme.of(context).textTheme.displayLarge!.copyWith(
          //         color: Colors.black,
          //         fontSize: 21,
          //         fontWeight: FontWeight.bold,
          //       ),
          // )),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.all(4),
          child: Center(
              child: Text(
            overflow: TextOverflow.ellipsis,
            element.email,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          child: TextField(
            maxLines: 2,
            controller: TextEditingController(text: element.laporan),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.black,
                fontSize: 17,
                height: 1.65,
                letterSpacing: 0.875),
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.all(4),
          child: Center(
              child: Text(
            overflow: TextOverflow.ellipsis,
            DateFormat('dd-MMMM-yyyy').format(element.tanggal),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
          )),
        ),
      ]));
    }
    return temp;
  }
  //emai , jml poin, tgl, id

  @override
  Widget build(BuildContext context) {
    return (listLaporan.isNotEmpty)
        ? Container(
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
                  hintText: 'Cari Survei',
                  onSubmitted: (p0) => search(),
                  onTap: () => search(),
                  textJudul: "Keluhan Survei",
                  onTapReset: () {
                    controller.text = "";
                    search();
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Daftar Keluhan",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 700,
                    width: 1200,
                    margin: EdgeInsets.only(top: 16),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.30),
                          1: FractionColumnWidth(0.20),
                          2: FractionColumnWidth(0.30),
                          3: FractionColumnWidth(0.20),
                        },
                        border: TableBorder.all(
                          borderRadius: BorderRadius.circular(20),
                          width: 2,
                        ),
                        children: [
                          TableRow(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent.shade100,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20))),
                                height: 40,
                                child: Center(
                                    child: Text(
                                  "Judul Survei",
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
                                  "Email Pelapor",
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
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade100,
                                ),
                                height: 40,
                                child: Center(
                                    child: Text(
                                  "Keluhan",
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
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent.shade100,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20))),
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
                            ],
                          ),
                          ...generateTableRow(context)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16)
              ],
            ),
          )
        : const LoadingTengah();
  }
}

//judul, email, pesan, tgl
class Laporan {
  String judul;
  String email;
  String laporan;
  DateTime tanggal;
  String idSurvei;
  Laporan(
      {required this.judul,
      required this.email,
      required this.laporan,
      required this.tanggal,
      required this.idSurvei});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'judul': judul,
      'email': email,
      'pesan': laporan,
      'tanggal': tanggal.millisecondsSinceEpoch,
    };
  }

  factory Laporan.fromMap(Map<String, dynamic> map) {
    return Laporan(
      judul: map['judulSurvei'] as String,
      email: map['email_pelapor'] as String,
      laporan: map['laporan'] as String,
      tanggal:
          DateTime.fromMillisecondsSinceEpoch((map['tanggal'] as int) * 1000),
      idSurvei: map['idSurvei'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Laporan.fromJson(String source) =>
      Laporan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Laporan(judul: $judul, email: $email, pesan: $laporan, tanggal: $tanggal)';
  }
}
