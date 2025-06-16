// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:aplikasi_admin/app/widget_component/navbar.dart';
// import 'package:aplikasi_admin/app/widget_component/row_container.dart';
// import 'package:flutter/material.dart';

// import 'package:aplikasi_admin/features/master_faq/faq.dart';
// import 'package:aplikasi_admin/features/master_faq/faq_controller.dart';
// import 'package:aplikasi_admin/utils/hover_builder.dart';
// import 'package:aplikasi_admin/utils/loading_lingkaran.dart';
// import 'package:uuid/uuid.dart';

// class MasterFAQ extends StatefulWidget {
//   const MasterFAQ({super.key});

//   @override
//   State<MasterFAQ> createState() => _MasterFAQState();
// }

// class _MasterFAQState extends State<MasterFAQ> {
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
//       listTampilan = listFAQ;
//       setState(() {});
//     });

//     super.initState();
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

//   //mode RUD
//   final controllerPertanyaan = TextEditingController();
//   final controllerJawaban = TextEditingController();
//   final controllerID = TextEditingController();

//   //mode C
//   final controllerPertanyaanC = TextEditingController();
//   final controllerJawabanC = TextEditingController();

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
//                     "Master FAQ",
//                     style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                         color: Colors.black,
//                         fontSize: 48,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   width: 875,
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
//                             if (listFAQ.isNotEmpty) {
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
//                             hintText: "Cari pertanyaan",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       (listFAQ.isNotEmpty)
//                           ? Container(
//                               height: 400,
//                               width: 725,
//                               decoration:
//                                   BoxDecoration(border: Border.all(width: 1)),
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//                                 child: Table(
//                                   columnWidths: const <int, TableColumnWidth>{
//                                     0: FractionColumnWidth(0.375),
//                                     1: FractionColumnWidth(0.625),
//                                   },
//                                   border: TableBorder.all(),
//                                   children: [
//                                     TableRow(
//                                       children: [
//                                         Container(
//                                           height: 40,
//                                           child: Center(
//                                               child: Text(
//                                             "Pertanyaan ",
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
//                                             "Jawaban",
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
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               // final temp = listTest.where(
//                               //   (element) => element.toLowerCase().contains("nand"),
//                               // );
//                               // print(temp);
//                               setState(() {
//                                 isModeC = true;
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.yellow.shade700,
//                             ),
//                             child: Container(
//                               height: 50,
//                               width: 100,
//                               child: Center(
//                                 child: Text(
//                                   "Mode C",
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
//                           const SizedBox(width: 28),
//                           ElevatedButton(
//                             onPressed: () async {
//                               setState(() {
//                                 isModeC = false;
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                             ),
//                             child: Container(
//                               height: 50,
//                               width: 100,
//                               child: Center(
//                                 child: Text(
//                                   "Mode RUD",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelSmall!
//                                       .copyWith(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 32),
//                       (isModeC)
//                           ? InputC(
//                               controllerPertanyaan: controllerPertanyaanC,
//                               controllerJawaban: controllerJawabanC,
//                               onTap: () {
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
//                             )
//                           : InputRUD(
//                               controllerID: controllerID,
//                               controllerPertanyaan: controllerPertanyaan,
//                               controllerJawaban: controllerJawaban,
//                               onTapDelete: () async {
//                                 if (pilihan.idFAQ != 'x-x') {
//                                   FAQController()
//                                       .hapusFAQ(context, pilihan.idFAQ);
//                                   setState(() {
//                                     controllerID.text = "";
//                                     controllerJawaban.text = "";
//                                     controllerPertanyaan.text = "";
//                                     listFAQ.removeWhere((element) =>
//                                         element.idFAQ == pilihan.idFAQ);
//                                   });
//                                 }
//                               },
//                               onTapUpdate: () async {
//                                 if (pilihan.idFAQ != 'x-x') {
//                                   FAQController().updateFAQ(
//                                       context,
//                                       controllerPertanyaan.text,
//                                       controllerJawaban.text,
//                                       pilihan.idFAQ);
//                                   setState(() {
//                                     listFAQ.removeWhere((element) =>
//                                         element.idFAQ == pilihan.idFAQ);
//                                     FAQ temp = FAQ(
//                                         jawaban: controllerJawaban.text,
//                                         idFAQ: pilihan.idFAQ,
//                                         pertanyaan: controllerPertanyaan.text);
//                                     listFAQ.add(temp);
//                                   });
//                                 }
//                               },
//                             )
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

