import 'package:aplikasi_admin/features/master_barrel/widgets/tombol_row.dart';
import 'package:aplikasi_admin/features/master_component/header_master.dart';
import 'package:aplikasi_admin/features/master_component/loading_tengah.dart';
import 'package:aplikasi_admin/features/master_faq/faq.dart';
import 'package:aplikasi_admin/features/master_faq/faq_controller.dart';
import 'package:aplikasi_admin/utils/web_pagination.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HalamanFAQ extends StatefulWidget {
  HalamanFAQ({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<HalamanFAQ> createState() => _HalamanFAQState();
}

class _HalamanFAQState extends State<HalamanFAQ> {
  List<FAQ> listData = [];
  List<FAQ> listDataSimpanan = [];
  List<FAQ> listDataTampilan = [];
  int jumlahHalaman = 0;
  int jumlahItemPerhalaman = 7;
  int ctrPagination = 1;

  String kataSearch = "";
  bool isModeC = false;
  @override
  void initState() {
    Future(() async {
      listData = await FAQController().getFAQ();
      listDataSimpanan = listData;
      setPagination();
      setState(() {});
    });

    super.initState();
  }

  siapkanData() {
    setState(() {
      kataSearch = controller.text;
      listDataTampilan = listData
          .where((element) => element.controllerPertanyaan.text
              .toLowerCase()
              .contains(kataSearch))
          .toList();
    });
  }

  setPagination() {
    if (listDataSimpanan.isEmpty) {
      jumlahHalaman = 0;
      ctrPagination = 0;
      isiHasilDitampilkan(0);
    } else {
      jumlahHalaman = (listDataSimpanan.length ~/ jumlahItemPerhalaman) +
          ((listDataSimpanan.length % jumlahItemPerhalaman > 0) ? 1 : 0);
      print(
          "isi hasil ditampilkan ->  lbh 1 || jumlah halaman -> $jumlahHalaman");
      isiHasilDitampilkan(1);
      ctrPagination = 1;
    }
  }

  isiHasilDitampilkan(int nomorHalaman) {
    if (nomorHalaman != 0) {
      int index = nomorHalaman - 1;
      int awal = index * jumlahItemPerhalaman;
      int jumlah = 0;
      if ((awal + jumlahItemPerhalaman) >= listDataSimpanan.length) {
        jumlah = listDataSimpanan.length;
      } else {
        jumlah = nomorHalaman * jumlahItemPerhalaman;
      }

      print("ini awal -> $awal || ini jumlah -> $jumlah");
      List<FAQ> temp = listDataSimpanan.sublist(awal, jumlah);
      listDataTampilan = temp;
    }
    setState(() {});
  }

  List<TableRow> generateTableRow(BuildContext context) {
    List<TableRow> temp = [];
    for (var element in listDataTampilan) {
      temp.add(TableRow(children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              maxLines: 2,
              controller: element.controllerPertanyaan,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17.5,
                  height: 1.55,
                  letterSpacing: 0.85),
              decoration: InputDecoration(border: InputBorder.none),
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              maxLines: 2,
              controller: element.controllerJawaban,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17.5,
                  height: 1.65,
                  letterSpacing: 0.875),
              decoration: InputDecoration(border: InputBorder.none),
            )),
        Container(
            padding: const EdgeInsets.only(top: 6),
            child: (element.isBaru)
                ? RowBaru(
                    onPressedHapus: () {
                      setState(() {
                        listData.removeWhere((e) => element.idFAQ == e.idFAQ);
                        // listFAQ.removeAt(i);
                      });
                    },
                    onPressedTambah: () async {
                      bool hasil = await FAQController().buatFAQ(
                        context,
                        element.idFAQ,
                        element.controllerPertanyaan.text,
                        element.controllerJawaban.text,
                      );
                      if (hasil) {
                        setState(() {
                          element.isBaru = false;
                        });
                      } else {
                        listData.removeWhere((e) => element.idFAQ == e.idFAQ);
                      }
                    },
                  )
                : RowUpdate(
                    onPressHapus: () async {
                      bool hasil = await FAQController()
                          .hapusFAQ(context, element.idFAQ);
                      if (hasil) {
                        setState(() {
                          listData.removeWhere((e) => element.idFAQ == e.idFAQ);
                        });
                        isiHasilDitampilkan(ctrPagination);
                      }
                    },
                    onPressUpdate: () {
                      FAQController().updateFAQ(
                        context,
                        element.controllerPertanyaan.text,
                        element.controllerJawaban.text,
                        element.idFAQ,
                      );
                    },
                  )),
      ]));
    }

    return temp;
  }

  Widget contentGenerator() {
    if (listData.isNotEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderMaster(
              constraints: widget.constraints,
              controller: controller,
              hintText: "Cari FAQ",
              onSubmitted: (value) {
                siapkanData();
                setPagination();
              },
              onTap: () {
                siapkanData();
                setPagination();
              },
              onTapReset: () {
                controller.text = "";
                siapkanData();
                setPagination();
              },
              textJudul: "Master FAQ",
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Daftar Pertanyaan",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 120),
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  size: 24,
                  color: Colors.white,
                ),
                label: Text(
                  "Pertanyaan baru",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    kataSearch = "";

                    listData.add(
                      FAQ(
                        jawaban: "",
                        idFAQ: const Uuid().v4().substring(0, 8),
                        pertanyaan: "",
                        isBaru: true,
                        controllerJawaban: TextEditingController(),
                        controllerPertanyaan: TextEditingController(),
                      ),
                    );
                    listDataSimpanan = listData;
                    ctrPagination = jumlahHalaman;
                    isiHasilDitampilkan(jumlahHalaman);
                  });
                  // scrollController.animateTo(
                  //   scrollController.position.maxScrollExtent,
                  //   duration: const Duration(milliseconds: 500),
                  //   curve: Curves.fastOutSlowIn,
                  // );
                },
              ),
            ),
            Center(
              child: Container(
                // height: 700,
                width: 1100,
                margin: EdgeInsets.only(top: 16),
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  child: Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FractionColumnWidth(0.40),
                      1: FractionColumnWidth(0.40),
                      2: FractionColumnWidth(0.2),
                    },
                    border: TableBorder.all(
                      borderRadius: BorderRadius.circular(20),
                      width: 2,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade100,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20))),
                            height: 40,
                            child: Center(
                                child: Text(
                              "Pertanyaan",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                          ),
                          Container(
                            color: Colors.blueAccent.shade100,
                            height: 40,
                            child: Center(
                                child: Text(
                              "Jawaban",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade100,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20))),
                            height: 40,
                            child: Center(
                                child: Text(
                              "Aksi",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                          ),
                        ],
                      ),
                      ...generateTableRow(context)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            WebPagination(
              onPageChanged: (value) {
                setState(() {
                  ctrPagination = value;
                  isiHasilDitampilkan(ctrPagination);
                });
              },
              currentPage: ctrPagination,
              totalPage: jumlahHalaman,
              displayItemCount: 5,
            ),
            const SizedBox(height: 16)
          ],
        ),
      );
    } else {
      return const LoadingTengah();
    }
  }

  final controller = TextEditingController();
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return contentGenerator();
  }
}

