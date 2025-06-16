import 'package:aplikasi_admin/features/formV2/constant.dart';
import 'package:aplikasi_admin/features/formV2/data_form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/form_state.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_state.dart';
import 'package:aplikasi_admin/features/formV2/widget/judul_form.dart';
import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/formV2/widget/pembatas.dart';
import 'package:aplikasi_admin/features/formV2/widget/petunjuk_form.dart';
import 'package:aplikasi_admin/features/formV2/widget/sidebar_klasik.dart';
import 'package:aplikasi_admin/features/formV2/widget/soal_form_klasik.dart';
import 'package:aplikasi_admin/features/formV2/widget/tanda_cabang.dart';
import 'package:aplikasi_admin/features/formV2/widget/template_berhasil.dart';
import 'package:aplikasi_admin/features/formV2/widget/tidak_ada_cabang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HalamanFormKlasik extends StatefulWidget {
  const HalamanFormKlasik({
    super.key,
    required this.idForm,
  });
  final String idForm;
  @override
  State<HalamanFormKlasik> createState() => _HalamanFormKlasikState();
}

class _HalamanFormKlasikState extends State<HalamanFormKlasik> {
  bool sudahPengecekan = false;
  FormController? controller;
  initData() async {
    print(widget.idForm);
    final temp =
        await DataFormController().setUpFormKlasikFlutter(widget.idForm);
    // final temp = DataFormController().setUpFormKlasikPercobaan("");
    if (temp != null) {
      controller = temp;
      setState(() {});
    }
  }

  Widget generateKonten() {
    if (controller == null) {
      return LoadingBiasa(text: "Memuat Data Form");
    } else {
      return FormKlasik(controller: controller!);
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

class FormKlasik extends ConsumerStatefulWidget {
  FormKlasik({
    super.key,
    required this.controller,
  });
  FormController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormKlasikState();
}

class _FormKlasikState extends ConsumerState<FormKlasik> {
  late StateNotifierProvider<FormController, FormStateX> provider;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    provider = StateNotifierProvider((ref) => widget.controller);
    super.initState();
  }

  Widget generateSoalForm(PertanyaanController controller) {
    if (controller.getTipePertanyaan() == TipePertanyaan.pembatasPertanyaan) {
      return PembatasForm(
        controller: controller,
        formController: widget.controller,
        key: Key(controller.getIdSoal()),
      );
    } else {
      return SoalFormKlasik(
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
              SoalFormKlasik(
                controller: soalController,
                formController: widget.controller,
                key: Key(soalController.getIdSoal()),
              )
          ],
        );
      }
    } else {
      return ReorderableListView(
        shrinkWrap: true,
        children: [
          for (final soalController in state.listSoalController)
            generateSoalForm(soalController)
        ],
        onReorder: (oldIndex, newIndex) {
          widget.controller.tukarPosisiSoal(newIndex, oldIndex, context);
        },
      );
    }
  }

  generateForm(FormStateX temp, BoxConstraints constraints) {
    if (temp.halamanForm == HalamanForm.halamanForm) {
      return Row(
        children: [
          SizedBox(
            width: constraints.maxWidth * 0.25,
            height: double.infinity,
            child: SidebarKlasik(
              formController: widget.controller,
              scrollController: _scrollController,
            ),
          ),
          Container(
            width: constraints.maxWidth * 0.75,
            height: double.infinity,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: SingleChildScrollView(
              controller: _scrollController,
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
    } else {
      return const TemplateBerhasil();
    }
  }

  @override
  Widget build(BuildContext context) {
    final temp = ref.watch(provider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return generateForm(temp, constraints);
      },
    );
  }
}



// class HalamanFormKlasik extends ConsumerStatefulWidget {
//   HalamanFormKlasik({super.key, required this.idForm});
//   final String idForm;
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _HalamanFormKlasikState();
// }

// class _HalamanFormKlasikState extends ConsumerState<HalamanFormKlasik> {
//   FormController? controller;
//   initData() async {
//     final temp =
//         await DataFormController().setUpFormFlutterKlasik(widget.idForm);
//     if (temp != null) {
//       controller = temp;
//       setState(() {});
//     }
//   }

//   Widget generateKontenUtama() {
//     if (controller == null) {
//       return LoadingBiasa(text: "Memuat Data Form");
//     } else {
//       return FormKlasik(controller: controller!);
//     }
//   }

//   @override
//   void initState() {
//     initData();
//     super.initState();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: generateKontenUtama(),
//     );
//   }
// }
