// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hei_survei/app/utama.dart';
// import 'package:hei_survei/constants.dart';
// import 'package:hei_survei/features/katalog/katalog_controller.dart';
// import 'package:hei_survei/features/katalog/model/survei_data.dart';
// import 'package:hei_survei/features/katalog/widgets/kartu_survei.dart';
// import 'package:hei_survei/utils/web_pagination.dart';

// class HalamanKatalog extends ConsumerStatefulWidget {
//   HalamanKatalog({
//     super.key,
//     required this.constraints,
//   });
//   BoxConstraints constraints;
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HalamanKatalogState();
// }

// class _HalamanKatalogState extends ConsumerState<HalamanKatalog>
//     with AutomaticKeepAliveClientMixin<HalamanKatalog> {
//   //variable pagination
//   int jumlahHalaman = 0;
//   int jumlahItemPerhalaman = 4;
//   int ctrPagination = 1;
//   List<Widget> widgetTampilan = []; //ini yg menentukan apa yg ditampilkan
//   //
//   //variabel search
//   String pilihanOrder = 'Terbaru';
//   List<SurveiData> listSurvei = [];
//   //
//   //variabel filter kategori
//   Map<String, bool>? mapCheck;
//   bool isFilterExpanded = false;
//   List<String> listKategori = [];
//   List<String> arrFilter = [];
//   //
//   final controllerSearch = TextEditingController();
//   @override
//   void initState() {
//     Future(() async {
//       listKategori = await KatalogController().getAllKategori();
//       mapCheck = Map.fromIterables(listKategori,
//           List.from(List.generate(listKategori.length, (index) => false)));
//       setState(() {});
//     });
//     super.initState();
//   }

//   resetFilter() {
//     mapCheck!.forEach((key, value) {
//       mapCheck![key] = false;
//       setState(() {});
//     });
//   }

//   siapkanFilter() {
//     arrFilter.clear();
//     mapCheck!.forEach((key, value) {
//       if (value) arrFilter.add(key);
//     });
//   }

//   List<Widget> rowGeneratorFilter(int angka, BuildContext context) {
//     int pembagi = angka;
//     int indexInduk = -1;
//     List<Widget> hasil = List.generate(
//       listKategori.length ~/ pembagi + 1,
//       (index) => Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: List.generate(pembagi, (index) {
//           if (indexInduk < listKategori.length - 1) {
//             indexInduk++;
//             String keyNow = listKategori[indexInduk];
//             //print(indexInduk);
//             return Expanded(
//                 child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     fillColor: MaterialStateColor.resolveWith(
//                         (states) => Colors.grey.shade300),
//                     checkColor: Colors.black,
//                     value: mapCheck![listKategori[indexInduk]],
//                     onChanged: (value) {
//                       setState(() {
//                         mapCheck![keyNow] = value!;
//                       });
//                     },
//                   ),
//                   Container(
//                     child: Text(
//                       listKategori[indexInduk],
//                       overflow: TextOverflow.fade,
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                             fontSize: 16,
//                             color: Colors.grey.shade100,
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//           } else {
//             return Expanded(child: SizedBox());
//           }
//         }),
//       ),
//     );
//     return hasil;
//   }

//   Widget kategoriGenerator(BoxConstraints constraints) {
//     if (mapCheck != null) {
//       if (isFilterExpanded) {
//         return Container(
//           margin: EdgeInsets.symmetric(
//               horizontal: (constraints.maxWidth > 550) ? 120 : 96,
//               vertical: 20),
//           padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
//           decoration: BoxDecoration(
//             color: Colors.blueGrey.shade700,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "Filter",
//                     style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontSize: 27,
//                           color: Colors.white,
//                         ),
//                   ),
//                   const Spacer(),
//                   IconButton.filled(
//                       onPressed: () {
//                         setState(() {
//                           isFilterExpanded = false;
//                         });
//                       },
//                       icon: Icon(
//                         Icons.arrow_upward,
//                         size: 30,
//                       ))
//                 ],
//               ),
//               Divider(
//                 color: Colors.black.withOpacity(0.6),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: rowGeneratorFilter(
//                     (constraints.maxWidth > 1700)
//                         ? 4
//                         : (constraints.maxWidth > 1080)
//                             ? 3
//                             : (constraints.maxWidth > 780)
//                                 ? 2
//                                 : 1,
//                     context),
//               ),
//               Divider(
//                 color: Colors.black.withOpacity(0.6),
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         searchSurvei(controllerSearch.text);
//                         print(arrFilter);
//                       },
//                       child: Text(
//                         "Cari",
//                         style:
//                             Theme.of(context).textTheme.displaySmall!.copyWith(
//                                   fontSize: 16,
//                                   color: Colors.grey.shade200,
//                                 ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green.shade600),
//                     ),
//                     const SizedBox(width: 12),
//                     ElevatedButton(
//                       onPressed: () {
//                         resetFilter();
//                       },
//                       child: Text(
//                         "Ulang",
//                         style:
//                             Theme.of(context).textTheme.displaySmall!.copyWith(
//                                   fontSize: 16,
//                                   color: Colors.grey.shade200,
//                                 ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red.shade600),
//                     ),
//                     const SizedBox(height: 3),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       } else {
//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//           height: 60,
//           decoration: BoxDecoration(
//             color: Colors.blueGrey.shade600,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Row(
//             children: [
//               Text(
//                 "Filter Kategori",
//                 style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                       fontSize: 27,
//                       color: Colors.white,
//                     ),
//               ),
//               const Spacer(),
//               IconButton.filled(
//                   onPressed: () {
//                     setState(() {
//                       isFilterExpanded = true;
//                     });
//                   },
//                   icon: Icon(
//                     Icons.arrow_downward,
//                     size: 30,
//                   ))
//             ],
//           ),
//         );
//       }
//     } else {
//       return const Center(
//         child: SizedBox(
//           height: 60,
//           width: 60,
//           child: CircularProgressIndicator(strokeWidth: 16),
//         ),
//       );
//     }
//   }

