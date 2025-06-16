import 'dart:convert';

import 'package:aplikasi_admin/features/survei/models/survei_data.dart';

class SurveiX {
  DetailSurvei detailSurvei;
  SurveiData headerSurvei;
  SurveiX({
    required this.detailSurvei,
    required this.headerSurvei,
  });
}

class DetailSurvei {
  int hargaPerPartisipan;
  int insentifPerPartisipan;
  int demografiUsia;
  List<String> demografiLokasi;
  List<String> demografiInterest;
  int batasPartisipan;
  bool diJual;
  int hargaJual;
  String idForm;
  DetailSurvei(
      {required this.hargaPerPartisipan,
      required this.insentifPerPartisipan,
      required this.demografiUsia,
      required this.demografiLokasi,
      required this.demografiInterest,
      required this.batasPartisipan,
      required this.diJual,
      required this.hargaJual,
      required this.idForm});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hargaPerPartisipan': hargaPerPartisipan,
      'insentifPerPartisipan': insentifPerPartisipan,
      'demografiUsia': demografiUsia,
      'demografiLokasi': demografiLokasi,
      'demografiInterest': demografiInterest,
      'batasPartisipan': batasPartisipan,
      'diJual': diJual,
      'hargaJual': hargaJual,
      'idForm': idForm,
    };
  }

  factory DetailSurvei.fromMap(Map<String, dynamic> map) {
    // print(lokasiTemp);
    return DetailSurvei(
      hargaPerPartisipan: map['hargaPerPartisipan'] as int,
      insentifPerPartisipan: map['insentifPerPartisipan'] as int,
      demografiUsia: map['demografiUsia'] as int,
      demografiInterest: (map['demografiInterest'] as List)
          .map((item) => item as String)
          .toList(),
      demografiLokasi: (map['demografiLokasi'] as List)
          .map((item) => item as String)
          .toList(),
      batasPartisipan: map['batasPartisipan'] as int,
      diJual: map['diJual'] as bool,
      hargaJual: map['hargaJual'] as int,
      idForm: map['idForm'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailSurvei.fromJson(String source) =>
      DetailSurvei.fromMap(json.decode(source) as Map<String, dynamic>);
}
