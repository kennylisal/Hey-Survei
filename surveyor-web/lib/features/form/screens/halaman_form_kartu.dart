import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hei_survei/app/widgets/header_non_main.dart';
import 'package:hei_survei/features/form/data_form_controller.dart';
import 'package:hei_survei/features/form/error_auth.dart';
import 'package:hei_survei/features/form/error_idform.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/form_state.dart';
import 'package:hei_survei/features/form/widget/container_soal_kartu.dart';
import 'package:hei_survei/features/form/widget/judul_form.dart';
import 'package:hei_survei/features/form/widget/petunjuk_form.dart';
import 'package:hei_survei/features/form/widget/sidebar_kartu.dart';
import 'package:hei_survei/features/form/widget/tanda_cabang.dart';
import 'package:hei_survei/features/form/widget/tidak_ada_cabang.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

enum PilihanHalaman { illegalId, illegalCreds, halamanForm }

class HalamanFormKartu extends StatefulWidget {
  const HalamanFormKartu({
    super.key,
    required this.idForm,
  });
  final String idForm;
  @override
  State<HalamanFormKartu> createState() => _HalamanFormKartuState();
}

class _HalamanFormKartuState extends State<HalamanFormKartu> {
  PilihanHalaman halamanTampilan = PilihanHalaman.halamanForm;
  bool sudahPengecekan = false;
  FormController? controller;

  Future<bool> pengecekanAwal() async {
    bool formExist = await DataFormController().cekExistKartu(widget.idForm);
    // false;

    if (!formExist) {
      halamanTampilan = PilihanHalaman.illegalId;
      return formExist;
    }
    bool hasilPengecekan =
        await DataFormController().cekCredForm(widget.idForm, "kartu");
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
    final temp =
        await DataFormController().setUpFormKartuFlutter(widget.idForm);
    if (temp != null) {
      controller = temp;
      setState(() {});
    }
  }

  Widget generateKontenV2() {
    if (sudahPengecekan) {
      if (halamanTampilan == PilihanHalaman.halamanForm) {
        if (controller != null) {
          return FormKartu(controller: controller!);
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
        body: generateKontenV2());
  }
}

class FormKartu extends ConsumerStatefulWidget {
  FormKartu({
    super.key,
    required this.controller,
  });
  FormController controller;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormKartuState();
}

class _FormKartuState extends ConsumerState<FormKartu>
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
            ContainerSoalKartu(
              controller: state.listSoalCabang[state.indexCabang],
              formController: widget.controller,
            ),
          ],
        );
      }
    } else {
      return ContainerSoalKartu(
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
        return
            // generateBody(constraints, temp);
            Row(
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.24,
              height: double.infinity,
              child: SideBarKartu(
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


 // generateBody(BoxConstraints constraints, FormStateX temp) {
  //   if (!widget.controller.isLoading) {
  //     return Row(
  //       children: [
  //         SizedBox(
  //           width: constraints.maxWidth * 0.24,
  //           height: double.infinity,
  //           child: SideBarKartu(
  //             formController: widget.controller,
  //             tabController: _tabcontroller,
  //           ),
  //         ),
  //         Container(
  //           width: constraints.maxWidth * 0.75,
  //           height: double.infinity,
  //           color: Theme.of(context).colorScheme.primaryContainer,
  //           child: SingleChildScrollView(
  //             scrollDirection: Axis.vertical,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const Spacer(),
  //                 Container(
  //                   width: constraints.maxWidth > 1400
  //                       ? 1040
  //                       : constraints.maxWidth * 0.740,
  //                   color: Theme.of(context).colorScheme.primaryContainer,
  //                   child: Column(
  //                     children: [
  //                       JudulForm(controller: temp.controllerJudul),
  //                       PetunjukForm(controller: temp.controllerPetunjuk),
  //                       generateKontenUtama(temp)
  //                     ],
  //                   ),
  //                 ),
  //                 const Spacer(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   } else {
  //     return LoadingBiasa(
  //         text: "Sedang memproses publikasi", pakaiKembali: false);
  //   }
  // }
//form kartu sebelum enkripsi
// class HalamanFormKartu extends StatefulWidget {
//   const HalamanFormKartu({
//     super.key,
//     required this.idForm,
//   });
//   final String idForm;
//   @override
//   State<HalamanFormKartu> createState() => _HalamanFormKartuState();
// }

// class _HalamanFormKartuState extends State<HalamanFormKartu> {
//   bool sudahPengecekan = false;
//   FormController? controller;
//   bool hasilPengecekan = false;

//   initData() async {
//     final temp =
//         await DataFormController().setUpFormKartuFlutter(widget.idForm);
//     if (temp != null) {
//       controller = temp;
//       setState(() {});
//     }
//   }

//   pengecekanCreds() async {
//     hasilPengecekan =
//         // await DataFormController().cekCredForm(widget.idForm, "kartu");
//         true;
//     sudahPengecekan = true;
//     setState(() {});
//     if (hasilPengecekan) {
//       await initData();
//     }
//     setState(() {});
//   }

//   @override
//   void initState() {
//     pengecekanCreds();
//     super.initState();
//   }

//   Widget generateKonten() {
//     if (!sudahPengecekan) {
//       return LoadingBiasa(
//         text: "Mengecek Kredensial",
//         pakaiKembali: false,
//       );
//     } else {
//       if (hasilPengecekan) {
//         if (controller == null) {
//           return LoadingBiasa(
//             text: "Memuat Data Form",
//             pakaiKembali: false,
//           );
//         } else {
//           return FormKartu(controller: controller!);
//         }
//       } else {
//         return const ErrorAuthForm();
//       }
//     }
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