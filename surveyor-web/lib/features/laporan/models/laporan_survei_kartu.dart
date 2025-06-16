// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hei_survei/features/laporan/models/jawaban_survei.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';

class DataLaporanSurveiKartu {
  String idSurvei;
  String judul;
  String deskripsi;
  List<PertanyaanKartu> daftarPertanyaanKartu;
  List<PertanyaanKartuCabang> daftarPertanyaanKartuCabang;
  List<ResponSurvei> listRespon;
  List<ResponSurvei> listResponCabang;
  DataLaporanSurveiKartu(
      {required this.idSurvei,
      required this.judul,
      required this.deskripsi,
      required this.daftarPertanyaanKartu,
      required this.listRespon,
      required this.daftarPertanyaanKartuCabang,
      required this.listResponCabang});

  DataLaporanSurveiKartu copyWith({
    String? idSurvei,
    String? judul,
    String? deskripsi,
    List<PertanyaanKartu>? daftarPertanyaanKartu,
    List<ResponSurvei>? listRespon,
    List<PertanyaanKartuCabang>? daftarPertanyaanKartuCabang,
    List<ResponSurvei>? listResponCabang,
  }) {
    return DataLaporanSurveiKartu(
      idSurvei: idSurvei ?? this.idSurvei,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      daftarPertanyaanKartu:
          daftarPertanyaanKartu ?? this.daftarPertanyaanKartu,
      listRespon: listRespon ?? this.listRespon,
      daftarPertanyaanKartuCabang:
          daftarPertanyaanKartuCabang ?? this.daftarPertanyaanKartuCabang,
      listResponCabang: listResponCabang ?? this.listResponCabang,
    );
  }
}
