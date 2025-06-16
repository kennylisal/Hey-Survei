// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/laporan/constanst.dart';
import 'package:hei_survei/features/laporan/laporan_kartu/laporan_kartu_controller.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';

class LaporanUtamaKartuController
    extends StateNotifier<List<SoalLaporanUtamaKartu>> {
  LaporanUtamaKartuController({required List<SoalLaporanUtamaKartu> list})
      : super(list);
  int getLength() => state.length;
  List<SoalLaporanUtamaKartu> getList() => state;
  tambahData(SoalLaporanUtamaKartu soalLaporan) {
    state = [...state, soalLaporan];
  }

  gantiChart(String idSoal, TipeCharts tipeChartBaru) {
    int index =
        state.indexWhere((element) => element.pertanyaanKartu.idSoal == idSoal);

    final pertanyaan = state[index].pertanyaanKartu;

    Map<String, dynamic> mapCharts = LaporanDataKartuController()
        .mapforCharts(pertanyaan.dataSoal, state[index].dataJawaban);

    final chartBaru = LaporanDataKartuController().generateChart(
        mapCharts,
        tipeChartBaru,
        (pertanyaan.dataSoal.tipeSoal == "Gambar Ganda" ||
            pertanyaan.dataSoal.tipeSoal == "Carousel"));
    state[index].tipeChart = tipeChartBaru;
    state[index].tampilanJawaban = chartBaru;

    state = [...state];
  }
}

class SoalLaporanUtamaKartu {
  PertanyaanKartu pertanyaanKartu;
  Map<String, dynamic> dataJawaban;
  TipeCharts tipeChart;
  Widget tampilanJawaban;
  SoalLaporanUtamaKartu({
    required this.pertanyaanKartu,
    required this.dataJawaban,
    required this.tipeChart,
    required this.tampilanJawaban,
  });

  SoalLaporanUtamaKartu copyWith({
    PertanyaanKartu? pertanyaanKartu,
    Map<String, dynamic>? dataJawaban,
    TipeCharts? tipeChart,
    Widget? tampilanJawaban,
  }) {
    return SoalLaporanUtamaKartu(
      pertanyaanKartu: pertanyaanKartu ?? this.pertanyaanKartu,
      dataJawaban: dataJawaban ?? this.dataJawaban,
      tipeChart: tipeChart ?? this.tipeChart,
      tampilanJawaban: tampilanJawaban ?? this.tampilanJawaban,
    );
  }
}
