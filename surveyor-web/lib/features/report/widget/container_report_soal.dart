// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/laporan/models/chart_data_angka.dart';
import 'package:hei_survei/features/laporan/models/chart_data_string.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:hei_survei/features/report/state/controller_report.dart';
import 'package:hei_survei/features/report/state/controller_soal_report.dart';
import 'package:hei_survei/features/report/widget/pertanyaan_soal.dart';

class ContainerReportSoal extends ConsumerStatefulWidget {
  const ContainerReportSoal({
    required this.idForm,
  });
  final String idForm;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContainerSoalReportState();
}

class _ContainerSoalReportState extends ConsumerState<ContainerReportSoal> {
  @override
  Widget build(BuildContext context) {
    final controllerReport = ControllerReport(idForm: "idForm");
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          for (final controllerSoal in controllerReport.getListController()!)
            ReportSoal(controller: controllerSoal),
        ],
      ),
    );
  }
}

class ReportSoal extends ConsumerStatefulWidget {
  const ReportSoal({
    required this.controller,
  });
  final ControllerSoalReport controller;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportSoalState();
}

class _ReportSoalState extends ConsumerState<ReportSoal> {
  final List<ChartData> chartData = [
    // ChartData('David', 25, Colors.black),
    // ChartData('Steve', 38, Colors.blue),
    // ChartData('Jack', 34, Colors.purple),
    // ChartData('Others', 52, Colors.green)
    ChartData('David', 25),
    ChartData('Steve', 38),
    ChartData('Jack', 34),
    ChartData('Others', 52)
  ];

