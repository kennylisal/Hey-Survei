import 'package:flutter/material.dart';
import 'package:hei_survei/features/laporan/models/chart_data_angka.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.chartData,
    required this.isLegendVisible,
    required this.max,
    required this.min,
  });
  final int max;
  final int min;
  final List<ChartDataAngka> chartData;
  final bool isLegendVisible;
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(
          visibleMinimum: (min - 1),
          visibleMaximum: (max + 1),
          title: AxisTitle(
            text: (isLegendVisible)
                ? "Minimun : $min            Maximum : $max"
                : "",
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
          )),
      series: <ChartSeries>[
        ColumnSeries<ChartDataAngka, int>(
          dataSource: chartData,
          xValueMapper: (ChartDataAngka data, _) => data.x,
          yValueMapper: (ChartDataAngka data, _) => data.y,
        )
      ],
    );
  }
}
