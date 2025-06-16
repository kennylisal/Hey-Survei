// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hei_survei/features/katalog/model/survei_data.dart';

class Transaksi {
  String idTrans;
  String invoice;
  DateTime tanggalTransaksi;
  int totalHarga;
  DetailTransaksi detail;
  Transaksi({
    required this.idTrans,
    required this.invoice,
    required this.tanggalTransaksi,
    required this.totalHarga,
    required this.detail,
  });

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      idTrans: map['idTrans'] as String,
      invoice: map['invoice'] as String,
      tanggalTransaksi: DateTime.fromMillisecondsSinceEpoch(
          (map['tanggalTransaksi'] as int) * 1000),
      totalHarga: map['totalHarga'] as int,
      detail: DetailTransaksi.fromMap(map['detail'] as Map<String, dynamic>),
    );
  }

  factory Transaksi.fromJson(String source) =>
      Transaksi.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaksi(idTrans: $idTrans, invoice: $invoice, tanggalTransaksi: $tanggalTransaksi, totalHarga: $totalHarga, detail: $detail)';
  }
}

class DetailTransaksi {
  String caraPembayaran;
  List<SurveiData> listSurvei;
  DetailTransaksi({
    required this.caraPembayaran,
    required this.listSurvei,
  });

  factory DetailTransaksi.fromMap(Map<String, dynamic> map) {
    List<Object?> list = map['listSurvei'];
    return DetailTransaksi(
      caraPembayaran: map['caraPembayaran'] as String,
      listSurvei: List.generate(list.length,
          (index) => SurveiData.fromJson(json.encode(list[index]))),
    );
  }

  // String toJson() => json.encode(toMap());

  factory DetailTransaksi.fromJson(String source) =>
      DetailTransaksi.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DetailTransaksi(caraPembayaran: $caraPembayaran, listSurvei: $listSurvei)';
}
