// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/laporan/constanst.dart';
import 'package:hei_survei/features/laporan/laporan_klasik/laporan_controller.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';

class LaporanUtamaKlasikController
    extends StateNotifier<List<SoalLaporanUtamaKlasik>> {
  LaporanUtamaKlasikController({required List<SoalLaporanUtamaKlasik> list})
      : super(list);
  int getLength() => state.length;
  List<SoalLaporanUtamaKlasik> getList() => state;
  tambahData(SoalLaporanUtamaKlasik soalLaporan) {
    state = [...state, soalLaporan];
  }

  gantiChart(String idSoal, TipeCharts tipeChartBaru) {
    int index = state
        .indexWhere((element) => element.pertanyaanKlasik.idSoal == idSoal);
    print("mau ganti soal nomor $index");

    final pertanyaan = state[index].pertanyaanKlasik;

    Map<String, dynamic> mapCharts = LaporanDataKlasikController()
        .mapforCharts(pertanyaan.dataSoal, state[index].dataJawaban);

    final chartBaru = LaporanDataKlasikController().generateChart(
        mapCharts,
        tipeChartBaru,
        (pertanyaan.dataSoal.tipeSoal == "Gambar Ganda" ||
            pertanyaan.dataSoal.tipeSoal == "Carousel"));
    // print(mapCharts);
    // state[index].tampilanJawaban = SizedBox();
    state[index].tipeChart = tipeChartBaru;
    state[index].tampilanJawaban = chartBaru;

    state = [...state];
  }
}

class SoalLaporanUtamaKlasik {
  PertanyaanKlasik pertanyaanKlasik;
  Map<String, dynamic> dataJawaban;
  TipeCharts tipeChart;
  Widget tampilanJawaban;
  SoalLaporanUtamaKlasik({
    required this.pertanyaanKlasik,
    required this.tipeChart,
    required this.dataJawaban,
    required this.tampilanJawaban,
  });
  SoalLaporanUtamaKlasik copyWith({
    PertanyaanKlasik? pertanyaanKlasik,
    Map<String, int>? dataJawaban,
    TipeCharts? tipeChart,
    Widget? tampilanJawaban,
  }) {
    return SoalLaporanUtamaKlasik(
      pertanyaanKlasik: pertanyaanKlasik ?? this.pertanyaanKlasik,
      tipeChart: tipeChart ?? this.tipeChart,
      dataJawaban: dataJawaban ?? this.dataJawaban,
      tampilanJawaban: tampilanJawaban ?? this.tampilanJawaban,
    );
  }
}



// //ini versi lama
// class DataChartJawaban {
//   String tipeSoal;
//   Map<String, int> mapChart;
//   String idSoal;
//   DataChartJawaban({
//     required this.tipeSoal,
//     required this.mapChart,
//     required this.idSoal,
//   });

//   @override
//   String toString() =>
//       'D(tipeSoal: $tipeSoal, mapChart: $mapChart, idSoal: $idSoal)';
// }