// for (var i = 0; i < listTampilan.length; i++) {
    //   temp.add(TableRow(children: [
    //     Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 10),
    //         child: TextField(
    //           maxLines: 2,
    //           controller: listFAQ[i].controllerPertanyaan,
    //           style: Theme.of(context).textTheme.displayLarge!.copyWith(
    //               color: Colors.black,
    //               fontSize: 17.5,
    //               height: 1.55,
    //               letterSpacing: 0.85),
    //           decoration: InputDecoration(border: InputBorder.none),
    //         )),
    //     Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 10),
    //         child: TextField(
    //           maxLines: 2,
    //           controller: listFAQ[i].controllerJawaban,
    //           style: Theme.of(context).textTheme.displayLarge!.copyWith(
    //               color: Colors.black,
    //               fontSize: 17.5,
    //               height: 1.65,
    //               letterSpacing: 0.875),
    //           decoration: InputDecoration(border: InputBorder.none),
    //         )),
    //     Container(
    //         padding: const EdgeInsets.only(top: 6),
    //         child: (listFAQ[i].isBaru)
    //             ? RowBaru(
    //                 onPressedHapus: () {
    //                   setState(() {
    //                     listFAQ.removeAt(i);
    //                   });
    //                 },
    //                 onPressedTambah: () async {
    //                   bool hasil = await FAQController().buatFAQ(
    //                     context,
    //                     listFAQ[i].idFAQ,
    //                     listFAQ[i].controllerPertanyaan.text,
    //                     listFAQ[i].controllerJawaban.text,
    //                   );
    //                   if (hasil) {
    //                     setState(() {
    //                       listFAQ[i].isBaru = false;
    //                     });
    //                   } else {
    //                     listFAQ.removeAt(i);
    //                   }
    //                 },
    //               )
    //             : RowUpdate(
    //                 onPressHapus: () {
    //                   setState(() {
    //                     FAQController().hapusFAQ(context, listFAQ[i].idFAQ);
    //                     listFAQ.removeAt(i);
    //                   });
    //                 },
    //                 onPressUpdate: () {
    //                   FAQController().updateFAQ(
    //                     context,
    //                     listFAQ[i].controllerPertanyaan.text,
    //                     listFAQ[i].controllerJawaban.text,
    //                     listFAQ[i].idFAQ,
    //                   );
    //                 },
    //               )),
    //   ]));
    // }


