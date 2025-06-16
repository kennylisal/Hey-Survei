import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DataKatalog {
  String judul;
  String kategori;
  int insentif;
  String namaPencipta;
  int durasi;
  String deskripsi;
  String idForm;
  String idSurvei;
  bool isKlasik;
  DateTime tanggalPenerbitan;
  DataKatalog(
      {required this.judul,
      required this.kategori,
      required this.insentif,
      required this.namaPencipta,
      required this.durasi,
      required this.deskripsi,
      required this.idForm,
      required this.idSurvei,
      required this.isKlasik,
      required this.tanggalPenerbitan});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'judul': judul,
      'kategori': kategori,
      'insentif': insentif,
      'namaPencipta': namaPencipta,
      'waktu': durasi,
      'deskripsi': deskripsi,
      'idForm': idForm,
      'idSurvei': idSurvei,
      'isKlasik': isKlasik,
      'tanggalPenerbitan': tanggalPenerbitan.millisecondsSinceEpoch,
    };
  }

  factory DataKatalog.fromMap(Map<String, dynamic> map) {
    print(DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['tanggal'] as String) * 1000));
    return DataKatalog(
      judul: map['judul'] as String,
      kategori: map['kategori'] as String,
      //insentif: map['insentif'] as int,
      insentif: 500,
      namaPencipta: "KennyLisal",
      //namaPencipta: map['namaPencipta'] as String,
      durasi: map['durasi'] as int,
      deskripsi: map['deskripsi'] as String,
      idForm: map['id_form'] as String,
      idSurvei: map['id_survei'] as String,
      isKlasik: (map['isKlasik'] as int == 1),
      tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
          int.parse(map['tanggal'] as String) * 1000),
    );
  }

  String toJson() => json.encode(toMap());

  factory DataKatalog.fromJson(String source) =>
      DataKatalog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataKatalog(judul: $judul, kategori: $kategori, insentif: $insentif, namaPencipta: $namaPencipta, durasi: $durasi, deskripsi: $deskripsi, idForm: $idForm, idSurvei: $idSurvei, isKlasik: $isKlasik, tanggalPenerbitan: $tanggalPenerbitan)';
  }
}
