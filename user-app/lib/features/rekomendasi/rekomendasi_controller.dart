// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:survei_aplikasi/utils/graphql_db.dart';

class RekomendasiController {
  Future<List<SurveiDemo>?> getSurveiDemo() async {
    try {
      List<SurveiDemo> hasil = [];
      String request = """
query Query {
  getAllDemoSurvei {
    code,status,data {
      id_survei,tanggal_penerbitan,judul,kategori,insentif,judul,deskripsi,isKlasik,durasi,demografiLokasi,demografiUsia,demografiInterest,gambarSurvei
    }
  }
}
      """;

      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {});
      if (data!['getAllDemoSurvei']['code'] == 200) {
        List<Object?> dataSurvei = data['getAllDemoSurvei']['data'];
        hasil = List.generate(dataSurvei.length,
            (index) => SurveiDemo.fromJson(json.encode(dataSurvei[index])));
        return hasil;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> perluPengecekan() async {
    try {
      String request = """
query Query {
  rekomendasiPakaiPengecekan {
    code,pesan,status
  }
}
      """;
      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: request, mapVariable: {});
      if (data!['rekomendasiPakaiPengecekan']['code'] == 200) {
        final hasil = data['rekomendasiPakaiPengecekan']['pesan'] as String;
        return (hasil == "true");
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class SurveiDemo {
  String judul;
  String id_survei;
  String deskripsi;
  int durasi;
  bool isKlasik;
  String status;
  DateTime tanggalPenerbitan;
  String kategori;
  int insentif;
  bool isTerbitan;
  int demoUsia;
  List<String> demoKota;
  List<String> demoInterest;
  String gambarSurvei;
  SurveiDemo({
    required this.judul,
    required this.id_survei,
    required this.deskripsi,
    required this.durasi,
    required this.isKlasik,
    required this.status,
    required this.tanggalPenerbitan,
    required this.kategori,
    required this.insentif,
    required this.isTerbitan,
    required this.demoUsia,
    required this.demoInterest,
    required this.demoKota,
    required this.gambarSurvei,
  });

  factory SurveiDemo.fromMap(Map<String, dynamic> map) {
    List<Object?> tempInter = map['demografiInterest'];
    List<Object?> tempKota = map['demografiLokasi'];
    String gambarSurvei = "";
    if (map['gambarSurvei'] != null) {
      gambarSurvei = map['gambarSurvei'] as String;
    }
    return SurveiDemo(
      id_survei: map['id_survei'] as String,
      judul: map['judul'] as String,
      deskripsi: map['deskripsi'] as String,
      durasi: 10,
      isKlasik: map['isKlasik'] as bool,
      status: "Aktif",
      tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
          (map['tanggal_penerbitan'] as int) * 1000),
      insentif: map['insentif'] as int,
      kategori: map['kategori'] as String,
      isTerbitan: true,
      demoUsia: map['demografiUsia'] as int,
      demoInterest: List.generate(
          tempInter.length, (index) => tempInter[index] as String),
      demoKota:
          List.generate(tempKota.length, (index) => tempKota[index] as String),
      gambarSurvei: gambarSurvei,
    );
  }

  factory SurveiDemo.fromJson(String source, {bool isTerbitan = true}) =>
      SurveiDemo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SurveiDemo(judul: $judul, id_survei: $id_survei, deskripsi: $deskripsi, durasi: $durasi, isKlasik: $isKlasik, status: $status, tanggalPenerbitan: $tanggalPenerbitan, kategori: $kategori, insentif: $insentif, isTerbitan: $isTerbitan, demoUsia: $demoUsia, demoKota: $demoKota, demoInterest: $demoInterest)';
  }
}
