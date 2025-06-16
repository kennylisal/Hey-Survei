import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PercobaanRealTimeDB extends StatefulWidget {
  const PercobaanRealTimeDB({super.key});

  @override
  State<PercobaanRealTimeDB> createState() => _PercobaanRealTimeDBState();
}

class _PercobaanRealTimeDBState extends State<PercobaanRealTimeDB> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("users");

// await ref.update({
//   "123/age": 19,
//   "123/address/line1": "1 Mountain View",
// });

  void createRecord() async {
    try {
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('tagihan/userKenny');

      await dbRef.set({
        "name": "Kenny",
        "age": 19,
        "address": {"line1": "Joke around that"}
      });
    } catch (e) {
      print(e);
    }
  }

  void createRecordV2() async {
    FirebaseDatabase.instance.ref('tagihan/userKennyV2').set({
      "name": "Kenny",
      "age": 19,
      "address": {"line1": "Joke around that"}
    }).then((value) {
      print("berhasil tambah data");
    }).catchError((e) {
      print(e);
    });
  }

  void updateData() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref('tagihan/userKenny');
    await dbRef.update({"age": 21});
  }

  void listenFromDB() {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref('tagihan/userKenny');
    dbRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<String, dynamic>;

        print(data);
      } else {
        print("Tidak ada data");
      }
    });
  }

  void deleteRecord() {
    FirebaseDatabase.instance.ref('tagihan/userKenny').remove().then((value) {
      print("berhasil");
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  @override
  void initState() {
    listenFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                createRecordV2();
              },
              child: Text("Klik disini untuk set")),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                updateData();
              },
              child: Text("Klik disini untuk update")),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                deleteRecord();
              },
              child: Text("Klik disini untuk update")),
        ],
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class RowUpdate extends StatelessWidget {
//   RowUpdate({
//     super.key,
//     required this.onPressHapus,
//     required this.onPressUpdate,
//   });
//   Function() onPressUpdate;
//   Function() onPressHapus;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Container(
//           margin: const EdgeInsets.only(top: 3),
//           child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
//               ),
//               child: Text(
//                 "Update",
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: Colors.white,
//                       fontSize: 19,
//                       fontWeight: FontWeight.bold,
//                     ),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 5.5),
//           child: CircleAvatar(
//             radius: 20,
//             backgroundColor: Colors.redAccent.shade400,
//             child: IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.delete,
//                   color: Colors.white,
//                 )),
//           ),
//         )
//       ],
//     );
//   }
// }

// class RowBaru extends StatelessWidget {
//   RowBaru({
//     super.key,
//     required this.onPressedHapus,
//     required this.onPressedTambah,
//   });
//   Function() onPressedTambah;
//   Function() onPressedHapus;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Container(
//           margin: const EdgeInsets.only(top: 3),
//           child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.greenAccent.shade400,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
//               ),
//               child: Text(
//                 "Tambahkan",
//                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                       color: Colors.white,
//                       fontSize: 19,
//                       fontWeight: FontWeight.bold,
//                     ),
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 5.5),
//           child: CircleAvatar(
//             radius: 20,
//             backgroundColor: Colors.redAccent.shade400,
//             child: IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.delete,
//                   color: Colors.white,
//                 )),
//           ),
//         )
//       ],
//     );
//   }
// }

// class Kategori {
//   String namaKategori;
//   String idKategori;
//   bool isBaru;
//   TextEditingController textEditingController;
//   Kategori({
//     required this.namaKategori,
//     required this.idKategori,
//     required this.isBaru,
//     required this.textEditingController,
//   });
//   factory Kategori.fromMap(Map<String, dynamic> map) {
//     String nama = map['nama'] as String;
//     return Kategori(
//       namaKategori: nama,
//       idKategori: map['id'] as String,
//       isBaru: false,
//       textEditingController: TextEditingController(text: nama),
//     );
//   }

//   factory Kategori.fromJson(String source) =>
//       Kategori.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() =>
//       'Kategori(namaKategori: $namaKategori, idKategori: $idKategori)';
// }

// class PercobaanListView extends StatefulWidget {
//   PercobaanListView({super.key});

//   @override
//   State<PercobaanListView> createState() => _PercobaanListViewState();
// }

// class _PercobaanListViewState extends State<PercobaanListView> {
//   final scrollController = ScrollController();

