import 'dart:convert';

import 'package:aplikasi_admin/features/master_survei/survei.dart';

class Order {
  String emailUser;
  DateTime tanggalPenerbitan;
  int totalHarga;
  String idOrder;
  int persenan;
  List<SurveiData> listSurvei;
  Order({
    required this.emailUser,
    required this.tanggalPenerbitan,
    required this.totalHarga,
    required this.idOrder,
    required this.persenan,
    required this.listSurvei,
  });

  Order copyWith({
    String? emailUser,
    DateTime? tglPenerbitan,
    int? totalHarga,
    String? idOrder,
    List<SurveiData>? listSurvei,
    int? persenan,
  }) {
    return Order(
      emailUser: emailUser ?? this.emailUser,
      tanggalPenerbitan: tglPenerbitan ?? this.tanggalPenerbitan,
      totalHarga: totalHarga ?? this.totalHarga,
      idOrder: idOrder ?? this.idOrder,
      listSurvei: listSurvei ?? this.listSurvei,
      persenan: persenan ?? this.persenan,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emailUser': emailUser,
      'tglPenerbitan': tanggalPenerbitan.millisecondsSinceEpoch,
      'totalHarga': totalHarga,
      'idOrder': idOrder,
      // 'listSurvei': listSurvei.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    print(map);
    return Order(
      emailUser: map['emailUser'] as String,
      tanggalPenerbitan:
          DateTime.fromMillisecondsSinceEpoch((map['tanggal'] as int) * 1000),
      totalHarga: map['hargaTotal'] as int,
      idOrder: map['idOrder'] as String,
      persenan: map['presentasi'] as int,
      listSurvei: [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
