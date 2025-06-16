import 'dart:convert';

import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FAQ {
  String jawaban;
  String idFAQ;
  String pertanyaan;
  TextEditingController controllerJawaban;
  TextEditingController controllerPertanyaan;
  bool isBaru;
  FAQ({
    required this.jawaban,
    required this.idFAQ,
    required this.pertanyaan,
    required this.isBaru,
    required this.controllerJawaban,
    required this.controllerPertanyaan,
  });

  factory FAQ.fromMap(Map<String, dynamic> map) {
    String jawaban = map['jawaban'] as String;
    String pertanyaan = map['pertanyaan'] as String;
    return FAQ(
      jawaban: jawaban,
      idFAQ: map['id'] as String,
      pertanyaan: pertanyaan,
      controllerJawaban: TextEditingController(text: jawaban),
      controllerPertanyaan: TextEditingController(text: pertanyaan),
      isBaru: false,
    );
  }

  factory FAQ.fromJson(String source) =>
      FAQ.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FAQ(jawaban: $jawaban, idFAQ: $idFAQ, pertanyaan: $pertanyaan)';
}
