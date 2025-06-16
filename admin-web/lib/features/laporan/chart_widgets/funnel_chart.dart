import 'package:aplikasi_admin/features/laporan/chart_widgets/legend_text_chart.dart';
import 'package:aplikasi_admin/features/laporan/models/chart_data_string.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FunnelChart extends StatelessWidget {
  const FunnelChart({
    super.key,
    required this.chartData,
    required this.isLegendGambar,
  });
  final List<ChartData> chartData;
  final bool isLegendGambar;
  @override
  Widget build(BuildContext context) {
    return SfFunnelChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        legendItemBuilder: (legendText, series, point, seriesIndex) {
          return ContainerLegendChart(
              isLegendGambar: isLegendGambar,
              legendText: legendText,
              point: point,
              series: series,
              color: point.color);
        },
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 21,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
      ),
      series: FunnelSeries<ChartData, String>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
              fontSize: 18),
        ),
      ),
    );
  }
}
