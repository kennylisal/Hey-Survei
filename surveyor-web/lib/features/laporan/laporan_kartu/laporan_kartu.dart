import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/app/widgets/header_non_main.dart';
import 'package:hei_survei/features/laporan/alert_kembali.dart';
import 'package:hei_survei/features/laporan/constanst.dart';
import 'package:hei_survei/features/laporan/error_idsurvei.dart';
import 'package:hei_survei/features/laporan/laporan_kartu/laporan_kartu_controller.dart';
import 'package:hei_survei/features/laporan/laporan_kartu/laporan_kartu_page_controller.dart';
import 'package:hei_survei/features/laporan/laporan_kartu/laporan_kartu_services.dart';
import 'package:hei_survei/features/laporan/laporan_util.dart';
import 'package:hei_survei/features/laporan/models/laporan_survei_kartu.dart';
import 'package:hei_survei/features/laporan/models/pertanyaan_survei.dart';
import 'package:hei_survei/features/laporan/state/data_kumpulan_jawaban.dart';
import 'package:hei_survei/features/laporan/state/laporan_kartu_controller.dart';
import 'package:hei_survei/features/laporan/state/laporan_utama_controller_kartu.dart';
import 'package:hei_survei/features/laporan/widgets/belum_ada_respon.dart';
import 'package:hei_survei/features/laporan/widgets/button_pilih_chart.dart';
import 'package:hei_survei/features/laporan/widgets/container_kartu_satuan.dart';
import 'package:hei_survei/features/laporan/widgets/container_kartu_utama.dart';
import 'package:hei_survei/features/laporan/widgets/container_x.dart';
import 'package:hei_survei/features/laporan/widgets/container_x_non_foto.dart';
import 'package:hei_survei/features/laporan/widgets/komponen_tab_search.dart';
import 'package:hei_survei/features/laporan/widgets/pembatas_cabang.dart';
import 'package:hei_survei/features/laporan/widgets/search_field_email.dart';
import 'package:hei_survei/features/laporan/widgets/toggle_button.dart';
import 'package:hei_survei/features/laporan/widgets/tombol_excel.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:excel/excel.dart' hide Border;

class ContainerLaporanKartu extends StatefulWidget {
  ContainerLaporanKartu({
    super.key,
    required this.idSurvei,
  });
  String idSurvei;
  @override
  State<ContainerLaporanKartu> createState() => _ContainerLaporanKartuState();
}

class _ContainerLaporanKartuState extends State<ContainerLaporanKartu> {
  bool isIdElligible = false;
  bool selesaiLoading = false;

