import 'package:aplikasi_admin/features/laporan/chart_widgets/legend_text_chart.dart';
import 'package:aplikasi_admin/features/laporan/models/chart_data_string.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PyramidChart extends StatelessWidget {
  const PyramidChart({
    Key? key,
    required this.chartData,
    required this.isLegendGambar,
  }) : super(key: key);
  final List<ChartData> chartData;
  final bool isLegendGambar;
  @override
  Widget build(BuildContext context) {
    return SfPyramidChart(
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
              )),
      series: PyramidSeries<ChartData, String>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(
          builder: (data, point, series, pointIndex, seriesIndex) {
            return Text(
              (data.y != 0) ? "${data.y}" : "",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
            );
          },
          isVisible: true,
          overflowMode: OverflowMode.trim,
          textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
        ),
      ),
    );
  }
}
