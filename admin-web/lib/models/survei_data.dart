import 'dart:convert';

import 'package:intl/intl.dart';

class SurveiDataX {
  String judul;
  String id_survei;
  String deskripsi;
  int jumlahPartisipan;
  int batasPartisipan;
  int durasi;
  bool isKlasik;
  String status;
  DateTime tanggalPenerbitan;
  String kategori;
  int harga;
  SurveiDataX({
    required this.judul,
    required this.deskripsi,
    required this.jumlahPartisipan,
    required this.batasPartisipan,
    required this.durasi,
    required this.isKlasik,
    required this.status,
    required this.tanggalPenerbitan,
    required this.kategori,
    required this.harga,
    required this.id_survei,
  });

  factory SurveiDataX.fromMap(Map<String, dynamic> map) {
    return SurveiDataX(
        id_survei: map['id_survei'] as String,
        judul: map['judul'] as String,
        deskripsi: "Deskripsi",
        jumlahPartisipan: 10,
        batasPartisipan: 50,
        durasi: 10,
        isKlasik: true,
        status: "Aktif",
        tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
            (map['tanggal_penerbitan'] as int) * 1000),
        harga: map['harga'] as int,
        kategori: "Umum");
  }
  //   factory SurveiData.fromMap(Map<String, dynamic> map) {
  //   return SurveiData(
  //       id_survei: ,
  //       judul: map['judul'] as String,
  //       deskripsi: "Deskripsi",
  //       jumlahPartisipan: 10,
  //       batasPartisipan: 50,
  //       durasi: 10,
  //       isKlasik: true,
  //       status: "Aktif",
  //       tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
  //           (map['tanggal_penerbitan'] as int) * 1000),
  //       harga: map['harga'] as int,
  //       kategori: "Umum");
  // }

  // factory SurveiData.fromMap(Map<String, dynamic> map) {
  //   return SurveiData(
  //       judul: map['judul'] as String,
  //       deskripsi: "Deskripsi",
  //       jumlahPartisipan: 10,
  //       batasPartisipan: 50,
  //       durasi: 10,
  //       isKlasik: true,
  //       status: "Aktif",
  //       tanggal: map['tanggal'] as String,
  //       harga: map['harga'] as int,
  //       kategori: ["Umum"]);
  // }

  //String toJson() => json.encode(toMap());

  factory SurveiDataX.fromJson(String source) =>
      SurveiDataX.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'SurveiData(judul: $judul, deskripsi: $deskripsi, jumlahPartisipan: $jumlahPartisipan, batasPartisipan: $batasPartisipan, durasi: $durasi, isKlasik: $isKlasik, status: $status, tanggal: $tanggal, kategori: $kategori, harga: $harga)';
  // }
  @override
  String toString() {
    return 'SurveiData(judul: $judul, tanggal: ${DateFormat('dd-MMMM-yyyy').format(tanggalPenerbitan)}, harga: $harga)';
  }
}
