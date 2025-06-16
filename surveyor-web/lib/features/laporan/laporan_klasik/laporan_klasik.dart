import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/app/widgets/header_non_main.dart';
import 'package:hei_survei/features/laporan/alert_kembali.dart';
import 'package:hei_survei/features/laporan/constanst.dart';
import 'package:hei_survei/features/laporan/error_idsurvei.dart';
import 'package:hei_survei/features/laporan/laporan_klasik/laporan_controller.dart';
import 'package:hei_survei/features/laporan/laporan_klasik/laporan_page_controller.dart';
import 'package:hei_survei/features/laporan/laporan_klasik/laporan_services.dart';
import 'package:hei_survei/features/laporan/laporan_util.dart';
import 'package:hei_survei/features/laporan/models/laporan_survei_klasik.dart';
import 'package:hei_survei/features/laporan/state/data_kumpulan_jawaban.dart';
import 'package:hei_survei/features/laporan/state/laporan_klasik_controller.dart';
import 'package:hei_survei/features/laporan/state/laporan_utama_controller_klasik.dart';
import 'package:hei_survei/features/laporan/widgets/belum_ada_respon.dart';
import 'package:hei_survei/features/laporan/widgets/button_pilih_chart.dart';
import 'package:hei_survei/features/laporan/widgets/container_soal_satuan.dart';
import 'package:hei_survei/features/laporan/widgets/container_utama_soal.dart';
import 'package:hei_survei/features/laporan/widgets/komponen_tab_search.dart';
import 'package:hei_survei/features/laporan/widgets/pembatas_cabang.dart';
import 'package:hei_survei/features/laporan/widgets/pembatas_soal.dart';
import 'package:hei_survei/features/laporan/widgets/toggle_button.dart';
import 'package:hei_survei/features/laporan/widgets/tombol_excel.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

class ContainerLaporanKlasik extends StatefulWidget {
  ContainerLaporanKlasik({
    super.key,
    required this.idSurvei,
  });
  String idSurvei;
  @override
  State<ContainerLaporanKlasik> createState() => _ContainerLaporanKlasikState();
}

class _ContainerLaporanKlasikState extends State<ContainerLaporanKlasik> {
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

  initPengecekan() async {
    isIdElligible = await cekExistSurvei(widget.idSurvei);
    selesaiLoading = true;
    setState(() {});
  }

  Widget contentGenerator() {
    if (selesaiLoading) {
      if (isIdElligible) {
        return HalamanLaporanKlasik(idSurvei: widget.idSurvei);
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

class HalamanLaporanKlasik extends ConsumerStatefulWidget {
  HalamanLaporanKlasik({
    super.key,
    required this.idSurvei,
  });
  String idSurvei;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanLaporanState();
}

class _HalamanLaporanState extends ConsumerState<HalamanLaporanKlasik> {
  PageLaporanController controllerHalaman = PageLaporanController();
  List<bool> listBoolToggle = [true, false];
  List<String> daftarResponden = [];
  //
  DataLaporanSurveiKlasik? dataLaporanSurvei; //ini untuk tampung data dari DB
  LaporanKlasikController? laporanKlasikController; // ini untuk satuan
  LaporanKlasikController? laporanKlasikCabangController; // ini untuk satuan
  LaporanUtamaKlasikController?
      laporanUtamaController; //ini untuk laporan data gabungan
  LaporanUtamaKlasikController? laporanCabangController;
  //ini untuk laporan data gabungan
  DataKumpulanJawabanController laporanUtama = DataKumpulanJawabanController();
  DataKumpulanJawabanController laporanCabang = DataKumpulanJawabanController();
  PenghitungSoalController penghitungSoalController =
      PenghitungSoalController();
  int penyeimbang = 0;
  int penyeimbangSatuan = 0;
  String judulSurvei = "";
  @override
  void initState() {
    initData();
    super.initState();
  }

  void buatExcel() {
    try {
      if (laporanUtamaController != null) {
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
        var temp = laporanUtamaController;
        for (var i = 0; i < temp!.getLength(); i++) {
          var data = temp.getList()[i];
          var soal =
              data.pertanyaanKlasik.quillController.document.toPlainText();
          var mapHasil = LaporanDataKlasikController()
              .mapforCharts(data.pertanyaanKlasik.dataSoal, data.dataJawaban);
          if (data.pertanyaanKlasik.dataSoal.tipeSoal == 'pembatas') {
            // print("ini pembatas");
            var cellPembatas = sheet.cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: pointerY));
            cellPembatas.value = TextCellValue(soal);
            cellPembatas.cellStyle = CellStyle(
                backgroundColorHex: '#1AFF1A',
                fontFamily: getFontFamily(FontFamily.Calisto_MT),
                fontSize: 15);
            pointerY = pointerY + 2;
          } else {
            // print("ini bukan pembatas");
            var cellSoal = sheet.cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: pointerY));
            cellSoal.value = TextCellValue(soal);
            cellSoal.cellStyle = styleExcel;
            pointerY++;

            mapHasil.forEach((key, value) {
              var cellJawabanKey = sheet.cell(CellIndex.indexByColumnRow(
                  columnIndex: 1, rowIndex: pointerY));
              cellJawabanKey.value = TextCellValue(key);
              cellJawabanKey.cellStyle = styleExcel;
              var cellJawabanValue = sheet.cell(CellIndex.indexByColumnRow(
                  columnIndex: 4, rowIndex: pointerY));
              cellJawabanValue.value = TextCellValue(value.toString());
              cellJawabanValue.cellStyle = styleExcel;

              pointerY++;
            });
            pointerY++;
          }
        }
        var fileBytes = excel.save(fileName: '${judulSurvei}.xlsx');
      }
    } catch (e) {}
  }

