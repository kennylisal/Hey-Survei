import 'package:aplikasi_admin/features/laporan/models/chart_angka_1.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Histogram extends StatelessWidget {
  Histogram({
    super.key,
    required this.chartData,
    required this.isLegendVisible,
    required this.max,
    required this.min,
  });
  final double max;
  final double min;
  final List<ChartDataAngka1> chartData;
  final bool isLegendVisible;
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(
          title: AxisTitle(
        text:
            (isLegendVisible) ? "Minimun : $min            Maximum : $max" : "",
        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
      )),
      series: <ChartSeries>[
        HistogramSeries<ChartDataAngka1, double>(
          dataSource: chartData,
          showNormalDistributionCurve: true,
          curveColor: const Color.fromRGBO(192, 108, 132, 1),
          binInterval: 1,
          yValueMapper: (datum, index) => datum.y,
        )
      ],
    );
  }
}
