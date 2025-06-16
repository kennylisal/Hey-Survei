// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_quill/flutter_quill.dart';

import 'package:hei_survei/features/report/model/data_soal.dart';

class DataPertanyaanForm {
  Delta soalPertanyaan;
  String urlGambar;
  String idSoal;
  DataSoalReport dataSoalReport;
  DataPertanyaanForm({
    required this.soalPertanyaan,
    required this.urlGambar,
    required this.idSoal,
    required this.dataSoalReport,
  });
}
