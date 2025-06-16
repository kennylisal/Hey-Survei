import 'package:aplikasi_admin/app/routing/route_constant.dart';
import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/survei/survei_controller.dart';
import 'package:aplikasi_admin/features/survei/widget_survei/kartu_baru.dart';
import 'package:aplikasi_admin/features/survei/widget_survei/klasik_baru.dart';
import 'package:aplikasi_admin/features/survei/widget_survei/template_form_kartu.dart';
import 'package:aplikasi_admin/features/survei/widget_survei/template_form_klasik.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuatSurvei extends StatefulWidget {
  BuatSurvei({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;

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
            context.goNamed(RouterConstant.formKartu, pathParameters: {
              'idForm': idBaru,
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
      const TemplateFormKartu(),
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
            context.goNamed(RouterConstant.formKlasik, pathParameters: {
              'idForm': idBaru,
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
      const TemplateFormKlasik(),
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
          : LoadingBiasa(text: "Aplikasi Sedang memproses Form"),
    );
  }
}
