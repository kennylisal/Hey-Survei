// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:aplikasi_admin/features/laporan/models/jawaban_survei.dart';
import 'package:aplikasi_admin/features/laporan/models/pertanyaan_survei.dart';

class DataLaporanSurveiKlasik {
  String idSurvei;
  String judul;
  String deskripsi;
  List<PertanyaanKlasik> daftarPertanyaanKlasik;
  List<PertanyaanKlasikCabang> daftarPertanyaanKlasikCabang;
  List<ResponSurvei> listRespon;
  List<ResponSurvei> listResponCabang;
  DataLaporanSurveiKlasik({
    required this.idSurvei,
    required this.judul,
    required this.deskripsi,
    required this.daftarPertanyaanKlasik,
    required this.listRespon,
    required this.daftarPertanyaanKlasikCabang,
    required this.listResponCabang,
  });
}
