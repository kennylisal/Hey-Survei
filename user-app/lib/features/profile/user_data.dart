import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserData {
  String email;
  DateTime waktu_pendaftaran;
  DateTime tglLahir;
  String kota;
  List<String> interest;
  String url_gambar;
  int poin;
  bool isAuthenticated;
  UserData({
    required this.email,
    required this.waktu_pendaftaran,
    required this.kota,
    required this.interest,
    required this.url_gambar,
    required this.poin,
    required this.isAuthenticated,
    required this.tglLahir,
  });

  bool tglLahirTerisi() {
    final umurUser = AgeCalculator.age(tglLahir);
    return (umurUser.years < 4);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'waktu_pendaftaran': waktu_pendaftaran.millisecondsSinceEpoch,
      'kota': kota,
      'interest': interest,
      'url_gambar': url_gambar,
      'poin': poin,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    List<dynamic> temp = (map['interest']);
    return UserData(
      email: map['email'] as String,
      // waktu_pendaftaran: DateTime.now(),
      waktu_pendaftaran: DateTime.fromMillisecondsSinceEpoch(
          (map['waktu_pendaftaran'] as int) * 1000),
      tglLahir:
          DateTime.fromMillisecondsSinceEpoch((map['tglLahir'] as int) * 1000),
      kota: map['kota'] as String,
      interest: List.generate(temp.length, (index) => temp[index] as String),
      url_gambar: map['url_gambar'] as String,
      poin: map['poin'] as int,
      isAuthenticated: map['isAuthenticated'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserData(email: $email, waktu_pendaftaran: $waktu_pendaftaran, kota: $kota, interest: $interest, url_gambar: $url_gambar, poin: $poin, isAuthenticated: $isAuthenticated)';
  }
}
