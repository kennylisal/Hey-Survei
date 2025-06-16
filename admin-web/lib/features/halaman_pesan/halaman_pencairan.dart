// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:aplikasi_admin/features/master_component/header_master.dart';
import 'package:aplikasi_admin/features/master_component/loading_tengah.dart';
import 'package:aplikasi_admin/utils/backend.dart';
import 'package:aplikasi_admin/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HalamanPengajuanPencairan extends StatefulWidget {
  HalamanPengajuanPencairan({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<HalamanPengajuanPencairan> createState() =>
      _HalamanPengajuanPencairanState();
}

class _HalamanPengajuanPencairanState extends State<HalamanPengajuanPencairan> {
  //emai , jml poin, tgl, id
  List<PengajuanPencairan> listLaporan = [];
  List<PengajuanPencairan> listTampilan = [];
  final controller = TextEditingController();
  final scrollController = ScrollController();
  String kataSearch = "";

  Future<List<PengajuanPencairan>> getPencairan() async {
    try {
      String query = """ 
query GetPengajuanPencairan {
  getPengajuanPencairan {
    code,status,data {
      emailUser,jumlahPoin,waktu_pengajuan,idPencairan,aktif,idUser
    }
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: {});
      if (data!['getPengajuanPencairan']['code'] == 200) {
        List<Object?> dataHasil = data["getPengajuanPencairan"]["data"];
        List<PengajuanPencairan> temp = List.generate(
            dataHasil.length,
            (index) =>
                PengajuanPencairan.fromJson(json.encode(dataHasil[index])));
        return temp;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  aturPencairan({
    required String status,
    required String idPencairan,
    required int poin,
    required String idUser,
  }) async {
    try {
      String query = """ 
mutation UpdatePencairan(\$idPencairan: String!, \$status: String!, \$idUser: String!, \$poin: Int!) {
  updatePencairan(idPencairan: \$idPencairan, status: \$status, idUser: \$idUser, poin: \$poin) {
    code,data,status
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: query, mapVariable: {
        "idPencairan": idPencairan,
        "status": status,
        "idUser": idUser,
        "poin": poin,
      });
      if (data!['updatePencairan']['code'] == 200) {
        getDataAwal();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Berhasil update pencairan")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal update")));
    }
  }

  getDataAwal() async {
    listLaporan = await getPencairan();
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
        .where((element) => element.email.toLowerCase().contains(kataSearch))
        .toList();
    for (var element in listTampilan) {
      temp.add(TableRow(children: [
        Container(
          height: 40,
          child: Center(
              child: Text(
            element.email,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17.5,
                ),
          )),
        ),
        Container(
          height: 40,
          child: Center(
              child: Text(
            CurrencyFormat.convertToIdr(element.jumlahPoin, 2),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17.5,
                ),
          )),
        ),
        Container(
          height: 40,
          child: Center(
              child: Text(
            DateFormat('dd-MMMM-yyyy').format(element.tanggal),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17.5,
                ),
          )),
        ),
        Container(
          height: 40,
          child: Center(
              child: Text(
            element.idPencairan,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17.5,
                ),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          child: (element.aktif == "Diproses")
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async => aturPencairan(
                          idPencairan: element.idPencairan,
                          status: "Sukses",
                          poin: element.jumlahPoin,
                          idUser: element.idUser),
                      child: Icon(Icons.check, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: Colors.green, // <-- Button color
                        foregroundColor: Colors.blue, // <-- Splash color
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async => aturPencairan(
                          idPencairan: element.idPencairan,
                          status: "Ditolak",
                          poin: element.jumlahPoin,
                          idUser: element.idUser),
                      child: Icon(Icons.no_accounts, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: Colors.red, // <-- Button color
                        foregroundColor: Colors.blue, // <-- Splash color
                      ),
                    )
                  ],
                )
              : Center(
                  child: Text(
                    element.aktif,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 19.5,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
        ),
      ]));
    }
    return temp;
  }

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
              children: [
                HeaderMaster(
                  constraints: widget.constraints,
                  controller: controller,
                  hintText: 'Cari email',
                  onSubmitted: (p0) => search(),
                  onTap: () => search(),
                  textJudul: "Pencairan Partisipan",
                  onTapReset: () {
                    controller.text = "";
                    search();
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Daftar Pengajuan Pencairan",
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
                          0: FractionColumnWidth(0.20),
                          1: FractionColumnWidth(0.20),
                          2: FractionColumnWidth(0.20),
                          3: FractionColumnWidth(0.20),
                          4: FractionColumnWidth(0.20),
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
                                  "Email Pegguna",
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
                                  "Jumlah Poin",
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
                                  "Tanggal Pengajuan",
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
                                  "ID Pengajuan",
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
                          ...generateTableRow(context)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const LoadingTengah();
  }
}

class PengajuanPencairan {
  String email;
  int jumlahPoin;
  DateTime tanggal;
  String idPencairan;
  String aktif;
  String idUser;
  PengajuanPencairan({
    required this.email,
    required this.jumlahPoin,
    required this.tanggal,
    required this.idPencairan,
    required this.aktif,
    required this.idUser,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'jumlahPoin': jumlahPoin,
      'tanggal': tanggal.millisecondsSinceEpoch,
      'idPencairan': idPencairan,
    };
  }

  factory PengajuanPencairan.fromMap(Map<String, dynamic> map) {
    return PengajuanPencairan(
      email: map['emailUser'] as String,
      jumlahPoin: map['jumlahPoin'] as int,
      tanggal: DateTime.fromMillisecondsSinceEpoch(
          (map['waktu_pengajuan'] as int) * 1000),
      idPencairan: map['idPencairan'] as String,
      aktif: map['aktif'] as String,
      idUser: map['idUser'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PengajuanPencairan.fromJson(String source) =>
      PengajuanPencairan.fromMap(json.decode(source) as Map<String, dynamic>);
}
