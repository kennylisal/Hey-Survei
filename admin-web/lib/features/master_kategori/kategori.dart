import 'dart:convert';

import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Kategori {
  String namaKategori;
  String idKategori;
  bool isBaru;
  TextEditingController textEditingController;
  Kategori(
      {required this.namaKategori,
      required this.idKategori,
      required this.isBaru,
      required this.textEditingController});
  factory Kategori.fromMap(Map<String, dynamic> map) {
    String nama = map['nama'] as String;
    return Kategori(
      namaKategori: nama,
      idKategori: map['id'] as String,
      isBaru: false,
      textEditingController: TextEditingController(text: nama),
    );
  }

  factory Kategori.fromJson(String source) =>
      Kategori.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Kategori(namaKategori: $namaKategori, idKategori: $idKategori)';
}
