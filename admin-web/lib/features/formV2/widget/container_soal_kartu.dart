import 'package:aplikasi_admin/features/formV2/constant.dart';
import 'package:aplikasi_admin/features/formV2/widget/quill_soal.dart';
import 'package:aplikasi_admin/features/formV2/widget/tampilan_teks_cabang.dart';
import 'package:aplikasi_admin/features/formV2/state/form_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_controller.dart';
import 'package:aplikasi_admin/features/formV2/state/pertanyaan_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ContainerSoalKartu extends StatelessWidget {
  ContainerSoalKartu(
      {super.key, required this.controller, required this.formController});
  PertanyaanController controller;
  FormController formController;

  Widget generateWidgetSoal() {
    if (controller.getModelSoal() == ModelSoal.modelY) {
      return SoalModelY(
        controller: controller,
        formController: formController,
      );
    } else if (controller.getModelSoal() == ModelSoal.modelZ) {
      return SoalModelZ(
        controller: controller,
        formController: formController,
      );
    } else {
      return SoalModelX(
        controller: controller,
        formController: formController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateWidgetSoal();
  }
}

class SoalModelX extends StatelessWidget {
  SoalModelX({
    super.key,
    required this.controller,
    required this.formController,
  });
  PertanyaanController controller;
  FormController formController;
  @override
  Widget build(BuildContext context) {
    PertanyaanState state = controller.getState();

    return DragTarget<Tipesoal>(
      onAcceptWithDetails: (details) {
        controller.gantiTipeJawaban(details.data);
      },
      builder: (context, candidateData, rejectedData) => Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        soal: (state as PertanyaanCabangKartuState)
                            .kataPertanyaan,
                        jawaban: state.kataJawban,
                      ),
                    Container(
                        padding: const EdgeInsets.only(
                          left: 6,
                          top: 3,
                        ),
                        child: Text(
                          'Pertanyaan',
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
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              QuilSoal(quillController: state.quillController),
                              const SizedBox(height: 8),
                              Container(
                                height: 243,
                                width: 450,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  filterQuality: FilterQuality.medium,
                                  imageUrl:
                                      (state as PertanyaanKartuState).urlGambar,
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
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) {
                                    return const Icon(
                                      Icons.error,
                                      size: 48,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  Text(
                                    'Jawaban',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  controller.generateWidgetSoalKartu(
                                      controller, formController),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Container(
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
                                          if (constraints.maxWidth > 850)
                                            Text(e.tipeSoal.value),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                controller.gantiTipeJawaban(value!);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    controller.generateFooterKartu(context, formController),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SoalModelY extends StatelessWidget {
  SoalModelY({
    super.key,
    required this.controller,
    required this.formController,
  });
  FormController formController;
  PertanyaanController controller;
  @override
  Widget build(BuildContext context) {
    PertanyaanState state = controller.getState();
    return DragTarget<Tipesoal>(
        onAcceptWithDetails: (details) {
          controller.gantiTipeJawaban(details.data);
        },
        builder: (context, candidateData, rejectedData) => Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      width: double.infinity,
                                      height: 50,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                        value: state.dataSoal.tipeSoal,
                                        items: listMode
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.tipeSoal,
                                                child: Row(
                                                  children: [
                                                    e.icon,
                                                    const SizedBox(width: 8),
                                                    if (constraints.maxWidth >
                                                        775)
                                                      Text(e.tipeSoal.value),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          controller.gantiTipeJawaban(value!);
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 400,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.black),
                                      ),
                                      child: CachedNetworkImage(
                                        filterQuality: FilterQuality.medium,
                                        imageUrl:
                                            (state as PertanyaanKartuState)
                                                .urlGambar,
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
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) {
                                          return const Icon(
                                            Icons.error,
                                            size: 48,
                                            color: Colors.red,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 24),
                                      if (state.isCabang())
                                        TampilanTeksPointer(
                                          soal: (state
                                                  as PertanyaanCabangKartuState)
                                              .kataPertanyaan,
                                          jawaban: state.kataJawban,
                                        ),
                                      Container(
                                          padding: const EdgeInsets.only(
                                            left: 6,
                                            top: 3,
                                          ),
                                          child: Text(
                                            'Pertanyaan',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )),
                                      QuilSoal(
                                          quillController:
                                              state.quillController),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Jawaban',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      controller.generateWidgetSoalKartu(
                                          controller, formController),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          controller.generateFooterKartu(
                              context, formController),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ));
  }
}

class SoalModelZ extends StatelessWidget {
  SoalModelZ({
    super.key,
    required this.controller,
    required this.formController,
  });
  FormController formController;
  PertanyaanController controller;
  @override
  Widget build(BuildContext context) {
    PertanyaanState state = controller.getState();
    return DragTarget<Tipesoal>(
      onAcceptWithDetails: (details) {
        controller.gantiTipeJawaban(details.data);
      },
      builder: (context, candidateData, rejectedData) => Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                if (state.isCabang())
                                  TampilanTeksPointer(
                                    soal: (state as PertanyaanCabangKartuState)
                                        .kataPertanyaan,
                                    jawaban: state.kataJawban,
                                  ),
                                Container(
                                    padding: const EdgeInsets.only(
                                      left: 6,
                                      top: 3,
                                    ),
                                    child: Text(
                                      'Pertanyaan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    )),
                                QuilSoal(
                                    quillController: state.quillController),
                                const SizedBox(height: 16),
                                Text(
                                  'Jawaban',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                controller.generateWidgetSoalKartu(
                                    controller, formController),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
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
                                              if (constraints.maxWidth > 775)
                                                Text(e.tipeSoal.value),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    controller.gantiTipeJawaban(value!);
                                  },
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 400,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.black),
                                ),
                                child: CachedNetworkImage(
                                  filterQuality: FilterQuality.medium,
                                  imageUrl:
                                      (state as PertanyaanKartuState).urlGambar,
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
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) {
                                    return const Icon(
                                      Icons.error,
                                      size: 48,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    controller.generateFooterKartu(context, formController),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class SoalModelZ extends ConsumerStatefulWidget {
//   SoalModelZ({
//     super.key,
//     required this.controller,
//   });
//   PertanyaanController controller;
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SoalModelZState();
// }

// class _SoalModelZState extends ConsumerState<SoalModelZ> {
//   late StateNotifierProvider<PertanyaanController, PertanyaanState> provider;
//   @override
//   void initState() {
//     provider = StateNotifierProvider((ref) => widget.controller);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(provider);
//     return Column(
//       children: [
//         LayoutBuilder(
//           builder: (context, constraints) {
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         flex: 8,
//                         child: Container(
//                           width: double.infinity,
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 4),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 24),
//                               if (state.isCabang())
//                                 TampilanTeksPointer(
//                                   soal: (state as PertanyaanCabangKartuState)
//                                       .kataPertanyaan,
//                                   jawaban: state.kataJawban,
//                                 ),
//                               Container(
//                                   padding: const EdgeInsets.only(
//                                     left: 6,
//                                     top: 3,
//                                   ),
//                                   child: Text(
//                                     'Pertanyaan',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium!
//                                         .copyWith(fontWeight: FontWeight.bold),
//                                   )),
//                               QuilSoal(quillController: state.quillController),
//                               const SizedBox(height: 16),
//                               Text(
//                                 'Jawaban',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium!
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               widget.controller
//                                   .generateWidgetSoal(widget.controller),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Flexible(
//                         fit: FlexFit.tight,
//                         flex: 3,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               width: double.infinity,
//                               height: 50,
//                               child: DropdownButton(
//                                 isExpanded: true,
//                                 style: Theme.of(context).textTheme.labelLarge,
//                                 value: state.dataSoal.tipeSoal,
//                                 items: listMode
//                                     .map(
//                                       (e) => DropdownMenuItem(
//                                         value: e.name,
//                                         child: Row(
//                                           children: [
//                                             e.icon,
//                                             const SizedBox(width: 8),
//                                             if (constraints.maxWidth > 775)
//                                               Text(e.name.value),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                     .toList(),
//                                 onChanged: (value) {
//                                   FocusScope.of(context)
//                                       .requestFocus(FocusNode());
//                                   widget.controller.gantiTipeJawaban(value!);
//                                 },
//                               ),
//                             ),
//                             Container(
//                               width: double.infinity,
//                               height: 400,
//                               margin: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 border:
//                                     Border.all(width: 2, color: Colors.black),
//                               ),
//                               child: CachedNetworkImage(
//                                 filterQuality: FilterQuality.medium,
//                                 imageUrl:
//                                     (state as PertanyaanKartuState).urlGambar,
//                                 imageBuilder: (context, imageProvider) {
//                                   return Container(
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: imageProvider,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 progressIndicatorBuilder:
//                                     (context, url, downloadProgress) =>
//                                         CircularProgressIndicator(
//                                             value: downloadProgress.progress),
//                                 errorWidget: (context, url, error) {
//                                   return const Icon(
//                                     Icons.error,
//                                     size: 48,
//                                     color: Colors.red,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   const Divider(),
//                   widget.controller.generateFooterKlasik(context),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// class SoalModelY extends ConsumerStatefulWidget {
//   SoalModelY({
//     super.key,
//     required this.controller,
//   });
//   PertanyaanController controller;
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SoalModelYState();
// }

// class _SoalModelYState extends ConsumerState<SoalModelY> {
//   late StateNotifierProvider<PertanyaanController, PertanyaanState> provider;
//   @override
//   void initState() {
//     provider = StateNotifierProvider((ref) => widget.controller);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(provider);
//     return Column(
//       children: [
//         LayoutBuilder(
//           builder: (context, constraints) {
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         fit: FlexFit.tight,
//                         flex: 3,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               width: double.infinity,
//                               height: 50,
//                               child: DropdownButton(
//                                 isExpanded: true,
//                                 style: Theme.of(context).textTheme.labelLarge,
//                                 value: state.dataSoal.tipeSoal,
//                                 items: listMode
//                                     .map(
//                                       (e) => DropdownMenuItem(
//                                         value: e.name,
//                                         child: Row(
//                                           children: [
//                                             e.icon,
//                                             const SizedBox(width: 8),
//                                             if (constraints.maxWidth > 775)
//                                               Text(e.name.value),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                     .toList(),
//                                 onChanged: (value) {
//                                   FocusScope.of(context)
//                                       .requestFocus(FocusNode());
//                                   FocusScope.of(context)
//                                       .requestFocus(FocusNode());
//                                   widget.controller.gantiTipeJawaban(value!);
//                                 },
//                               ),
//                             ),
//                             Container(
//                               width: double.infinity,
//                               height: 400,
//                               margin: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 border:
//                                     Border.all(width: 2, color: Colors.black),
//                               ),
//                               child: CachedNetworkImage(
//                                 filterQuality: FilterQuality.medium,
//                                 imageUrl:
//                                     (state as PertanyaanKartuState).urlGambar,
//                                 imageBuilder: (context, imageProvider) {
//                                   return Container(
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: imageProvider,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 progressIndicatorBuilder:
//                                     (context, url, downloadProgress) =>
//                                         CircularProgressIndicator(
//                                             value: downloadProgress.progress),
//                                 errorWidget: (context, url, error) {
//                                   return const Icon(
//                                     Icons.error,
//                                     size: 48,
//                                     color: Colors.red,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Flexible(
//                         flex: 8,
//                         child: Container(
//                           width: double.infinity,
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 4),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 24),
//                               if (state.isCabang())
//                                 TampilanTeksPointer(
//                                   soal: (state as PertanyaanCabangKartuState)
//                                       .kataPertanyaan,
//                                   jawaban: state.kataJawban,
//                                 ),
//                               Container(
//                                   padding: const EdgeInsets.only(
//                                     left: 6,
//                                     top: 3,
//                                   ),
//                                   child: Text(
//                                     'Pertanyaan',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium!
//                                         .copyWith(fontWeight: FontWeight.bold),
//                                   )),
//                               QuilSoal(quillController: state.quillController),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Jawaban',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium!
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               widget.controller
//                                   .generateWidgetSoal(widget.controller),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   const Divider(),
//                   widget.controller.generateFooterKlasik(context),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }