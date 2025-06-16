import 'package:aplikasi_admin/features/formV2/data_form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/form_state.dart';
import 'package:aplikasi_admin/features/formV2/widget/judul_form.dart';
import 'package:aplikasi_admin/features/formV2/widget/loading_form.dart';
import 'package:aplikasi_admin/features/formV2/widget/petunjuk_form.dart';
import 'package:aplikasi_admin/features/formV2/widget/tanda_cabang.dart';
import 'package:aplikasi_admin/features/formV2/widget/tidak_ada_cabang.dart';
import 'package:aplikasi_admin/features/preview/widget_jawaban.dart/preview_container_kartu.dart';
import 'package:aplikasi_admin/features/preview/widgets/sidebar_preview_kartu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HalamanPreviewKartu extends StatefulWidget {
  HalamanPreviewKartu({
    super.key,
    required this.idForm,
  });
  final String idForm;
  @override
  State<HalamanPreviewKartu> createState() => _HalamanPreviewKartuState();
}

class _HalamanPreviewKartuState extends State<HalamanPreviewKartu> {
  FormController? controller;
  initData() async {
    final temp =
        await DataFormController().setUpFormKartuFlutter(widget.idForm);
    if (temp != null) {
      controller = temp;
      setState(() {});
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
    setState(() {});
  }

  Widget generateKonten() {
    if (controller == null) {
      return LoadingBiasa(text: "Memuat Data Form");
    } else {
      return PreviewFormKartu(controller: controller!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: generateKonten());
  }
}

class PreviewFormKartu extends ConsumerStatefulWidget {
  PreviewFormKartu({
    super.key,
    required this.controller,
  });
  FormController controller;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreviewFormKartuState();
}

class _PreviewFormKartuState extends ConsumerState<PreviewFormKartu>
    with TickerProviderStateMixin {
  late StateNotifierProvider<FormController, FormStateX> provider;
  late TabController _tabcontroller;

  @override
  void initState() {
    _tabcontroller = TabController(initialIndex: 0, length: 2, vsync: this);
    provider = StateNotifierProvider((ref) => widget.controller);
    super.initState();
  }

  Widget generateKontenUtama(FormStateX state) {
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
            PreviewContainerKartu(
              controller: state.listSoalCabang[state.indexCabang],
              formController: widget.controller,
            ),
          ],
        );
      }
    } else {
      return PreviewContainerKartu(
        controller: state.listSoalController[state.indexUtama],
        formController: widget.controller,
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
              width: constraints.maxWidth * 0.24,
              height: double.infinity,
              child: SidebarPreviewKartu(
                formController: widget.controller,
                tabController: _tabcontroller,
              ),
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
                      width: constraints.maxWidth > 1400
                          ? 1040
                          : constraints.maxWidth * 0.740,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Column(
                        children: [
                          JudulForm(controller: temp.controllerJudul),
                          PetunjukForm(controller: temp.controllerPetunjuk),
                          generateKontenUtama(temp)
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
