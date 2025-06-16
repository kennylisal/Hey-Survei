import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/features/publish_survei/survei_controller.dart';
import 'package:hei_survei/features/publish_survei/widgets/kartu_baru.dart';
import 'package:hei_survei/features/publish_survei/widgets/klasik_baru.dart';
import 'package:hei_survei/features/publish_survei/widgets/template_kartu.dart';
import 'package:hei_survei/features/publish_survei/widgets/template_klasik.dart';
import 'package:hei_survei/utils/kriptografi.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

class BuatSurvei extends StatefulWidget {
  BuatSurvei({
    super.key,
    required this.constraints,
    required this.ontapKartu,
    required this.ontapKlasik,
  });
  BoxConstraints constraints;
  Function() ontapKartu;
  Function() ontapKlasik;
  @override
  State<BuatSurvei> createState() => _BuatSurveiState();
}

class _BuatSurveiState extends State<BuatSurvei> {
  bool isLoading = false;

  List<Widget> widgetTampilan = [];

  List<Widget> rowGenerator(BuildContext context, int pembagi) {
    int indexInduk = -1;

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

  final snackBar = SnackBar(content: Text("Terjadi Masalah Server"));

  @override
  void initState() {
    widgetTampilan = [
      KotakFormKartuBaru(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          String idBaru = await SurveiController().buatFormKartu();

          if (!context.mounted) return;

          if (idBaru != "Gagal") {
            setState(() {
              isLoading = false;
            });
            context.pushNamed(RouteConstant.formKartu, pathParameters: {
              // 'idForm': idBaru,
              'idForm': Kriptografi.encrypt(idBaru),
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
      TemplateFormKartu(onTap: widget.ontapKartu),
      KotakFormKlasikBaru(
        onTap: () async {
          setState(() {
            isLoading = true;
          });

          String idBaru = await SurveiController().buatFormKlasik();

          if (!context.mounted) return;
          if (idBaru != "Gagal") {
            setState(() {
              isLoading = false;
            });
            context.pushNamed(RouteConstant.formKlasik, pathParameters: {
              // 'idForm': idBaru,
              'idForm': Kriptografi.encrypt(idBaru),
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
      TemplateFormKlasik(onTap: widget.ontapKlasik),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (!isLoading)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Pembuatan Form",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: Colors.black),
                ),
                const SizedBox(height: 12),
                Text(
                  "Buat sebuah form dari awal atau menggunakan template",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 6),
                Text(
                  "atau gunakan template",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 32),
                ...rowGenerator(
                    context,
                    (widget.constraints.maxWidth > 1800)
                        ? 4
                        : (widget.constraints.maxWidth > 1500)
                            ? 3
                            : (widget.constraints.maxWidth > 850)
                                ? 2
                                : 1),
              ],
            )
          : LoadingBiasa(
              text: "Aplikasi Sedang memproses Form",
              pakaiKembali: false,
            ),
    );
  }
}
