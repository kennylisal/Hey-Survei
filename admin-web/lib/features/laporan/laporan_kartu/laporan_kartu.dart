import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/laporan/alert_kembali.dart';
import 'package:aplikasi_admin/features/laporan/constanst.dart';
import 'package:aplikasi_admin/features/laporan/laporan_kartu/laporan_kartu_controller.dart';
import 'package:aplikasi_admin/features/laporan/laporan_kartu/laporan_kartu_page_controller.dart';
import 'package:aplikasi_admin/features/laporan/laporan_kartu/laporan_kartu_services.dart';
import 'package:aplikasi_admin/features/laporan/laporan_util.dart';
import 'package:aplikasi_admin/features/laporan/models/laporan_survei_kartu.dart';
import 'package:aplikasi_admin/features/laporan/state/data_kumpulan_jawaban.dart';
import 'package:aplikasi_admin/features/laporan/state/laporan_kartu_controller.dart';
import 'package:aplikasi_admin/features/laporan/state/laporan_utama_controller_kartu.dart';
import 'package:aplikasi_admin/features/laporan/widgets/belum_ada_respon.dart';
import 'package:aplikasi_admin/features/laporan/widgets/button_pilih_chart.dart';
import 'package:aplikasi_admin/features/laporan/widgets/container_kartu_satuan.dart';
import 'package:aplikasi_admin/features/laporan/widgets/container_kartu_utama.dart';
import 'package:aplikasi_admin/features/laporan/widgets/container_x.dart';
import 'package:aplikasi_admin/features/laporan/widgets/container_x_non_foto.dart';
import 'package:aplikasi_admin/features/laporan/widgets/komponen_tab_search.dart';
import 'package:aplikasi_admin/features/laporan/widgets/search_field_email.dart';
import 'package:aplikasi_admin/features/laporan/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HalamanLaporanKartu extends ConsumerStatefulWidget {
  HalamanLaporanKartu({
    super.key,
    required this.idSurvei,
  });
  String idSurvei;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HalamanLaporanKartuState();
}