//   List<Kategori> listKategori = [
//     Kategori(
//         namaKategori: "90an",
//         idKategori: "ddd",
//         isBaru: false,
//         textEditingController: TextEditingController()),
//     Kategori(
//         namaKategori: "80an",
//         idKategori: "ddd",
//         isBaru: false,
//         textEditingController: TextEditingController()),
//     Kategori(
//         namaKategori: "Anime",
//         idKategori: "ddd",
//         isBaru: false,
//         textEditingController: TextEditingController()),
//     Kategori(
//         namaKategori: "45 minute",
//         idKategori: "ddd",
//         isBaru: false,
//         textEditingController: TextEditingController()),
//     Kategori(
//         namaKategori: "AKG never type",
//         idKategori: "ddd",
//         isBaru: false,
//         textEditingController: TextEditingController()),
//     Kategori(
//         namaKategori: "Berbudaya",
//         idKategori: "ddd",
//         isBaru: false,
//         textEditingController: TextEditingController()),
//   ];
//   List<Kategori> listTampilan = [];

//   List<TableRow> generateTableRow(
//     BuildContext context,
//     // TextStyle textStyle,
//   ) {
//     List<TableRow> temp = [];
//     listTampilan = listKategori
//         .where((element) => element.namaKategori.toLowerCase().contains(""))
//         .toList();
//     for (var i = 0; i < listTampilan.length; i++) {
//       temp.add(TableRow(children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           child: Text(
//             (i + 1).toString(),
//             style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: Colors.black,
//                   fontSize: 20,
//                 ),
//           ),
//         ),
//         Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: TextField(
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: Colors.black,
//                   fontSize: 17.5,
//                   height: 1.65,
//                   letterSpacing: 0.875),
//               decoration: InputDecoration(border: InputBorder.none),
//               maxLines: 2,
//             )),
//         Container(child: (listKategori[i].isBaru) ? RowBaru() : RowUpdate()),
//       ]));
//     }
//     return temp;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textStyle = Theme.of(context).textTheme.displayLarge!.copyWith(
//           color: Colors.black,
//           fontSize: 18,
//           // fontWeight: FontWeight.bold,
//         );
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: 500,
//             width: 900,
//             margin: const EdgeInsets.all(20),
//             decoration: BoxDecoration(border: Border.all(width: 1)),
//             child: SingleChildScrollView(
//               controller: scrollController,
//               scrollDirection: Axis.vertical,
//               child: Table(
//                 columnWidths: const <int, TableColumnWidth>{
//                   0: FractionColumnWidth(0.05),
//                   1: FractionColumnWidth(0.7),
//                   2: FractionColumnWidth(0.25),
//                 },
//                 border: TableBorder.all(),
//                 children: [
//                   TableRow(
//                     children: [
//                       Container(
//                         height: 40,
//                         child: Center(
//                             child: Text(
//                           "No",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayLarge!
//                               .copyWith(
//                                 color: Colors.black,
//                                 fontSize: 21,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                         )),
//                       ),
//                       Container(
//                         height: 40,
//                         child: Center(
//                             child: Text(
//                           "Nama Kategori",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayLarge!
//                               .copyWith(
//                                 color: Colors.black,
//                                 fontSize: 21,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                         )),
//                       ),
//                       Container(
//                         height: 40,
//                         child: Center(
//                             child: Text(
//                           "Aksi",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayLarge!
//                               .copyWith(
//                                 color: Colors.black,
//                                 fontSize: 21,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                         )),
//                       ),
//                     ],
//                   ),
//                   ...generateTableRow(context, textStyle)
//                 ],
//               ),
//             ),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   listKategori.add(Kategori(
//                     namaKategori: "Kategori Baru",
//                     idKategori: "cncb",
//                     isBaru: true,
//                     textEditingController: TextEditingController(),
//                   ));
//                 });
//               },
//               child: Text("scroll bwah"))
//         ],
//       ),
//     );
//   }
// }

// class PercobaanTabel extends StatefulWidget {
//   const PercobaanTabel({super.key});

//   @override
//   State<PercobaanTabel> createState() => _PercobaanTabelState();
// }

// class _PercobaanTabelState extends State<PercobaanTabel> {
//   @override
//   Widget build(BuildContext context) {
//     Future<Uint8List> _generatePdf(PdfPageFormat format, String content) async {
//       final pdf = pw.Document();

