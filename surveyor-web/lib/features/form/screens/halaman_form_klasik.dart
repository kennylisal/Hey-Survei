import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hei_survei/app/widgets/header_non_main.dart';
import 'package:hei_survei/features/form/data_form_controller.dart';
import 'package:hei_survei/features/form/error_auth.dart';
import 'package:hei_survei/features/form/error_idform.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/form_state.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_state.dart';
import 'package:hei_survei/features/form/widget/judul_form.dart';
import 'package:hei_survei/features/form/widget/pembatas.dart';
import 'package:hei_survei/features/form/widget/sidebar_klasik.dart';
import 'package:hei_survei/features/form/widget/soal_form_klasik.dart';
import 'package:hei_survei/features/form/widget/tanda_cabang.dart';
import 'package:hei_survei/features/form/widget/tidak_ada_cabang.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

enum PilihanHalaman { illegalId, illegalCreds, halamanForm }

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
  PilihanHalaman halamanTampilan = PilihanHalaman.halamanForm;
  bool sudahPengecekan = false;
  FormController? controller;

  Future<bool> pengecekanAwal() async {
    bool formExist = await DataFormController().cekExistKlasik(widget.idForm);
    // false;

    if (!formExist) {
      halamanTampilan = PilihanHalaman.illegalId;
      return formExist;
    }
    bool hasilPengecekan =
        await DataFormController().cekCredForm(widget.idForm, "klasik");
    // true;
    if (!hasilPengecekan) {
      halamanTampilan = PilihanHalaman.illegalCreds;
      return hasilPengecekan;
    }

    return true;
  }

  pengecekanInit() async {
    bool hasilPengecekan = await pengecekanAwal();
    if (hasilPengecekan) {
      initData();
    }
    sudahPengecekan = true;
    setState(() {});
  }

  initData() async {
    print("masuk initData");
    final temp =
        await DataFormController().setUpFormKlasikFlutter(widget.idForm);
    if (temp != null) {
      print("masuk temp");
      controller = temp;
      setState(() {});
    }
  }

  Widget generateKontenV2() {
    if (sudahPengecekan) {
      if (halamanTampilan == PilihanHalaman.halamanForm) {
        if (controller != null) {
          return FormKlasik(controller: controller!);
        } else {
          return LoadingBiasa(
            text: "Data Form Error",
            pakaiKembali: true,
          );
        }
      } else if (halamanTampilan == PilihanHalaman.illegalId) {
        return const ErrorIdForm();
      } else {
        return const ErrorAuthForm();
      }
    } else {
      return LoadingBiasa(
        text: "Memuat Data Form",
        pakaiKembali: false,
      );
    }
  }

  @override
  void initState() {
    pengecekanInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: HeaderNonMain(),
      ),
      body: generateKontenV2(),
    );
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

//ini form klasik yg lama sebelum enkripsi
// class HalamanFormKlasik extends StatefulWidget {
//   const HalamanFormKlasik({
//     super.key,
//     required this.idForm,
//   });
//   final String idForm;
//   @override
//   State<HalamanFormKlasik> createState() => _HalamanFormKlasikState();
// }

// class _HalamanFormKlasikState extends State<HalamanFormKlasik> {
//   PilihanHalaman halamanTampilan = PilihanHalaman.halamanForm;
//   bool sudahPengecekan = false;
//   FormController? controller;
//   String pesanLoading = "Memuat Data Form";
//   initData() async {
//     print("masuk initData");
//     final temp =
//         await DataFormController().setUpFormKlasikFlutter(widget.idForm);
//     if (temp != null) {
//       print("masuk temp");
//       controller = temp;
//       setState(() {});
//     }
//   }

//   Future<bool> pengecekanAwal() async {
//     bool formExist = true;
//     if (!formExist) {
//       halamanTampilan = PilihanHalaman.illegalId;
//       return formExist;
//     }
//     bool hasilPengecekan =
//         await DataFormController().cekCredForm(widget.idForm, "klasik");
//     if (!hasilPengecekan) {
//       halamanTampilan = PilihanHalaman.illegalCreds;
//       return hasilPengecekan;
//     }

//     return true;
//   }

//   pengecekanInit() async {
//     bool hasilPengecekan = await pengecekanAwal();
//     if (hasilPengecekan) {
//       initData();
//       setState(() {});
//       sudahPengecekan = true;
//     }
//   }

//   Widget generateKontenV2() {
//     if (sudahPengecekan) {
//       if (halamanTampilan == PilihanHalaman.halamanForm) {
//         if (controller != null) {
//           return FormKlasik(controller: controller!);
//         } else {
//           return LoadingBiasa(
//             text: "Data Form Error",
//             pakaiKembali: true,
//           );
//         }
//       } else if (halamanTampilan == PilihanHalaman.illegalId) {
//         return const ErrorIdForm();
//       } else {
//         return const ErrorAuthForm();
//       }
//     } else {
//       return LoadingBiasa(
//         text: "Memuat Data Form",
//         pakaiKembali: false,
//       );
//     }
//   }

//   pengecekanCreds() async {
//     //check if exist
//     bool hasilPengecekan =
//         // await DataFormController().cekCredForm(widget.idForm, "klasik");
//         true;
//     print("ini hasil pengecekan -> $hasilPengecekan");
//     if (hasilPengecekan) {
//       sudahPengecekan = true;
//       print("sudah pengecekan di truekan");
//       initData();
//       setState(() {});
//     } else {
//       if (!context.mounted) return;
//       context.goNamed(RouteConstant.home);
//     }
//   }

//   Widget generateKonten() {
//     if (controller == null) {
//       return LoadingBiasa(
//         text: "Memuat Data Form",
//         pakaiKembali: false,
//       );
//     } else {
//       return FormKlasik(controller: controller!);
//     }
//   }

//   @override
//   void initState() {
//     pengecekanCreds();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: const PreferredSize(
//           preferredSize: Size.fromHeight(75),
//           child: HeaderNonMain(),
//         ),
//         body: generateKonten());
//   }
// }