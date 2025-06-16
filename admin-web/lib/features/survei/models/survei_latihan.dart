// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';

class SurveiLatihan {
  String judul;
  DateTime tanggalPenerbitan;
  int harga;
  SurveiLatihan({
    required this.judul,
    required this.tanggalPenerbitan,
    required this.harga,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'judul': judul,
      'tanggalPenerbitan': DateFormat("dd-MMMM-yyyy").format(tanggalPenerbitan),
      'harga': harga,
    };
  }

  factory SurveiLatihan.fromMap(Map<String, dynamic> map) {
    return SurveiLatihan(
      judul: map['judul'] as String,
      tanggalPenerbitan: DateTime.fromMillisecondsSinceEpoch(
          (map['tanggal_penerbitan'] as int) * 1000),
      harga: map['harga'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SurveiLatihan.fromJson(String source) =>
      SurveiLatihan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SurveiLatihan(judul: $judul, tanggalPenerbitan: $tanggalPenerbitan, harga: $harga)';
}
