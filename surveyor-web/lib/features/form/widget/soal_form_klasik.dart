import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/features/form/constant.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_state.dart';
import 'package:hei_survei/features/form/widget/quill_soal.dart';
import 'package:hei_survei/features/form/widget/tampilan_gambar_soal_klasik.dart';
import 'package:hei_survei/features/form/widget/tampilan_teks_cabang.dart';
import 'package:hei_survei/features/form/widget/tombol_biru.dart';
import 'package:hei_survei/features/form/widget/tombol_merah.dart';

class SoalFormKlasik extends ConsumerStatefulWidget {
  SoalFormKlasik({
    super.key,
    required this.controller,
    required this.formController,
  });
  PertanyaanController controller;
  FormController formController;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SoalFormKlasikState();
}

class _SoalFormKlasikState extends ConsumerState<SoalFormKlasik> {
  late StateNotifierProvider<PertanyaanController, PertanyaanState> provider;
  @override
  void initState() {
    provider = StateNotifierProvider((ref) => widget.controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(provider);
    return LayoutBuilder(
      builder: (context, constraints) => Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: DragTarget<Tipesoal>(
            onAcceptWithDetails: (details) {
              setState(() {
                widget.controller.gantiTipeJawabanKlasik(
                  details.data,
                  widget.formController,
                );
              });
            },
            builder: (context, candidateData, rejectedData) => Column(
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
                          QuilSoal(quillController: state.quillController),
                          (state as PertanyaanKlasikState).isBergambar
                              ? TampilanGambar(
                                  urlGambar: state.urlGambar,
                                  onPressed: () async {
                                    // controller.aturUrlGambar(context);
                                    widget.controller.aturUrlGambar(context);
                                    setState(() {});
                                  },
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
                              onChanged: (value) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                widget.controller.gantiTipeJawabanKlasik(
                                  value!,
                                  widget.formController,
                                );
                                // setState(() {});
                              },
                            ),
                          ),
                          state.isBergambar
                              ? TombolMerah(
                                  onPressed: () {
                                    setState(() {
                                      widget.controller.setLogicGambar(false);
                                    });
                                  },
                                )
                              : TombolBiru(
                                  onPressed: () {
                                    setState(() {
                                      widget.controller.setLogicGambar(true);
                                    });
                                  },
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
                      child: widget.controller.generateWidgetSoalKartu(
                        widget.controller,
                        widget.formController,
                      ),
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
                widget.controller
                    .generateFooterKlasik(context, widget.formController),
              ],
            ),
          )),
    );
  }
}
