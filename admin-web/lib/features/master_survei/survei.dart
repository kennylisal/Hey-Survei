import 'dart:convert';

import 'package:intl/intl.dart';

class SurveiData {
  String judul;
  String deskripsi;
  int jumlahPartisipan;
  int batasPartisipan;
  int durasi;
  bool isKlasik;
  String status;
  DateTime tanggalPenerbitan;
  String kategori;
  int hargaJual;
  int harga;
  String emailUser;
  String id_survei;
  SurveiData({
    required this.judul,
    required this.deskripsi,
    required this.jumlahPartisipan,
    required this.batasPartisipan,
    required this.durasi,
    required this.isKlasik,
    required this.status,
    required this.tanggalPenerbitan,
    required this.kategori,
    required this.hargaJual,
    required this.emailUser,
    required this.id_survei,
    required this.harga, //ini harga pembuatan
  });

  factory SurveiData.fromMap(Map<String, dynamic> map) {
    return SurveiData(
      id_survei: map['id_survei'] as String,
      judul: map['judul'] as String,
      deskripsi: map['deskripsi'] as String,
      jumlahPartisipan: map['jumlahPartisipan'] as int,
      batasPartisipan: map['batasPartisipan'] as int,
      durasi: map['durasi'] as int,
      isKlasik: (map['isKlasik'] as bool),
      status: map['status'] as String,
      tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
          (map['tanggal_penerbitan'] as int) * 1000),
      hargaJual: map['hargaJual'] as int,
      kategori: map['kategori'] as String,
      emailUser: map['emailUser'] as String,
      harga: map['harga'] as int,
    );
  }

  //String toJson() => json.encode(toMap());

  factory SurveiData.fromJson(String source) =>
      SurveiData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SurveiData(judul: $judul, deskripsi: $deskripsi, jumlahPartisipan: $jumlahPartisipan, batasPartisipan: $batasPartisipan, durasi: $durasi, isKlasik: $isKlasik, status: $status, tanggal: ${DateFormat('dd-MMMM-yyyy').format(tanggalPenerbitan)}, kategori: $kategori, harga: $hargaJual)';
  }
}