  Future<bool> cekExistSurvei(String idSurvei) async {
    try {
      bool hasil = false;
      final surveiRef =
          FirebaseFirestore.instance.collection('h_survei').doc(idSurvei);

      await surveiRef.get().then((value) {
        if (value.exists) {
          hasil = true;
        }
      }).onError((error, stackTrace) {
        log(error.toString());
      });
      return hasil;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Widget contentGenerator() {
    if (selesaiLoading) {
      if (isIdElligible) {
        return HalamanLaporanKartu(idSurvei: widget.idSurvei);
      } else {
        return const ErrorIdSurvei();
      }
    } else {
      return LoadingBiasa(
        text: "Memuat Data Survei",
        pakaiKembali: false,
      );
    }
  }

  initPengecekan() async {
    isIdElligible = await cekExistSurvei(widget.idSurvei);
    selesaiLoading = true;
    setState(() {});
  }

  @override
  void initState() {
    initPengecekan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: HeaderNonMain(),
      ),
      body: contentGenerator(),
    );
  }
}

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
  LaporanKartuController? laporanKartuControllerCabang;
  LaporanUtamaKartuController? laporanUtamaKartuController;
  LaporanUtamaKartuController? laporanCabangKartuController;
  DataKumpulanJawabanController laporanUtama = DataKumpulanJawabanController();
  DataKumpulanJawabanController laporanCabang = DataKumpulanJawabanController();
  PenghitungSoalController penghitungSoalController =
      PenghitungSoalController();

  String judulSurvei = "";
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    final dataLaporan = await LaporanKartuServices().getDataLaporanKartu(
        widget.idSurvei,
        laporanUtama,
        laporanCabang,
        controllerHalaman,
        penghitungSoalController);
    // print("selesai kumpul data form kartu");
    if (dataLaporan != null) {
      print("masuk non null");
      if (dataLaporan.listRespon.isEmpty) {
        print("masuk jawaban kosong");
        controllerHalaman.setResponEmpty(true);
        setState(() {});
      } else {
        laporanUtamaKartuController = LaporanUtamaKartuController(list: []);
        laporanCabangKartuController = LaporanUtamaKartuController(list: []);

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

          // if (data.dataSoal.tipeSoal == "Gambar Ganda" ||
          //     data.dataSoal.tipeSoal == "Carousel") {
          //   print(mapCharts);
          // }
          if (data.dataSoal.tipeSoal == "Pilihan Ganda") {
            print(mapCharts);
          }
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

        for (var data in dataLaporan.daftarPertanyaanKartuCabang) {
          final pertanyaan = data;
          final mapJawaban = laporanCabang.getState()[data.idSoal]!.dataJawaban;
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
          laporanCabangKartuController!.tambahData(hasil);
        }

        List<Widget> jawabanTampilan = List.generate(
          dataLaporan.daftarPertanyaanKartu.length,
          (index) => LaporanUtils().generateJawabanLaporan(
            dataLaporan.daftarPertanyaanKartu[index].dataSoal,
            dataLaporan.listRespon.first.daftarJawaban[index],
            context,
          ),
        );

        List<Widget> jawabanTampilanCabang = List.generate(
            dataLaporan.daftarPertanyaanKartuCabang.length,
            (index) => LaporanUtils().generateJawabanLaporan(
                dataLaporan.daftarPertanyaanKartuCabang[index].dataSoal,
                dataLaporan.listResponCabang.first.daftarJawaban[index],
                context));

        laporanKartuController = LaporanKartuController(
          userPilihan: dataLaporan.listRespon.first.emailPenjawab,
          listRespon: dataLaporan.listRespon,
          listPertanyaanLaporan: dataLaporan.daftarPertanyaanKartu,
          responPilihan: dataLaporan.listRespon.first,
          pertanyaanTampilan: jawabanTampilan,
        );

        laporanKartuControllerCabang = LaporanKartuController(
            userPilihan: dataLaporan.listResponCabang.first.emailPenjawab,
            listRespon: dataLaporan.listResponCabang,
            listPertanyaanLaporan: dataLaporan.daftarPertanyaanKartuCabang,
            responPilihan: dataLaporan.listResponCabang.first,
            pertanyaanTampilan: jawabanTampilanCabang);

        daftarResponden = List.generate(dataLaporan.listRespon.length,
            (index) => dataLaporan.listRespon[index].emailPenjawab);
        controllerHalaman.setIdSurvei(dataLaporan.idSurvei);
        judulSurvei = dataLaporan.judul;
        setState(() {});
        print("selesai init data");
      }
    }
  }

  List<Widget> generateKontenV2() {
    if (laporanUtamaKartuController == null) {
      if (controllerHalaman.getIsResponEmpty()) {
        return const [BelumAdaRespon()];
      } else {
        return [
          LoadingBiasa(
            text: "Memuat Data Laporan",
            pakaiKembali: false,
          )
        ];
      }
    } else {
      if (controllerHalaman.getIsResponEmpty()) {
        return const [BelumAdaRespon()];
      } else {
        if (controllerHalaman.getPage() == PagePilihan.halamanUtama) {
          SoalLaporanUtamaKartu? soalUtamaPilihan =
              controllerHalaman.getSoalPilihan();
          SoalLaporanUtamaKartu? soalUtamaCabang =
              controllerHalaman.getSoalPilihanCabang();
          return [
            ...List.generate(
              laporanUtamaKartuController!.getLength(),
              (index) {
                String idPilihan = (soalUtamaPilihan == null)
                    ? ""
                    : soalUtamaPilihan.pertanyaanKartu.idSoal;
                return generateSoalUtama(index, idPilihan, soalUtamaPilihan,
                    laporanUtamaKartuController!, false);
              },
            ),
            //generate soal cabang -- tambah seluruh cabang disini
            if (laporanCabangKartuController!.getLength() != 0)
              const PembatasCabang(),
            ...List.generate(laporanCabangKartuController!.getLength(),
                (index) {
              String idPilihanCabang = (soalUtamaCabang == null)
                  ? ""
                  : soalUtamaCabang.pertanyaanKartu.idSoal;
              return generateSoalUtama(
                index,
                idPilihanCabang,
                soalUtamaCabang,
                laporanCabangKartuController!,
                true,
              );
            })
          ];
        } else {
          final listTemp = laporanKartuController!.getListPertanyaan();
          final listCabang = laporanKartuControllerCabang!.getListPertanyaan();
          return [
            ...List.generate(listTemp.length, (index) {
              String modelPertanyaan = listTemp[index].modelPertanyaan;
              return generateSoalKartuSatuan(listTemp[index], modelPertanyaan,
                  index, laporanKartuController!, false);
            }),
            //generate soal cabang -- tambah seluruh cabang disini
            if (laporanCabangKartuController!.getLength() != 0)
              const PembatasCabang(),
            ...List.generate(listCabang.length, (index) {
              String modelPertanyaan = listCabang[index].modelPertanyaan;
              return generateSoalKartuSatuan(listCabang[index], modelPertanyaan,
                  index, laporanKartuControllerCabang!, true);
            })
          ];
        }
      }
    }
  }

  Widget generateSoalKartuSatuan(
    PertanyaanKartu pertanyaan,
    String modelPertanyaan,
    int index,
    LaporanKartuController laporanKartuController,
    bool isCabang,
  ) {
    if (pertanyaan.urlGambar == "" || pertanyaan.urlGambar == "urlGambar") {
      return ContainerXNonKartu(
        jawaban: laporanKartuController.getListJawaban()[index],
        jawabanPertanyaan:
            laporanKartuController.getResponPilihan().daftarJawaban[index],
        pertanyaanKartu: pertanyaan,
        isCabang: isCabang,
        totalSoal: penghitungSoalController.getNilai(),
        index: (index + 1),
      );
    } else if (modelPertanyaan == "Model X") {
      return ContainerKartuX(
        jawaban: laporanKartuController.getListJawaban()[index],
        jawabanPertanyaan:
            laporanKartuController.getResponPilihan().daftarJawaban[index],
        pertanyaanKartu: pertanyaan,
        isCabang: isCabang,
        totalSoal: penghitungSoalController.getNilai(),
        index: (index + 1),
      );
    } else if (modelPertanyaan == "Model Y") {
      return ContainerKartuY(
        jawaban: laporanKartuController.getListJawaban()[index],
        jawabanPertanyaan:
            laporanKartuController.getResponPilihan().daftarJawaban[index],
        pertanyaanKartu: pertanyaan,
        isCabang: isCabang,
        totalSoal: penghitungSoalController.getNilai(),
        index: (index + 1),
      );
    } else {
      return ContainerKartuZ(
        jawaban: laporanKartuController.getListJawaban()[index],
        jawabanPertanyaan:
            laporanKartuController.getResponPilihan().daftarJawaban[index],
        pertanyaanKartu: pertanyaan,
        isCabang: isCabang,
        totalSoal: penghitungSoalController.getNilai(),
        index: (index + 1),
      );
    }
  }

  Widget generateSoalUtama(
    int index,
    String idPilihan,
    SoalLaporanUtamaKartu? soalUtamaPilihan,
    LaporanUtamaKartuController laporanUtamaKartuController,
    bool isCabang,
  ) {
    bool isSelected = idPilihan ==
        laporanUtamaKartuController.getList()[index].pertanyaanKartu.idSoal;
    if (isCabang) print(idPilihan);
    if (laporanUtamaKartuController
                .getList()[index]
                .pertanyaanKartu
                .urlGambar ==
            "urlGambar" ||
        laporanUtamaKartuController
                .getList()[index]
                .pertanyaanKartu
                .urlGambar ==
            "") {
      return ContainerKartuXUtamaNonFoto(
        isSelected: isSelected,
        dataPertanyaan:
            laporanUtamaKartuController.getList()[index].pertanyaanKartu,
        jawaban: laporanUtamaKartuController.getList()[index].tampilanJawaban,
        onPressed: () {
          setState(() {
            if (isCabang) {
              print("masuk cabang");
              soalUtamaPilihan = laporanCabangKartuController!.getList()[index];
              print(soalUtamaPilihan!.pertanyaanKartu.dataSoal.idSoal);
              controllerHalaman.setSoalCabang(soalUtamaPilihan!);
            } else {
              soalUtamaPilihan = laporanUtamaKartuController.getList()[index];
              controllerHalaman.setSoalUtama(soalUtamaPilihan!);
            }
          });
        },
        isCabang: isCabang,
        totalSoal: penghitungSoalController.getNilai(),
        index: (index + 1),
      );
    } else if (laporanUtamaKartuController
            .getList()[index]
            .pertanyaanKartu
            .modelPertanyaan ==
        "Model X") {
      return ContainerUtamaKartuX(
        isSelected: isSelected,
        dataPertanyaan:
            laporanUtamaKartuController.getList()[index].pertanyaanKartu,
        jawaban: laporanUtamaKartuController.getList()[index].tampilanJawaban,
        onPressed: () {
          setState(() {
            if (isCabang) {
              print("masuk cabang");
              soalUtamaPilihan = laporanCabangKartuController!.getList()[index];
              print(soalUtamaPilihan!.pertanyaanKartu.dataSoal.idSoal);
              controllerHalaman.setSoalCabang(soalUtamaPilihan!);
            } else {
              soalUtamaPilihan = laporanUtamaKartuController.getList()[index];
              controllerHalaman.setSoalUtama(soalUtamaPilihan!);
            }
          });
        },
        isCabang: isCabang,
        totalSoal: penghitungSoalController.getNilai(),
        index: (index + 1),
      );
    } else if (laporanUtamaKartuController
            .getList()[index]
            .pertanyaanKartu
            .modelPertanyaan ==
        "Model Y") {
      return ContainerUtamaKartuY(
        isSelected: isSelected,
        dataPertanyaan:
            laporanUtamaKartuController.getList()[index].pertanyaanKartu,
        jawaban: laporanUtamaKartuController.getList()[index].tampilanJawaban,
        onPressed: () {
          setState(() {
            if (isCabang) {
              soalUtamaPilihan = laporanCabangKartuController!.getList()[index];
              controllerHalaman.setSoalCabang(soalUtamaPilihan!);
            } else {
              soalUtamaPilihan = laporanUtamaKartuController.getList()[index];
              controllerHalaman.setSoalUtama(soalUtamaPilihan!);
            }
          });
        },
        isCabang: isCabang,
        totalSoal: penghitungSoalController.getNilai(),
        index: (index + 1),
      );
    } else {
      return ContainerUtamaKartuZ(
        isSelected: isSelected,
        dataPertanyaan:
            laporanUtamaKartuController.getList()[index].pertanyaanKartu,
        jawaban: laporanUtamaKartuController.getList()[index].tampilanJawaban,
        onPressed: () {
          setState(() {
            if (isCabang) {
              soalUtamaPilihan = laporanCabangKartuController!.getList()[index];
              controllerHalaman.setSoalCabang(soalUtamaPilihan!);
            } else {
              soalUtamaPilihan = laporanUtamaKartuController.getList()[index];
              controllerHalaman.setSoalUtama(soalUtamaPilihan!);
            }
          });
        },
        isCabang: isCabang,
        totalSoal: penghitungSoalController.getNilai(),
        index: (index + 1),
      );
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
            height: 335,
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
                            gantiChartSoalPilihan(
                                controllerHalaman.isCabangAktif(),
                                soalUtamaPilihan.pertanyaanKartu.idSoal,
                                e);
                            // laporanUtamaKartuController!.gantiChart(
                            //     soalUtamaPilihan.pertanyaanKartu.idSoal, e);

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

  gantiChartSoalPilihan(bool isCabang, String idSoal, TipeCharts e) {
    if (isCabang) {
      laporanCabangKartuController!.gantiChart(idSoal, e);
    } else {
      laporanUtamaKartuController!.gantiChart(idSoal, e);
    }
  }

  void buatExcel() {
    try {
      if (laporanUtamaKartuController != null) {
        var excel = Excel.createExcel();
        var styleExcel = CellStyle(
            // backgroundColorHex: '#1AFF1A',
            fontFamily: getFontFamily(FontFamily.Calisto_MT),
            fontSize: 13);
        Sheet sheet = excel[excel.getDefaultSheet()!];
        // sheet.setColumnWidth(0, 30);
        // sheet.setColumnWidth(2, 30);
        // sheet.setColumnWidth(4, 30);
        int pointerY = 0;
        var temp = laporanUtamaKartuController;
        for (var i = 0; i < temp!.getLength(); i++) {
          var data = temp.getList()[i];
          var soal =
              data.pertanyaanKartu.quillController.document.toPlainText();
          var mapHasil = LaporanDataKartuController()
              .mapforCharts(data.pertanyaanKartu.dataSoal, data.dataJawaban);

          // print("ini bukan pembatas");
          var cellSoal = sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: pointerY));
          cellSoal.value = TextCellValue(soal);
          cellSoal.cellStyle = styleExcel;
          pointerY++;

          mapHasil.forEach((key, value) {
            var cellJawabanKey = sheet.cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: pointerY));
            cellJawabanKey.value = TextCellValue(key);
            cellJawabanKey.cellStyle = styleExcel;
            var cellJawabanValue = sheet.cell(
                CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: pointerY));
            cellJawabanValue.value = TextCellValue(value.toString());
            cellJawabanValue.cellStyle = styleExcel;

            pointerY++;
          });
          pointerY++;
        }
        var fileBytes = excel.save(fileName: '${judulSurvei}.xlsx');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                        text: "Judul Survei :",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 16,
                                ),
                        children: [
                          TextSpan(
                            text: judulSurvei,
                            // text: controllerHalaman.getIdSurvei(),
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
                  TombolExcel(
                    onPressed: () => buatExcel(),
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
    );
  }
}

