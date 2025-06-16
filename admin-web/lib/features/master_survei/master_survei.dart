// import 'package:aplikasi_admin/app/widget_component/navbar.dart';
// import 'package:aplikasi_admin/app/widget_component/row_container.dart';
// import 'package:aplikasi_admin/features/master_survei/survei.dart';
// import 'package:aplikasi_admin/features/master_survei/survei_controller.dart';
// import 'package:aplikasi_admin/utils/hover_builder.dart';
// import 'package:aplikasi_admin/utils/loading_lingkaran.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class MasterSurvei extends StatefulWidget {
//   const MasterSurvei({super.key});

//   @override
//   State<MasterSurvei> createState() => _MasterSurveiState();
// }

// class _MasterSurveiState extends State<MasterSurvei> {
//   List<SurveiData> listSurvei = [];
//   List<SurveiData> listTampilan = [];

//   String kataSearch = "";

//   SurveiData? pilihan = null;

//   @override
//   void initState() {
//     Future(() async {
//       listSurvei = await MasterSurveiController().getAllSurvei(context);
//       listTampilan = listSurvei;
//       setState(() {});
//     });
//     super.initState();
//   }

//   List<TableRow> generateTableRow(BuildContext context) {
//     List<TableRow> temp = [];
//     listTampilan = listSurvei
//         .where((element) => element.judul.toLowerCase().contains(kataSearch))
//         .toList();
//     for (var element in listTampilan) {
//       temp.add(TableRow(children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 pilihan = element;
//                 controllerJudul.text = pilihan!.judul;
//               });
//             },
//             child: HoverBuilder(
//               builder: (isHovered) => Text(
//                 element.judul,
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: (isHovered)
//                           ? Colors.greenAccent.shade400
//                           : Colors.black,
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//               ),
//             ),
//           ),
//         ),
//         Container(
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               element.kategori,
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//             )),
//         Container(
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               '${DateFormat('dd-MMMM-yyyy').format(element.tanggalPenerbitan)}',
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//             )),
//         Container(
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               "${element.jumlahPartisipan} / ${element.batasPartisipan}",
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//             )),
//         Container(
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               element.status,
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//             )),
//       ]));
//     }
//     return temp;
//   }

