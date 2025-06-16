import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/widgets/header_main.dart';
import 'package:hei_survei/app/widgets/side_navgitaon.dart';
import 'package:hei_survei/features/buat_form/container_buat_form.dart';
import 'package:hei_survei/features/katalog/detail_survei.dart';
import 'package:hei_survei/features/draft/draft_form.dart';
import 'package:hei_survei/features/katalog/katalog_baru.dart';
import 'package:hei_survei/features/order_penerbitan/order_midtrans.dart';
import 'package:hei_survei/features/profile/profile.dart';

import 'package:hei_survei/features/surveiku/screens/survei_aktif.dart';

import 'package:hei_survei/features/surveiku/screens/surveiku.dart';
import 'package:hei_survei/features/transaksi/cart.dart';
import 'package:hei_survei/features/transaksi/order.dart';
import 'package:hei_survei/features/transaksi/order_baru.dart';
import 'package:hei_survei/features/transaksi/transaksi_controller.dart';
import 'package:hei_survei/utils/hover_builder.dart';

class HalamanUtama extends ConsumerStatefulWidget {
  const HalamanUtama({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends ConsumerState<HalamanUtama> {
  //
  late int _selectedPage;

  late PageController _pageController;

  //
  SideMenuController sideMenuController = SideMenuController();

  List<SideMenuItem> items = [];
  String idSurveiDetail = "";

  SideNavigation? sideNavigation;
  PageView generateKontenView(BoxConstraints constraints) {
    List<Widget> _pages = [
      SurveikuBaru(constraints: constraints),
      HalamanLaporan(),
      SurveiAktifBaru(constraints: constraints), //khusus liat survei yg aktif
      HalamanKatalog(constraints: constraints),
      DraftForm(constraints: constraints),
      ContainerBuatForm(constraints: constraints),
      DetailSurvei(constraints: constraints),
      HalamanCart(constraints: constraints),
      // HalamanOrder(constraints: constraints),
      HalamanOrderBaru(constraints: constraints),
      HalamanProfile(constraints: constraints),
      OrderMidTrans(constraints: constraints),
    ];
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: _pages,
      scrollDirection: Axis.vertical,
    );
  }

  gantiHalaman(int index) {
    log("ini index baru pilihan $index");
    try {
      ref.read(indexUtamaProvider.notifier).update((state) => index);
      setState(() {
        if (index == 8) {
          ref.read(dataUtamaProvider.notifier).gantiWarnaBg(Colors.grey);
        } else {
          ref.read(dataUtamaProvider.notifier).gantiWarnaBg(Colors.white);
        }
        _pageController.jumpToPage(index);
      });
    } catch (e) {}
  }

  gantiIdSurveiDetail(String idBaru) {
    setState(() {
      idSurveiDetail = idBaru;
    });
  }

  initKeranjang() async {
    int jumlah = await TransaksiController().getJumlahKeranjang();
    print("ini jumlah keranjang $jumlah");
    ref.read(jumlahKeranjangProvider.notifier).update((state) => jumlah);
  }

  initOrder() async {
    bool temp = await TransaksiController().getStatusOrder();
    ref.read(adaOrderProvider.notifier).update((state) => temp);
  }

  @override
  void initState() {
    _selectedPage = ref.read(indexUtamaProvider);
    _pageController = PageController(initialPage: _selectedPage);
    sideNavigation = SideNavigation(
      items: items,
      controller: sideMenuController,
      ontapBuatForm: () => gantiHalaman(5),
    );
    initKeranjang();
    initOrder();

    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(indexUtamaProvider, ((previous, next) {
      if (previous != next) {
        print("ganti hal");
        _pageController.jumpToPage(next);
      }
    }));
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: HeaderMain(),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 224, 244, 255),
                      border: Border(
                        right:
                            BorderSide(color: Colors.grey.shade700, width: 2),
                      ),
                    ),
                    width: 310,
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: Column(
                            children: [
                              Container(
                                  width: double.infinity,
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: ElevatedButton(
                                      onPressed: () => gantiHalaman(5),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        "Buat Form",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                              color: Colors.white,
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                      ))),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Divider(
                                  color: Colors.black,
                                  height: 4,
                                ),
                              ),
                              TileSamping(
                                iconHeight: 40,
                                onTap: () => gantiHalaman(2),
                                resourceIcon: 'assets/surveyor.png',
                                textJudul: 'Survei Aktif',
                              ),
                              TileSamping(
                                iconHeight: 40,
                                onTap: () => gantiHalaman(3),
                                resourceIcon: 'assets/preview.png',
                                textJudul: 'Pencarian',
                              ),
                              TileSamping(
                                iconHeight: 40,
                                onTap: () => gantiHalaman(4),
                                resourceIcon: 'assets/draft.png',
                                textJudul: 'Draft',
                              ),
                              TileSamping(
                                iconHeight: 40,
                                onTap: () => gantiHalaman(10),
                                resourceIcon: 'assets/logo-bayar.png',
                                textJudul: 'Pembayaran',
                              ),
                              const Spacer(),
                              Image.asset(
                                'assets/logo-app.png',
                                height: 110,
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    color: Colors.grey.shade50.withOpacity(0.9),
                    width: double.infinity,
                    child: generateKontenView(constraints),
                  ),
                )
              ],
            );
          },
        ));
  }
}

