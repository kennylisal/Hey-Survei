import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/constant.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_state.dart';
import 'package:hei_survei/features/form/widget/quill_soal.dart';
import 'package:hei_survei/features/form/widget/tampilan_teks_cabang.dart';

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