class _HalamanLaporanKartuState extends ConsumerState<HalamanLaporanKartu> {
  PageLaporanKartuController controllerHalaman = PageLaporanKartuController();
  List<bool> listBoolToggle = [true, false];
  List<String> daftarResponden = [];
  //
  DataLaporanSurveiKartu? dataLaporanSurvei;
  LaporanKartuController? laporanKartuController;
  LaporanUtamaKartuController? laporanUtamaKartuController;
  DataKumpulanJawabanController laporanUtama = DataKumpulanJawabanController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    final dataLaporan = await LaporanKartuServices()
        .getDataLaporanKartu(widget.idSurvei, laporanUtama, controllerHalaman);
    if (dataLaporan != null) {
      if (dataLaporan.listRespon.isEmpty) {
        controllerHalaman.setResponEmpty(true);
      } else {
        laporanUtamaKartuController = LaporanUtamaKartuController(list: []);

        for (var data in dataLaporan.daftarPertanyaanKartu) {
          final pertanyaan = data;
          final mapJawaban = laporanUtama.getState()[data.idSoal]!.dataJawaban;
          final tipeChartAwal = LaporanDataKartuController()
              .penentuanChartAwal(data.dataSoal.tipeSoal);

          Map<String, dynamic> mapCharts = LaporanDataKartuController()
              .mapforCharts(pertanyaan.dataSoal, mapJawaban);
          bool isLegendGambar =
              (pertanyaan.dataSoal.tipeSoal == "Gambar Ganda" ||
                  pertanyaan.dataSoal.tipeSoal == "Carousel");

          final widgetChart = LaporanDataKartuController()
              .generateChart(mapCharts, tipeChartAwal, isLegendGambar);
          final hasil = SoalLaporanUtamaKartu(
            pertanyaanKartu: data,
            dataJawaban: mapJawaban,
            tipeChart: tipeChartAwal,
            tampilanJawaban: widgetChart,
          );

          laporanUtamaKartuController!.tambahData(hasil);
        }
        List<Widget> jawabanTampilan = List.generate(
          dataLaporan.daftarPertanyaanKartu.length,
          (index) => LaporanUtils().generateJawabanLaporan(
            dataLaporan.daftarPertanyaanKartu[index].dataSoal,
            dataLaporan.listRespon.first.daftarJawaban[index],
            context,
          ),
        );

        laporanKartuController = LaporanKartuController(
          userPilihan: dataLaporan.listRespon.first.emailPenjawab,
          listRespon: dataLaporan.listRespon,
          listPertanyaanLaporan: dataLaporan.daftarPertanyaanKartu,
          responPilihan: dataLaporan.listRespon.first,
          pertanyaanTampilan: jawabanTampilan,
        );

        daftarResponden = List.generate(dataLaporan.listRespon.length,
            (index) => dataLaporan.listRespon[index].emailPenjawab);
        controllerHalaman.setIdSurvei(dataLaporan.idSurvei);
        setState(() {});
      }
    }
  }

  List<Widget> generateKontenV2() {
    if (laporanUtamaKartuController == null) {
      return [LoadingBiasa(text: "Memuat Data Laporan")];
    } else {
      if (controllerHalaman.getIsResponEmpty()) {
        return const [BelumAdaRespon()];
      } else {
        if (controllerHalaman.getPage() == PagePilihan.halamanUtama) {
          SoalLaporanUtamaKartu? soalUtamaPilihan =
              controllerHalaman.getSoalPilihan();
          return [
            ...List.generate(laporanUtamaKartuController!.getLength(), (index) {
              String idPilihan = (soalUtamaPilihan == null)
                  ? ""
                  : soalUtamaPilihan!.pertanyaanKartu.idSoal;
              if (laporanUtamaKartuController!
                          .getList()[index]
                          .pertanyaanKartu
                          .urlGambar ==
                      "urlGambar" ||
                  laporanUtamaKartuController!
                          .getList()[index]
                          .pertanyaanKartu
                          .urlGambar ==
                      "") {
                return ContainerKartuXUtamaNonFoto(
                  isSelected: idPilihan ==
                      laporanUtamaKartuController!
                          .getList()[index]
                          .pertanyaanKartu
                          .idSoal,
                  dataPertanyaan: laporanUtamaKartuController!
                      .getList()[index]
                      .pertanyaanKartu,
                  jawaban: laporanUtamaKartuController!
                      .getList()[index]
                      .tampilanJawaban,
                  onPressed: () {
                    setState(() {
                      soalUtamaPilihan =
                          laporanUtamaKartuController!.getList()[index];
                      controllerHalaman.setSoalUtama(soalUtamaPilihan!);
                    });
                  },
                );
              } else if (laporanUtamaKartuController!
                      .getList()[index]
                      .pertanyaanKartu
                      .modelPertanyaan ==
                  "Model X") {
                return ContainerUtamaKartuX(
                  isSelected: idPilihan ==
                      laporanUtamaKartuController!
                          .getList()[index]
                          .pertanyaanKartu
                          .idSoal,
                  dataPertanyaan: laporanUtamaKartuController!
                      .getList()[index]
                      .pertanyaanKartu,
                  jawaban: laporanUtamaKartuController!
                      .getList()[index]
                      .tampilanJawaban,
                  onPressed: () {
                    setState(() {
                      soalUtamaPilihan =
                          laporanUtamaKartuController!.getList()[index];
                      controllerHalaman.setSoalUtama(soalUtamaPilihan!);
                    });
                  },
                );
              } else if (laporanUtamaKartuController!
                      .getList()[index]
                      .pertanyaanKartu
                      .modelPertanyaan ==
                  "Model Y") {
                return ContainerUtamaKartuY(
                  isSelected: idPilihan ==
                      laporanUtamaKartuController!
                          .getList()[index]
                          .pertanyaanKartu
                          .idSoal,
                  dataPertanyaan: laporanUtamaKartuController!
                      .getList()[index]
                      .pertanyaanKartu,
                  jawaban: laporanUtamaKartuController!
                      .getList()[index]
                      .tampilanJawaban,
                  onPressed: () {
                    setState(() {
                      soalUtamaPilihan =
                          laporanUtamaKartuController!.getList()[index];
                      controllerHalaman.setSoalUtama(soalUtamaPilihan!);
                    });
                  },
                );
              } else {
                return ContainerUtamaKartuZ(
                  isSelected: idPilihan ==
                      laporanUtamaKartuController!
                          .getList()[index]
                          .pertanyaanKartu
                          .idSoal,
                  dataPertanyaan: laporanUtamaKartuController!
                      .getList()[index]
                      .pertanyaanKartu,
                  jawaban: laporanUtamaKartuController!
                      .getList()[index]
                      .tampilanJawaban,
                  onPressed: () {
                    setState(() {
                      soalUtamaPilihan =
                          laporanUtamaKartuController!.getList()[index];
                      controllerHalaman.setSoalUtama(soalUtamaPilihan!);
                    });
                  },
                );
              }
            })
          ];
        } else {
          final listTemp = laporanKartuController!.getListPertanyaan();
          return [
            ...List.generate(listTemp.length, (index) {
              String modelPertanyaan = listTemp[index].modelPertanyaan;
              if (listTemp[index].urlGambar == "" ||
                  listTemp[index].urlGambar == "urlGambar") {
                return ContainerXNonKartu(
                  jawaban: laporanKartuController!.getListJawaban()[index],
                  jawabanPertanyaan: laporanKartuController!
                      .getResponPilihan()
                      .daftarJawaban[index],
                  pertanyaanKartu: listTemp[index],
                );
              } else if (modelPertanyaan == "Model X") {
                return ContainerKartuX(
                  jawaban: laporanKartuController!.getListJawaban()[index],
                  jawabanPertanyaan: laporanKartuController!
                      .getResponPilihan()
                      .daftarJawaban[index],
                  pertanyaanKartu: listTemp[index],
                );
              } else if (modelPertanyaan == "Model Y") {
                return ContainerKartuY(
                  jawaban: laporanKartuController!.getListJawaban()[index],
                  jawabanPertanyaan: laporanKartuController!
                      .getResponPilihan()
                      .daftarJawaban[index],
                  pertanyaanKartu: listTemp[index],
                );
              } else {
                return ContainerKartuZ(
                  jawaban: laporanKartuController!.getListJawaban()[index],
                  jawabanPertanyaan: laporanKartuController!
                      .getResponPilihan()
                      .daftarJawaban[index],
                  pertanyaanKartu: listTemp[index],
                );
              }
            })
          ];
        }
      }
    }
  }

  Widget generateTab() {
    if (controllerHalaman.getPage() == PagePilihan.halamanSatuan) {
      return Column(
        children: [
          ContainerPilihan(email: laporanKartuController!.emailUserPilihan()),
          const SizedBox(height: 30),
          Text(
            "Tabel Responden",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          SearchFieldEmail(
            onSubmitted: (value) {
              final listResponden = laporanKartuController!.getListPenjawab();
              setState(() {
                daftarResponden = listResponden
                    .where((element) => element.contains(value))
                    .toList();
              });
            },
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            height: 250,
            decoration: BoxDecoration(
                border: Border.all(width: 1), color: Colors.white),
            child: ListView(
                children: List.generate(
                    daftarResponden.length,
                    (index) => ContainerPilihanResponden(
                          email: daftarResponden[index],
                          onPressed: () {
                            laporanKartuController!.gantiJawabanbyEmail(
                              daftarResponden[index],
                              context,
                            );
                            setState(() {});
                          },
                        ))),
          )
        ],
      );
    } else {
      if (controllerHalaman.getSoalPilihan() == null) {
        return const SizedBox();
      } else {
        final soalUtamaPilihan = controllerHalaman.getSoalPilihan();
        List<TipeCharts> listJenisChart = LaporanUtils().getJenisChartTersdia(
            soalUtamaPilihan!.pertanyaanKartu.dataSoal.tipeSoal);

        return Column(
          children: [
            Text(
              "Potongan Soal",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Text(
                soalUtamaPilihan.pertanyaanKartu.quillController.document
                    .toPlainText(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
                text: TextSpan(
                    text: "Tipe Soal : ",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 16,
                        ),
                    children: [
                  TextSpan(
                    text: soalUtamaPilihan.pertanyaanKartu.dataSoal.tipeSoal,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ])),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 2)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Pilihan Charts",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    for (var e in listJenisChart)
                      ButtonPilihChart(
                        text: e.value,
                        onPressed: () {
                          if (e != soalUtamaPilihan.tipeChart) {
                            laporanUtamaKartuController!.gantiChart(
                                soalUtamaPilihan.pertanyaanKartu.idSoal, e);

                            setState(() {});
                          }
                        },
                        isPicked: e == soalUtamaPilihan.tipeChart,
                      )
                  ]),
            ),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Container(
              width: constraints.maxWidth * 0.24,
              height: double.infinity,
              color: Colors.blueGrey.shade50,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    child: Center(
                      child: InkWell(
                        onTap: () => AlertUtil().showAlertKembali(
                          context: context,
                          pesanBatal: "Batal",
                          pesanLanjut: "Lanjut",
                          pesanUtama: "Anda akan keluar dari halaman Laporan",
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade700,
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            const SizedBox(width: 16),
                            (constraints.maxWidth > 225)
                                ? Text(
                                    "Kembali",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        text: "ID Survei :",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 16,
                                ),
                        children: [
                          TextSpan(
                            text: controllerHalaman.getIdSurvei(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        ]),
                  ),
                  const SizedBox(height: 12),
                  ToggleButtonTab(
                    onPressed: (index) {
                      listBoolToggle = [false, false];
                      listBoolToggle[index] = true;
                      controllerHalaman.gantiHalaman(index);
                      setState(() {});
                    },
                    listBoolToggle: listBoolToggle,
                  ),
                  const SizedBox(height: 18),
                  generateTab()
                ],
              ),
            ),
            Container(
              width: constraints.maxWidth * 0.74,
              height: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      //itu if supaya erbuah kalau
                      width: constraints.maxWidth > 1200
                          ? 900
                          : constraints.maxWidth * 0.8,
                      // color: Color.fromARGB(255, 197, 206, 255),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: generateKontenV2(),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        );
      },
    ));
  }
}

// List<Widget> generateKonten() {
//   if (laporanUtamaKartuController == null) {
//     return [LoadingBiasa(text: "Memuat Data Laporan")];
//   } else {
//     if (controllerHalaman.getIsResponEmpty()) {
//       return const [BelumAdaRespon()];
//     } else {
//       if (controllerHalaman.getPage() == PagePilihan.halamanUtama) {
//         print("ini getSoalPilihan => ${controllerHalaman.getSoalPilihan()}");
//         SoalLaporanUtamaKartu? soalUtamaPilihan =
//             controllerHalaman.getSoalPilihan();

//         return [
//           ...List.generate(laporanUtamaKartuController!.getLength(), (index) {
//             String idPilihan = (soalUtamaPilihan == null)
//                 ? ""
//                 : soalUtamaPilihan!.pertanyaanKartu.idSoal;
//             if (soalUtamaPilihan!.pertanyaanKartu.urlGambar == "urlGambar" ||
//                 soalUtamaPilihan!.pertanyaanKartu.urlGambar == "") {
//               return ContainerKartuXUtamaNonFoto(
//                 isSelected: idPilihan ==
//                     laporanUtamaKartuController!
//                         .getList()[index]
//                         .pertanyaanKartu
//                         .idSoal,
//                 dataPertanyaan: laporanUtamaKartuController!
//                     .getList()[index]
//                     .pertanyaanKartu,
//                 jawaban: laporanUtamaKartuController!
//                     .getList()[index]
//                     .tampilanJawaban,
//                 onPressed: () {
//                   setState(() {
//                     soalUtamaPilihan =
//                         laporanUtamaKartuController!.getList()[index];
//                     controllerHalaman.setSoalUtama(soalUtamaPilihan!);
//                   });
//                 },
//               );
//             } else if (soalUtamaPilihan!.pertanyaanKartu.modelPertanyaan ==
//                 "Model X") {
//               return ContainerUtamaKartuX(
//                 isSelected: idPilihan ==
//                     laporanUtamaKartuController!
//                         .getList()[index]
//                         .pertanyaanKartu
//                         .idSoal,
//                 dataPertanyaan: laporanUtamaKartuController!
//                     .getList()[index]
//                     .pertanyaanKartu,
//                 jawaban: laporanUtamaKartuController!
//                     .getList()[index]
//                     .tampilanJawaban,
//                 onPressed: () {
//                   setState(() {
//                     soalUtamaPilihan =
//                         laporanUtamaKartuController!.getList()[index];
//                     controllerHalaman.setSoalUtama(soalUtamaPilihan!);
//                   });
//                 },
//               );
//             } else if (soalUtamaPilihan!.pertanyaanKartu.modelPertanyaan ==
//                 "Model Y") {
//               return ContainerUtamaKartuY(
//                 isSelected: idPilihan ==
//                     laporanUtamaKartuController!
//                         .getList()[index]
//                         .pertanyaanKartu
//                         .idSoal,
//                 dataPertanyaan: laporanUtamaKartuController!
//                     .getList()[index]
//                     .pertanyaanKartu,
//                 jawaban: laporanUtamaKartuController!
//                     .getList()[index]
//                     .tampilanJawaban,
//                 onPressed: () {
//                   setState(() {
//                     soalUtamaPilihan =
//                         laporanUtamaKartuController!.getList()[index];
//                     controllerHalaman.setSoalUtama(soalUtamaPilihan!);
//                   });
//                 },
//               );
//             } else {
//               return ContainerUtamaKartuZ(
//                 isSelected: idPilihan ==
//                     laporanUtamaKartuController!
//                         .getList()[index]
//                         .pertanyaanKartu
//                         .idSoal,
//                 dataPertanyaan: laporanUtamaKartuController!
//                     .getList()[index]
//                     .pertanyaanKartu,
//                 jawaban: laporanUtamaKartuController!
//                     .getList()[index]
//                     .tampilanJawaban,
//                 onPressed: () {
//                   setState(() {
//                     soalUtamaPilihan =
//                         laporanUtamaKartuController!.getList()[index];
//                     controllerHalaman.setSoalUtama(soalUtamaPilihan!);
//                   });
//                 },
//               );
//             }

//             //disini bikin container utama X Y Z
//           })
//         ];
//       } else {
//         final listTemp = laporanKartuController!.getListPertanyaan();
//         return [
//           ...List.generate(listTemp.length, (index) {
//             String modelPertanyaan = listTemp[index].modelPertanyaan;
//             if (listTemp[index].urlGambar == "" ||
//                 listTemp[index].urlGambar == "urlGambar") {
//               return ContainerXNonKartu(
//                 jawaban: laporanKartuController!.getListJawaban()[index],
//                 jawabanPertanyaan: laporanKartuController!
//                     .getResponPilihan()
//                     .daftarJawaban[index],
//                 pertanyaanKartu: listTemp[index],
//               );
//             } else if (modelPertanyaan == "Model X") {
//               return ContainerKartuX(
//                 jawaban: laporanKartuController!.getListJawaban()[index],
//                 jawabanPertanyaan: laporanKartuController!
//                     .getResponPilihan()
//                     .daftarJawaban[index],
//                 pertanyaanKartu: listTemp[index],
//               );
//             } else if (modelPertanyaan == "Model Y") {
//               return ContainerKartuY(
//                 jawaban: laporanKartuController!.getListJawaban()[index],
//                 jawabanPertanyaan: laporanKartuController!
//                     .getResponPilihan()
//                     .daftarJawaban[index],
//                 pertanyaanKartu: listTemp[index],
//               );
//             } else {
//               return ContainerKartuZ(
//                 jawaban: laporanKartuController!.getListJawaban()[index],
//                 jawabanPertanyaan: laporanKartuController!
//                     .getResponPilihan()
//                     .daftarJawaban[index],
//                 pertanyaanKartu: listTemp[index],
//               );
//             }
//           })
//         ];
//       }
//     }
//   }
// }
