// import 'package:flutter/material.dart';
// import 'package:hei_survei/features/transaksi/model/oder_data.dart';
// import 'package:hei_survei/features/transaksi/model/transaksi.dart';
// import 'package:hei_survei/features/transaksi/transaksi_controller.dart';
// import 'package:hei_survei/features/transaksi/widget_order.dart';
// import 'package:hei_survei/utils/loading_biasa.dart';
// import 'package:intl/intl.dart';

// class HalamanOrder extends StatefulWidget {
//   HalamanOrder({super.key, required this.constraints});
//   BoxConstraints constraints;
//   @override
//   State<HalamanOrder> createState() => _HalamanOrderState();
// }

// class _HalamanOrderState extends State<HalamanOrder> {
//   Order? orderAktif;
//   bool sudahLoading = false;
//   List<Transaksi> sejarah = [];
//   List<Widget> listSejarah = [];
//   Widget kontenUtama = const TidakAdaOrder();

//   @override
//   void initState() {
//     Future(() async {
//       sejarah = await TransaksiController().getSejarahTransUser();
//       if (sejarah.isNotEmpty) {
//         listSejarah = List.generate(
//             sejarah.length,
//             (index) => KotakSejarah(
//                   hargaTotal: sejarah[index].totalHarga,
//                   invoice: sejarah[index].invoice,
//                   tanggal: DateFormat('dd-MMMM-yyyy').format(
//                     sejarah[index].tanggalTransaksi,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       print("ganti konten dong");
//                       kontenUtama = KotakKontenTrans(transaksi: sejarah[index]);
//                     });
//                   },
//                 ));
//       }
//       // print(percobaan);
//       orderAktif = await TransaksiController().getUserOrder();

//       if (orderAktif != null) {
//         kontenUtama = KotakKontenOrder(
//           order: orderAktif!,
//           nomorVA: "",
//           invoice: "",
//         );
//       }
//       sudahLoading = true;
//       setState(() {});
//     });

//     super.initState();
//   }

//   bool isKecil() => widget.constraints.maxWidth > 1480;
//   double panjangContainer() {
//     return (isKecil() ? 780 : 500);
//   }

//   tampilkanPesananAktif() {
//     if (orderAktif == null) {
//       kontenUtama = TidakAdaOrder();
//     } else {
//       kontenUtama = KotakKontenOrder(
//         order: orderAktif!,
//         nomorVA: "",
//         invoice: "",
//       );
//     }
//     setState(() {});
//   }

//   DecorationImage gambarKlasik = const DecorationImage(
//     image: AssetImage('assets/logo-klasik.png'),
//     fit: BoxFit.fill,
//   );

//   DecorationImage gambarKartu = const DecorationImage(
//     image: AssetImage('assets/logo-kartu.png'),
//     fit: BoxFit.fill,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 10),
//           Text(
//             "Halaman Pesanan",
//             style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                 fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
//           ),
//           const SizedBox(height: 12),
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 20),
//             width: double.infinity,
//             child: (!sudahLoading)
//                 //  (orderAktif == null)
//                 ? LoadingBiasa(
//                     text: "Memuat Data Keranjang",
//                     pakaiKembali: false,
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Container(
//                         width: panjangContainer(),
//                         child: kontenUtama,
//                         // child: KotakKontenOrder(order: orderAktif!),
//                       ),
//                       if (widget.constraints.maxWidth > 1021)
//                         KotakSamping(
//                           marginKiri:
//                               (widget.constraints.maxWidth < 1620) ? 0 : 150,
//                           onPressed: () => tampilkanPesananAktif(),
//                           listSejarah: listSejarah,
//                         )
//                     ],
//                   ),
//           ),
//           if (widget.constraints.maxWidth < 1021)
//             KotakSamping(
//               marginKiri: (widget.constraints.maxWidth < 1430) ? 0 : 150,
//               onPressed: () => tampilkanPesananAktif(),
//               listSejarah: listSejarah,
//             )
//         ],
//       ),
//     );
//   }
// }


// // Container(
// //   width: double.infinity,
// //   padding: const EdgeInsets.symmetric(
// //       horizontal: 20, vertical: 12),
// //   margin:
// //       const EdgeInsets.symmetric(vertical: 10),
// //   // height: 100,
// //   decoration: BoxDecoration(
// //       color: const Color.fromARGB(
// //           255, 247, 247, 247),
// //       borderRadius: BorderRadius.circular(12),
// //       border: Border.all(
// //         width: 1,
// //         color: Colors.black,
// //       )),
// //   child: Column(
// //     crossAxisAlignment:
// //         CrossAxisAlignment.start,
// //     children: [
// //       Row(
// //         crossAxisAlignment:
// //             CrossAxisAlignment.start,
// //         mainAxisAlignment:
// //             MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             "Judul Survei Pertama",
// //             style: Theme.of(context)
// //                 .textTheme
// //                 .titleLarge!
// //                 .copyWith(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   overflow:
// //                       TextOverflow.ellipsis,
// //                 ),
// //           ),
// //           Text(
// //             CurrencyFormat.convertToIdr(
// //                 10000, 2),
// //             style: Theme.of(context)
// //                 .textTheme
// //                 .displaySmall!
// //                 .copyWith(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 20,
// //                     color: Colors.black),
// //           )
// //         ],
// //       ),
// //       Row(
// //         children: [
// //           Container(
// //             height: 80,
// //             width: 100,
// //             margin: const EdgeInsets.symmetric(
// //                 vertical: 10),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius:
// //                   BorderRadius.circular(10),
// //               border: Border.all(
// //                 width: 2.75,
// //                 color: (true)
// //                     ? Colors.redAccent
// //                     : Colors.greenAccent,
// //               ),
// //               image: (true)
// //                   ? gambarKlasik
// //                   : gambarKartu,
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Container(
// //             height: 90,
// //             width: 265,
// //             child: Text(
// //               // data.deskripsi,
// //               "sdjkhfsleufhdjsjefb;seoufbs; eofubwp;o fspoefhsepfuhspe fusefugsefigsefi sdfbse;oucvbsosdsdsdasdawdawdawd adawdawdefbesfib",
// //               style: Theme.of(context)
// //                   .textTheme
// //                   .displaySmall!
// //                   .copyWith(
// //                     fontSize: 15,
// //                   ),
// //               textAlign: TextAlign.justify,
// //               overflow: TextOverflow.fade,
// //             ),
// //           ),
// //         ],
// //       ),
// //     ],
// //   ),
// // ),
