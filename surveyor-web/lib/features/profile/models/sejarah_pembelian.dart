// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SejarahPembelian {
  String emailPembeli;
  String idSejarah;
  String namaSurvei;
  int pendapatan;
  DateTime tglPembelian;
  SejarahPembelian({
    required this.emailPembeli,
    required this.idSejarah,
    required this.namaSurvei,
    required this.pendapatan,
    required this.tglPembelian,
  });

  SejarahPembelian copyWith({
    String? emailPembeli,
    String? idSejarah,
    String? namaSurvei,
    int? pendapatan,
    DateTime? tglPembelian,
  }) {
    return SejarahPembelian(
      emailPembeli: emailPembeli ?? this.emailPembeli,
      idSejarah: idSejarah ?? this.idSejarah,
      namaSurvei: namaSurvei ?? this.namaSurvei,
      pendapatan: pendapatan ?? this.pendapatan,
      tglPembelian: tglPembelian ?? this.tglPembelian,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emailPembeli': emailPembeli,
      'idSejarah': idSejarah,
      'namaSurvei': namaSurvei,
      'pendapatan': pendapatan,
      'tglPembelian': tglPembelian.millisecondsSinceEpoch,
    };
  }

  factory SejarahPembelian.fromMap(Map<String, dynamic> map) {
    return SejarahPembelian(
      emailPembeli: map['emailPembeli'] as String,
      idSejarah: map['idSejarah'] as String,
      namaSurvei: map['namaSurvei'] as String,
      pendapatan: map['pendapatan'] as int,
      tglPembelian: DateTime.fromMillisecondsSinceEpoch(
          (map['tglPembelian'] as int) * 1000),
    );
  }

  String toJson() => json.encode(toMap());

  factory SejarahPembelian.fromJson(String source) =>
      SejarahPembelian.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SejarahPembelian(emailPembeli: $emailPembeli, idSejarah: $idSejarah, namaSurvei: $namaSurvei, pendapatan: $pendapatan, tglPembelian: $tglPembelian)';
  }
}
