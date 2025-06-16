import 'dart:convert';

class DataTransaksi {
  String nomorVA;
  String namaBank;
  int totalPembayaran;
  String judulSurvei;
  DataTransaksi({
    required this.nomorVA,
    required this.namaBank,
    required this.totalPembayaran,
    required this.judulSurvei,
  });

  DataTransaksi copyWith({
    String? nomorVA,
    String? namaBank,
    int? totalPembayaran,
    String? judulSurvei,
  }) {
    return DataTransaksi(
      nomorVA: nomorVA ?? this.nomorVA,
      namaBank: namaBank ?? this.namaBank,
      totalPembayaran: totalPembayaran ?? this.totalPembayaran,
      judulSurvei: judulSurvei ?? this.judulSurvei,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nomorVA': nomorVA,
      'namaBank': namaBank,
      'totalPembayaran': totalPembayaran,
      'judulSurvei': judulSurvei,
    };
  }

  factory DataTransaksi.fromMap(Map<String, dynamic> map) {
    return DataTransaksi(
      nomorVA: map['nomorVA'] as String,
      namaBank: map['namaBank'] as String,
      totalPembayaran: map['totalPembayaran'] as int,
      judulSurvei: map['judulSurvei'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataTransaksi.fromJson(String source) =>
      DataTransaksi.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataTransaksi(nomorVA: $nomorVA, namaBank: $namaBank, totalPembayaran: $totalPembayaran, judulSurvei: $judulSurvei)';
  }
}
