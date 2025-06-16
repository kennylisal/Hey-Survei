import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DataSejarah {
  String judul;
  String deskripsi;
  bool isKlasik;
  DateTime tglPengisian;
  int insentif;
  String gambarSurvei;
  String idSurvei;
  DataSejarah({
    required this.judul,
    required this.deskripsi,
    required this.isKlasik,
    required this.tglPengisian,
    required this.insentif,
    required this.gambarSurvei,
    required this.idSurvei,
  });

  // DataSejarah copyWith({
  //   String? judul,
  //   String? deskripsi,
  //   bool? isKlasik,
  //   DateTime? tglPengisian,
  //   int? insentif,
  //   String
  // }) {
  //   return DataSejarah(
  //     judul: judul ?? this.judul,
  //     deskripsi: deskripsi ?? this.deskripsi,
  //     isKlasik: isKlasik ?? this.isKlasik,
  //     tglPengisian: tglPengisian ?? this.tglPengisian,
  //     insentif: insentif ?? this.insentif,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'judul': judul,
      'deskripsi': deskripsi,
      'isKlasik': isKlasik,
      'tglPengisian': tglPengisian.millisecondsSinceEpoch,
      'insentif': insentif,
    };
  }

  factory DataSejarah.fromMap(Map<String, dynamic> map) {
    String gambarSurvei = "";
    if (map['gambarSurvei'] != null) {
      gambarSurvei = map['gambarSurvei'] as String;
    }
    return DataSejarah(
        judul: map['judul'] as String,
        deskripsi: map['deskripsi'] as String,
        isKlasik: map['isKlasik'] as bool,
        tglPengisian: DateTime.fromMillisecondsSinceEpoch(
            (map['tglPengisian'] as int) * 1000),
        insentif: map['insentif'] as int,
        gambarSurvei: gambarSurvei,
        idSurvei: map['id_survei'] as String);
  }

  String toJson() => json.encode(toMap());

  factory DataSejarah.fromJson(String source) =>
      DataSejarah.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataSejarah(judul: $judul, deskripsi: $deskripsi, isKlasik: $isKlasik, tglPengisian: $tglPengisian, insentif: $insentif)';
  }
}