  List<Widget> generateKonten() {
    if (laporanUtamaController == null) {
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
          SoalLaporanUtamaKlasik? soalUtamaPilihan =
              controllerHalaman.getSoalPilihan();
          SoalLaporanUtamaKlasik? soalUtamaCabang =
              controllerHalaman.getSoalPilihanCabang();
          String idPilihan = (soalUtamaPilihan == null)
              ? ""
              : soalUtamaPilihan.pertanyaanKlasik.idSoal;
          String idPilihanCabang = (soalUtamaCabang == null)
              ? ""
              : soalUtamaCabang.pertanyaanKlasik.idSoal;
          return [
            ...List.generate(laporanUtamaController!.getLength(), (index) {
              if (laporanUtamaController!
                      .getList()[index]
                      .pertanyaanKlasik
                      .dataSoal
                      .tipeSoal ==
                  "pembatas") {
                penyeimbang--;
                return PembatasSoal(
                  namaPembatas: laporanUtamaController!
                      .getList()[index]
                      .pertanyaanKlasik
                      .urlGambar,
                  quillController: laporanUtamaController!
                      .getList()[index]
                      .pertanyaanKlasik
                      .quillController,
                );
              } else {
                return ContainerUtamaPresentaseLaporan(
                  isSelected: idPilihan ==
                      laporanUtamaController!
                          .getList()[index]
                          .pertanyaanKlasik
                          .idSoal,
                  dataPertanyaan:
                      laporanUtamaController!.getList()[index].pertanyaanKlasik,
                  jawaban:
                      laporanUtamaController!.getList()[index].tampilanJawaban,
                  onPressed: () {
                    setState(() {
                      soalUtamaPilihan =
                          laporanUtamaController!.getList()[index];
                      controllerHalaman.setSoalUtama(soalUtamaPilihan!);
                    });
                  },
                  isCabang: false,
                  index: (index + penyeimbang + 1),
                  totalSoal: penghitungSoalController.getNilai(),
                );
              }
            }),
            if (laporanCabangController!.getLength() != 0)
              const PembatasCabang(),
            //tampilkan soal cabang disini
            ...List.generate(laporanCabangController!.getLength(), (index) {
              return ContainerUtamaPresentaseLaporan(
                dataPertanyaan:
                    laporanCabangController!.getList()[index].pertanyaanKlasik,
                jawaban:
                    laporanCabangController!.getList()[index].tampilanJawaban,
                onPressed: () {
                  setState(() {
                    soalUtamaCabang = laporanCabangController!.getList()[index];
                    controllerHalaman.setSoalCabang(soalUtamaCabang!);
                  });
                },
                isSelected: idPilihanCabang ==
                    laporanCabangController!
                        .getList()[index]
                        .pertanyaanKlasik
                        .idSoal,
                isCabang: true,
                index: 0,
                totalSoal: 0,
              );
            }),
          ];
        } else {
          final listTemp = laporanKlasikController!.getListPertanyaan();
          final listCabang = laporanKlasikCabangController!.getListPertanyaan();
          return [
            ...List.generate(listTemp.length, (index) {
              if (listTemp[index].dataSoal.tipeSoal != "pembatas") {
                return ContainerPertanyaanJawabanLaporan(
                  dataPertanyaan: listTemp[index],
                  jawabanPertanyaan: laporanKlasikController!
                      .getResponPilihan()
                      .daftarJawaban[index],
                  jawaban: laporanKlasikController!.getListJawaban()[index],
                  isCabang: false,
                  index: (index + penyeimbangSatuan + 1),
                  totalSoal: penghitungSoalController.getNilai(),
                );
              } else {
                penyeimbangSatuan--;
                return PembatasSoal(
                  namaPembatas: listTemp[index].urlGambar,
                  quillController: listTemp[index].quillController,
                );
              }
            }),
            //pembatas soal cabang
            if (laporanCabangController!.getLength() != 0)
              const PembatasCabang(),
            ...List.generate(
                listCabang.length,
                (index) => ContainerPertanyaanJawabanLaporan(
                      dataPertanyaan: listCabang[index],
                      jawabanPertanyaan: laporanKlasikCabangController!
                          .getResponPilihan()
                          .daftarJawaban[index],
                      jawaban: laporanKlasikCabangController!
                          .getListJawaban()[index],
                      isCabang: true,
                      index: 0,
                      totalSoal: 0,
                    ))
          ];
        }
      }
    }
  }

  initData() async {
    final dataLaporan = await LaporanServices().getDataLaporanKlasik(
      widget.idSurvei,
      laporanUtama,
      laporanCabang,
      controllerHalaman,
      penghitungSoalController,
    );
    if (dataLaporan != null) {
      // print("masuk non null");
      if (dataLaporan.listRespon.isEmpty) {
        controllerHalaman.setResponEmpty(true);
        // print("masuk jawaban kosong");
        setState(() {});
      } else {
        // print("masuk di bagian kedua");
        laporanUtamaController = LaporanUtamaKlasikController(list: []);
        laporanCabangController = LaporanUtamaKlasikController(list: []);

        //persiapan data laporan utama

        //disini perlu kasih cabang keknya
        //disigni bagian soal utama====================
        for (var data in dataLaporan.daftarPertanyaanKlasik) {
          final pertanyaan = data;
          if (pertanyaan.dataSoal.tipeSoal == 'pembatas') {
            final hasil = SoalLaporanUtamaKlasik(
              pertanyaanKlasik: data,
              tipeChart: TipeCharts.barChart,
              dataJawaban: {},
              tampilanJawaban: const SizedBox(),
            );
            laporanUtamaController!.tambahData(hasil);
          } else {
            final mapJawaban =
                laporanUtama.getState()[data.idSoal]!.dataJawaban;
            final tipeChartAwal = LaporanDataKlasikController()
                .penentuanChartAwal(data.dataSoal.tipeSoal);
            Map<String, dynamic> mapCharts = LaporanDataKlasikController()
                .mapforCharts(pertanyaan.dataSoal, mapJawaban);
            bool isLegendGambar =
                (pertanyaan.dataSoal.tipeSoal == "Gambar Ganda" ||
                    pertanyaan.dataSoal.tipeSoal == "Carousel");
            // print(pertanyaan.dataSoal.tipeSoal);
            final widgetChart = LaporanDataKlasikController()
                .generateChart(mapCharts, tipeChartAwal, isLegendGambar);
            // print("bikin soalLaporan utama klasik");
            final hasil = SoalLaporanUtamaKlasik(
              pertanyaanKlasik: data,
              tipeChart: tipeChartAwal,
              dataJawaban: mapJawaban,
              tampilanJawaban: widgetChart,
            );
            // print("tambah ke list");
            laporanUtamaController!.tambahData(hasil);
          }
        }
        //disigni bagian soal Cabang====================
        for (var data in dataLaporan.daftarPertanyaanKlasikCabang) {
          final pertanyaan = data;
          final mapJawaban = laporanCabang.getState()[data.idSoal]!.dataJawaban;
          final tipeChartAwal = LaporanDataKlasikController()
              .penentuanChartAwal(data.dataSoal.tipeSoal);
          Map<String, dynamic> mapCharts = LaporanDataKlasikController()
              .mapforCharts(pertanyaan.dataSoal, mapJawaban);
          bool isLegendGambar =
              (pertanyaan.dataSoal.tipeSoal == "Gambar Ganda" ||
                  pertanyaan.dataSoal.tipeSoal == "Carousel");
          // print(pertanyaan.dataSoal.tipeSoal);
          final widgetChart = LaporanDataKlasikController()
              .generateChart(mapCharts, tipeChartAwal, isLegendGambar);
          // print("bikin soalLaporan cabang klasik");
          final hasil = SoalLaporanUtamaKlasik(
            pertanyaanKlasik: data,
            tipeChart: tipeChartAwal,
            dataJawaban: mapJawaban,
            tampilanJawaban: widgetChart,
          );
          // print("tambah ke list");
          laporanCabangController!.tambahData(hasil);
        }

        // persiapan data laporan satuan
        //disini keknya perlu taruh itu pembatas
        List<Widget> jawabanTampilan = List.generate(
            dataLaporan.daftarPertanyaanKlasik.length,
            (index) => LaporanUtils().generateJawabanLaporan(
                  dataLaporan.daftarPertanyaanKlasik[index].dataSoal,
                  dataLaporan.listRespon.first.daftarJawaban[index],
                  context,
                ));

        List<Widget> jawabanCabangTampilan = List.generate(
            dataLaporan.daftarPertanyaanKlasikCabang.length,
            (index) => LaporanUtils().generateJawabanLaporan(
                dataLaporan.daftarPertanyaanKlasikCabang[index].dataSoal,
                dataLaporan.listResponCabang.first.daftarJawaban[index],
                context));

        laporanKlasikController = LaporanKlasikController(
          userPilihan: dataLaporan.listRespon.first.emailPenjawab,
          listRespon: dataLaporan.listRespon,
          listPertanyaanLaporan: dataLaporan.daftarPertanyaanKlasik,
          responPilihan: dataLaporan.listRespon.first,
          pertanyaanTampilan: jawabanTampilan,
        );

        laporanKlasikCabangController = LaporanKlasikController(
          userPilihan: dataLaporan.listResponCabang.first.emailPenjawab,
          listRespon: dataLaporan.listResponCabang,
          listPertanyaanLaporan: dataLaporan.daftarPertanyaanKlasikCabang,
          responPilihan: dataLaporan.listResponCabang.first,
          pertanyaanTampilan: jawabanCabangTampilan,
        );

        daftarResponden = List.generate(dataLaporan.listRespon.length,
            (index) => dataLaporan.listRespon[index].emailPenjawab);
        controllerHalaman.setIdSurvei(dataLaporan.idSurvei);
        judulSurvei = dataLaporan.judul;
        setState(() {});
      }
    }
  }

  Widget generateTab() {
    if (controllerHalaman.getPage() == PagePilihan.halamanSatuan) {
      return Column(
        children: [
          ContainerPilihan(email: laporanKlasikController!.emailUserPilihan()),
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(14)),
            child: TextField(
              onSubmitted: (value) {
                final listResponden =
                    laporanKlasikController!.getListResponden();
                setState(() {
                  daftarResponden = listResponden
                      .where((element) => element.contains(value))
                      .toList();
                });
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email Responded",
                  suffixIcon: Icon(Icons.search)),
            ),
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
                            penyeimbangSatuan = 0;
                            laporanKlasikController!.gantiJawabanbyEmail(
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
        final soalUtamaPilihan = controllerHalaman.getSoalPilihan()!;
        List<TipeCharts> listJenisChart = LaporanUtils().getJenisChartTersdia(
            soalUtamaPilihan.pertanyaanKlasik.dataSoal.tipeSoal);
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
                soalUtamaPilihan.pertanyaanKlasik.quillController.document
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
                    text: soalUtamaPilihan.pertanyaanKlasik.dataSoal.tipeSoal,
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
                            // print("ganti chart");
                            laporanUtamaController!.gantiChart(
                                soalUtamaPilihan.pertanyaanKlasik.idSoal, e);
                            // soalUtamaPilihan = laporanUtamaController!.getList()[0];
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
      laporanCabangController!.gantiChart(idSoal, e);
    } else {
      laporanUtamaController!.gantiChart(idSoal, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Container(
              width: constraints.maxWidth * 0.25,
              height: double.infinity,
              color: Colors.blueGrey.shade50,
              child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
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
                              // text: dataLaporanSurvei!.judul,
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
                        penyeimbang = 0;
                        penyeimbangSatuan = 0;
                        listBoolToggle = [false, false];
                        listBoolToggle[index] = true;
                        controllerHalaman.gantiHalaman(index);
                        setState(() {});
                      },
                      listBoolToggle: listBoolToggle,
                    ),
                    const SizedBox(height: 18),
                    generateTab()
                  ]),
            ),
            Container(
              width: constraints.maxWidth * 0.75,
              height: double.infinity,
              color: Color.fromARGB(255, 197, 206, 255),
              child:
                  // SizedBox(),
                  SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      width: constraints.maxWidth > 1200
                          ? 900
                          : constraints.maxWidth * 0.745,
                      color: Color.fromARGB(255, 197, 206, 255),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: generateKonten(),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
