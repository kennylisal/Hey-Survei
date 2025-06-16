import 'package:aplikasi_admin/features/master_barrel/widgets/tombol_row.dart';
import 'package:aplikasi_admin/features/master_component/header_master.dart';
import 'package:aplikasi_admin/features/master_component/loading_tengah.dart';
import 'package:aplikasi_admin/features/master_kategori/kategori.dart';
import 'package:aplikasi_admin/features/master_kategori/kategori_controller.dart';
import 'package:aplikasi_admin/utils/web_pagination.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HalamanKategori extends StatefulWidget {
  HalamanKategori({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;
  @override
  State<HalamanKategori> createState() => _HalamanKategoriState();
}

class _HalamanKategoriState extends State<HalamanKategori> {
  List<Kategori> listData = [];
  List<Kategori> listDataSimpanan = [];
  List<Kategori> listDataTampilan = [];
  final scrollController = ScrollController();
  String kataSearch = "";

  int jumlahHalaman = 0;
  int jumlahItemPerhalaman = 10;
  int ctrPagination = 1;

  @override
  void initState() {
    Future(() async {
      listData = await KategoriController().getKategori();
      listDataSimpanan = listData;
      setPagination();
      setState(() {});
    });
    super.initState();
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
      List<Kategori> temp = listDataSimpanan.sublist(awal, jumlah);
      listDataTampilan = temp;
    }
    setState(() {});
  }

  siapkanData() {
    setState(() {
      kataSearch = controller.text;
      listDataSimpanan = listData
          .where((element) => element.textEditingController.text
              .toLowerCase()
              .contains(kataSearch))
          .toList();
    });
  }

  List<TableRow> generateTableRow(BuildContext context) {
    List<TableRow> temp = [];

    int ctr = 0;
    for (var element in listDataTampilan) {
      temp.add(TableRow(children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            // (ctr + 1).toString(),
            ((ctrPagination - 1) * jumlahItemPerhalaman + ctr + 1).toString(),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
          ),
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: element.textEditingController,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17.5,
                  height: 1.65,
                  letterSpacing: 0.875),
              decoration: InputDecoration(border: InputBorder.none),
            )),
        (element.isBaru)
            ? RowBaru(
                onPressedHapus: () {
                  setState(() {
                    listData
                        .removeWhere((e) => e.idKategori == element.idKategori);
                  });
                },
                onPressedTambah: () {
                  print("tambah ini");
                  setState(() {
                    KategoriController().buatKategori(
                      context,
                      element.textEditingController.text,
                      element.idKategori,
                    );
                    element.isBaru = false;
                  });
                },
              )
            : RowUpdate(
                onPressHapus: () async {
                  bool hasil = await KategoriController()
                      .hapusKategori(context, element.idKategori);

                  if (hasil) {
                    setState(() {
                      listData.removeWhere(
                          (e) => e.idKategori == element.idKategori);
                    });
                    isiHasilDitampilkan(ctrPagination);
                  }
                },
                onPressUpdate: () {
                  KategoriController().updateKategori(
                    context,
                    element.idKategori,
                    element.textEditingController.text,
                  );
                },
              ),
      ]));
      ctr++;
    }

    return temp;
  }

  final controller = TextEditingController();
  // final scrollController = ScrollController();

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
              hintText: "Cari Kategori",
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
              textJudul: "Master Kategori",
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Daftar Kategori",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 33,
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
                  "Kategori baru",
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
                      Kategori(
                        namaKategori: "",
                        idKategori: const Uuid().v4().substring(0, 8),
                        isBaru: true,
                        textEditingController: TextEditingController(),
                      ),
                    );
                    listDataSimpanan = listData;
                    ctrPagination = jumlahHalaman;
                    isiHasilDitampilkan(jumlahHalaman);
                  });
                },
              ),
            ),
            Center(
              child: Container(
                width: 1100,
                margin: EdgeInsets.only(top: 16),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FractionColumnWidth(0.05),
                      1: FractionColumnWidth(0.7),
                      2: FractionColumnWidth(0.25),
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
                              "No",
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
                              "Nama Kategori",
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
            const SizedBox(height: 12),
          ],
        ),
      );
    } else {
      return const LoadingTengah();
    }
  }

  @override
  Widget build(BuildContext context) {
    return contentGenerator();
  }
}


                // Container(
                //   margin: const EdgeInsets.only(top: 3, left: 60),
                //   child: ElevatedButton(
                //       onPressed: () {
                //         setState(() {
                //           listKategori.add(
                //             Kategori(
                //               namaKategori: "",
                //               idKategori: const Uuid().v4().substring(0, 8),
                //               isBaru: true,
                //               textEditingController: TextEditingController(),
                //             ),
                //           );
                //         });
                //         scrollController.animateTo(
                //           scrollController.position.maxScrollExtent,
                //           duration: const Duration(milliseconds: 500),
                //           curve: Curves.fastOutSlowIn,
                //         );
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.blue,
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 12, horizontal: 18),
                //       ),
                //       child: Text(
                //         "Tambah",
                //         style:
                //             Theme.of(context).textTheme.displayLarge!.copyWith(
                //                   color: Colors.white,
                //                   fontSize: 19,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //       )),
                // ),
                
