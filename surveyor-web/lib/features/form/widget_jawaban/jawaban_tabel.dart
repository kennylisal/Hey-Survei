import 'package:flutter/material.dart';
import 'package:hei_survei/features/form/model/data_soal.dart';
import 'package:hei_survei/features/form/state/form_controller.dart';
import 'package:hei_survei/features/form/state/pertanyaan_controller.dart';

class JawabanTabel extends StatelessWidget {
  JawabanTabel({
    super.key,
    required this.controller,
    required this.dataTable,
    required this.formController,
  });
  final DataTabel dataTable;
  final PertanyaanController controller;
  final FormController formController;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: double.infinity,
                      child: Row(
                        children: [
                          if (constraints.maxWidth > 440)
                            Text("Kolom : ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 15)),
                          _TombolTabel(
                            icon: Icons.remove,
                            onPressed: () {
                              controller.kurangKolom();
                              if (formController.isCabangShown() ||
                                  controller.isPertanyaanKartu()) {
                                formController.refreshUI();
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(dataTable.kolom.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15)),
                          const SizedBox(width: 8),
                          _TombolTabel(
                            icon: Icons.add,
                            onPressed: () {
                              controller.tambahKolom();
                              if (formController.isCabangShown() ||
                                  controller.isPertanyaanKartu()) {
                                formController.refreshUI();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: double.infinity,
                      child: Row(
                        children: [
                          if (constraints.maxWidth > 440)
                            Text("Baris    : ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 15)),
                          _TombolTabel(
                            icon: Icons.remove,
                            onPressed: () {
                              controller.kurangBaris();
                              // if (formController!.isSoalSekarangKartu())
                              if (formController.isCabangShown() ||
                                  controller.isPertanyaanKartu()) {
                                formController.refreshUI();
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(dataTable.baris.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15)),
                          const SizedBox(width: 8),
                          _TombolTabel(
                            icon: Icons.add,
                            onPressed: () {
                              controller.tambahBaris();
                              // if (formController!.isSoalSekarangKartu())
                              if (formController.isCabangShown() ||
                                  controller.isPertanyaanKartu()) {
                                formController.refreshUI();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (constraints.maxWidth > 440)
                          Text("Berjudul : ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15)),
                        Switch(
                          value: dataTable.berjudul,
                          onChanged: (value) {
                            controller.switchJudul(value);

                            if (formController.isCabangShown() ||
                                controller.isPertanyaanKartu()) {
                              formController.refreshUI();
                            }
                          },
                        ),
                      ],
                    ),
                    (dataTable.berjudul)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              dataTable.baris,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.only(right: 16),
                                width: double.infinity,
                                child: TextField(
                                  controller: dataTable.listJudul[index],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    hintText: "Judul ${index + 1}",
                                    border: const UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  child: Table(
                    border: TableBorder.all(
                        width: 2, borderRadius: BorderRadius.circular(16)),
                    columnWidths: const {
                      0: FractionColumnWidth(.33),
                      1: FractionColumnWidth(.33),
                      2: FractionColumnWidth(.33)
                    },
                    children: [
                      (dataTable.berjudul)
                          ? TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade200,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16))),
                              children: List.generate(
                                dataTable.baris,
                                (index) => Container(
                                  height: 35,
                                  child: Center(
                                    child: Text("Judul ${index + 1}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            )
                          : TableRow(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16))),
                              children: List.generate(
                                dataTable.baris,
                                (index) => Container(
                                  height: 35,
                                ),
                              ),
                            ),
                      for (var i = 0; i < dataTable.kolom; i++)
                        TableRow(
                            children: List.generate(
                          dataTable.baris,
                          (index) => Container(
                            height: 35,
                          ),
                        ))
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _TombolTabel extends StatelessWidget {
  _TombolTabel({super.key, required this.icon, required this.onPressed});
  final IconData icon;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.black,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
