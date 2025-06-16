import 'package:flutter/material.dart';
import 'package:hei_survei/features/laporan/chart_widgets/container_legend_gambar.dart';

class ContainerLegendChart extends StatelessWidget {
  ContainerLegendChart(
      {super.key,
      required this.isLegendGambar,
      required this.legendText,
      required this.point,
      required this.series,
      required this.color});
  final bool isLegendGambar;
  final dynamic series;
  final dynamic point;
  final String legendText;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Row(
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
              // color: series.renderPoints[point.index].color,
            ),
            margin: const EdgeInsets.only(right: 8),
          ),
          (!isLegendGambar)
              ? Text(
                  legendText,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 18,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                )
              : GambarLegendChart(urlGambar: legendText),
        ],
      ),
    );
  }
}
