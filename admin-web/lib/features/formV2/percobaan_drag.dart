import 'package:aplikasi_admin/features/formV2/constant.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PerobaanDragable extends StatefulWidget {
  const PerobaanDragable({super.key});

  @override
  State<PerobaanDragable> createState() => _PerobaanDragableState();
}

class _PerobaanDragableState extends State<PerobaanDragable> {
  Tipesoal tipePilihan = Tipesoal.pilihanGanda;
  // Tipesoal dragPilihan = Tipesoal.pilihanGanda;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Container(
              width: constraints.maxWidth * 0.25,
              height: double.infinity,
              child: Column(
                children: [
                  // Draggable<Tipesoal>(
                  //   // onDragStarted: () {
                  //   //   print("Dipilih pilihan ganda");
                  //   //   dragPilihan = Tipesoal.pilihanGanda;
                  //   // },
                  //   // onDragUpdate: (details) {
                  //   //   print("Dipilih pilihan ganda");
                  //   //   dragPilihan = Tipesoal.pilihanGanda;
                  //   // },
                  //   data: Tipesoal.pilihanGanda,
                  //   child: Container(
                  //     height: 100,
                  //     width: 100,
                  //     color: Colors.amber,
                  //     child: Text("Pilgan"),
                  //   ),
                  //   feedback: Container(
                  //     height: 100,
                  //     width: 100,
                  //     color: Colors.green,
                  //   ),
                  //   childWhenDragging: Container(
                  //     height: 100,
                  //     width: 100,
                  //     color: Colors.red,
                  //     child: Icon(Icons.circle_outlined),
                  //   ),
                  // ),
                  // SizedBox(height: 16),
                  // Draggable<Tipesoal>(
                  //   // onDragStarted: () {
                  //   //   print("Dipilih kotak centang");
                  //   //   dragPilihan = Tipesoal.kotakCentang;
                  //   // },
                  //   // onDragUpdate: (details) {
                  //   //   print("Dipilih kotak centang");
                  //   //   dragPilihan = Tipesoal.kotakCentang;
                  //   // },
                  //   data: Tipesoal.kotakCentang,
                  //   child: Container(
                  //     height: 100,
                  //     width: 100,
                  //     color: Colors.amber,
                  //     child: Text("kotak centang"),
                  //   ),
                  //   feedback: Container(
                  //     height: 100,
                  //     width: 100,
                  //     color: Colors.green,
                  //   ),
                  //   childWhenDragging: Container(
                  //     height: 100,
                  //     width: 100,
                  //     color: Colors.red,
                  //     child: Icon(Icons.square),
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    width: 205,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.5),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pilihan Ganda",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        DottedBorder(
                          padding: EdgeInsets.all(3),
                          borderType: BorderType.RRect,
                          strokeWidth: 2,
                          child: Draggable<Tipesoal>(
                            data: Tipesoal.kotakCentang,
                            child: Container(
                              height: 35,
                              width: 35,
                              color: Colors.grey.shade300,
                              child: Icon(Icons.circle_outlined),
                            ),
                            feedback: Container(
                              height: 35,
                              width: 35,
                              color: Colors.grey.shade300,
                              child: Icon(Icons.circle_outlined),
                            ),
                            childWhenDragging: Container(
                              height: 35,
                              width: 35,
                              color: Colors.white,
                              child: Icon(Icons.square),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  KolomTipeSoalDrag()
                  // Container(
                  //     decoration: BoxDecoration(border: Border.all(width: 1.5)),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 14, vertical: 10),
                  //     width: 240,
                  //     height: 400,
                  //     child: SingleChildScrollView(
                  //       child: Column(
                  //         children: [
                  //           for (var item in listMode)
                  //             ContainerDragTipeSoal(
                  //               tipesoal: item.tipeSoal,
                  //               icon: item.icon,
                  //             )
                  //         ],
                  //       ),
                  //     ))
                ],
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
                      width: constraints.maxWidth > 1200
                          ? 900
                          : constraints.maxWidth * 0.745,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Column(
                        children: [
                          Container(
                            width: 700,
                            height: 500,
                            color: Colors.cyan.shade200,
                            child: DragTarget<Tipesoal>(
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.cyan,
                                  child: Text(
                                      "tipe data sekarang : ${tipePilihan.value}"),
                                );
                              },
                              onAcceptWithDetails: (details) {
                                setState(() {
                                  tipePilihan = details.data;
                                });
                              },
                            ),
                          )
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
    ));
  }
}

class KolomTipeSoalDrag extends StatefulWidget {
  const KolomTipeSoalDrag({super.key});

  @override
  State<KolomTipeSoalDrag> createState() => _KolomTipeSoalDragState();
}

class _KolomTipeSoalDragState extends State<KolomTipeSoalDrag> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pilihan Tipe Soal",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: (isExpanded)
                      ? Icon(
                          Icons.arrow_upward,
                          size: 24,
                        )
                      : Icon(
                          Icons.arrow_downward,
                          size: 24,
                        )),
            )
          ],
        ),
        const SizedBox(height: 10),
        if (isExpanded)
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1.5)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            width: 240,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in listMode)
                    ContainerDragTipeSoal(
                      tipesoal: item.tipeSoal,
                      icon: item.icon,
                    )
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ContainerDragTipeSoal extends StatelessWidget {
  ContainerDragTipeSoal({
    super.key,
    required this.tipesoal,
    required this.icon,
  });
  Tipesoal tipesoal;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      width: 208,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          border: Border.all(width: 1.5),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tipesoal.value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            DottedBorder(
              padding: EdgeInsets.all(3),
              borderType: BorderType.RRect,
              strokeWidth: 2,
              child: Draggable<Tipesoal>(
                data: tipesoal,
                child: Container(
                  height: 35,
                  width: 35,
                  color: Colors.lightBlue.shade100,
                  child: icon,
                ),
                feedback: Container(
                  height: 35,
                  width: 35,
                  color: Colors.lightBlue.shade100,
                  child: icon,
                ),
                childWhenDragging: Container(
                  height: 35,
                  width: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
