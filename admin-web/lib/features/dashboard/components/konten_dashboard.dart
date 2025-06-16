import 'package:aplikasi_admin/app/app.dart';
import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/features/dashboard/components/konten_table.dart';
import 'package:aplikasi_admin/features/dashboard/components/tambahan_grafik.dart';
import 'package:aplikasi_admin/features/dashboard/controller.dart';
import 'package:aplikasi_admin/features/master_component/container_laporang_singkat.dart';
import 'package:aplikasi_admin/features/master_component/loading_tengah.dart';
import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:aplikasi_admin/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class TombolEksperimen extends ConsumerWidget {
  const TombolEksperimen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          ref
              .read(dataUtamaProvider.notifier)
              .siapkanDataPublish("6c8a69e6", "klasik");
          context.goNamed(RouterConstant.publishSurvei);
        },
        child: Text("Kil"));
  }
}

class DashboardKonten extends StatefulWidget {
  DashboardKonten({
    super.key,
    required this.constraints,
  });

  BoxConstraints constraints;

  @override
  State<DashboardKonten> createState() => _DashboardKontenState();
}

class _DashboardKontenState extends State<DashboardKonten> {
  //data atas
  int jmlSurveiAktif = -1;
  int jmlUserAktif = -1;
  int jmlPembelianSurvei = -1;
  int jmlPengisianSurvei = -1;
  //
  //data Grafik
  int jumlahKeuntungan = -1;
  int jumlahPublishedBulanIni = -1;
  // int jumlahSurveiTerbanned = -1;
  int jumlahKeuntunganOrder = -1;
  int jmlJan = -1;
  int jmlFeb = -1;
  int jmlMar = -1;
  int jmlApr = -1;
  List<ChartData> chartData = [];
  List<SurveiData> surveiTerbaru = [];
  //
  @override
  void initState() {
    Future(() async {
      jumlahKeuntungan = await DashboardController().getKeuntunganTotal();
      jumlahKeuntunganOrder = await DashboardController().getKeuntunganOrder();
      // jumlahSurveiTerbanned =
      //     await DashboardController().getJumlahSurveiBanned();
      jmlPembelianSurvei = await DashboardController().getJumlahSurveiTerbeli();
      jmlPengisianSurvei =
          await DashboardController().getJumlahSurveiTerjawab();
      jumlahPublishedBulanIni =
          await DashboardController().getPublishedBulan(6);
      jmlJan = await DashboardController().getPublishedBulan(3);
      jmlFeb = await DashboardController().getPublishedBulan(4);
      jmlMar = await DashboardController().getPublishedBulan(5);
      jmlApr = await DashboardController().getPublishedBulan(6);
      chartData = [
        ChartData(DateTime(2015, 4, 1), jmlJan.toDouble()),
        ChartData(DateTime(2015, 5, 1), jmlFeb.toDouble()),
        ChartData(DateTime(2015, 6, 1), jmlMar.toDouble()),
        ChartData(DateTime(2015, 7, 1), jmlApr.toDouble()),
      ];
      surveiTerbaru = await DashboardController().getSurveiTerbaru();

      jmlSurveiAktif = await DashboardController().getJumlahSurveiAktif();
      jmlUserAktif = await DashboardController().getJumlahUserAktif();

      setState(() {});
    });
    super.initState();
  }

  final List<DataLaporanSingkat> listDataLaporanSingkat = [
    DataLaporanSingkat(
      bgColor: Colors.pink.shade100.withOpacity(0.6),
      borderColor: Colors.pinkAccent.shade400,
      lokasiFoto: 'assets/s-aktif.png',
    ),
    DataLaporanSingkat(
      bgColor: Colors.amber.shade100.withOpacity(0.6),
      borderColor: Colors.amberAccent.shade400,
      lokasiFoto: 'assets/users.png',
    ),
    DataLaporanSingkat(
      bgColor: Colors.cyan.shade100.withOpacity(0.6),
      borderColor: Colors.cyanAccent.shade400,
      lokasiFoto: 'assets/checkout.png',
    ),
    DataLaporanSingkat(
      bgColor: Colors.purple.shade100.withOpacity(0.6),
      borderColor: Colors.purpleAccent.shade400,
      lokasiFoto: 'assets/list.png',
    ),
  ];

  Widget generateLaporanSingkat(int x, int y, int z, int l) {
    return SizedBox();
  }

