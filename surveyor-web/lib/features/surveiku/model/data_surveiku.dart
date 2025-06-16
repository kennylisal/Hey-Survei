import 'dart:convert';

class DataKartuSurveiku {
  String idSurvei;
  String idForm;
  String deskripsi;
  bool isKlasik;
  String judul;
  String durasi;
  String status;
  String tanggal;
  String jumlahPartisipan;
  String batasPartisipan;
  DataKartuSurveiku({
    required this.deskripsi,
    required this.isKlasik,
    required this.judul,
    required this.durasi,
    required this.status,
    required this.tanggal,
    required this.jumlahPartisipan,
    required this.batasPartisipan,
    required this.idSurvei,
    required this.idForm,
  });

  factory DataKartuSurveiku.fromMap(Map<String, dynamic> map) {
    return DataKartuSurveiku(
      idSurvei: map['id_survei'] as String,
      idForm: map['id_form'] as String,
      deskripsi: map['deskripsi'] as String,
      isKlasik: (map['isKlasik'] as int == 1),
      judul: map['judul'] as String,
      durasi: (map['durasi'] as int).toString(),
      status: map['status'] as String,
      tanggal: map['tanggal'] as String,
      jumlahPartisipan: (map['jumlahPartisipan'] as int).toString(),
      batasPartisipan: (map['batasPartisipan'] as int).toString(),
    );
  }
  factory DataKartuSurveiku.fromJson(String source) =>
      DataKartuSurveiku.fromMap(json.decode(source) as Map<String, dynamic>);
}
