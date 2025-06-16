import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/detail_survei/widgets/header_seksi.dart';
import 'package:survei_aplikasi/features/home/home_controller.dart';
import 'package:survei_aplikasi/features/home/widgets/header.dart';
import 'package:survei_aplikasi/features/home/widgets/icon_menu.dart';
import 'package:survei_aplikasi/features/home/widgets/seksi_rekomendasi.dart';
import 'package:survei_aplikasi/utils/currency_formatter.dart';

class HalamanUtama extends ConsumerStatefulWidget {
  const HalamanUtama({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends ConsumerState<HalamanUtama>
// with AutomaticKeepAliveClientMixin<HalamanUtama>

{
  int poin = -1;
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    poin = await HomeController().getPoinUser(ref.read(authProvider).user.id);
    setState(() {});
  }

  isKecil(BoxConstraints constraints) {
    return (constraints.maxWidth < 329);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(24)),
                  child: InkWell(
                    onLongPress: () {
                      if (poin > 0) {
                        context.pushNamed(RouteConstant.riwayatKontribusiHome,
                            pathParameters: {
                              'emailUser': ref.read(authProvider).user.email,
                              'poinUser': "${ref.read(authProvider).user.poin}",
                            });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: (constraints.maxWidth / 2) + 33.5,
                              child: Text(
                                ref.watch(authProvider).user.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Icon(
                              Icons.monetization_on_rounded,
                              size: 30,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const SizedBox(height: 9),
                        Text(
                          "Poin Anda",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 3.5),
                        (poin == -1)
                            ? const Center(
                                child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: FittedBox(
                                        child: CircularProgressIndicator(
                                            color: Colors.white))),
                              )
                            : Text(
                                CurrencyFormat.convertToIdr(poin, 2),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontSize: 24.5,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                  ),
                ),
                HeaderSeksi(judul: "Menu Utama"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconMenu(
                        onTap: () {
                          //lempar ke search saja
                          context.pushNamed(RouteConstant.search,
                              pathParameters: {'doCarikan': 'true'});
                        },
                        judul: "Isi Survei",
                        lokasiGambar: 'assets/katalog.png',
                        height: isKecil(constraints) ? 45 : 60,
                        isKecil: isKecil(constraints),
                      ),
                      IconMenu(
                        onTap: () {
                          context.pushNamed(RouteConstant.rekomnedasi);
                        },
                        judul: "Rekomendasi",
                        lokasiGambar: 'assets/rekomendasi.png',
                        height: isKecil(constraints) ? 45 : 60,
                        isKecil: isKecil(constraints),
                      ),
                      IconMenu(
                        onTap: () async {
                          context.pushNamed(RouteConstant.faq);
                        },
                        judul: "FAQ",
                        lokasiGambar: 'assets/FAQ.png',
                        height: isKecil(constraints) ? 45 : 60,
                        isKecil: isKecil(constraints),
                      ),
                    ],
                  ),
                ),
                const HeaderSeksi(judul: "Katalog"),
                KolomRekomendasi(constraints: constraints),
                const SizedBox(height: 20),
              ],
            );
          },
        ));
  }

  // @override
  // // bool get wantKeepAlive => (baseUri == Uri.base.toString());
  // bool get wantKeepAlive => true;
}

// class HalamanUtama extends StatefulWidget {
//   const HalamanUtama({super.key});

//   @override
//   State<HalamanUtama> createState() => _HalamanUtamaState();
// }

// class _HalamanUtamaState extends State<HalamanUtama>
//     with AutomaticKeepAliveClientMixin<HalamanUtama> {
//   List<HSurvei> listSurvei = [];
//   @override
//   void initState() {
//     Future(() async {
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
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SingleChildScrollView(
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
//       },
//     );
//   }

//   @override
//   //  bool get wantKeepAlive => (baseUri == Uri.base.toString());
//   bool get wantKeepAlive => true;
// }
