import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/features/buat_form/controller.dart';
import 'package:hei_survei/features/buat_form/widgets/kartu_template.dart';
import 'package:hei_survei/utils/kriptografi.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

class HalamanTemplateKlasik extends StatefulWidget {
  HalamanTemplateKlasik({
    super.key,
    required this.constraints,
    required this.onTapKembali,
  });
  BoxConstraints constraints;
  Function() onTapKembali;
  @override
  State<HalamanTemplateKlasik> createState() => _HalamanTemplateKlasikState();
}

class _HalamanTemplateKlasikState extends State<HalamanTemplateKlasik> {
  bool isLoading = true;
  String pesanLoading = "Memuat Data Template Form Klasik yang tersedia";
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

  initData() async {
    final list = await BuatFormController().getTemplateList(true);
    if (list != null) {
      setState(() {
        widgetTampilan = List.generate(
            list.length,
            (index) => KartuTemplate(
                  templateForm: list[index],
                  onTapBuat: () async {
                    if (pesanLoading != "Memproses form baru dengan template") {
                      setState(() {
                        pesanLoading = "Memproses form baru dengan template";
                      });
                      String idForm = await BuatFormController()
                          .buatFormKlasikDariTemplate(
                              idForm: list[index].idForm, context: context);
                      if (!context.mounted) return;
                      context
                          .goNamed(RouteConstant.formKlasik, pathParameters: {
                        // 'idForm': idForm,
                        'idForm': Kriptografi.encrypt(idForm),
                      });
                    }
                  },
                  onTapPreview: () {
                    context
                        .goNamed(RouteConstant.previewKlasik, pathParameters: {
                      // 'idForm': list[index].idForm,
                      'idForm': Kriptografi.encrypt(list[index].idForm),
                    });
                  },
                ));
        isLoading = false;
      });
    }
  }

  generateKonten() {
    if (isLoading) {
      return LoadingBiasa(
        text: pesanLoading,
        pakaiKembali: false,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 8),
              child: Row(
                children: [
                  IconButton.filled(
                      onPressed: widget.onTapKembali,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  const SizedBox(width: 6),
                  Text(
                    "Kembali",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Pembuatan Form Klasik",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Text(
            "Silahkan pilih dari salah satu template ini",
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
      );
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: generateKonten());
  }
}