//   isiHasilDitampilkan(int nomorHalaman) {
//     if (nomorHalaman != 0) {
//       int index = nomorHalaman - 1;
//       int awal = index * jumlahItemPerhalaman;
//       int jumlah = 0;
//       if ((awal + jumlahItemPerhalaman) >= listSurvei.length) {
//         jumlah = listSurvei.length;
//       } else {
//         jumlah = nomorHalaman * jumlahItemPerhalaman;
//       }

//       print("ini awal -> $awal || ini jumlah -> $jumlah");
//       List<SurveiData> temp = listSurvei.sublist(awal, jumlah);
//       widgetTampilan = List.generate(
//           temp.length,
//           (index) => KartuSurvei(
//                 surveiData: temp[index],
//                 onTap: () {},
//               ));
//     }
//   }

//   List<Widget> rowGenerator(BuildContext context, int pembagi) {
//     int indexInduk = -1;

//     List<Widget> listWidget = widgetTampilan;
//     List<Widget> hasil =
//         List.generate(listWidget.length ~/ pembagi + 1, (index) {
//       return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(pembagi, (index) {
//             if (indexInduk < listWidget.length - 1) {
//               indexInduk++;
//               return listWidget[indexInduk];
//             } else
//               return SizedBox(
//                 width: 275,
//               );
//           }));
//     });

//     return hasil;
//   }

//   setPagination() {
//     setState(() {
//       if (listSurvei.isEmpty) {
//         jumlahHalaman = 0;
//         ctrPagination = 0;
//         isiHasilDitampilkan(0);
//       } else {
//         jumlahHalaman = (listSurvei.length ~/ jumlahItemPerhalaman) +
//             ((listSurvei.length % jumlahItemPerhalaman > 0) ? 1 : 0);
//         print(
//             "isi hasil ditampilkan ->  lbh 1 || jumlah halaman -> $jumlahHalaman");
//         isiHasilDitampilkan(1);
//         ctrPagination = 1;
//       }
//     });
//   }

//   generateKartuSurvei() {}

//   searchSurvei(String search) async {
//     siapkanFilter(); //ini untuk cari yg mana sja filter yg mau
//     listSurvei = await KatalogController()
//         .searchHSurvei(search: search, kategori: arrFilter);

//     sortDataSurvei(pilihanOrder);
//     setPagination();
//     // print(listSurvei);
//   }

