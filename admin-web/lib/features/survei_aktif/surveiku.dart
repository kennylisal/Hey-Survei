import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/survei/models/survei_data.dart';
import 'package:aplikasi_admin/features/survei_aktif/detail_survei.dart';
import 'package:aplikasi_admin/features/survei_aktif/kartu_surveiku.dart';

import 'package:aplikasi_admin/features/survei_aktif/models/surveiku.dart';
import 'package:aplikasi_admin/features/survei_aktif/surveiku_controller.dart';
import 'package:aplikasi_admin/utils/generate_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

enum HalamanSurveiku { surveiku, detail }

class SurveiAktif extends ConsumerStatefulWidget {
  SurveiAktif({super.key, required this.constraints});
  BoxConstraints constraints;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SurveiAktifBaruState();
}

class _SurveiAktifBaruState extends ConsumerState<SurveiAktif>
    with AutomaticKeepAliveClientMixin<SurveiAktif> {
  List<SurveiData> listSurvei = [];
  List<Widget> widgetTampilan = [];
  SurveikuData? dataAwal;
  int modeTampilan = 0;
  List<bool> listBool = [true, false, false, false];
  //tambahan bagian baru
  String idSurveiPilihan = "";
  HalamanSurveiku halPilihan = HalamanSurveiku.surveiku;
  Future<Uint8List> _generatePdf(PdfPageFormat format, String content) async {
    final pdf = pw.Document();

    final img = await rootBundle.load('assets/logo-app.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
    final hasil = pw.Container(
        width: double.infinity,
        height: double.infinity,
        padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.BarcodeWidget(
                    data: content,
                    width: 205,
                    height: 205,
                    barcode: pw.Barcode.qrCode(),
                    color: PdfColor.fromHex("#000000"),
                  ),
                  pw.SizedBox(width: 26),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    height: 90,
                    child: image1,
                  ),
                  pw.SizedBox(width: 11),
                ]),
            pw.SizedBox(height: 17.5),
            pw.Text(
              "Scan Barcode ini Di Aplikasi Hei-Survei",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(width: 8),
          ],
        ));
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => hasil,
    ));

    return pdf.save();
  }

  @override
  void initState() {
    Future(() async {
      Future(() async {
        dataAwal = await SurveikuController().getSurveiKu();
        // dataAwal = null;
        print(dataAwal);
        if (dataAwal != null) {
          surveiDatatoWidget();
        }
        setState(() {});
      });
      setState(() {});
    });
    super.initState();
    print(Uri.base.toString());
  }

  surveiDatatoWidget() {
    listSurvei = [...dataAwal!.listSurvei, ...dataAwal!.listBeli];
    if (modeTampilan == 0) {
      listSurvei = [...dataAwal!.listSurvei, ...dataAwal!.listBeli];
    } else if (modeTampilan == 1) {
      listSurvei = [...dataAwal!.listBeli, ...dataAwal!.listSurvei];
    } else if (modeTampilan == 3) {
      listSurvei = [...dataAwal!.listSurvei, ...dataAwal!.listBeli];
      listSurvei
          .sort((a, b) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
    } else {
      listSurvei = [...dataAwal!.listSurvei, ...dataAwal!.listBeli];
      listSurvei
          .sort((b, a) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
    }

    widgetTampilan = List.generate(
        listSurvei.length,
        (index) => KartuSurveiku(
              isTerbitan: listSurvei[index].isTerbitan,
              dataKartu: listSurvei[index],
              onTapDetail: () {
                setState(() {
                  idSurveiPilihan = listSurvei[index].id_survei;
                  halPilihan = HalamanSurveiku.detail;
                });
              },
              onTapLaporan: () {
                if (listSurvei[index].isKlasik) {
                  context.goNamed(RouterConstant.laporanKlasik,
                      pathParameters: {
                        'idSurvei': listSurvei[index].id_survei
                      });
                } else {
                  context.goNamed(RouterConstant.laporanKartu, pathParameters: {
                    'idSurvei': listSurvei[index].id_survei
                  });
                }
              },
              onTapQR: () async {
                await PdfUtils().displayPdf(listSurvei[index].id_survei);
              },
            ));
  }

  Widget contentGenerator() {
    if (dataAwal == null) {
      return LoadingBiasa(text: "Sedang memuat data");
    } else {
      if (dataAwal!.listBeli.isEmpty && dataAwal!.listSurvei.isEmpty) {
        return const TidakAdaSurvei();
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowGenerator(
              context,
              (widget.constraints.maxWidth > 1550)
                  ? 3
                  : (widget.constraints.maxWidth > 1125)
                      ? 2
                      : 1),
        );
      }
    }
  }

  List<Widget> rowGenerator(BuildContext context, int pembagi) {
    int indexInduk = -1;
    List<Widget> listWidget = widgetTampilan;
    // TemplateForm templateForm = TemplateForm(
    //   judul: "Template Form pertanyaan 90an",
    //   idForm: "3344",
    //   petunjuk: "Jawablah pertanyaan ini sesuai denagn ingatan anda",
    //   isKlasik: true,
    //   kategori: "90an",
    // );
    // listWidget.add(KartuTemplate(
    //   templateForm: templateForm,
    //   onTapBuat: () {},
    //   onTapPreview: () {},
    // ));
    List<Widget> hasil =
        List.generate(listWidget.length ~/ pembagi + 1, (index) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(pembagi, (index) {
            if (indexInduk < listWidget.length - 1) {
              indexInduk++;
              return listWidget[indexInduk];
            } else
              return SizedBox(
                width: 275,
              );
          }));
    });

    return hasil;
  }

  Widget generateKontenSurveiku() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ContainerPetunjukAtas(
        //     text:
        //         "Petunjuk : Seluruh survei yang anda publikasikan dan beli terdapat disini"),
        Text(
          "Survei Aktif",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          "Cek detail dari survei yang anda publikasikan",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 24, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(
          "dan beli dengan memilih salah satu kartu dibawah",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 24, color: Colors.black),
        ),

        const SizedBox(height: 32),
        PilihanUrutan(
            onPressed: (index) {
              for (var i = 0; i < listBool.length; i++) {
                listBool[i] = false;
              }
              listBool[index] = true;
              modeTampilan = index;
              surveiDatatoWidget();
              setState(() {});
            },
            listBool: listBool),
        const SizedBox(height: 20),
        contentGenerator(),
        const SizedBox(height: 200),
      ],
    );
  }

  Widget switchKonten() {
    if (halPilihan == HalamanSurveiku.surveiku) {
      return generateKontenSurveiku();
    } else {
      return DetailSurvei(
        constraints: widget.constraints,
        idSurvei: idSurveiPilihan,
        onTapKembali: () {
          setState(() {
            halPilihan = HalamanSurveiku.surveiku;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(child: switchKonten());
  }

  @override
  bool get wantKeepAlive => true;
  // @override
  // bool get wantKeepAlive => (baseUri == Uri.base.toString());
}

class TidakAdaSurvei extends StatelessWidget {
  const TidakAdaSurvei({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Center(
          child: Image.asset(
            'assets/logo-tidak.png',
            scale: 0.9,
          ),
        ),
      ],
    );
  }
}

class TidakAdaSurveiAktif extends StatelessWidget {
  const TidakAdaSurveiAktif({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Center(
          child: Image.asset(
            'assets/logo-tidak.png',
            height: 300,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Ayo mulai membuat survei",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class PilihanUrutan extends StatelessWidget {
  PilihanUrutan({
    super.key,
    required this.onPressed,
    required this.listBool,
  });
  Function(int)? onPressed;
  List<bool> listBool;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Urutkan",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ToggleButtons(
              children: [
                Container(
                    padding: EdgeInsets.all(7),
                    child: Text(
                      "Terbitan",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 16, color: Colors.black),
                    )),
                Container(
                    padding: EdgeInsets.all(7),
                    child: Text(
                      "Terbeli",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 16, color: Colors.black),
                    )),
                Container(
                    padding: EdgeInsets.all(7),
                    child: Text(
                      "Terbaru",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 16, color: Colors.black),
                    )),
                Container(
                    padding: EdgeInsets.all(7),
                    child: Text(
                      "Terlama",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 16, color: Colors.black),
                    )),
              ],
              isSelected: listBool,
              fillColor: Colors.lightBlue.shade300,
              selectedColor: Colors.black,
              borderRadius: BorderRadius.circular(30),
              borderWidth: 2,
              borderColor: Colors.black,
              selectedBorderColor: Colors.black,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
