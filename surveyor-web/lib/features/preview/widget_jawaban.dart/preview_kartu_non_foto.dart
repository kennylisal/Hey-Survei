import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/constant.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_state.dart';
import 'package:hei_survei/features/form/widget/tampilan_teks_cabang.dart';
import 'package:hei_survei/features/preview/widgets/quill_soal_preview.dart';

class PreviewKartuNonFoto extends StatelessWidget {
  PreviewKartuNonFoto({
    super.key,
    required this.controller,
    required this.formController,
  });
  PertanyaanController controller;
  FormController formController;
  @override
  Widget build(BuildContext context) {
    PertanyaanState state = controller.getState();
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                      soal:
                          (state as PertanyaanCabangKartuState).kataPertanyaan,
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
                            PreviewQuilSoal(
                                quillController: state.quillController),
                            const SizedBox(height: 8),
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
                                controller.generateJawabanPreview(controller),
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
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  // controller.generateFooterKartu(context, formController),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
