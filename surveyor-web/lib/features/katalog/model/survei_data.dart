// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';

class SurveiData {
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
  bool isTerbitan;
  String idPemilik;
  String gambarSurvei;
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
    required this.harga,
    required this.id_survei,
    this.isTerbitan = true,
    required this.idPemilik,
    required this.gambarSurvei,
  });

  String generateLink() {
    return "ayaya";
  }

  factory SurveiData.fromMap(Map<String, dynamic> map, bool isTerbitan) {
    String gambarSurvei = "";
    if (map['gambarSurvei'] != null) {
      gambarSurvei = map['gambarSurvei'] as String;
    }
    return SurveiData(
      id_survei: map['id_survei'] as String,
      idPemilik: map['idUser'] as String,
      judul: map['judul'] as String,
      deskripsi: map['deskripsi'] as String,
      jumlahPartisipan: map['jumlahPartisipan'] as int,
      batasPartisipan: map['batasPartisipan'] as int,
      // durasi: 0,
      durasi: map['durasi'] as int,
      isKlasik: map['isKlasik'] as bool,
      status: map['status'] as String,
      tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
          (map['tanggal_penerbitan'] as int) * 1000),
      // harga: 27500,
      harga: map['hargaJual'] as int,
      gambarSurvei: gambarSurvei,
      kategori:
          (map['kategori'] as String), //==========================ini masalah
      isTerbitan: isTerbitan,
    );
  }

  // factory SurveiData.fromMapKeranjang(
  //     Map<String, dynamic> map, bool isTerbitan) {
  //   return SurveiData(
  //     id_survei: map['id_survei'] as String,
  //     idPemilik: map['idUser'] as String,
  //     judul: map['judul'] as String,
  //     deskripsi: map['deskripsi'] as String,
  //     jumlahPartisipan: map['jumlahPartisipan'] as int,
  //     batasPartisipan: map['batasPartisipan'] as int,
  //     durasi: 0,

  //     isKlasik: map['isKlasik'] as bool,
  //     status: map['status'] as String,
  //     tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
  //         (map['tanggal_penerbitan'] as int) * 1000),
  //     // harga: 27500,
  //     harga: map['harga'] as int,
  //     kategori:
  //         (map['kategori'] as String), //==========================ini masalah
  //     isTerbitan: isTerbitan,
  //   );
  // }

  // factory SurveiData.fromMapSejarah(Map<String, dynamic> map) {
  //   return SurveiData(
  //     id_survei: map['id_survei'] as String,
  //     judul: map['judulSurvei'] as String,
  //     deskripsi: map['deskripsi'] as String,
  //     idPemilik: "",
  //     jumlahPartisipan: -1,
  //     batasPartisipan: -1,
  //     durasi: -1,
  //     isKlasik: map['isKlasik'] as bool,
  //     status: "Aktif",
  //     tanggalPenerbitan: DateTime.now(),
  //     harga: map['harga'] as int,
  //     kategori: "",
  //   );
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

  factory SurveiData.fromJson(String source, {bool isTerbitan = true}) =>
      SurveiData.fromMap(
          json.decode(source) as Map<String, dynamic>, isTerbitan);

  // factory SurveiData.fromJsonSejarah(String source) =>
  //     SurveiData.fromMapSejarah(json.decode(source) as Map<String, dynamic>);

  // factory SurveiData.fromJsonKeranjang(String source,
  //         {bool isTerbitan = true}) =>
  //     SurveiData.fromMapKeranjang(
  //         json.decode(source) as Map<String, dynamic>, isTerbitan);

  // @override
  // String toString() {
  //   return 'SurveiData(judul: $judul, deskripsi: $deskripsi, jumlahPartisipan: $jumlahPartisipan, batasPartisipan: $batasPartisipan, durasi: $durasi, isKlasik: $isKlasik, status: $status, tanggal: $tanggal, kategori: $kategori, harga: $harga)';
  // }
  @override
  String toString() {
    return 'SurveiData(judul: $judul, tanggal: ${DateFormat('dd-MMMM-yyyy').format(tanggalPenerbitan)}, harga: $harga)';
  }
}
