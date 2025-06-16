import 'dart:convert';

class DataForm {
  String id;
  String judul;
  DateTime tanggal;
  bool isKlasik;
  DataForm({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.isKlasik,
  });

  factory DataForm.fromMap(Map<String, dynamic> map) {
    return DataForm(
      id: map['id'] as String,
      judul: map['judul'] as String,
      tanggal:
          DateTime.fromMillisecondsSinceEpoch((map['tanggal'] as int) * 1000),
      isKlasik: (map['tipe'] as String == 'klasik') ? true : false,
    );
  }

  factory DataForm.fromJson(String source) =>
      DataForm.fromMap(json.decode(source) as Map<String, dynamic>);
}
