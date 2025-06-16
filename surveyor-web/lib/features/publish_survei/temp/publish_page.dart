// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:hei_survei/features/katalog/katalog_controller.dart';
// import 'package:hei_survei/features/survei/survei_services.dart';
// import 'package:hei_survei/utils/navigasi_atas.dart';
// import 'package:intl/intl.dart';

// class PublishPage extends StatefulWidget {
//   const PublishPage({
//     super.key,
//     this.formId = "Percobaan pertama",
//     this.isKlasik = "1",
//   });

//   final String formId;
//   final String isKlasik;
//   @override
//   State<PublishPage> createState() => _PublishPageState();
// }

// class _PublishPageState extends State<PublishPage> {
//   showAlertDialog({
//     required BuildContext context,
//     required String deskripsi,
//     required int batasPartisipan,
//     required int harga,
//     required String judul,
//     required int durasi,
//     required String kategori,
//   }) {
//     Widget cancelButton = TextButton(
//       child: Text(
//         "Batal",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//             ),
//       ),
//       onPressed: () {
//         Navigator.pop(context, 'Cancel');
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text(
//         "Lanjut",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//             ),
//       ),
//       onPressed: () async {
//         //   //bikin pengecekan
//         //   //if(hargaSatuan != -1 &&){}
//         await SurveiServices().publishSurvei(
//           idForm: widget.formId,
//           batasPartisipan: batasPartisipan,
//           deskripsi: deskripsi,
//           durasi: durasi,
//           harga: harga,
//           isKlasik: widget.isKlasik == "1",
//           judul: judul,
//           kategori: kategori,
//         );
//         print("berhasil");
//         // context.pushNamed(RouteConstant.publishSurvei, queryParameters: {
//         //   "formId": widget.formId,
//         //   "isKlasik": "1",
//         // });
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text(
//         "Notifikasi",
//         style: Theme.of(context)
//             .textTheme
//             .titleLarge!
//             .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
//       ),
//       content: Text(
//         "Pastikan detail survei sudah lengkap dan sesuai!",
//         style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
//       ),
//       actions: [continueButton, cancelButton],
//     );

//     showDialog(
//       context: context,
//       builder: (context) => alert,
//     );
//   }

//   String pilihanRadio = "";

//   List<String> listKategori = [];

//   List<Widget> rowGeneratorV2(int angka, BuildContext context) {
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
//               child: RadioListTile(
//                 fillColor:
//                     MaterialStateColor.resolveWith((states) => Colors.white),
//                 title: Text(
//                   listKategori[indexInduk],
//                   overflow: TextOverflow.fade,
//                   style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                         fontSize: 16,
//                         color: Colors.grey.shade100,
//                       ),
//                 ),
//                 value: listKategori[indexInduk],
//                 groupValue: pilihanRadio,
//                 onChanged: (value) {
//                   setState(() {
//                     pilihanRadio = value!;
//                   });
//                 },
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

//   @override
//   void initState() {
//     Future(() async {
//       await siapkanKategori();
//       final mapReward = await SurveiServices().getHargaReward();
//       final mapForm = await SurveiServices().getDataForm(
//           widget.formId, (widget.isKlasik == "1") ? "klasik" : "kartu");

//       controllerJudul.text = mapForm!['judul']!;

//       hargaSatuan =
//           mapReward!['hargapPerSurvei']! + mapReward!['hargaPerPartisipan']!;
//       hargaSurvei = jumlahPartisipan * hargaSatuan;

//       setState(() {});
//     });
//     super.initState();
//   }

//   siapkanKategori() async {
//     final data = await KatalogController().getListKategori();

//     List<Object?> listObject = data!["getAllKategori"]['data'];

//     listKategori = List.generate(listObject.length, (index) {
//       Map<String, dynamic> temp = listObject[index] as Map<String, dynamic>;
//       return temp['nama'] as String;
//     });
//   }

//   final controllerJudul = TextEditingController();
//   final controllerDeskripsi = TextEditingController();
//   final controllerDurasi = TextEditingController();
//   int jumlahPartisipan = 100;
//   int hargaSurvei = -1;
//   int hargaSatuan = -1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   NavigasiAtas(isSmall: (constraints.maxWidth < 780)),
//                   const SizedBox(height: 16),
//                   Text(
//                     "Publikasi Survei",
//                     style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                         fontWeight: FontWeight.bold, color: Colors.black),
//                   ),
//                   Container(
//                     width: 875,
//                     margin: const EdgeInsets.only(top: 16),
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 32, horizontal: 72),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Center(
//                       child: Container(
//                         width: double.infinity,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             (controllerJudul.text == "")
//                                 ? TampilanLoading()
//                                 : RowContainer(
//                                     text: "Judul : ",
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 16,
//                                         horizontal: 16,
//                                       ),
//                                       decoration: BoxDecoration(
//                                           border: Border.all(
//                                             width: 1,
//                                             color: Colors.black,
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(24)),
//                                       child: TextField(
//                                         controller: controllerJudul,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .labelLarge!
//                                             .copyWith(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                             ),
//                                         //kunci untuk textfield besar adalah maxline - nya
//                                         decoration:
//                                             const InputDecoration.collapsed(
//                                           hintText: "Judul Survei",
//                                         ),
//                                         minLines: 2,
//                                         maxLines: null,
//                                       ),
//                                     ),
//                                   ),
//                             const SizedBox(height: 16),
//                             RowContainer(
//                               text: "Deskripsi : ",
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                   horizontal: 16,
//                                 ),
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                       width: 1,
//                                       color: Colors.black,
//                                     ),
//                                     borderRadius: BorderRadius.circular(24)),
//                                 child: TextField(
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelLarge!
//                                       .copyWith(
//                                         color: Colors.black,
//                                         fontSize: 17,
//                                       ),
//                                   //kunci untuk textfield besar adalah maxline - nya
//                                   decoration: const InputDecoration.collapsed(
//                                     hintText: "Deskripsi Survei",
//                                   ),
//                                   minLines: 3,
//                                   maxLines: null,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             RowContainer(
//                               text: "Perkiraan Durasi (Menit)",
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                   horizontal: 16,
//                                 ),
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                       width: 1,
//                                       color: Colors.black,
//                                     ),
//                                     borderRadius: BorderRadius.circular(24)),
//                                 child: TextField(
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .labelLarge!
//                                         .copyWith(
//                                           color: Colors.black,
//                                           fontSize: 17,
//                                         ),
//                                     //kunci untuk textfield besar adalah maxline - nya
//                                     decoration: const InputDecoration.collapsed(
//                                       hintText: "Durasi",
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     inputFormatters: <TextInputFormatter>[
//                                       FilteringTextInputFormatter.allow(
//                                           RegExp(r'[0-9]')),
//                                     ]),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             RowContainer(
//                                 text: "Kategori:",
//                                 child: Container(
//                                   width: 575,
//                                   height: 175,
//                                   decoration: BoxDecoration(
//                                     color: Colors.blueGrey.shade700,
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: (listKategori.isNotEmpty)
//                                             ? [
//                                                 Container(
//                                                   margin: const EdgeInsets.only(
//                                                       top: 12, left: 16),
//                                                   child: Text("Pilih Satu",
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .labelSmall!
//                                                           .copyWith(
//                                                             fontSize: 20,
//                                                             color: Colors.white,
//                                                           )),
//                                                 ),
//                                                 Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 16),
//                                                   child: Divider(
//                                                       color: Colors.white,
//                                                       thickness: 2),
//                                                 ),
//                                                 ...rowGeneratorV2(
//                                                     (constraints.maxWidth >
//                                                             1080)
//                                                         ? 3
//                                                         : (constraints
//                                                                     .maxWidth >
//                                                                 780)
//                                                             ? 2
//                                                             : 1,
//                                                     context),
//                                               ]
//                                             : [
//                                                 const SizedBox(
//                                                   height: 200,
//                                                   width: 65,
//                                                   child: Center(
//                                                     child:
//                                                         CircularProgressIndicator(
//                                                             strokeWidth: 10),
//                                                   ),
//                                                 )
//                                               ]),
//                                   ),
//                                 )),
//                             Row(
//                               children: [
//                                 const Spacer(),
//                                 RichText(
//                                   text: TextSpan(
//                                       text: "Pilihan Kategori : ",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .labelSmall!
//                                           .copyWith(fontSize: 17),
//                                       children: [
//                                         TextSpan(
//                                           text: (pilihanRadio == "")
//                                               ? ""
//                                               : pilihanRadio,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .labelSmall!
//                                               .copyWith(
//                                                   fontSize: 19,
//                                                   fontWeight: FontWeight.bold),
//                                         ),
//                                       ]),
//                                 )
//                               ],
//                             ),
//                             RowContainer(
//                                 text: "Partisipan & Harga",
//                                 child: Container(
//                                   width: 575,
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         (hargaSatuan == -1)
//                                             ? SizedBox(
//                                                 height: 50,
//                                                 width: 50,
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               )
//                                             : Container(
//                                                 height: 200,
//                                                 width: 375,
//                                                 decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                       color: Colors.black,
//                                                       width: 2,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20)),
//                                                 child: Row(
//                                                   children: [
//                                                     Expanded(
//                                                         flex: 4,
//                                                         child: Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal: 4,
//                                                                   vertical: 18),
//                                                           child: Column(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Text(
//                                                                 "Jumlah Partisipan",
//                                                                 style: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .displayLarge!
//                                                                     .copyWith(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           24,
//                                                                     ),
//                                                               ),
//                                                               const SizedBox(
//                                                                   height: 6),
//                                                               Text(
//                                                                 jumlahPartisipan
//                                                                     .toString(),
//                                                                 style: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .displayLarge!
//                                                                     .copyWith(
//                                                                         color: Colors
//                                                                             .black,
//                                                                         fontSize:
//                                                                             51,
//                                                                         fontWeight:
//                                                                             FontWeight.bold),
//                                                               ),
//                                                               const SizedBox(
//                                                                   height: 28),
//                                                               RichText(
//                                                                 text: TextSpan(
//                                                                     text:
//                                                                         "Biaya : ",
//                                                                     style: Theme.of(
//                                                                             context)
//                                                                         .textTheme
//                                                                         .displayLarge!
//                                                                         .copyWith(
//                                                                           color:
//                                                                               Colors.black,
//                                                                           fontSize:
//                                                                               20,
//                                                                         ),
//                                                                     children: [
//                                                                       TextSpan(
//                                                                         text: CurrencyFormat.convertToIdr(
//                                                                             hargaSurvei,
//                                                                             2),
//                                                                         style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                                                                             color: Colors
//                                                                                 .black,
//                                                                             fontSize:
//                                                                                 26,
//                                                                             fontWeight:
//                                                                                 FontWeight.bold),
//                                                                       ),
//                                                                     ]),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         )),
//                                                     Expanded(
//                                                         flex: 1,
//                                                         child: Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   vertical: 16),
//                                                           child: Column(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceBetween,
//                                                             children: [
//                                                               IconButton.filled(
//                                                                 onPressed: () {
//                                                                   setState(() {
//                                                                     jumlahPartisipan +=
//                                                                         50;
//                                                                     hargaSurvei =
//                                                                         jumlahPartisipan *
//                                                                             hargaSatuan;
//                                                                   });
//                                                                 },
//                                                                 icon: Icon(
//                                                                     Icons.add),
//                                                               ),
//                                                               IconButton.filled(
//                                                                 onPressed: () {
//                                                                   if (jumlahPartisipan >
//                                                                       100) {
//                                                                     setState(
//                                                                         () {
//                                                                       jumlahPartisipan -=
//                                                                           50;
//                                                                       hargaSurvei =
//                                                                           jumlahPartisipan *
//                                                                               hargaSatuan;
//                                                                     });
//                                                                   }
//                                                                 },
//                                                                 icon: Icon(Icons
//                                                                     .remove),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         )),
//                                                   ],
//                                                 ),
//                                               ),
//                                         Text(
//                                             "* Jumlah partisipan kelipatan 50"),
//                                         Text(
//                                             "* Harga per partisipan terhitung Rp.2200"),
//                                       ]),
//                                 )),
//                             const SizedBox(height: 16),
//                             SizedBox(height: 16),
//                             Center(
//                               child: ElevatedButton(
//                                   onPressed: () => showAlertDialog(
//                                         context: context,
//                                         deskripsi: controllerDeskripsi.text,
//                                         batasPartisipan: jumlahPartisipan,
//                                         harga: hargaSurvei,
//                                         judul: controllerJudul.text,
//                                         durasi:
//                                             int.parse(controllerDurasi.text),
//                                         kategori: pilihanRadio,
//                                       ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blueAccent.shade700,
//                                   ),
//                                   child: Container(
//                                     height: 75,
//                                     width: 155,
//                                     child: Center(
//                                       child: Text(
//                                         "Terbitkan Survei",
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
//                                   )),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class RowContainer extends StatelessWidget {
//   const RowContainer({
//     super.key,
//     required this.text,
//     required this.child,
//   });

//   final String text;
//   final Widget child;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 3,
//           child: Container(
//               width: 150,
//               padding: const EdgeInsets.only(top: 8),
//               child: Text(
//                 text,
//                 style: Theme.of(context).textTheme.labelSmall!.copyWith(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                     ),
//               )),
//         ),
//         Expanded(
//           child: SizedBox(),
//         ),
//         Expanded(
//           flex: 11,
//           child: child,
//         ),
//       ],
//     );
//   }
// }

// class CurrencyFormat {
//   static String convertToIdr(dynamic number, int decimalDigit) {
//     NumberFormat currencyFormatter = NumberFormat.currency(
//       locale: 'id',
//       symbol: 'Rp ',
//       decimalDigits: decimalDigit,
//     );
//     return currencyFormatter.format(number);
//   }
// }

// class TampilanLoading extends StatelessWidget {
//   const TampilanLoading({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       height: 40,
//       width: 40,
//       child: CircularProgressIndicator(
//         strokeWidth: 12,
//       ),
//     );
//   }
// }

// //bikin layout bagaiaman nanti susunan deskripsi : []

// //hias deskripsi saja dulu

// //load data kategori dulu

// //bikin loading sampai data kategori sudah di load