// List<Widget> generateKontenV2() {
//     if (laporanUtamaKartuController == null) {
//       return [
//         LoadingBiasa(
//           text: "Memuat Data Laporan",
//           pakaiKembali: false,
//         )
//       ];
//     } else {
//       if (controllerHalaman.getIsResponEmpty()) {
//         return const [BelumAdaRespon()];
//       } else {
//         if (controllerHalaman.getPage() == PagePilihan.halamanUtama) {
//           SoalLaporanUtamaKartu? soalUtamaPilihan =
//               controllerHalaman.getSoalPilihan();
//           return [
//             ...List.generate(laporanUtamaKartuController!.getLength(), (index) {
//               String idPilihan = (soalUtamaPilihan == null)
//                   ? ""
//                   : soalUtamaPilihan!.pertanyaanKartu.idSoal;
//               if (laporanUtamaKartuController!
//                           .getList()[index]
//                           .pertanyaanKartu
//                           .urlGambar ==
//                       "urlGambar" ||
//                   laporanUtamaKartuController!
//                           .getList()[index]
//                           .pertanyaanKartu
//                           .urlGambar ==
//                       "") {
//                 return ContainerKartuXUtamaNonFoto(
//                   isSelected: idPilihan ==
//                       laporanUtamaKartuController!
//                           .getList()[index]
//                           .pertanyaanKartu
//                           .idSoal,
//                   dataPertanyaan: laporanUtamaKartuController!
//                       .getList()[index]
//                       .pertanyaanKartu,
//                   jawaban: laporanUtamaKartuController!
//                       .getList()[index]
//                       .tampilanJawaban,
//                   onPressed: () {
//                     setState(() {
//                       soalUtamaPilihan =
//                           laporanUtamaKartuController!.getList()[index];
//                       controllerHalaman.setSoalUtama(soalUtamaPilihan!);
//                     });
//                   },
//                 );
//               } else if (laporanUtamaKartuController!
//                       .getList()[index]
//                       .pertanyaanKartu
//                       .modelPertanyaan ==
//                   "Model X") {
//                 return ContainerUtamaKartuX(
//                   isSelected: idPilihan ==
//                       laporanUtamaKartuController!
//                           .getList()[index]
//                           .pertanyaanKartu
//                           .idSoal,
//                   dataPertanyaan: laporanUtamaKartuController!
//                       .getList()[index]
//                       .pertanyaanKartu,
//                   jawaban: laporanUtamaKartuController!
//                       .getList()[index]
//                       .tampilanJawaban,
//                   onPressed: () {
//                     setState(() {
//                       soalUtamaPilihan =
//                           laporanUtamaKartuController!.getList()[index];
//                       controllerHalaman.setSoalUtama(soalUtamaPilihan!);
//                     });
//                   },
//                 );
//               } else if (laporanUtamaKartuController!
//                       .getList()[index]
//                       .pertanyaanKartu
//                       .modelPertanyaan ==
//                   "Model Y") {
//                 return ContainerUtamaKartuY(
//                   isSelected: idPilihan ==
//                       laporanUtamaKartuController!
//                           .getList()[index]
//                           .pertanyaanKartu
//                           .idSoal,
//                   dataPertanyaan: laporanUtamaKartuController!
//                       .getList()[index]
//                       .pertanyaanKartu,
//                   jawaban: laporanUtamaKartuController!
//                       .getList()[index]
//                       .tampilanJawaban,
//                   onPressed: () {
//                     setState(() {
//                       soalUtamaPilihan =
//                           laporanUtamaKartuController!.getList()[index];
//                       controllerHalaman.setSoalUtama(soalUtamaPilihan!);
//                     });
//                   },
//                 );
//               } else {
//                 return ContainerUtamaKartuZ(
//                   isSelected: idPilihan ==
//                       laporanUtamaKartuController!
//                           .getList()[index]
//                           .pertanyaanKartu
//                           .idSoal,
//                   dataPertanyaan: laporanUtamaKartuController!
//                       .getList()[index]
//                       .pertanyaanKartu,
//                   jawaban: laporanUtamaKartuController!
//                       .getList()[index]
//                       .tampilanJawaban,
//                   onPressed: () {
//                     setState(() {
//                       soalUtamaPilihan =
//                           laporanUtamaKartuController!.getList()[index];
//                       controllerHalaman.setSoalUtama(soalUtamaPilihan!);
//                     });
//                   },
//                 );
//               }
//             })
//           ];
//         } else {
//           final listTemp = laporanKartuController!.getListPertanyaan();
//           return [
//             ...List.generate(listTemp.length, (index) {
//               String modelPertanyaan = listTemp[index].modelPertanyaan;
//               if (listTemp[index].urlGambar == "" ||
//                   listTemp[index].urlGambar == "urlGambar") {
//                 return ContainerXNonKartu(
//                   jawaban: laporanKartuController!.getListJawaban()[index],
//                   jawabanPertanyaan: laporanKartuController!
//                       .getResponPilihan()
//                       .daftarJawaban[index],
//                   pertanyaanKartu: listTemp[index],
//                 );
//               } else if (modelPertanyaan == "Model X") {
//                 return ContainerKartuX(
//                   jawaban: laporanKartuController!.getListJawaban()[index],
//                   jawabanPertanyaan: laporanKartuController!
//                       .getResponPilihan()
//                       .daftarJawaban[index],
//                   pertanyaanKartu: listTemp[index],
//                 );
//               } else if (modelPertanyaan == "Model Y") {
//                 return ContainerKartuY(
//                   jawaban: laporanKartuController!.getListJawaban()[index],
//                   jawabanPertanyaan: laporanKartuController!
//                       .getResponPilihan()
//                       .daftarJawaban[index],
//                   pertanyaanKartu: listTemp[index],
//                 );
//               } else {
//                 return ContainerKartuZ(
//                   jawaban: laporanKartuController!.getListJawaban()[index],
//                   jawabanPertanyaan: laporanKartuController!
//                       .getResponPilihan()
//                       .daftarJawaban[index],
//                   pertanyaanKartu: listTemp[index],
//                 );
//               }
//             })
//           ];
//         }
//       }
//     }
//   }

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