//   TextEditingController controllerJudul = TextEditingController(text: "");

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       appBar: getNavBar(context),
//       body: LayoutBuilder(
//         builder: (context, constraints) => SingleChildScrollView(
//           child: Center(
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 32),
//                   child: Text(
//                     "Master & Report Survei",
//                     style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                         color: Colors.black,
//                         fontSize: 48,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   width: 880,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 50,
//                         width: 450,
//                         padding: const EdgeInsets.only(
//                           left: 17,
//                           top: 17,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: TextField(
//                           onSubmitted: (value) {
//                             if (listSurvei.isNotEmpty) {
//                               setState(() {
//                                 kataSearch = value;
//                               });
//                             }
//                           },
//                           textInputAction: TextInputAction.search,
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayLarge!
//                               .copyWith(
//                                 color: Colors.black,
//                                 fontSize: 17,
//                               ),
//                           decoration: InputDecoration.collapsed(
//                             hintText: "Cari Survei",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       (listSurvei.isNotEmpty)
//                           ? Container(
//                               height: 400,
//                               width: 725,
//                               decoration:
//                                   BoxDecoration(border: Border.all(width: 1)),
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//                                 child: Table(
//                                   columnWidths: const <int, TableColumnWidth>{
//                                     0: FractionColumnWidth(0.2),
//                                     1: FractionColumnWidth(0.16),
//                                     2: FractionColumnWidth(0.16),
//                                     3: FractionColumnWidth(0.16),
//                                     4: FractionColumnWidth(0.16),
//                                     5: FractionColumnWidth(0.16),
//                                   },
//                                   border: TableBorder.all(),
//                                   children: [
//                                     TableRow(
//                                       children: [
//                                         Container(
//                                           height: 40,
//                                           child: Center(
//                                               child: Text(
//                                             "Judul",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(
//                                                   color: Colors.black,
//                                                   fontSize: 21,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                           )),
//                                         ),
//                                         Container(
//                                           height: 40,
//                                           child: Center(
//                                               child: Text(
//                                             "Tanggal",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(
//                                                   color: Colors.black,
//                                                   fontSize: 21,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                           )),
//                                         ),
//                                         Container(
//                                           height: 40,
//                                           child: Center(
//                                               child: Text(
//                                             "Kategori",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(
//                                                   color: Colors.black,
//                                                   fontSize: 21,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                           )),
//                                         ),
//                                         Container(
//                                           height: 40,
//                                           child: Center(
//                                               child: Text(
//                                             "Partisipan",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(
//                                                   color: Colors.black,
//                                                   fontSize: 21,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                           )),
//                                         ),
//                                         Container(
//                                           height: 40,
//                                           child: Center(
//                                               child: Text(
//                                             "Status",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(
//                                                   color: Colors.black,
//                                                   fontSize: 21,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                           )),
//                                         ),
//                                       ],
//                                     ),
//                                     ...generateTableRow(context)
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : LoadingLingkaran(
//                               width: 175,
//                               height: 175,
//                               strokeWidth: 16,
//                             ),
//                       const SizedBox(height: 28),
//                       Column(
//                         children: [
//                           RowContainer(
//                             text: "Pertanyaan",
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                                 horizontal: 16,
//                               ),
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.black,
//                                   ),
//                                   borderRadius: BorderRadius.circular(24)),
//                               child: TextField(
//                                 controller: controllerJudul,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .labelLarge!
//                                     .copyWith(
//                                       color: Colors.black,
//                                       fontSize: 17,
//                                     ),
//                                 //kunci untuk textfield besar adalah maxline - nya
//                                 decoration: const InputDecoration.collapsed(
//                                   hintText: "Pertanyaan FAQ",
//                                 ),
//                                 minLines: 2,
//                                 maxLines: null,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           RowContainer(
//                             text: "Deskripsi",
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                                 horizontal: 16,
//                               ),
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.black,
//                                   ),
//                                   borderRadius: BorderRadius.circular(24)),
//                               child: TextField(
//                                 controller: TextEditingController(
//                                     text: (pilihan == null)
//                                         ? ""
//                                         : pilihan!.deskripsi),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .labelLarge!
//                                     .copyWith(
//                                       color: Colors.black,
//                                       fontSize: 17,
//                                     ),
//                                 //kunci untuk textfield besar adalah maxline - nya
//                                 decoration: const InputDecoration.collapsed(
//                                   hintText: "Pertanyaan FAQ",
//                                 ),
//                                 minLines: 2,
//                                 maxLines: null,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           RowContainer(
//                             text: "Deskripsi",
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                                 horizontal: 16,
//                               ),
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.black,
//                                   ),
//                                   borderRadius: BorderRadius.circular(24)),
//                               child: Text(
//                                   (pilihan == null) ? "" : pilihan!.deskripsi,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelLarge!
//                                       .copyWith(
//                                         color: Colors.black,
//                                         fontSize: 17,
//                                       )),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           RowContainer(
//                             text: "Partisipan",
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                                 horizontal: 16,
//                               ),
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.black,
//                                   ),
//                                   borderRadius: BorderRadius.circular(24)),
//                               child: Text(
//                                   (pilihan == null)
//                                       ? ""
//                                       : "${pilihan!.jumlahPartisipan} / ${pilihan!.batasPartisipan}",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelLarge!
//                                       .copyWith(
//                                         color: Colors.black,
//                                         fontSize: 17,
//                                       )),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           RowContainer(
//                             text: "Tgl Pembuatan",
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                                 horizontal: 16,
//                               ),
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.black,
//                                   ),
//                                   borderRadius: BorderRadius.circular(24)),
//                               child: Text(
//                                   (pilihan == null)
//                                       ? ""
//                                       : '${DateFormat('dd-MMMM-yyyy').format(pilihan!.tanggalPenerbitan)}',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelLarge!
//                                       .copyWith(
//                                         color: Colors.black,
//                                         fontSize: 17,
//                                       )),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           RowContainer(
//                             text: "Harga",
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                                 horizontal: 16,
//                               ),
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.black,
//                                   ),
//                                   borderRadius: BorderRadius.circular(24)),
//                               child: Text(
//                                   (pilihan == null)
//                                       ? ""
//                                       : pilihan!.hargaJual.toString(),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelLarge!
//                                       .copyWith(
//                                         color: Colors.black,
//                                         fontSize: 17,
//                                       )),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blueAccent.shade700,
//                             ),
//                             child: Container(
//                               height: 50,
//                               width: 100,
//                               child: Center(
//                                 child: Text(
//                                   "XXXXXXXXXXXXXXX",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelSmall!
//                                       .copyWith(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
