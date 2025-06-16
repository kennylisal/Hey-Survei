// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hei_survei/features/katalog/model/survei_data.dart';

class Order {
  DateTime tanggal;
  int harga;
  List<SurveiData> listSurvei;
  String idOrder;
  Order(
      {required this.tanggal,
      required this.harga,
      required this.listSurvei,
      required this.idOrder});

  int getTotalharga() {
    int acc = 0;
    for (var element in listSurvei) {
      acc += element.harga;
    }
    return acc;
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    List<Object?> listTemp = map["listSurvei"];
    return Order(
      tanggal:
          DateTime.fromMillisecondsSinceEpoch((map['tanggal'] as int) * 1000),
      harga: map['hargaTotal'] as int,
      idOrder: map['idOrder'] as String,
      listSurvei: List.generate(listTemp.length,
          (index) => SurveiData.fromJson(json.encode(listTemp[index]))),
    );
  }

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Order(tanggal: $tanggal, harga: $harga, listSurvei: $listSurvei, idOrder : $idOrder)';
}