  final List<ChartDataAngka> chartDataAngka = [
    ChartDataAngka(2010, 32),
    ChartDataAngka(2011, 40),
    ChartDataAngka(2012, 34),
    ChartDataAngka(2013, 52),
    ChartDataAngka(2014, 42),
    ChartDataAngka(2015, 38),
    ChartDataAngka(2016, 41),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 3, color: Colors.purple),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pertanyaan",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "non - Wajib",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: PertanyaanQuill(
                            quillController: QuillController(
                                document: Document.fromDelta(
                                    widget.controller.getDocumentPertanyaan()),
                                selection:
                                    const TextSelection.collapsed(offset: 0))),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: 240,
                          height: 135,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 2,
                            color: Colors.black,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 350,
                  margin: const EdgeInsets.only(left: 20),
                  width: double.infinity,
                  child: Row(
                    children: [
                      // Flexible(
                      //   flex: 1,
                      //   child: Container(
                      //     height: 200,
                      //     decoration:
                      //         BoxDecoration(border: Border.all(width: 2)),
                      //   ),
                      // ),
                      // Flexible(
                      //     flex: 3,
                      //     child: LineChart(
                      //         chartData: chartDataAngka,
                      //         isLegendVisible: false))
                      // Flexible(
                      //   flex: 3,
                      //   child: PyramidChart(
                      //     chartData: chartData,
                      //     isLegendVisible: true,
                      //   ),
                      // ),
                      // Flexible(
                      //     flex: 3,
                      //     child: LineChart(
                      //         chartData: chartDataAngka,
                      //         isLegendVisible: false))
                      // Flexible(
                      //     flex: 3,
                      //     child: PieChart(
                      //       chartData: chartData,
                      //       isLegendVisible: true,
                      //     ))
                    ],
                  ),
                ),
                Text(
                  "Jumlah Partisipan : 30",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// class ChartData {
//   ChartData(
//     this.x,
//     this.y,
//     this.color,
//   );
//   final String x;
//   final double y;
//   Color? color;
// }

// class ChartDataAngka {
//   ChartDataAngka(this.x, this.y);
//   final int x;
//   final int y;
// }

// class PieChart extends StatelessWidget {
//   const PieChart({
//     Key? key,
//     required this.chartData,
//     required this.isLegendVisible,
//   }) : super(key: key);
//   final List<ChartData> chartData;
//   final bool isLegendVisible;
//   @override
//   Widget build(BuildContext context) {
//     return SfCircularChart(
//         legend: Legend(
//             isVisible: isLegendVisible,
//             textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   overflow: TextOverflow.ellipsis,
//                 )),
//         series: <CircularSeries>[
//           // Render pie chart
//           PieSeries<ChartData, String>(
//               dataSource: chartData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               dataLabelMapper: (ChartData data, _) =>
//                   (isLegendVisible) ? "${data.y}" : "${data.x} \n ${data.y}",
//               dataLabelSettings: DataLabelSettings(
//                   isVisible: true,
//                   textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                         overflow: TextOverflow.ellipsis,
//                       ))),
//         ]);
//   }
// }

// class DonutChart extends StatelessWidget {
//   const DonutChart({
//     Key? key,
//     required this.chartData,
//     required this.isLegendVisible,
//   }) : super(key: key);
//   final List<ChartData> chartData;
//   final bool isLegendVisible;
//   @override
//   Widget build(BuildContext context) {
//     return SfCircularChart(
//       legend: Legend(
//           isVisible: isLegendVisible,
//           textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 overflow: TextOverflow.ellipsis,
//               )),
//       series: [
//         DoughnutSeries<ChartData, String>(
//           dataSource: chartData,
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.y,
//           dataLabelMapper: (ChartData data, _) =>
//               (isLegendVisible) ? "${data.y}" : "${data.x} \n ${data.y}",
//           dataLabelSettings: DataLabelSettings(
//             isVisible: true,
//             textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class PyramidChart extends StatelessWidget {
//   const PyramidChart({
//     Key? key,
//     required this.chartData,
//     required this.isLegendVisible,
//   }) : super(key: key);
//   final List<ChartData> chartData;
//   final bool isLegendVisible;
//   @override
//   Widget build(BuildContext context) {
//     return SfPyramidChart(
//       legend: Legend(
//           isVisible: isLegendVisible,
//           textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 overflow: TextOverflow.ellipsis,
//               )),
//       series: PyramidSeries<ChartData, String>(
//         dataSource: chartData,
//         xValueMapper: (ChartData data, _) => data.x,
//         yValueMapper: (ChartData data, _) => data.y,
//         dataLabelSettings: DataLabelSettings(
//           builder: (data, point, series, pointIndex, seriesIndex) {
//             return (isLegendVisible)
//                 ? Text(
//                     "${data.y}",
//                     style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                   )
//                 : Text(
//                     "${data.x} \n ${data.y}",
//                     style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                   );
//           },
//           isVisible: true,
//           overflowMode: OverflowMode.trim,
//           textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 overflow: TextOverflow.ellipsis,
//               ),
//         ),
//       ),
//     );
//   }
// }

// class FunnelChart extends StatelessWidget {
//   const FunnelChart({
//     super.key,
//     required this.chartData,
//     required this.isLegendVisible,
//   });
//   final List<ChartData> chartData;
//   final bool isLegendVisible;
//   @override
//   Widget build(BuildContext context) {
//     return SfFunnelChart(
//       legend: Legend(
//           isVisible: isLegendVisible,
//           textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 overflow: TextOverflow.ellipsis,
//               )),
//       series: FunnelSeries<ChartData, String>(
//           dataSource: chartData,
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.y,
//           dataLabelSettings: DataLabelSettings(
//             builder: (data, point, series, pointIndex, seriesIndex) {
//               return Text(data.x);
//             },
//             isVisible: true,
//             overflowMode: OverflowMode.trim,
//             textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//           )),
//     );
//   }
// }

// class LineChart extends StatelessWidget {
//   const LineChart({
//     super.key,
//     required this.chartData,
//     required this.isLegendVisible,
//   });
//   final List<ChartDataAngka> chartData;
//   final bool isLegendVisible;
//   @override
//   Widget build(BuildContext context) {
//     return SfCartesianChart(
//       series: <ChartSeries>[
//         LineSeries<ChartDataAngka, int>(
//           dataSource: chartData,
//           xValueMapper: (ChartDataAngka data, _) => data.x,
//           yValueMapper: (ChartDataAngka data, _) => data.y,
//         )
//       ],
//     );
//   }
// }
