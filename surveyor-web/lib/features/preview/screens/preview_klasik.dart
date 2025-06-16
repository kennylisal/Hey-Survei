import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/form/data_form_controller.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/form_state.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_state.dart';
import 'package:hei_survei/features/form/widget/judul_form.dart';
import 'package:hei_survei/features/form/widget/tanda_cabang.dart';
import 'package:hei_survei/features/form/widget/tidak_ada_cabang.dart';
import 'package:hei_survei/features/preview/widgets/pembatas_preview.dart';
import 'package:hei_survei/features/preview/widgets/preview_soal_klasik.dart';
import 'package:hei_survei/features/preview/widgets/sidebar_preview_klasik.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

class HalamanPreviewKlasik extends StatefulWidget {
  HalamanPreviewKlasik({
    super.key,
    required this.idForm,
  });
  final String idForm;
  @override
  State<HalamanPreviewKlasik> createState() => _HalamanPreviewKlasikState();
}

class _HalamanPreviewKlasikState extends State<HalamanPreviewKlasik> {
  FormController? controller;

  initData() async {
    final temp =
        await DataFormController().setUpFormKlasikFlutter(widget.idForm);
    if (temp != null) {
      print("terisi");
      controller = temp;
      setState(() {});
    }
  }

  Widget generateKonten() {
    if (controller == null) {
      return LoadingBiasa(
        text: "Memuat Data Form",
        pakaiKembali: true,
      );
    } else {
      return PreviewFormKlasik(controller: controller!);
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: generateKonten());
  }
}

class PreviewFormKlasik extends ConsumerStatefulWidget {
  PreviewFormKlasik({
    super.key,
    required this.controller,
  });
  FormController controller;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreviewFormKlasikState();
}

class _PreviewFormKlasikState extends ConsumerState<PreviewFormKlasik> {
  late StateNotifierProvider<FormController, FormStateX> provider;

  @override
  void initState() {
    provider = StateNotifierProvider((ref) => widget.controller);
    super.initState();
  }

  Widget generateSoalForm(PertanyaanController controller) {
    if (controller.getTipePertanyaan() == TipePertanyaan.pembatasPertanyaan) {
      return PreviewPembatasForm(
        controller: controller,
        formController: widget.controller,
        key: Key(controller.getIdSoal()),
      );
    } else {
      return PreviewSoalKlasik(
        controller: controller,
        formController: widget.controller,
        key: Key(controller.getIdSoal()),
      );
    }
  }

  Widget generateKontenUtama(FormStateX state, FormController formController) {
    if (state.isCabangShown) {
      if (state.listSoalCabang.isEmpty) {
        return const Column(
          children: [
            TandaCabang(),
            TidakAdaCabang(),
          ],
        );
      } else {
        return Column(
          children: [
            const TandaCabang(),
            for (final soalController in state.listSoalCabang)
              PreviewSoalKlasik(
                controller: soalController,
                formController: widget.controller,
                key: Key(soalController.getIdSoal()),
              )
          ],
        );
      }
    } else {
      return Column(
        children: [
          for (final soalController in state.listSoalController)
            generateSoalForm(soalController),
          // PreviewSoalKlasik(
          //   controller: soalController,
          //   formController: widget.controller,
          //   key: Key(soalController.getIdSoal()),
          // )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final temp = ref.watch(provider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.25,
              height: double.infinity,
              child: PreviewSidebarKlasik(formController: widget.controller),
            ),
            Container(
              width: constraints.maxWidth * 0.75,
              height: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      width: constraints.maxWidth > 1200
                          ? 900
                          : constraints.maxWidth * 0.745,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Column(
                        children: [
                          JudulForm(controller: temp.controllerJudul),
                          // PetunjukForm(controller: temp.controllerPetunjuk),
                          generateKontenUtama(temp, widget.controller),
                        ],
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
