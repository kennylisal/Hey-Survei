import 'package:aplikasi_admin/features/laporan/chart_widgets/donut_chart.dart';
import 'package:aplikasi_admin/features/laporan/chart_widgets/funnel_chart.dart';
import 'package:aplikasi_admin/features/laporan/chart_widgets/histogram.dart';
import 'package:aplikasi_admin/features/laporan/chart_widgets/line_chart.dart';
import 'package:aplikasi_admin/features/laporan/chart_widgets/pie_chart.dart';
import 'package:aplikasi_admin/features/laporan/chart_widgets/pyramid_chart.dart';
import 'package:aplikasi_admin/features/laporan/chart_widgets/tabel_jawaban.dart';
import 'package:aplikasi_admin/features/laporan/constanst.dart';
import 'package:aplikasi_admin/features/laporan/models/chart_angka_1.dart';
import 'package:aplikasi_admin/features/laporan/models/chart_data_angka.dart';
import 'package:aplikasi_admin/features/laporan/models/chart_data_string.dart';
import 'package:aplikasi_admin/features/laporan/models/data_soal_lama.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class LaporanDataKartuController {
  Map<String, dynamic> mapforCharts(
      DataSoal dataSoal, Map<String, dynamic> mapJawaban) {
    if (dataSoal.tipeSoal == "Pilihan Ganda" ||
        dataSoal.tipeSoal == "Kotak Centang") {
      DataPilgan dataPilgan = dataSoal as DataPilgan;
      Map<String, dynamic> temp = {};
      for (var data in dataPilgan.listJawaban) {
        temp[data.text] = mapJawaban[data.idData];
      }
      return temp;
    } else if (dataSoal.tipeSoal == "Carousel" ||
        dataSoal.tipeSoal == "Gambar Ganda") {
      DataGambarGanda dataGambarGanda = dataSoal as DataGambarGanda;
      Map<String, dynamic> temp = {};
      for (var data in dataGambarGanda.listDataGambar) {
        temp[data.urlGambar] = mapJawaban[data.idData];
      }
      return temp;
    } else if (dataSoal.tipeSoal == "Urutan Pilihan") {
      DataUrutan dataUrutan = dataSoal as DataUrutan;
      Map<String, dynamic> temp = {};
      for (var data in dataUrutan.listDataOpsi) {
        temp[data.text] = mapJawaban[data.idData];
      }
      return temp;
    } else if (dataSoal.tipeSoal == "Tanggal") {
      Map<String, dynamic> temp = {};
      for (var element in mapJawaban.entries) {
        DateTime tgl =
            DateTime.fromMillisecondsSinceEpoch((element.value as int));
        temp[element.key] = DateFormat('dd-MMMM-yyyy').format(tgl);
      }
      return temp;
    } else if (dataSoal.tipeSoal == "Waktu") {
      Map<String, dynamic> temp = {};
      for (var element in mapJawaban.entries) {
        TimeOfDay waktu = element.value;
        temp[element.key] = "${waktu.hour} : ${waktu.minute}";
      }
      return temp;
    } else {
      return mapJawaban;
    }
  }

  Widget generateChart(Map<String, dynamic> mapJawaban, TipeCharts tipeCharts,
      bool isLegendGambar) {
    if (tipeCharts == TipeCharts.pieChart) {
      final chartData = generateChartDataString(mapJawaban);
      return PieChart(
        chartData: chartData,
        isLegendGambar: isLegendGambar,
      );
    } else if (tipeCharts == TipeCharts.funnelChart) {
      final chartData = generateChartDataString(mapJawaban);
      return FunnelChart(chartData: chartData, isLegendGambar: isLegendGambar);
    } else if (tipeCharts == TipeCharts.pyramidChart) {
      final chartData = generateChartDataString(mapJawaban);
      return PyramidChart(chartData: chartData, isLegendGambar: isLegendGambar);
    } else if (tipeCharts == TipeCharts.donutChart) {
      final chartData = generateChartDataString(mapJawaban);
      return DonutChart(chartData: chartData, isLegendGambar: isLegendGambar);
    }
    //diatas khusus untuk pilgan dkk
    else if (tipeCharts == TipeCharts.barChart) {
      final chartData = generateChartDataAngka(mapJawaban);

      bool isLegendVisible = chartData.length > 1;
      int min = 0;
      int max = 1;
      if (isLegendVisible) {
        min = chartData[0].x;
        max = chartData.last.x;
      }

      return LineChart(
          chartData: chartData,
          isLegendVisible: isLegendVisible,
          max: max,
          min: min);
    } else if (tipeCharts == TipeCharts.histogram) {
      final chartData = generateChartDataAngka1(mapJawaban);
      bool isLegendVisible = chartData.length > 1;
      double min = 0;
      double max = 1;
      if (isLegendVisible) {
        min = chartData[0].y;
        max = chartData.last.y;
      }
      return Histogram(
        chartData: chartData,
        isLegendVisible: isLegendVisible,
        max: max,
        min: min,
      );
    }
    //diatas untuk slider angka
    else if (tipeCharts == TipeCharts.emailxJawaban) {
      final chartData = generateChartEmailJawaban(mapJawaban);
      return TabelLaporanUtama(
        mapData: chartData,
        judul1: "Email",
        judul2: "Jawaban",
        isModeAngka: false,
      );
    } else if (tipeCharts == TipeCharts.nomorxEmail) {
      final chartData = generateChartEmailJawaban(mapJawaban);
      return TabelLaporanUtama(
        mapData: chartData,
        judul1: "Nomor",
        judul2: "Email Penajwab",
        isModeAngka: true,
      );
    } else {
      return SizedBox();
    }
  }

  TipeCharts penentuanChartAwal(String tipeSoal) {
    if (tipeSoal == "Pilihan Ganda" ||
        tipeSoal == "Kotak Centang" ||
        tipeSoal == "Urutan Pilihan") {
      return TipeCharts.pieChart;
    } else if (tipeSoal == "Gambar Ganda" || tipeSoal == "Carousel") {
      return TipeCharts.pieChart;
    } else if (tipeSoal == "Slider Angka") {
      return TipeCharts.barChart;
    } else if (tipeSoal == "Waktu" ||
        tipeSoal == "Tanggal" ||
        tipeSoal == "Teks" ||
        tipeSoal == "Teks Paragraf" ||
        tipeSoal == "Angka") {
      return TipeCharts.emailxJawaban;
    } else {
      //ini untuk tabel dan image Picker
      return TipeCharts.nomorxEmail;
    }
  }

  List<ChartData> generateChartDataString(Map<String, dynamic> mapJawaban) {
    List<ChartData> hasil = [];
    for (var element in mapJawaban.entries) {
      int angka = element.value as int;
      hasil.add(ChartData(element.key, angka.toDouble()));
    }
    return hasil;
  }

  List<ChartDataAngka> generateChartDataAngka(Map<String, dynamic> mapJawaban) {
    List<ChartDataAngka> hasil = [];
    for (var element in mapJawaban.entries) {
      int angkaUtama = int.parse(element.key);
      int angkaKedua = element.value as int;
      hasil.add(ChartDataAngka(angkaUtama, angkaKedua));
    }
    return hasil;
  }

  List<ChartDataAngka1> generateChartDataAngka1(
      Map<String, dynamic> mapJawaban) {
    List<ChartDataAngka1> hasil = [];
    for (var element in mapJawaban.entries) {
      int angka = element.value as int;
      hasil.add(ChartDataAngka1(y: angka.toDouble()));
    }
    return hasil;
  }

  Map<String, String> generateChartEmailJawaban(
      Map<String, dynamic> mapJawaban) {
    Map<String, String> hasil =
        mapJawaban.map((key, value) => MapEntry(key, value.toString()));
    return hasil;
  }
}