class TileSamping extends StatelessWidget {
  TileSamping({
    super.key,
    required this.textJudul,
    required this.iconHeight,
    required this.resourceIcon,
    required this.onTap,
  });
  String textJudul;
  String resourceIcon;
  double iconHeight;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return HoverBuilder(builder: (isHovered) {
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                resourceIcon,
                // 'assets/surveyor.png',
                height: iconHeight,
                color: Colors.blue.shade600,
              ),
              SizedBox(width: 35),
              Text(
                // "Hei Survei",
                textJudul,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.blue.shade600,
                      fontSize: (isHovered) ? 25 : 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class SideBarBaru extends StatelessWidget {
  const SideBarBaru({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 600,
      child: ListView(
        children: [
          Container(
              width: 320,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Buat Form",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                  ))),
          Spacer(),
          Image.asset(
            'assets/logo-app.png',
            height: 110,
          ),
        ],
      ),
    );
  }
}

class TidakAdaData extends StatelessWidget {
  const TidakAdaData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Center(
          child: Image.asset(
            'assets/no-data-katalog.png',
            height: 300,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Masukkan Pencarian lain",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class HalamanLaporan extends StatelessWidget {
  const HalamanLaporan({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Laporan"),
    );
  }
}

    //ini awalnya di line 94 bawah sideNavigation
    // items = [
    //   SideMenuItem(
    //     title: 'Survei Aktif',
    //     onTap: (index, _) => gantiHalaman(2),
    //     iconWidget: Image.asset(
    //       'assets/surveyor.png',
    //       color: Colors.blue.shade600.withOpacity(0.8),
    //     ),
    //   ),
    //   SideMenuItem(
    //     title: 'Pencarian',
    //     onTap: (index, _) => gantiHalaman(3),
    //     iconWidget: Image.asset(
    //       'assets/preview.png',
    //       color: Colors.blue.shade600.withOpacity(0.8),
    //     ),
    //   ),
    //   SideMenuItem(
    //     title: 'Draft',
    //     onTap: (index, _) => gantiHalaman(4),
    //     iconWidget: Image.asset(
    //       'assets/draft.png',
    //       color: Colors.blue.shade600.withOpacity(0.8),
    //     ),
    //   ),
    //   SideMenuItem(
    //     title: 'Pembayaran',
    //     onTap: (index, _) => gantiHalaman(4),
    //     iconWidget: Image.asset(
    //       'assets/logo-bayar.png',
    //       color: Colors.blue.shade600.withOpacity(0.8),
    //     ),
    //   ),
    // ];


// PreferredSize(
        //   preferredSize: Size.fromHeight(75),
        //   child: Container(
        //     color: Color.fromARGB(255, 27, 110, 179),
        //     padding: const EdgeInsets.symmetric(horizontal: 50),
        //     width: double.infinity,
        //     height: 66,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         Text(
        //           "Hei Survei",
        //           style: Theme.of(context).textTheme.displayLarge!.copyWith(
        //                 color: Colors.white,
        //                 fontSize: 35,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //         ),
        //         const Spacer(),
        //         ItemNavigasiAtas(
        //             onTap: () {
        //               gantiHalaman(0);
        //             },
        //             text: "Surveiku"),
        //         const SizedBox(width: 16),
        //         ItemNavigasiAtas(
        //             onTap: () {
        //               gantiHalaman(7);
        //             },
        //             text: "Keranjang"),
        //         const SizedBox(width: 16),
        //         ItemNavigasiAtas(
        //             onTap: () {
        //               gantiHalaman(8);
        //             },
        //             text: "Pesanan"),
        //         const SizedBox(width: 24),
        //         InkWell(
        //           onTap: () {
        //             gantiHalaman(9);
        //           },
        //           child: CircleAvatar(
        //             backgroundColor: Colors.green,
        //             radius: 24,
        //             child: CachedNetworkImage(
        //               filterQuality: FilterQuality.medium,
        //               imageUrl: ref.watch(authProvider).user.urlGambar,
        //               imageBuilder: (context, imageProvider) {
        //                 return Container(
        //                   decoration: BoxDecoration(
        //                     image: DecorationImage(
        //                       image: imageProvider,
        //                       fit: BoxFit.cover,
        //                     ),
        //                   ),
        //                 );
        //               },
        //               progressIndicatorBuilder:
        //                   (context, url, downloadProgress) =>
        //                       CircularProgressIndicator(
        //                           value: downloadProgress.progress),
        //               errorWidget: (context, url, error) {
        //                 return const Icon(
        //                   Icons.error,
        //                   size: 48,
        //                   color: Colors.red,
        //                 );
        //               },
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),