// class HalamanFAQ extends StatefulWidget {
//   HalamanFAQ({
//     super.key,
//     required this.constraints,
//   });
//   BoxConstraints constraints;
//   @override
//   State<HalamanFAQ> createState() => _HalamanFAQState();
// }

// class _HalamanFAQState extends State<HalamanFAQ> {
//   List<FAQ> listFAQ = [];
//   List<FAQ> listTampilan = [];

//   String kataSearch = "";

//   FAQ pilihan = FAQ(jawaban: "", idFAQ: "x-x", pertanyaan: "");
//   bool isModeC = false;
//   @override
//   void initState() {
//     Future(() async {
//       listFAQ = await FAQController().getFAQ();
//       listFAQ.add(FAQ(
//         jawaban:
//             "The debugEmulateFlutterTesterEnvironment getter is deprecated and will be removed in a future release. Please use `debugEmulateFlutterTesterEnvironment` from `dart:ui_web` instead.",
//         idFAQ: "ayaa",
//         pertanyaan:
//             'o see Tom Segura & Bert Kreischer LIVE at The MGM Grand Garden Arena, February 10th, 2024. Tickets availa',
//       ));
//       listFAQ.add(FAQ(
//         jawaban:
//             "Pertanya kedua soal yg bagaiaman caranya bisa lulus dari ini tempat",
//         idFAQ: "ayaddfa",
//         pertanyaan:
//             'Fokus bikin tugasmu saja, jangan terlalu pusing yg lain, ygpetning selesai harusnya aman',
//       ));
//       listFAQ.add(FAQ(
//         jawaban:
//             "Pertanya ketiga soal hidupmu sekarang, sebenarnya tidak terlalu parah bgmn ji ia ",
//         idFAQ: "ayaddfa",
//         pertanyaan:
//             'Habis ini banyak rencana yg mau kucoba dan kutelusuri jadi aman ji harusntya',
//       ));
//       listTampilan = listFAQ;
//       setState(() {});
//     });

//     super.initState();
//   }

//   search() {
//     setState(() {
//       kataSearch = controller.text;
//     });
//   }

//   gantiMode() {
//     setState(() {
//       controllerID.text = "";
//       controllerJawaban.text = "";
//       controllerPertanyaan.text = "";
//       controllerJawabanC.text = "";
//       controllerPertanyaanC.text = "";
//     });
//   }

