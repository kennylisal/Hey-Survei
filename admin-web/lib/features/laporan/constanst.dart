import 'package:flutter/material.dart';

enum TipeCharts {
  pieChart,
  nomorxEmail,
  barChart,
  emailxJawaban,
  funnelChart,
  donutChart,
  pyramidChart,
  histogram
}

List<TipeCharts> listChartDataString = [
  TipeCharts.pieChart,
  TipeCharts.funnelChart,
  TipeCharts.pyramidChart,
  TipeCharts.donutChart,
];

List<TipeCharts> listChartDataAngka = [
  TipeCharts.barChart,
  TipeCharts.histogram,
];

List<TipeCharts> listChartDataTabel = [TipeCharts.emailxJawaban];

List<TipeCharts> listChartDataTabelNomor = [TipeCharts.nomorxEmail];

Map<String, Icon> mapJenisSoal = {
  "Pilihan Ganda": const Icon(
    Icons.circle_outlined,
    size: 27,
  ),
  "Kotak Centang": const Icon(
    Icons.check_box_rounded,
    size: 27,
  ),
  "Slider Angka": const Icon(
    Icons.stacked_line_chart,
    size: 27,
  ),
  "Tanggal": const Icon(
    Icons.date_range,
    size: 27,
  ),
  "Waktu": const Icon(
    Icons.access_time,
    size: 27,
  ),
  "Teks": const Icon(
    Icons.abc,
    size: 27,
  ),
  "Teks Paragraf": const Icon(
    Icons.text_snippet_sharp,
    size: 27,
  ),
  "Tabel": const Icon(
    Icons.table_chart,
    size: 27,
  ),
  "Image Picker": const Icon(
    Icons.image_search,
    size: 27,
  ),
  "Gambar Ganda": const Icon(
    Icons.image,
    size: 27,
  ),
  "Carousel": const Icon(
    Icons.view_carousel,
    size: 27,
  ),
  "Urutan Pilihan": const Icon(
    Icons.stacked_bar_chart,
    size: 27,
  ),
  "Angka": const Icon(
    Icons.numbers,
    size: 27,
  ),
};

extension TipeChartsString on TipeCharts {
  String get value {
    switch (this) {
      case TipeCharts.pieChart:
        return "Pie Chart";
      case TipeCharts.barChart:
        return "barChart";
      case TipeCharts.emailxJawaban:
        return "email - Jawaban";
      case TipeCharts.funnelChart:
        return "Funnel Chart";
      case TipeCharts.nomorxEmail:
        return "nomor - Email";
      case TipeCharts.pyramidChart:
        return "Pyramid Chart";
      case TipeCharts.donutChart:
        return "Donut Chart";
      case TipeCharts.histogram:
        return "Histogram";
    }
  }
}