// class InputC extends StatelessWidget {
//   InputC({
//     super.key,
//     required this.controllerPertanyaan,
//     required this.controllerJawaban,
//     required this.onTap,
//   });
//   final TextEditingController controllerPertanyaan;
//   final TextEditingController controllerJawaban;
//   Function() onTap;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         RowContainer(
//           text: "Pertanyaan",
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 16,
//             ),
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 1,
//                   color: Colors.black,
//                 ),
//                 borderRadius: BorderRadius.circular(24)),
//             child: TextField(
//               controller: controllerPertanyaan,
//               style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                   ),
//               //kunci untuk textfield besar adalah maxline - nya
//               decoration: const InputDecoration.collapsed(
//                 hintText: "Pertanyaan FAQ",
//               ),
//               minLines: 2,
//               maxLines: null,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         RowContainer(
//           text: "Jawaban",
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 16,
//             ),
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 1,
//                   color: Colors.black,
//                 ),
//                 borderRadius: BorderRadius.circular(24)),
//             child: TextField(
//               controller: controllerJawaban,
//               style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                   ),
//               //kunci untuk textfield besar adalah maxline - nya
//               decoration: const InputDecoration.collapsed(
//                 hintText: "Jawaban FAQ",
//               ),
//               minLines: 4,
//               maxLines: null,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: onTap,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blueAccent.shade700,
//           ),
//           child: Container(
//             height: 50,
//             width: 100,
//             child: Center(
//               child: Text(
//                 "Buat FAQ",
//                 style: Theme.of(context).textTheme.labelSmall!.copyWith(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class InputRUD extends StatelessWidget {
//   InputRUD({
//     Key? key,
//     required this.controllerID,
//     required this.controllerPertanyaan,
//     required this.controllerJawaban,
//     required this.onTapDelete,
//     required this.onTapUpdate,
//   }) : super(key: key);
//   final TextEditingController controllerID;
//   final TextEditingController controllerPertanyaan;
//   final TextEditingController controllerJawaban;
//   Function() onTapDelete;
//   Function() onTapUpdate;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         RowContainer(
//             text: "ID",
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 16,
//                 horizontal: 16,
//               ),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(
//                     width: 1,
//                     color: Colors.black,
//                   ),
//                   borderRadius: BorderRadius.circular(24)),
//               child: TextField(
//                 enabled: false,
//                 controller: controllerID,
//                 style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                       color: Colors.black,
//                       fontSize: 17,
//                     ),
//                 //kunci untuk textfield besar adalah maxline - nya
//                 decoration: const InputDecoration.collapsed(
//                   hintText: "Deskripsi Survei",
//                 ),
//                 minLines: 1,
//                 maxLines: null,
//               ),
//             )),
//         const SizedBox(height: 16),
//         RowContainer(
//           text: "Pertanyaan",
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 16,
//             ),
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 1,
//                   color: Colors.black,
//                 ),
//                 borderRadius: BorderRadius.circular(24)),
//             child: TextField(
//               controller: controllerPertanyaan,
//               style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                   ),
//               //kunci untuk textfield besar adalah maxline - nya
//               decoration: const InputDecoration.collapsed(
//                 hintText: "Deskripsi Survei",
//               ),
//               minLines: 4,
//               maxLines: null,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         RowContainer(
//           text: "Jawaban",
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 16,
//             ),
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 1,
//                   color: Colors.black,
//                 ),
//                 borderRadius: BorderRadius.circular(24)),
//             child: TextField(
//               controller: controllerJawaban,
//               style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                   ),
//               //kunci untuk textfield besar adalah maxline - nya
//               decoration: const InputDecoration.collapsed(
//                 hintText: "Deskripsi Survei",
//               ),
//               minLines: 4,
//               maxLines: null,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: onTapUpdate,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent.shade700,
//               ),
//               child: Container(
//                 height: 50,
//                 width: 110,
//                 child: Center(
//                   child: Text(
//                     "Update FAQ",
//                     style: Theme.of(context).textTheme.labelSmall!.copyWith(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             ElevatedButton(
//               onPressed: onTapDelete,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red.shade600,
//               ),
//               child: Container(
//                 height: 50,
//                 width: 100,
//                 child: Center(
//                   child: Text(
//                     "Delete FAQ",
//                     style: Theme.of(context).textTheme.labelSmall!.copyWith(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
