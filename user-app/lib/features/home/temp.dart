// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:survei_aplikasi/features/home/home_controller.dart';
// import 'package:survei_aplikasi/features/home/widgets/kartu_baru.dart';
// import 'package:survei_aplikasi/features/search/model/h_survei.dart';

// class HalamanUtama extends ConsumerStatefulWidget {
//   const HalamanUtama({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HalamanUtamaState();
// }

// class _HalamanUtamaState extends ConsumerState<HalamanUtama>
//     with AutomaticKeepAliveClientMixin<HalamanUtama> {
//   List<HSurvei> listSurvei = [];

//   @override
//   void initState() {
//    Future(() async {
//       listSurvei = await HomeController().getSurveiTerbaru();
//       setState(() {});
//     });

//     super.initState();
//   }

//   List<Widget> generateSurveiTerbaru() {
//     List<Widget> hasil = List.generate(listSurvei.length,
//         (index) => KartuKatalog(dataKatalog: listSurvei[index]));
//     return hasil;
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: (listSurvei.isEmpty)
//               ? Center(
//                   child: LoadingBiasa(),
//                 )
//               : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     HeaderWidget(),
//                     Container(
//                       margin: EdgeInsets.only(bottom: 16, left: 24, right: 24),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 16),
//                       width: double.infinity,
//                       height: 105,
//                       decoration: BoxDecoration(
//                           color: Colors.blue.shade400,
//                           borderRadius: BorderRadius.circular(24)),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Kennylisal5@gmail.com",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayMedium!
//                                     .copyWith(
//                                       fontSize: 18,
//                                       color: Colors.white,
//                                     ),
//                               ),
//                               Icon(
//                                 Icons.monetization_on_rounded,
//                                 size: 30,
//                                 color: Colors.white,
//                               )
//                             ],
//                           ),
//                           Text(
//                             "Poin Anda",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayMedium!
//                                 .copyWith(
//                                   fontSize: 13.5,
//                                   color: Colors.white,
//                                 ),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             "Rp. 0",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayMedium!
//                                 .copyWith(
//                                     fontSize: 26,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                           )
//                         ],
//                       ),
//                     ),
//                     HeaderSeksi(judul: "Menu Utama"),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconMenu(
//                             onTap: () {
//                               //lempar ke search saja
//                               context.pushNamed(RouteConstant.search);
//                             },
//                             judul: "Isi Survei",
//                             lokasiGambar: 'assets/katalog.png',
//                             height: 55,
//                           ),
//                           IconMenu(
//                             onTap: () {},
//                             judul: "Rekomendasi",
//                             lokasiGambar: 'assets/rekomendasi.png',
//                             height: 65,
//                           ),
//                           IconMenu(
//                             onTap: () {
//                               context.pushNamed(RouteConstant.faq);
//                             },
//                             judul: "FAQ",
//                             lokasiGambar: 'assets/FAQ.png',
//                             height: 60,
//                           ),
//                         ],
//                       ),
//                     ),
//                     HeaderSeksi(judul: "Katalog"),
//                     ...generateSurveiTerbaru(),
//                     // KartuKatalog(dataKatalog: dataKatalog),
//                     // KartuKatalog(dataKatalog: dataKatalog),
//                     // KartuKatalog(dataKatalog: dataKatalog),
//                     Center(
//                       child: Container(
//                         margin: const EdgeInsets.only(top: 8),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue),
//                           onPressed: () {},
//                           child: Text(
//                             "Lihat Katalog Lengkap",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayMedium!
//                                 .copyWith(
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                 ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//         );
//   }

//   @override
//   // bool get wantKeepAlive => (baseUri == Uri.base.toString());
//   bool get wantKeepAlive => true;
// }