//       final img = await rootBundle.load('assets/logo-app.png');
//       final imageBytes = img.buffer.asUint8List();
//       pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
//       final hasil = pw.Container(
//           width: double.infinity,
//           height: double.infinity,
//           padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//           child: pw.Column(
//             mainAxisAlignment: pw.MainAxisAlignment.start,
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.end,
//                   crossAxisAlignment: pw.CrossAxisAlignment.end,
//                   children: [
//                     pw.BarcodeWidget(
//                       data: content,
//                       width: 205,
//                       height: 205,
//                       barcode: pw.Barcode.qrCode(),
//                       color: PdfColor.fromHex("#000000"),
//                     ),
//                     pw.SizedBox(width: 26),
//                     pw.Container(
//                       alignment: pw.Alignment.center,
//                       height: 90,
//                       child: image1,
//                     ),
//                     pw.SizedBox(width: 11),
//                   ]),
//               pw.SizedBox(height: 17.5),
//               pw.Text(
//                 "Scan Barcode ini Di Aplikasi Hei-Survei",
//                 style: pw.TextStyle(
//                   fontSize: 24,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(width: 8),
//             ],
//           ));
//       pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) => hasil,
//       ));

//       return pdf.save();
//     }

//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//                 onPressed: () async {
//                   await Printing.layoutPdf(
//                     onLayout: (format) => _generatePdf(format, "nahh"),
//                   );
//                 },
//                 child: Text("data")),
//             SizedBox(height: 20),
//             // if (isGenerated)
//             //   PdfPreview(
//             //     build: (format) =>  _generatePdf(format, "nahh"),
//             //   )
//           ],
//         ),
//       ),

//       // Center(
//       //   child: Container(
//       //     height: 225,
//       //     width: 400,
//       //     //decoration: BoxDecoration(border: Border.all(width: 2)),
//       //     child: SingleChildScrollView(
//       //       scrollDirection: Axis.vertical,
//       //       child: Table(
//       //         columnWidths: const <int, TableColumnWidth>{
//       //           0: FractionColumnWidth(0.15),
//       //           1: FractionColumnWidth(0.7),
//       //           2: FractionColumnWidth(0.15),
//       //         },
//       //         border: TableBorder.all(),
//       //         children: [
//       //           TableRow(children: [
//       //             Container(
//       //               height: 40,
//       //               child: Center(
//       //                   child: Text(
//       //                 "No",
//       //                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//       //                       color: Colors.black,
//       //                       fontSize: 21,
//       //                       fontWeight: FontWeight.bold,
//       //                     ),
//       //               )),
//       //             ),
//       //             Container(
//       //               height: 40,
//       //               child: Center(
//       //                   child: Text(
//       //                 "Nama Kategori",
//       //                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//       //                       color: Colors.black,
//       //                       fontSize: 21,
//       //                       fontWeight: FontWeight.bold,
//       //                     ),
//       //               )),
//       //             ),
//       //             Container(
//       //               height: 40,
//       //               child: Center(
//       //                   child: Text(
//       //                 "Aksi",
//       //                 style: Theme.of(context).textTheme.displayLarge!.copyWith(
//       //                       color: Colors.black,
//       //                       fontSize: 21,
//       //                       fontWeight: FontWeight.bold,
//       //                     ),
//       //               )),
//       //             ),
//       //           ]),
//       //           ...generateRow(context),
//       //         ],
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }

// List<TableRow> generateRow(BuildContext context) {
//   List<TableRow> temp = [];
//   for (var i = 0; i < 20; i++) {
//     temp.add(TableRow(children: [
//       Container(
//         height: 45,
//         child: Center(
//             child: Text(
//           "No",
//           style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                 color: Colors.black,
//                 fontSize: 21,
//                 fontWeight: FontWeight.bold,
//               ),
//         )),
//       ),
//       Container(
//         height: 45,
//         child: Center(
//             child: Text(
//           "Nama Kategori",
//           style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                 color: Colors.black,
//                 fontSize: 21,
//                 fontWeight: FontWeight.bold,
//               ),
//         )),
//       ),
//       Container(
//         height: 45,
//         child: Center(
//             child: IconButton.filled(onPressed: () {}, icon: Icon(Icons.abc))),
//       ),
//     ]));
//   }
//   return temp;
// }