//   List<TableRow> generateTableRow(BuildContext context) {
//     List<TableRow> temp = [];
//     listTampilan = listFAQ
//         .where(
//             (element) => element.pertanyaan.toLowerCase().contains(kataSearch))
//         .toList();
//     for (var element in listTampilan) {
//       temp.add(TableRow(children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           child: InkWell(
//             onTap: () {
//               pilihan = element;
//               controllerID.text = element.idFAQ;
//               controllerPertanyaan.text = element.pertanyaan;
//               controllerJawaban.text = element.jawaban;
//             },
//             child: HoverBuilder(
//               builder: (isHovered) => Text(
//                 element.pertanyaan,
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: (isHovered)
//                           ? Colors.greenAccent.shade400
//                           : Colors.black,
//                       fontSize: 21,
//                       fontWeight: FontWeight.bold,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//               ),
//             ),
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(16),
//           child: TextField(
//             enabled: false,
//             decoration: const InputDecoration.collapsed(hintText: ""),
//             controller: TextEditingController(text: element.jawaban),
//             style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: Colors.black,
//                   fontSize: 17,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//             minLines: 1,
//             maxLines: 4,
//           ),
//         ),
//       ]));
//     }

//     return temp;
//   }

//   final controller = TextEditingController();
//   //mode RUD
//   final controllerPertanyaan = TextEditingController();
//   final controllerJawaban = TextEditingController();
//   final controllerID = TextEditingController();

