import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderHeader {
  String idOrder;
  String invoice;
  DateTime tangal;
  int hargaTotal;
  List<String> listDetailSurvei;
  OrderHeader({
    required this.idOrder,
    required this.invoice,
    required this.tangal,
    required this.hargaTotal,
    required this.listDetailSurvei,
  });

  OrderHeader copyWith({
    String? idOrder,
    String? invoice,
    DateTime? tangal,
    int? hargaTotal,
    List<String>? listDetailSurvei,
  }) {
    return OrderHeader(
      idOrder: idOrder ?? this.idOrder,
      invoice: invoice ?? this.invoice,
      tangal: tangal ?? this.tangal,
      hargaTotal: hargaTotal ?? this.hargaTotal,
      listDetailSurvei: listDetailSurvei ?? this.listDetailSurvei,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTrans': idOrder,
      'invoice': invoice,
      'tangal': tangal.millisecondsSinceEpoch,
      'hargaTotal': hargaTotal,
      'listDetailSurvei': listDetailSurvei,
    };
  }

  factory OrderHeader.fromMap(Map<String, dynamic> map) {
    List<Object?> result = map['listDetailSurvei'];
    return OrderHeader(
      idOrder: map['idOrder'] as String,
      invoice: map['invoice'] as String,
      tangal:
          DateTime.fromMillisecondsSinceEpoch((map['tanggal'] as int) * 1000),
      hargaTotal: map['hargaTotal'] as int,
      listDetailSurvei:
          List.generate(result.length, (index) => result[index] as String),
      // listDetailSurvei: [],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderHeader.fromJson(String source) =>
      OrderHeader.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderHeader(idTrans: $idOrder, invoice: $invoice, tangal: $tangal, hargaTotal: $hargaTotal, listDetailSurvei: $listDetailSurvei)';
  }
}
