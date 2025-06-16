import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/app/widgets/container_petunjuk.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/surveiku/screens/detail_survei.dart';
import 'package:hei_survei/features/surveiku/screens/survei_aktif.dart';
import 'package:hei_survei/features/surveiku/surveiku_controller.dart';
import 'package:hei_survei/features/surveiku/widget/kartu_surveiku_v2.dart';
import 'package:hei_survei/utils/generator_pdf.dart';
import 'package:hei_survei/utils/hover_builder.dart';
import 'package:hei_survei/utils/kriptografi.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

enum HalamanSurveiku { surveiku, detail }

class SurveikuBaru extends StatefulWidget {
  SurveikuBaru({super.key, required this.constraints});
  BoxConstraints constraints;
  @override
  State<SurveikuBaru> createState() => _SurveikuBaruState();
}

class _SurveikuBaruState extends State<SurveikuBaru> {
  List<SurveiData> listSurvei = [];
  List<Widget> widgetTampilan = [];
  SurveikuData? dataAwal;
  int modeTampilan = 0;
  List<bool> listBool = [true, false, false, false];
  //
  String idSurveiPilihan = "";
  HalamanSurveiku halPilihan = HalamanSurveiku.surveiku;

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
        (index) => KartuSurveiV2(
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

  generateKontenSurveiku() {
    if (dataAwal == null) {
      LoadingBiasa(
        text: "Memuat Data Survei Anda",
        pakaiKembali: false,
      );
    } else {
      if (dataAwal!.listBeli.isEmpty && dataAwal!.listSurvei.isEmpty) {
        return const TampilanBelumAdaSurvei();
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "SurveiKu",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              "Semua Survei yg anda publikasina dan beli",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 6),
            Text(
              "akan tampil dibawah",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 32),
            PilihanUrutanSurveiku(
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
    }
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
  void initState() {
    Future(() async {
      dataAwal = await SurveikuController().getSurveiKu();
      print(dataAwal);
      if (dataAwal != null) {
        surveiDatatoWidget();
      }
      setState(() {});
    });
    super.initState();
    // print(Uri.base.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: (dataAwal == null)
            ? LoadingBiasa(
                text: "Memuat Data Survei Anda",
                pakaiKembali: false,
              )
            : switchKonten());
  }
}

class TampilanBelumAdaSurvei extends StatelessWidget {
  const TampilanBelumAdaSurvei({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ContainerPetunjukAtas(
          text: "Anda belum menerbitakan sebuah survei atau membeli survei",
        ),
        Text(
          "Survei Aktif",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          "Cek detail dari seluruh Survei yang anda terbitkan dan beli",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 24, color: Colors.black),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavigasiBaru(
              bgColorCircle: Color.fromARGB(225, 0, 184, 0),
              bgColorKotak: Color.fromARGB(255, 80, 255, 124),
              bgColorBorder: Color.fromARGB(255, 0, 121, 30),
              iconPilihan: Icons.document_scanner,
              textJudul: "Buat Survei",
              textDeskripsi:
                  "Klik disini untuk membuat atau melanjutkan draft survei yg telah ada",
              onTap: () => context.goNamed(RouteConstant.buatForm),
            ),
            NavigasiBaru(
              bgColorCircle: Color.fromARGB(143, 176, 0, 192),
              bgColorKotak: Color.fromARGB(255, 242, 95, 255),
              bgColorBorder: Color.fromARGB(192, 150, 0, 163),
              iconPilihan: Icons.search,
              textJudul: "Katalog Survei",
              textDeskripsi:
                  "Klik disini untuk mencari dan melihat katalog survei",
              onTap: () => context.goNamed(RouteConstant.katalog),
            ),
          ],
        )
      ],
    );
  }
}

class NavigasiBaru extends StatelessWidget {
  NavigasiBaru({
    super.key,
    required this.bgColorCircle,
    required this.bgColorKotak,
    required this.bgColorBorder,
    required this.iconPilihan,
    required this.textJudul,
    required this.textDeskripsi,
    required this.onTap,
  });
  Color bgColorCircle;
  Color bgColorKotak;
  Color bgColorBorder;
  IconData iconPilihan;
  String textJudul;
  String textDeskripsi;
  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (isHovered) {
        return InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            height: 340,
            width: 263,
            decoration: BoxDecoration(
              border: Border.all(color: bgColorBorder, width: 8),
              color: bgColorKotak,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: (isHovered) ? Colors.grey : Colors.transparent,
                  spreadRadius: 7,
                  blurRadius: 7,
                  offset: Offset(7, 7), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: bgColorCircle,
                  child: Icon(
                    iconPilihan,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  textJudul,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(height: 24),
                Center(
                  child: Text(
                    textDeskripsi,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 21),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class PilihanUrutanSurveiku extends StatelessWidget {
  PilihanUrutanSurveiku({
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