//   //mode C
//   final controllerPertanyaanC = TextEditingController();
//   final controllerJawabanC = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return (listFAQ.isNotEmpty)
//         ? Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 HeaderMaster(
//                   constraints: widget.constraints,
//                   controller: controller,
//                   hintText: "Cari FAQ",
//                   onSubmitted: (value) => search(),
//                   onTap: () => search(),
//                   onTapReset: () {
//                     controller.text = "";
//                     search();
//                   },
//                   textJudul: "Master FAQ",
//                 ),
//                 const SizedBox(height: 40),
//                 Center(
//                   child: Text(
//                     "Tabel Data",
//                     style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                           color: Colors.black,
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ),
//                 Center(
//                   child: Container(
//                     height: 350,
//                     width: 1250,
//                     margin: EdgeInsets.only(top: 16),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Table(
//                         columnWidths: const <int, TableColumnWidth>{
//                           0: FractionColumnWidth(0.375),
//                           1: FractionColumnWidth(0.625),
//                         },
//                         border: TableBorder.all(
//                           borderRadius: BorderRadius.circular(20),
//                           width: 2,
//                         ),
//                         children: [
//                           TableRow(
//                             children: [
//                               Container(
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     color: Colors.blueAccent.shade100,
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(20))),
//                                 child: Center(
//                                     child: Text(
//                                   "Pertanyaan ",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayLarge!
//                                       .copyWith(
//                                         color: Colors.black,
//                                         fontSize: 21,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 )),
//                               ),
//                               Container(
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     color: Colors.blueAccent.shade100,
//                                     borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(20))),
//                                 child: Center(
//                                     child: Text(
//                                   "Jawaban",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayLarge!
//                                       .copyWith(
//                                         color: Colors.black,
//                                         fontSize: 21,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 )),
//                               ),
//                             ],
//                           ),
//                           ...generateTableRow(context)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 20, horizontal: 80),
//                         margin: const EdgeInsets.only(left: 48, right: 24),
//                         decoration: BoxDecoration(
//                             color: Colors.blueGrey.shade100.withOpacity(0.6),
//                             border: Border.all(
//                                 width: 2, color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade200.withOpacity(0.7),
//                                 spreadRadius: 4,
//                                 blurRadius: 4,
//                                 offset:
//                                     Offset(1, 1), // changes position of shadow
//                               ),
//                             ]),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Center(
//                               child: Text(
//                                 "Read Update Delete",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayLarge!
//                                     .copyWith(
//                                       color: Colors.black,
//                                       fontSize: 44,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                               ),
//                             ),
//                             const SizedBox(height: 48),
//                             FieldContainer(
//                               controller: controllerID,
//                               textJudul: "ID FAQ",
//                               hintText: "ID",
//                               minLines: 1,
//                               enabled: false,
//                             ),
//                             const SizedBox(height: 18),
//                             FieldContainer(
//                               controller: controllerPertanyaan,
//                               textJudul: "Pertanyaan FAQ",
//                               hintText: "Pertanyaan",
//                               minLines: 4,
//                               enabled: true,
//                             ),
//                             const SizedBox(height: 18),
//                             FieldContainer(
//                               controller: controllerJawaban,
//                               textJudul: "Jawaban FAQ",
//                               hintText: "Jawaban",
//                               minLines: 4,
//                               enabled: true,
//                             ),
//                             const SizedBox(height: 18),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     if (pilihan.idFAQ != 'x-x') {
//                                       FAQController().updateFAQ(
//                                           context,
//                                           controllerPertanyaan.text,
//                                           controllerJawaban.text,
//                                           pilihan.idFAQ);
//                                       setState(() {
//                                         listFAQ.removeWhere((element) =>
//                                             element.idFAQ == pilihan.idFAQ);
//                                         FAQ temp = FAQ(
//                                             jawaban: controllerJawaban.text,
//                                             idFAQ: pilihan.idFAQ,
//                                             pertanyaan:
//                                                 controllerPertanyaan.text);
//                                         listFAQ.add(temp);
//                                       });
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blueAccent.shade700,
//                                   ),
//                                   child: Container(
//                                     height: 50,
//                                     width: 110,
//                                     child: Center(
//                                       child: Text(
//                                         "Update FAQ",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .labelSmall!
//                                             .copyWith(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                             ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     if (pilihan.idFAQ != 'x-x') {
//                                       FAQController()
//                                           .hapusFAQ(context, pilihan.idFAQ);
//                                       setState(() {
//                                         controllerID.text = "";
//                                         controllerJawaban.text = "";
//                                         controllerPertanyaan.text = "";
//                                         listFAQ.removeWhere((element) =>
//                                             element.idFAQ == pilihan.idFAQ);
//                                       });
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red.shade600,
//                                   ),
//                                   child: Container(
//                                     height: 50,
//                                     width: 100,
//                                     child: Center(
//                                       child: Text(
//                                         "Delete FAQ",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .labelSmall!
//                                             .copyWith(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                             ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         margin: const EdgeInsets.only(left: 24, right: 48),
//                         decoration: BoxDecoration(
//                             color: Colors.brown.shade100.withOpacity(0.6),
//                             border: Border.all(
//                                 width: 2, color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade200.withOpacity(0.7),
//                                 spreadRadius: 4,
//                                 blurRadius: 4,
//                                 offset:
//                                     Offset(0, 0), // changes position of shadow
//                               ),
//                             ]),
//                         child: Column(
//                           children: [
//                             Center(
//                               child: Text(
//                                 "Create FAQ",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayLarge!
//                                     .copyWith(
//                                       color: Colors.black,
//                                       fontSize: 44,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                               ),
//                             ),
//                             const SizedBox(height: 48),
//                             FieldContainer(
//                               controller: controllerPertanyaanC,
//                               textJudul: "Pertanyaan FAQ",
//                               hintText: "Pertanyaan",
//                               minLines: 4,
//                               enabled: true,
//                             ),
//                             const SizedBox(height: 30),
//                             FieldContainer(
//                               controller: controllerJawabanC,
//                               textJudul: "Jawaban FAQ",
//                               hintText: "Jawaban",
//                               minLines: 4,
//                               enabled: true,
//                             ),
//                             const SizedBox(height: 24),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 final pertanyaan = controllerJawabanC.text;
//                                 final jawaban = controllerJawabanC.text;
//                                 final id = const Uuid().v4().substring(0, 8);

//                                 setState(() {
//                                   listFAQ.add(FAQ(
//                                       jawaban: jawaban,
//                                       idFAQ: id,
//                                       pertanyaan: pertanyaan));
//                                 });

//                                 FAQController()
//                                     .buatFAQ(context, id, pertanyaan, jawaban);
//                                 controllerJawabanC.text = "";
//                                 controllerPertanyaanC.text = "";
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blueAccent.shade700,
//                               ),
//                               child: Container(
//                                 height: 60,
//                                 width: 125,
//                                 child: Center(
//                                   child: Text(
//                                     "Buat FAQ",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .labelSmall!
//                                         .copyWith(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 71),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16)
//               ],
//             ),
//           )
//         : const LoadingTengah();
//   }
// }
