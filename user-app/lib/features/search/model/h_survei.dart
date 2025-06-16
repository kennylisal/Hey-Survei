// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HSurvei {
  //ini dari hei_survei -> katalog -> model -> SurveiData
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
  String gambarSurvei;

  HSurvei({
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
    required this.gambarSurvei,
  });

  factory HSurvei.fromMap(Map<String, dynamic> map, bool isTerbitan) {
    String gambarSurvei = "";
    if (map['gambarSurvei'] != null) {
      gambarSurvei = map['gambarSurvei'] as String;
    }
    return HSurvei(
      id_survei: map['id_survei'] as String,
      judul: map['judul'] as String,
      deskripsi: map['deskripsi'] as String,
      durasi: map['durasi'] as int,
      isKlasik: map['isKlasik'] as bool,
      status: "Aktif",
      tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
          (map['tanggal_penerbitan'] as int) * 1000),
      insentif: map['insentif'] as int,
      kategori: map['kategori'] as String,
      isTerbitan: isTerbitan,
      gambarSurvei: gambarSurvei,
    );
  }

  factory HSurvei.fromJson(String source, {bool isTerbitan = true}) =>
      HSurvei.fromMap(json.decode(source) as Map<String, dynamic>, isTerbitan);

  @override
  String toString() {
    return 'HSurvei(judul: $judul, id_survei: $id_survei, deskripsi: $deskripsi, durasi: $durasi, isKlasik: $isKlasik, status: $status, tanggalPenerbitan: $tanggalPenerbitan, kategori: $kategori, insentif: $insentif, isTerbitan: $isTerbitan)';
  }
}
