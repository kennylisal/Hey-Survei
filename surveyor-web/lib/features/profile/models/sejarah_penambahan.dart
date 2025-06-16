// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hei_survei/features/katalog/model/survei_data.dart';

class SejarahPenambahanPoin {
  String emailPembeli;
  SurveiData survei;
  int tambahPoin;
  String idOrder;
  DateTime tglPenambahan;
  SejarahPenambahanPoin({
    required this.emailPembeli,
    required this.survei,
    required this.tambahPoin,
    required this.idOrder,
    required this.tglPenambahan,
  });

  SejarahPenambahanPoin copyWith({
    String? emailPembeli,
    SurveiData? survei,
    int? tambahPoin,
    String? idOrder,
    DateTime? tglPenambahan,
  }) {
    return SejarahPenambahanPoin(
      emailPembeli: emailPembeli ?? this.emailPembeli,
      survei: survei ?? this.survei,
      tambahPoin: tambahPoin ?? this.tambahPoin,
      idOrder: idOrder ?? this.idOrder,
      tglPenambahan: tglPenambahan ?? this.tglPenambahan,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'emailPembeli': emailPembeli,
  //     'survei': survei.toMap(),
  //     'tambahPoin': tambahPoin,
  //     'idOrder': idOrder,
  //     'tglPenambahan': tglPenambahan.millisecondsSinceEpoch,
  //   };
  // }

  factory SejarahPenambahanPoin.fromMap(Map<String, dynamic> map) {
    Object? dataSurvei = map['survei'];
    return SejarahPenambahanPoin(
      emailPembeli: map['emailPembeli'] as String,
      survei: SurveiData.fromJson(json.encode(dataSurvei)),
      tambahPoin: map['tambahPoin'] as int,
      idOrder: map['idOrder'] as String,
      tglPenambahan: DateTime.fromMillisecondsSinceEpoch(
          (map['tglPenambahan'] as int) * 1000),
    );
  }

  // String toJson() => json.encode(toMap());

  factory SejarahPenambahanPoin.fromJson(String source) =>
      SejarahPenambahanPoin.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SejarahPenambahanPoin(emailPembeli: $emailPembeli, survei: $survei, tambahPoin: $tambahPoin, idOrder: $idOrder, tglPenambahan: $tglPenambahan)';
  }
}
