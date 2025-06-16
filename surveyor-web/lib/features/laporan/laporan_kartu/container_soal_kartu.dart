import 'package:flutter/material.dart';
import 'package:hei_survei/features/laporan/models/jawaban_survei.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';

class ContainerPertanyaanJawabanLaporanKartu extends StatelessWidget {
  ContainerPertanyaanJawabanLaporanKartu({
    super.key,
    required this.dataPertanyaan,
    required this.jawaban,
    required this.jawabanPertanyaan,
  });
  PertanyaanKartu dataPertanyaan;
  JawabanPertanyaan jawabanPertanyaan;
  Widget jawaban;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
