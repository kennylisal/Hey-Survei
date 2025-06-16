import 'package:aplikasi_admin/features/formV2/constant.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_state.dart';
import 'package:aplikasi_admin/features/formV2/widget/tampilan_teks_cabang.dart';
import 'package:aplikasi_admin/features/preview/widgets/quill_soal_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PreviewSoalKlasik extends StatefulWidget {
  PreviewSoalKlasik({
    super.key,
    required this.controller,
    required this.formController,
  });
  PertanyaanController controller;
  FormController formController;
  @override
  State<PreviewSoalKlasik> createState() => _PreviewSoalKlasikState();
}

class _PreviewSoalKlasikState extends State<PreviewSoalKlasik> {
  late PertanyaanState state;
  @override
  void initState() {
    state = widget.controller.getState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (state.isCabang())
              TampilanTeksPointer(
                soal: (state as PertanyaanCabangKlasikState).kataPertanyaan,
                jawaban: (state as PertanyaanCabangKlasikState).kataJawban,
              ),
            Container(
                padding: const EdgeInsets.only(
                  left: 6,
                  top: 3,
                ),
                child: Text(
                  "Pertanyaan",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PreviewQuilSoal(quillController: state.quillController),
                      (state as PertanyaanKlasikState).isBergambar
                          ? TampilanGambarPreview(
                              urlGambar:
                                  (state as PertanyaanKlasikState).urlGambar,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        height: 50,
                        child: DropdownButton(
                          isExpanded: true,
                          style: Theme.of(context).textTheme.labelLarge,
                          value: state.dataSoal.tipeSoal,
                          items: listMode
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.tipeSoal,
                                  child: Row(
                                    children: [
                                      e.icon,
                                      const SizedBox(width: 8),
                                      if (constraints.maxWidth > 700)
                                        Text(e.tipeSoal.value),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 8,
                  child: widget.controller
                      .generateJawabanPreview(widget.controller),
                  // child: widget.controller.generateWidgetSoalKartu(
                  //   widget.controller,
                  //   widget.formController,
                  // ),
                  // widget.controller.generateWidgetSoal(widget.controller),
                ),
                const Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            // widget.controller
            //     .generateFooterKlasik(context, widget.formController),
          ],
        ),
      ),
    );
  }
}

class TampilanGambarPreview extends StatelessWidget {
  TampilanGambarPreview({
    super.key,
    required this.urlGambar,
  });
  final String urlGambar;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 4),
          height: 180,
          width: 320,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
          ),
          child: CachedNetworkImage(
            filterQuality: FilterQuality.medium,
            imageUrl: urlGambar,
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) {
              return const Icon(
                Icons.error,
                size: 48,
                color: Colors.red,
              );
            },
          ),
        ),
        SizedBox(height: 6),
      ],
    );
  }
}