  Widget generateLaporanTengahChart() {
    return Container(
      width: widget.constraints.maxWidth * 1,
      height: 460,
      margin: const EdgeInsets.only(bottom: 40, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 12,
              child: SfCartesianChart(
                  title: ChartTitle(
                    text: "Grafik Penerbitan Survei",
                    textStyle:
                        Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: Colors.blue.shade400,
                              fontSize: 19,
                            ),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                      text: "Jumlah Survei Terbit",
                      textStyle:
                          Theme.of(context).textTheme.displayLarge!.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                              ),
                    ),
                    labelStyle:
                        Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  primaryXAxis: DateTimeCategoryAxis(
                    title: AxisTitle(
                      text: "4 Bulan Terakhir",
                      textStyle:
                          Theme.of(context).textTheme.displayLarge!.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                                //fontWeight: FontWeight.bold,
                              ),
                    ),
                    labelStyle:
                        Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  series: <CartesianSeries<ChartData, DateTime>>[
                    // Renders Column chart
                    ColumnSeries<ChartData, DateTime>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.blue,
                    )
                  ])),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TambahanGrafik(
                judul: "Total Penghasilan Penerbitan Survei :",
                kontenAngka: CurrencyFormat.convertToIdr(jumlahKeuntungan, 2),
                warnaKotak: Colors.greenAccent.shade100,
              ),
              TambahanGrafik(
                judul: "Jumlah Keuntungan Pembelian Survei",
                kontenAngka:
                    CurrencyFormat.convertToIdr(jumlahKeuntunganOrder, 2),
                warnaKotak: Colors.lightBlue.shade200,
              ),
              TambahanGrafik(
                judul: "Jumlah Survei Diterbitkan Bulan ini : ",
                kontenAngka: jumlahPublishedBulanIni.toString(),
                warnaKotak: Colors.indigo.shade100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget generateKontenDashboard() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Dashboard",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Laporan Singkat",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 36,
                ),
          ),
          generateLaporanSingkat(jmlSurveiAktif, jmlUserAktif,
              jmlPembelianSurvei, jmlPengisianSurvei),
          Text(
            "Laporan Grafik",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 36,
                ),
          ),
          generateLaporanTengahChart(),
          Text(
            "Penerbitan Survei Terbaru",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 36,
                ),
          ),
          Container(
            width: widget.constraints.maxWidth * 1,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: KontenTableDashboard(listSurvei: surveiTerbaru),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (jmlUserAktif == -1)
        ? LoadingTengah()
        : Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Dashboard",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Laporan Singkat",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 36,
                      ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    KotakLaporanSingkat(
                      dataLaporanSingkat: listDataLaporanSingkat[0],
                      isBesar: widget.constraints.maxWidth > 1400,
                      text: "Survei Aktif",
                      angka: jmlSurveiAktif + 6,
                    ),
                    const Spacer(),
                    KotakLaporanSingkat(
                      dataLaporanSingkat: listDataLaporanSingkat[1],
                      isBesar: widget.constraints.maxWidth > 1400,
                      text: "Jumlah Pengguna",
                      angka: jmlUserAktif,
                    ),
                    const Spacer(),
                    KotakLaporanSingkat(
                      dataLaporanSingkat: listDataLaporanSingkat[2],
                      isBesar: widget.constraints.maxWidth > 1400,
                      text: "Survei Terbeli",
                      angka: jmlPembelianSurvei,
                    ),
                    const Spacer(),
                    KotakLaporanSingkat(
                      dataLaporanSingkat: listDataLaporanSingkat[3],
                      isBesar: widget.constraints.maxWidth > 1400,
                      text: "Survei Diselesaikan",
                      angka: jmlPengisianSurvei,
                    ),
                    const Spacer(),
                    //KotakDataKecil()
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  "Laporan Grafik",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 36,
                      ),
                ),
                Container(
                  width: widget.constraints.maxWidth * 1,
                  height: 460,
                  margin: const EdgeInsets.only(bottom: 40, top: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 12,
                          child: SfCartesianChart(
                              title: ChartTitle(
                                text: "Grafik Penerbitan Survei",
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Colors.blue.shade400,
                                      fontSize: 19,
                                    ),
                              ),
                              primaryYAxis: NumericAxis(
                                title: AxisTitle(
                                  text: "Jumlah Survei Terbit",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 18,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                ),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              primaryXAxis: DateTimeCategoryAxis(
                                title: AxisTitle(
                                  text: "4 Bulan Terakhir",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 18,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                ),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              series: <CartesianSeries<ChartData, DateTime>>[
                                // Renders Column chart
                                ColumnSeries<ChartData, DateTime>(
                                  dataSource: chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  color: Colors.blue,
                                )
                              ])),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TambahanGrafik(
                            judul: "Total Penghasilan Penerbitan Survei :",
                            kontenAngka: CurrencyFormat.convertToIdr(
                                jumlahKeuntungan, 2),
                            warnaKotak: Colors.greenAccent.shade100,
                          ),
                          TambahanGrafik(
                            judul: "Jumlah Keuntungan Pembelian Survei",
                            kontenAngka: CurrencyFormat.convertToIdr(
                                jumlahKeuntunganOrder, 2),
                            warnaKotak: Colors.lightBlue.shade200,
                          ),
                          TambahanGrafik(
                            judul: "Jumlah Survei Diterbitkan Bulan ini : ",
                            kontenAngka: jumlahPublishedBulanIni.toString(),
                            warnaKotak: Colors.indigo.shade100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  "Penerbitan Survei Terbaru",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 36,
                      ),
                ),
                Container(
                  width: widget.constraints.maxWidth * 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: KontenTableDashboard(listSurvei: surveiTerbaru),
                ),
              ],
            ),
          );
  }
}
