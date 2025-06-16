// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DataSoalReport {
  int jumlahPartisipan;
  Widget chartPilihan;
  DataSoalReport({
    required this.chartPilihan,
    required this.jumlahPartisipan,
  });
}

class DataPilganReport extends DataSoalReport {
  List<String> listJawaban;
  DataPilganReport({
    required super.chartPilihan,
    required this.listJawaban,
    required super.jumlahPartisipan,
  });
}