// class HalamanKategori extends StatefulWidget {
//   HalamanKategori({
//     super.key,
//     required this.constraints,
//   });
//   BoxConstraints constraints;
//   @override
//   State<HalamanKategori> createState() => _HalamanKategoriState();
// }

// class _HalamanKategoriState extends State<HalamanKategori> {
//   List<Kategori> listKategori = [];
//   List<Kategori> listTampilan = [];

//   String kataSearch = "";

//   // Kategori pilihan = Kategori(namaKategori: "", idKategori: "x-x");
//   bool isModeC = true;
//   @override
//   void initState() {
//     Future(() async {
//       listKategori = await KategoriController().getKategori();
//       listTampilan = listKategori;
//       setState(() {});
//     });
//     super.initState();
//   }

//   search() {
//     setState(() {
//       kataSearch = controller.text;
//     });
//   }

//   List<TableRow> generateTableRow(BuildContext context) {
//     List<TableRow> temp = [];
//     listTampilan = listKategori
//         .where((element) =>
//             element.namaKategori.toLowerCase().contains(kataSearch))
//         .toList();
//     for (var i = 0; i < listTampilan.length; i++) {
//       temp.add(TableRow(children: [
//         Container(
//             padding: const EdgeInsets.all(16),
//             child: Text((i + 1).toString(),
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: Colors.black,
//                       fontSize: 17,
//                       overflow: TextOverflow.ellipsis,
//                     ))),
//         Container(
//           padding: const EdgeInsets.all(8),
//           child: InkWell(
//             onTap: () {
//               pilihan = listTampilan[i];
//               controllerNama.text = pilihan.namaKategori;
//               controllerID.text = pilihan.idKategori;
//             },
//             child: HoverBuilder(
//               builder: (isHovered) => Text(
//                 listTampilan[i].namaKategori,
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: (isHovered)
//                           ? Colors.greenAccent.shade400
//                           : Colors.black,
//                       fontSize: 17,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//               ),
//             ),
//           ),
//         ),
//       ]));
//     }
//     return temp;
//   }

//   final controller = TextEditingController();
//   //mode RUD
//   final controllerNama = TextEditingController();
//   final controllerID = TextEditingController();

//   //mode C
//   final controllerNamaC = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return (listKategori.isNotEmpty)
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
//                   hintText: "Cari Kategori",
//                   onSubmitted: (value) => search(),
//                   onTap: () => search(),
//                   onTapReset: () {
//                     controller.text = "";
//                     search();
//                   },
//                   textJudul: "Master Kategori",
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
//                                 child: Center(
//                                     child: Text(
//                                   "No",
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
//                                 child: Center(
//                                     child: Text(
//                                   "Nama Kategori",
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
//                 const SizedBox(height: 40),
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
//                               textJudul: "ID Kategori",
//                               minLines: 1,
//                               hintText: "ID Kategori",
//                               enabled: false,
//                             ),
//                             const SizedBox(height: 48),
//                             FieldContainer(
//                               controller: controllerNama,
//                               textJudul: "Nama Kategori",
//                               minLines: 4,
//                               hintText: "Kategori",
//                               enabled: true,
//                             ),
//                             const SizedBox(height: 18),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     if (pilihan.idKategori != 'x-x') {
//                                       KategoriController().updateKategori(
//                                           context,
//                                           pilihan.idKategori,
//                                           controllerNama.text);
//                                       setState(() {
//                                         listKategori.removeWhere((element) =>
//                                             element.idKategori ==
//                                             pilihan.idKategori);
//                                         listKategori.add(Kategori(
//                                             namaKategori: controllerNama.text,
//                                             idKategori: pilihan.idKategori));
//                                       });
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blueAccent.shade700,
//                                   ),
//                                   child: Container(
//                                     height: 50,
//                                     //width: 110,
//                                     child: Center(
//                                       child: Text(
//                                         "Update Kategori",
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
//                                     if (pilihan.idKategori != 'x-x') {
//                                       KategoriController().hapusKategori(
//                                           context, pilihan.idKategori);
//                                       setState(() {
//                                         controllerID.text = "";
//                                         controllerNama.text = "";
//                                         listKategori.removeWhere((element) =>
//                                             element.idKategori ==
//                                             pilihan.idKategori);
//                                       });
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red.shade600,
//                                   ),
//                                   child: Container(
//                                     height: 50,
//                                     //width: 100,
//                                     padding:
//                                         const EdgeInsets.symmetric(vertical: 6),
//                                     child: Center(
//                                       child: Text(
//                                         "Delete Kategori",
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
//                                 "Create Kategori",
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
//                               controller: controllerNamaC,
//                               textJudul: "Nama Kategori",
//                               minLines: 4,
//                               hintText: "Kategori",
//                               enabled: true,
//                             ),
//                             const SizedBox(height: 24),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 final nama = controllerNamaC.text;
//                                 final id = const Uuid().v4().substring(0, 8);

//                                 setState(() {
//                                   listKategori.add(Kategori(
//                                       namaKategori: nama, idKategori: id));
//                                 });
//                                 KategoriController()
//                                     .buatKategori(context, nama, id);
//                                 controllerNamaC.text = "";
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blueAccent.shade700,
//                               ),
//                               child: Container(
//                                 height: 60,
//                                 width: 180,
//                                 child: Center(
//                                   child: Text(
//                                     "Buat Kategori",
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
//               ],
//             ),
//           )
//         : const LoadingTengah();
//   }
// }