//   sortDataSurvei(String order) {
//     setState(() {
//       pilihanOrder = order;
//       if (order == "Terbaru") {
//         listSurvei
//             .sort((b, a) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
//       } else if (order == "Terlama") {
//         listSurvei
//             .sort((a, b) => a.tanggalPenerbitan.compareTo(b.tanggalPenerbitan));
//       } else if (order == "Termurah") {
//         listSurvei.sort((a, b) => a.harga.compareTo(b.harga));
//       } else if (order == "Termahal") {
//         listSurvei.sort((b, a) => a.harga.compareTo(b.harga));
//       }
//       setPagination();
//       print(listSurvei);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double widhtMultiplier =
//         (widget.constraints.maxWidth > 1325) ? 0.16 : 0.088;
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(
//               horizontal: widget.constraints.maxWidth * widhtMultiplier,
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.blue.shade200,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20))),
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Text(
//                   "Pencarian Katalog Survei",
//                   style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 48,
//                       color: Colors.black),
//                 ),
//                 const SizedBox(height: 14),
//                 Container(
//                   width: double.infinity,
//                   height: 80,
//                   child: Row(
//                     children: [
//                       Expanded(
//                           flex: 3,
//                           child: Container(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(12),
//                                     bottomLeft: Radius.circular(12)),
//                                 color: Colors.grey.shade50,
//                               ),
//                               padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
//                               child: TextField(
//                                 controller: controllerSearch,
//                                 decoration: InputDecoration(
//                                   hintText: "Nama Survei",
//                                   border: InputBorder.none,
//                                 ),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displaySmall!
//                                     .copyWith(
//                                       fontSize: 17,
//                                       color: Colors.black,
//                                     ),
//                                 onSubmitted: (value) => searchSurvei(value),
//                               ),
//                             ),
//                           )),
//                       Container(
//                         child: Container(
//                           height: 59,
//                           width: 70,
//                           decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.only(
//                                   topRight: Radius.circular(15),
//                                   bottomRight: Radius.circular(15))),
//                           child: IconButton(
//                               onPressed: () =>
//                                   searchSurvei(controllerSearch.text),
//                               icon: Icon(
//                                 Icons.search,
//                                 color: Colors.white,
//                                 size: 36,
//                               )),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Container(
//                         width: 190,
//                         decoration: BoxDecoration(
//                             color: Colors.grey.shade50,
//                             border: Border.all(width: 2, color: Colors.black),
//                             borderRadius: BorderRadius.circular(16)),
//                         child: DropdownButton(
//                           underline: SizedBox(),
//                           isExpanded: true,
//                           borderRadius: BorderRadius.circular(16),
//                           iconSize: 36,
//                           padding:
//                               EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//                           value: pilihanOrder,
//                           style: Theme.of(context)
//                               .textTheme
//                               .displaySmall!
//                               .copyWith(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                           items: [
//                             DropdownMenuItem(
//                               child: Text("Terbaru"),
//                               value: "Terbaru",
//                             ),
//                             DropdownMenuItem(
//                               child: Text("Terlama"),
//                               value: "Terlama",
//                             ),
//                             DropdownMenuItem(
//                               child: Text("Termahal"),
//                               value: "Termahal",
//                             ),
//                             DropdownMenuItem(
//                               child: Text("Termurah"),
//                               value: "Termurah",
//                             ),
//                           ],
//                           onChanged: (value) {
//                             sortDataSurvei(value!);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           kategoriGenerator(widget.constraints),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
//             child: (widgetTampilan.isEmpty)
//                 ? TidakAdaData()
//                 : Column(children: [
//                     ...rowGenerator(
//                         context,
//                         (widget.constraints.maxWidth > 1600)
//                             ? 3
//                             : (widget.constraints.maxWidth > 1200)
//                                 ? 2
//                                 : 1),
//                     const SizedBox(height: 10),
//                     WebPagination(
//                       onPageChanged: (value) {
//                         setState(() {
//                           ctrPagination = value;
//                           isiHasilDitampilkan(ctrPagination);
//                         });
//                       },
//                       currentPage: ctrPagination,
//                       totalPage: jumlahHalaman,
//                       displayItemCount: 5,
//                     )
//                   ]),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => (baseUri == Uri.base.toString());
// }

//ini halaman katalog yg dibahpus

// // ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:hei_survei/features/katalog/katalog_controller.dart';
// import 'package:hei_survei/features/katalog/model/survei_data.dart';
// import 'package:hei_survei/utils/hover_builder.dart';
// import 'package:hei_survei/utils/navigasi_atas.dart';
// import 'package:hei_survei/utils/web_pagination.dart';
// import 'package:intl/intl.dart';

// class KatalogSurveiPage extends StatefulWidget {
//   const KatalogSurveiPage({super.key});

//   @override
//   State<KatalogSurveiPage> createState() => _KatalogSurveiPageState();
// }

// class _KatalogSurveiPageState extends State<KatalogSurveiPage> {
//   late List<Widget> listWidget;
//   bool isAvailable = false;
//   bool isExpanded = false;

//   String pesanPercobaan = "Data Normal";
//   String statusSearch = "normal";
//   List<KartuSurvei> hasilSearch = [];
//   List<KartuSurvei> hasilDitampilkan = [];
//   int jumlahItemPerhalaman = 2;
//   int jumlahHalaman = 0;
//   int _ctrPagination = 1;

//   String pilihanOrder = "Terbaru";
//   List<String> arrFilter = [];

//   final controllerSearch = TextEditingController();
//   Map<String, bool>? mapCheck;
//   String deskripsiPendek =
//       "he debugEmulateFlutterTesterEnvironment getter is deprecated and will be removed in a future release. Please use `debugEmulateFlutterTesterEnvironment` from `dart:ui_web` instead. yess i will try this next";
//   // List<String> kata = [
//   //   'pendidikan',
//   //   'sipil',
//   //   'pemerintahan',
//   //   'tiga',
//   //   'empat',
//   //   'lima',
//   //   'enam',
//   //   'tujuh',
//   //   'delapan',
//   //   'sembilan',
//   //   'sepuluh',
//   //   'sebelas',
//   //   'duaBelas',
//   //   'Kesehatan Mental', //ini 13
//   // ];

//   List<String> listKategori = [];

//   @override
//   void initState() {
//     // mapCheck = Map.fromIterables(
//     //     kata, List.from(List.generate(kata.length, (index) => false)));
//     Future(() async {
//       await siapkanKategori();
//       mapCheck = Map.fromIterables(listKategori,
//           List.from(List.generate(listKategori.length, (index) => false)));
//       setState(() {});
//     });
//     super.initState();
//   }

//   List<Widget> rowGenerator(int angka, BuildContext context) {
//     int pembagi = angka;
//     int indexInduk = -1;
//     List<Widget> hasil = List.generate(
//       listKategori.length ~/ pembagi + 1,
//       (index) => Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: List.generate(pembagi, (index) {
//           if (indexInduk < listKategori.length - 1) {
//             indexInduk++;
//             String keyNow = listKategori[indexInduk];
//             //print(indexInduk);
//             return Expanded(
//                 child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     fillColor: MaterialStateColor.resolveWith(
//                         (states) => Colors.grey.shade300),
//                     checkColor: Colors.black,
//                     value: mapCheck![listKategori[indexInduk]],
//                     onChanged: (value) {
//                       setState(() {
//                         mapCheck![keyNow] = value!;
//                       });
//                     },
//                   ),
//                   Container(
//                     child: Text(
//                       listKategori[indexInduk],
//                       overflow: TextOverflow.fade,
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                             fontSize: 16,
//                             color: Colors.grey.shade100,
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//           } else {
//             return Expanded(child: SizedBox());
//           }
//         }),
//       ),
//     );
//     return hasil;
//   }

//   Widget kategoriGenerator(BoxConstraints constraints) {
//     if (mapCheck != null) {
//       return (isExpanded)
//           ? Container(
//               margin: EdgeInsets.symmetric(
//                   horizontal: (constraints.maxWidth > 550) ? 120 : 96),
//               padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey.shade700,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         "Filter",
//                         style:
//                             Theme.of(context).textTheme.displaySmall!.copyWith(
//                                   fontSize: 27,
//                                   color: Colors.white,
//                                 ),
//                       ),
//                       const Spacer(),
//                       IconButton.filled(
//                           onPressed: () {
//                             setState(() {
//                               isExpanded = false;
//                             });
//                           },
//                           icon: Icon(
//                             Icons.arrow_upward,
//                             size: 30,
//                           ))
//                     ],
//                   ),
//                   Divider(
//                     color: Colors.black.withOpacity(0.6),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: rowGenerator(
//                         (constraints.maxWidth > 1700)
//                             ? 4
//                             : (constraints.maxWidth > 1080)
//                                 ? 3
//                                 : (constraints.maxWidth > 780)
//                                     ? 2
//                                     : 1,
//                         context),
//                   ),
//                   Divider(
//                     color: Colors.black.withOpacity(0.6),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             //print(hasilFilter());
//                             siapkanFilter();
//                             print(arrFilter);
//                             searchKategori();
//                           },
//                           child: Text(
//                             "Cari",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displaySmall!
//                                 .copyWith(
//                                   fontSize: 16,
//                                   color: Colors.grey.shade200,
//                                 ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green.shade600),
//                         ),
//                         const SizedBox(width: 12),
//                         ElevatedButton(
//                           onPressed: () {
//                             resetFilter();
//                           },
//                           child: Text(
//                             "Ulang",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displaySmall!
//                                 .copyWith(
//                                   fontSize: 16,
//                                   color: Colors.grey.shade200,
//                                 ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red.shade600),
//                         ),
//                         const SizedBox(height: 3),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           : Container(
//               margin: const EdgeInsets.symmetric(horizontal: 120),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey.shade600,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     "Filter",
//                     style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontSize: 27,
//                           color: Colors.white,
//                         ),
//                   ),
//                   const Spacer(),
//                   IconButton.filled(
//                       onPressed: () {
//                         setState(() {
//                           isExpanded = true;
//                         });
//                       },
//                       icon: Icon(
//                         Icons.arrow_downward,
//                         size: 30,
//                       ))
//                 ],
//               ),
//             );
//     } else {
//       return const Center(
//         child: SizedBox(
//           height: 60,
//           width: 60,
//           child: CircularProgressIndicator(strokeWidth: 16),
//         ),
//       );
//     }
//   }

//   // List<Widget> rowGenerator(int angka, BuildContext context) {
//   //   int pembagi = angka;
//   //   int indexInduk = -1;
//   //   List<Widget> hasil = List.generate(
//   //     kata.length ~/ pembagi + 1,
//   //     (index) => Row(
//   //       mainAxisAlignment: MainAxisAlignment.start,
//   //       children: List.generate(pembagi, (index) {
//   //         if (indexInduk < kata.length - 1) {
//   //           indexInduk++;
//   //           String keyNow = kata[indexInduk];
//   //           //print(indexInduk);
//   //           return Expanded(
//   //               child: Container(
//   //             padding: const EdgeInsets.symmetric(vertical: 4),
//   //             child: Row(
//   //               children: [
//   //                 Checkbox(
//   //                   fillColor: MaterialStateColor.resolveWith(
//   //                       (states) => Colors.grey.shade300),
//   //                   checkColor: Colors.black,
//   //                   value: mapCheck[kata[indexInduk]],
//   //                   onChanged: (value) {
//   //                     setState(() {
//   //                       mapCheck[keyNow] = value!;
//   //                     });
//   //                   },
//   //                 ),
//   //                 Container(
//   //                   child: Text(
//   //                     kata[indexInduk],
//   //                     overflow: TextOverflow.fade,
//   //                     style: Theme.of(context).textTheme.displaySmall!.copyWith(
//   //                           fontSize: 16,
//   //                           color: Colors.grey.shade100,
//   //                         ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ));
//   //         } else {
//   //           return Expanded(child: SizedBox());
//   //         }
//   //       }),
//   //     ),
//   //   );
//   //   return hasil;
//   // }

//   siapkanKategori() async {
//     final data = await KatalogController().getListKategori();

//     List<Object?> listObject = data!["getAllKategori"]['data'];

//     listKategori = List.generate(listObject.length, (index) {
//       Map<String, dynamic> temp = listObject[index] as Map<String, dynamic>;
//       return temp['nama'] as String;
//     });
//   }

//   isiHasilDitampilkan(int ctr) {
//     // ini index == nomor halaman dan tiap index punya jumlah sesuai jumlahPerHalaman
//     if (ctr != 0) {
//       int index = ctr - 1;
//       int awal = index * jumlahItemPerhalaman;
//       if ((awal + jumlahItemPerhalaman) > hasilSearch.length) {
//         int jumlah = (awal + jumlahItemPerhalaman) - hasilSearch.length;
//         print("$awal || $jumlah");
//         setState(() {
//           hasilDitampilkan = hasilSearch.sublist(awal, awal + jumlah);
//         });
//       } else {
//         setState(() {
//           hasilDitampilkan =
//               hasilSearch.sublist(awal, awal + jumlahItemPerhalaman);
//         });
//       }
//     }
//   }

//   List<String> hasilFilter() {
//     List<String> hasil = [];
//     mapCheck!.forEach((key, value) {
//       if (value) hasil.add(key);
//     });
//     return hasil;
//   }

//   siapkanFilter() {
//     arrFilter.clear();
//     mapCheck!.forEach((key, value) {
//       if (value) arrFilter.add(key);
//     });
//   }

//   resetFilter() {
//     mapCheck!.forEach((key, value) {
//       mapCheck![key] = false;
//       setState(() {});
//     });
//   }

//   Widget kontenGenerator(BoxConstraints constraints) {
//     if (statusSearch == "normal") {
//       if (hasilSearch.isEmpty) {
//         return TidakAdaSurvei();
//       } else {
//         return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//           ...kartuGeneratorV3((constraints.maxWidth > 1960)
//               ? 4
//               : (constraints.maxWidth > 1525)
//                   ? 3
//                   : (constraints.maxWidth > 1020)
//                       ? 2
//                       : 1),
//           WebPagination(
//               currentPage: _ctrPagination,
//               totalPage: jumlahHalaman,
//               //jumlah berapa page yg bisa diakses
//               //ini saja yg perlu diganti
//               displayItemCount: 5,
//               //jumlah berapa page yg keliatan
//               onPageChanged: (page) {
//                 setState(() {
//                   _ctrPagination = page;
//                   isiHasilDitampilkan(_ctrPagination);
//                 });
//               }),
//         ]);
//       }
//     } else {
//       return SizedBox(
//           height: 100,
//           width: 100,
//           child: const Center(child: CircularProgressIndicator()));
//     }
//   }

//   List<Widget> kartuGeneratorV3(int pembagi) {
//     int indexInduk = -1;
//     List<Widget> hasil = List.generate(
//       1,
//       (index) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(jumlahItemPerhalaman, (index) {
//             if (indexInduk < hasilDitampilkan.length - 1) {
//               indexInduk++;
//               return hasilDitampilkan[indexInduk];
//             } else
//               return const SizedBox(width: 400);
//           }),
//         );
//       },
//     );
//     return hasil;
//   }

//   void searchDataV2() async {
//     //kalau ada masalah, cek di katalog_services
//     if (statusSearch == "normal") {
//       try {
//         setState(() {
//           statusSearch = "loading";
//         });
//         Map<String, dynamic>? hasilQuery = await KatalogController()
//             .searchJudul(controllerSearch.text, pilihanOrder);

//         List<Object?> dataQuery = hasilQuery!["searchByJudul"]["data"];

//         setState(() {
//           statusSearch = "normal";
//           //pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//           pesanPercobaan = "berhasil ambil data";

//           //List<Object?> hasilQuery = query.data!["searchByJudul"]["data"];
//           //print(query.data!);
//           print(dataQuery.length);

//           List<SurveiData> data = List.generate(dataQuery.length,
//               (index) => SurveiData.fromJson(json.encode(dataQuery[index])));

//           hasilSearch = List.generate(
//               data.length,
//               (index) => KartuSurvei(
//                     surveiData: data[index],
//                     onTap: () {},
//                   ));

//           if (hasilSearch.isEmpty) {
//             jumlahHalaman = 0;
//             _ctrPagination = 0;
//             isiHasilDitampilkan(0);
//           } else {
//             jumlahHalaman = (hasilSearch.length ~/ jumlahItemPerhalaman) +
//                 ((hasilSearch.length % jumlahItemPerhalaman > 0) ? 1 : 0);
//             isiHasilDitampilkan(1);
//             _ctrPagination = 1;
//           }
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   void searchKategori() async {
//     _ctrPagination = 1;
//     if (statusSearch == "normal") {
//       try {
//         setState(() {
//           statusSearch = "loading";
//         });
//         Map<String, dynamic>? hasilQuery =
//             await KatalogController().searchByKategori(arrFilter, pilihanOrder);

//         List<Object?> dataQuery = hasilQuery!["searchByKategori"]["data"];
//         setState(() {
//           statusSearch = "normal";
//           //pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//           pesanPercobaan = "berhasil ambil data";

//           //List<Object?> hasilQuery = query.data!["searchByJudul"]["data"];
//           //print(query.data!);
//           print(dataQuery.length);

//           List<SurveiData> data = List.generate(dataQuery.length,
//               (index) => SurveiData.fromJson(json.encode(dataQuery[index])));

//           hasilSearch = List.generate(
//               data.length,
//               (index) => KartuSurvei(
//                     surveiData: data[index],
//                     onTap: () {},
//                   ));

//           if (hasilSearch.isEmpty) {
//             jumlahHalaman = 0;
//             _ctrPagination = 0;
//             isiHasilDitampilkan(0);
//           } else {
//             jumlahHalaman = (hasilSearch.length ~/ jumlahItemPerhalaman) +
//                 ((hasilSearch.length % jumlahItemPerhalaman > 0) ? 1 : 0);
//             isiHasilDitampilkan(1);
//             _ctrPagination = 1;
//           }
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Container(
//             constraints: BoxConstraints(minWidth: 800),
//             padding: const EdgeInsets.all(22),
//             child: CustomScrollView(
//               slivers: [
//                 SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       NavigasiAtas(isSmall: (constraints.maxWidth < 780)),
//                       const SizedBox(height: 48),
//                       Center(
//                         child: Text(
//                           "Katalog Survei",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayLarge!
//                               .copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                         ),
//                       ),
//                       const SizedBox(height: 48),
//                       Center(
//                         child: Text(
//                           pesanPercobaan,
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayLarge!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                         ),
//                       ),
//                       const SizedBox(height: 48),
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 72),
//                         decoration: BoxDecoration(
//                             border: Border.all(width: 2),
//                             borderRadius: BorderRadius.circular(16)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Flexible(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(12),
//                                       bottomLeft: Radius.circular(12)),
//                                   color: Colors.grey.shade50,
//                                 ),
//                                 padding:
//                                     const EdgeInsets.fromLTRB(24, 4, 24, 4),
//                                 child: TextField(
//                                   controller: controllerSearch,
//                                   decoration: InputDecoration(
//                                     hintText: "Nama Survei",
//                                     border: InputBorder.none,
//                                   ),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displaySmall!
//                                       .copyWith(
//                                         fontSize: 19,
//                                         color: Colors.black,
//                                       ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               height: 59,
//                               width: 90,
//                               decoration: BoxDecoration(
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(12),
//                                       bottomRight: Radius.circular(12))),
//                               child: IconButton(
//                                   onPressed: () => searchDataV2(),
//                                   icon: Icon(
//                                     Icons.search,
//                                     color: Colors.white,
//                                     size: 36,
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       kategoriGenerator(constraints),
//                       //Disini filternya ---------------------------------------------------------------------------------------
//                       // (isExpanded)
//                       //     ? Container(
//                       //         margin: EdgeInsets.symmetric(
//                       //             horizontal:
//                       //                 (constraints.maxWidth > 550) ? 120 : 96),
//                       //         padding: const EdgeInsets.symmetric(
//                       //             horizontal: 22, vertical: 6),
//                       //         decoration: BoxDecoration(
//                       //           color: Colors.blueGrey.shade700,
//                       //           borderRadius: BorderRadius.circular(16),
//                       //         ),
//                       //         child: Column(
//                       //           children: [
//                       //             Row(
//                       //               children: [
//                       //                 Text(
//                       //                   "Filter",
//                       //                   style: Theme.of(context)
//                       //                       .textTheme
//                       //                       .displaySmall!
//                       //                       .copyWith(
//                       //                         fontSize: 27,
//                       //                         color: Colors.white,
//                       //                       ),
//                       //                 ),
//                       //                 const Spacer(),
//                       //                 IconButton.filled(
//                       //                     onPressed: () {
//                       //                       setState(() {
//                       //                         isExpanded = false;
//                       //                       });
//                       //                     },
//                       //                     icon: Icon(
//                       //                       Icons.arrow_upward,
//                       //                       size: 30,
//                       //                     ))
//                       //               ],
//                       //             ),
//                       //             Divider(
//                       //               color: Colors.black.withOpacity(0.6),
//                       //             ),
//                       //             Column(
//                       //               mainAxisAlignment: MainAxisAlignment.start,
//                       //               children: rowGenerator(
//                       // (constraints.maxWidth > 1700)
//                       //     ? 4
//                       //     : (constraints.maxWidth > 1080)
//                       //         ? 3
//                       //         : (constraints.maxWidth > 780)
//                       //             ? 2
//                       //             : 1,
//                       // context),
//                       //             ),
//                       //             Divider(
//                       //               color: Colors.black.withOpacity(0.6),
//                       //             ),
//                       //             Container(
//                       //               padding: const EdgeInsets.symmetric(
//                       //                   vertical: 4, horizontal: 10),
//                       //               child: Row(
//                       //                 mainAxisAlignment:
//                       //                     MainAxisAlignment.start,
//                       //                 children: [
//                       //                   ElevatedButton(
//                       //                     onPressed: () {
//                       //                       //print(hasilFilter());
//                       //                       siapkanFilter();
//                       //                       print(arrFilter);
//                       //                       searchKategori();
//                       //                     },
//                       //                     child: Text(
//                       //                       "Cari",
//                       //                       style: Theme.of(context)
//                       //                           .textTheme
//                       //                           .displaySmall!
//                       //                           .copyWith(
//                       //                             fontSize: 16,
//                       //                             color: Colors.grey.shade200,
//                       //                           ),
//                       //                     ),
//                       //                     style: ElevatedButton.styleFrom(
//                       //                         backgroundColor:
//                       //                             Colors.green.shade600),
//                       //                   ),
//                       //                   const SizedBox(width: 12),
//                       //                   ElevatedButton(
//                       //                     onPressed: () {
//                       //                       resetFilter();
//                       //                     },
//                       //                     child: Text(
//                       //                       "Ulang",
//                       //                       style: Theme.of(context)
//                       //                           .textTheme
//                       //                           .displaySmall!
//                       //                           .copyWith(
//                       //                             fontSize: 16,
//                       //                             color: Colors.grey.shade200,
//                       //                           ),
//                       //                     ),
//                       //                     style: ElevatedButton.styleFrom(
//                       //                         backgroundColor:
//                       //                             Colors.red.shade600),
//                       //                   ),
//                       //                   const SizedBox(height: 3),
//                       //                 ],
//                       //               ),
//                       //             )
//                       //           ],
//                       //         ),
//                       //       )
//                       //     : Container(
//                       //         margin:
//                       //             const EdgeInsets.symmetric(horizontal: 120),
//                       //         padding: const EdgeInsets.symmetric(
//                       //             horizontal: 20, vertical: 4),
//                       //         height: 60,
//                       //         decoration: BoxDecoration(
//                       //           color: Colors.blueGrey.shade600,
//                       //           borderRadius: BorderRadius.circular(16),
//                       //         ),
//                       //         child: Row(
//                       //           children: [
//                       //             Text(
//                       //               "Filter",
//                       //               style: Theme.of(context)
//                       //                   .textTheme
//                       //                   .displaySmall!
//                       //                   .copyWith(
//                       //                     fontSize: 27,
//                       //                     color: Colors.white,
//                       //                   ),
//                       //             ),
//                       //             const Spacer(),
//                       //             IconButton.filled(
//                       //                 onPressed: () {
//                       //                   setState(() {
//                       //                     isExpanded = true;
//                       //                   });
//                       //                 },
//                       //                 icon: Icon(
//                       //                   Icons.arrow_downward,
//                       //                   size: 30,
//                       //                 ))
//                       //           ],
//                       //         ),
//                       //       ),
//                       const SizedBox(height: 24),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Urutkan",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displaySmall!
//                                 .copyWith(
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                           ),
//                           Container(
//                             width: 200,
//                             decoration: BoxDecoration(
//                                 color: Colors.grey.shade50,
//                                 borderRadius: BorderRadius.circular(16)),
//                             child: DropdownButton(
//                               underline: SizedBox(),
//                               isExpanded: true,
//                               borderRadius: BorderRadius.circular(16),
//                               iconSize: 36,
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 6, horizontal: 16),
//                               value: pilihanOrder,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displaySmall!
//                                   .copyWith(
//                                     fontSize: 16,
//                                     color: Colors.black,
//                                   ),
//                               items: [
//                                 DropdownMenuItem(
//                                   child: Text("Terbaru"),
//                                   value: "Terbaru",
//                                 ),
//                                 DropdownMenuItem(
//                                   child: Text("Terlama"),
//                                   value: "Terlama",
//                                 ),
//                                 DropdownMenuItem(
//                                   child: Text("Termahal"),
//                                   value: "Termahal",
//                                 ),
//                                 DropdownMenuItem(
//                                   child: Text("Termurah"),
//                                   value: "Termurah",
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 setState(() {
//                                   pilihanOrder = value!;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       kontenGenerator(constraints),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class KartuSurvei extends StatelessWidget {
//   KartuSurvei({
//     super.key,
//     required this.surveiData,
//     required this.onTap,
//   });

//   SurveiData surveiData;
//   Function() onTap;
//   @override
//   Widget build(BuildContext context) {
//     return HoverBuilder(
//       builder: (isHovered) => InkWell(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 400),
//           width: 400,
//           margin: const EdgeInsets.only(bottom: 20),
//           padding: const EdgeInsets.only(
//             top: 9,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(21),
//             border: Border.all(width: 3, color: Colors.black),
//             boxShadow: [
//               BoxShadow(
//                 color: (isHovered) ? Colors.grey : Colors.transparent,
//                 spreadRadius: 6,
//                 blurRadius: 3,
//                 offset: Offset(0, 6), // changes position of shadow
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   surveiData.judul,
//                   style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.black,
//                       wordSpacing: 2,
//                       letterSpacing: 1.25),
//                 ),
//               ),
//               SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.only(
//                     left: 18, right: 16, top: 0, bottom: 0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.timelapse),
//                         SizedBox(width: 4),
//                         Text(
//                           "${surveiData.durasi} menit",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displaySmall!
//                               .copyWith(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       DateFormat('dd-MMMM-yyyy')
//                           .format(surveiData.tanggalPenerbitan),
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(color: Colors.grey.shade800),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 3),
//                 child: Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   direction: Axis.horizontal,
//                   children: List.generate(
//                     surveiData.kategori.length,
//                     (index) {
//                       return Text(
//                         surveiData.kategori[index],
//                         style:
//                             Theme.of(context).textTheme.displaySmall!.copyWith(
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Divider(color: Colors.grey.shade800),
//               Container(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 height: 125,
//                 child: Row(
//                   children: [
//                     (surveiData.isKlasik)
//                         ? const FotoKlasik()
//                         : const FotoKartu(),
//                     SingleChildScrollView(
//                       child: Container(
//                         padding: const EdgeInsets.only(right: 0),
//                         width: 215,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(height: 4),
//                             Text(
//                               surveiData.deskripsi,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displaySmall!
//                                   .copyWith(
//                                       fontSize: 13,
//                                       color: Colors.black,
//                                       letterSpacing: 1.25,
//                                       height: 1.6),
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Divider(color: Colors.grey.shade800, height: 8),
//               Container(
//                 padding: const EdgeInsets.only(
//                     left: 18, right: 16, top: 6, bottom: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     JumlahPartisipanKatalog(
//                       batasPartisipan: surveiData.batasPartisipan.toString(),
//                       jumlahPartisipan: surveiData.jumlahPartisipan.toString(),
//                     ),
//                     Text(
//                       "Rp ${surveiData.harga}",
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.black),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class KartuPenjualan extends StatelessWidget {
//   KartuPenjualan({
//     super.key,
//     this.deskripsi =
//         "he debugEmulateFlutterTesterEnvironment getter is deprecated and will be removed in a future release. Please use ",
//     this.batasPartisipan = "50",
//     this.durasi = "10",
//     this.isKlasik = true,
//     required this.judul,
//     this.jumlahPartisipan = "10",
//     this.status = "Aktif",
//     required this.tanggal,
//     this.kategori = const ["Umum"],
//   });
//   String deskripsi;
//   bool isKlasik;
//   String judul;
//   String durasi;
//   String status;
//   String tanggal;
//   String jumlahPartisipan;
//   String batasPartisipan;
//   List<String> kategori;

//   @override
//   Widget build(BuildContext context) {
//     return HoverBuilder(
//       builder: (isHovered) => InkWell(
//         onTap: () {},
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 400),
//           width: 400,
//           margin: const EdgeInsets.only(bottom: 20),
//           padding: const EdgeInsets.only(
//             top: 9,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(21),
//             border: Border.all(width: 3, color: Colors.black),
//             boxShadow: [
//               BoxShadow(
//                 color: (isHovered) ? Colors.grey : Colors.transparent,
//                 spreadRadius: 6,
//                 blurRadius: 3,
//                 offset: Offset(0, 6), // changes position of shadow
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   judul,
//                   style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.black,
//                       wordSpacing: 2,
//                       letterSpacing: 1.25),
//                 ),
//               ),
//               SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.only(
//                     left: 18, right: 16, top: 0, bottom: 0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.timelapse),
//                         SizedBox(width: 4),
//                         Text(
//                           "$durasi menit",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displaySmall!
//                               .copyWith(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       tanggal,
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(color: Colors.grey.shade800),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 3),
//                 child: Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   direction: Axis.horizontal,
//                   children: List.generate(
//                     kategori.length,
//                     (index) {
//                       return Text(
//                         kategori[index],
//                         style:
//                             Theme.of(context).textTheme.displaySmall!.copyWith(
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Divider(color: Colors.grey.shade800),
//               Container(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 height: 125,
//                 child: Row(
//                   children: [
//                     (isKlasik) ? const FotoKlasik() : const FotoKartu(),
//                     SingleChildScrollView(
//                       child: Container(
//                         padding: const EdgeInsets.only(right: 0),
//                         width: 215,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(height: 4),
//                             Text(
//                               deskripsi,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displaySmall!
//                                   .copyWith(
//                                       fontSize: 13,
//                                       color: Colors.black,
//                                       letterSpacing: 1.25,
//                                       height: 1.6),
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Divider(color: Colors.grey.shade800, height: 8),
//               Container(
//                 padding: const EdgeInsets.only(
//                     left: 18, right: 16, top: 6, bottom: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     JumlahPartisipanKatalog(
//                       batasPartisipan: batasPartisipan,
//                       jumlahPartisipan: jumlahPartisipan,
//                     ),
//                     Text(
//                       "Rp 150.000",
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.black),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class JumlahPartisipanKatalog extends StatelessWidget {
//   JumlahPartisipanKatalog({
//     super.key,
//     required this.jumlahPartisipan,
//     required this.batasPartisipan,
//   });
//   String jumlahPartisipan;
//   String batasPartisipan;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Icon(
//           Icons.person,
//           size: 28,
//         ),
//         const SizedBox(width: 2),
//         RichText(
//             text: TextSpan(
//                 text: jumlahPartisipan,
//                 style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     color: Colors.black),
//                 children: [
//               TextSpan(text: ' / '),
//               TextSpan(text: batasPartisipan)
//             ]))
//       ],
//     );
//   }
// }

// class FotoKartu extends StatelessWidget {
//   const FotoKartu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       width: 148,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             width: 5,
//             color: Colors.greenAccent,
//           ),
//           image: const DecorationImage(
//             image: AssetImage('assets/logo-kartu.png'),
//             fit: BoxFit.fitWidth,
//           )),
//     );
//   }
// }

// class FotoKlasik extends StatelessWidget {
//   const FotoKlasik({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       width: 148,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             width: 5,
//             color: Colors.redAccent,
//           ),
//           image: DecorationImage(
//             image: const AssetImage('assets/logo-klasik.png'),
//             fit: BoxFit.fill,
//           )),
//     );
//   }
// }

// class TidakAdaSurvei extends StatelessWidget {
//   const TidakAdaSurvei({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Center(
//         child: Image.asset(
//           'assets/no-data-katalog.png',
//           scale: 1,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hei_survei/constants.dart';
// import 'package:hei_survei/features/katalog/katalog_baru.dart';
// import 'package:hei_survei/features/surveiku/detail_survei.dart';

// enum PilihanHalaman { katalog, detail }

// class ContainerKatalog extends StatefulWidget {
//   ContainerKatalog({
//     super.key,
//     required this.constraints,
//   });
//   BoxConstraints constraints;
//   @override
//   State<ContainerKatalog> createState() => _ContainerKatalogState();
// }

// class _ContainerKatalogState extends State<ContainerKatalog>
//     with AutomaticKeepAliveClientMixin<ContainerKatalog> {
//   String idSurveiPilihan = "";
//   PilihanHalaman halPilihan = PilihanHalaman.katalog;
//   Widget switchKonten() {
//     if (halPilihan == PilihanHalaman.katalog) {
//       return HalamanKatalog(constraints: widget.constraints);
//     } else {
//       return DetailSurveiX(
//         constraints: widget.constraints,
//         idSurvei: idSurveiPilihan,
//         onTapKembali: () {
//           setState(() {
//             halPilihan = PilihanHalaman.katalog;
//           });
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return const Placeholder();
//   }

//   @override
//   bool get wantKeepAlive => (baseUri == Uri.base.toString());
// }

