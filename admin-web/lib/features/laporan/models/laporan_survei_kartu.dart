// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:aplikasi_admin/features/laporan/models/jawaban_survei.dart';
import 'package:aplikasi_admin/features/laporan/models/pertanyaan_survei.dart';

class DataLaporanSurveiKartu {
  String idSurvei;
  String judul;
  String deskripsi;
  List<PertanyaanKartu> daftarPertanyaanKartu;
  List<ResponSurvei> listRespon;
  DataLaporanSurveiKartu({
    required this.idSurvei,
    required this.judul,
    required this.deskripsi,
    required this.daftarPertanyaanKartu,
    required this.listRespon,
  });

  DataLaporanSurveiKartu copyWith({
    String? idSurvei,
    String? judul,
    String? deskripsi,
    List<PertanyaanKartu>? daftarPertanyaanKartu,
    List<ResponSurvei>? listRespon,
  }) {
    return DataLaporanSurveiKartu(
      idSurvei: idSurvei ?? this.idSurvei,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      daftarPertanyaanKartu:
          daftarPertanyaanKartu ?? this.daftarPertanyaanKartu,
      listRespon: listRespon ?? this.listRespon,
    );
  }
}
