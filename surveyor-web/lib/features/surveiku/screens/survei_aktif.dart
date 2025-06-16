import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/katalog/widgets/kartu_survei_aktif.dart';
import 'package:hei_survei/features/surveiku/screens/detail_survei.dart';
import 'package:hei_survei/features/surveiku/surveiku_controller.dart';
import 'package:hei_survei/utils/generator_pdf.dart';
import 'package:hei_survei/utils/kriptografi.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

enum HalamanSurveiku { surveiku, detail }

class SurveiAktifBaru extends StatefulWidget {
  SurveiAktifBaru({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<SurveiAktifBaru> createState() => _SurveiAktifBaruState();
}

class _SurveiAktifBaruState extends State<SurveiAktifBaru>
    with AutomaticKeepAliveClientMixin<SurveiAktifBaru> {
  List<SurveiData> listSurvei = [];
  List<Widget> widgetTampilan = [];
  SurveikuData? dataAwal;
  int modeTampilan = 0;
  List<bool> listBool = [true, false];
  bool isLoading = false;
  //
  String idSurveiPilihan = "";
  HalamanSurveiku halPilihan = HalamanSurveiku.surveiku;
  @override
  void initState() {
    Future(() async {
      Future(() async {
        dataAwal = await SurveikuController().getSurveiAktif();
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
      listSurvei
          .sort((a, b) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
    } else {
      listSurvei = [...dataAwal!.listSurvei, ...dataAwal!.listBeli];
      listSurvei
          .sort((b, a) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
    }

    widgetTampilan = List.generate(
        listSurvei.length,
        (index) => KartuSurveiAktif(
              isTerbitan: listSurvei[index].isTerbitan,
              dataKartu: listSurvei[index],
              onTapDetail: () {
                setState(() {
                  // print(listSurvei[index].id_survei);
                  idSurveiPilihan = listSurvei[index].id_survei;
                  halPilihan = HalamanSurveiku.detail;
                });
              },
              onTapLaporan: () {
                if (listSurvei[index].isKlasik) {
                  context.goNamed(RouteConstant.laporanKlasik, pathParameters: {
                    // 'idSurvei': listSurvei[index].id_survei,
                    'idSurvei':
                        Kriptografi.encrypt(listSurvei[index].id_survei),
                  });
                } else {
                  context.goNamed(RouteConstant.laporanKartu, pathParameters: {
                    // 'idSurvei': listSurvei[index].id_survei,
                    'idSurvei':
                        Kriptografi.encrypt(listSurvei[index].id_survei),
                  });
                }
              },
              onTapQR: () => () async {
                await PdfUtils().displayPdf(listSurvei[index].generateLink());
              },
              onTapLink: () {
                final link = listSurvei[index].generateLink();
                Clipboard.setData(ClipboardData(text: link));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("link telah terjiplak")));
              },
            ));
  }

  Widget contentGenerator() {
    if (dataAwal == null) {
      return LoadingBiasa(
        text: "Sedang memuat data",
        pakaiKembali: false,
      );
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
    // surveiDatatoWidget();
    List<Widget> listWidget = widgetTampilan;
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

  generateKontenSurveiku() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
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
          "Bagikan QRCode Survei dan cek laporannya",
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
      ],
    );
  }

  Widget switchKonten() {
    if (halPilihan == HalamanSurveiku.surveiku) {
      return generateKontenSurveiku();
    } else {
      return DetailSurveiX(
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
  bool get wantKeepAlive => (baseUri == Uri.base.toString());
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
