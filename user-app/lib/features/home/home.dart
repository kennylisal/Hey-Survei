import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/dynamic_link/dynamic_link_baru.dart';
import 'package:survei_aplikasi/features/home/main_page.dart';

import 'package:survei_aplikasi/features/profile/profile.dart';
import 'package:survei_aplikasi/features/search/search.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends ConsumerState<HomePage> {
  late int currentIndex;
  @override
  void initState() {
    currentIndex = ref.read(indexUtamaProvider);
    DynamicLinkBaru().initDynamicLinks(context);
    super.initState();
  }

  gantiHalaman(int value) {
    try {
      setState(() {
        currentIndex = value;
      });
    } catch (e) {}
  }

  List<Widget> listHalaman = [
    const HalamanUtama(),
    HalamanSearch(),
    HalamanProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(15),
        child: AppBar(
          backgroundColor: Colors.blueAccent.shade700,
          leading: const SizedBox(),
        ),
      ),
      body: listHalaman[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade300,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue.shade900,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), label: "Pencarian"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Pengguna')
        ],
        onTap: (value) => gantiHalaman(value),
      ),
    );
  }
}



      // LayoutBuilder(
      //   builder: (context, constraints) {
      //     return SingleChildScrollView(
      //       scrollDirection: Axis.vertical,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           HeaderWidget(),
      //           Container(
      //             margin: EdgeInsets.only(bottom: 16, left: 24, right: 24),
      //             padding:
      //                 const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      //             width: double.infinity,
      //             height: 105,
      //             decoration: BoxDecoration(
      //                 color: Colors.blue.shade400,
      //                 borderRadius: BorderRadius.circular(24)),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(
      //                       "Kennylisal5@gmail.com",
      //                       style: Theme.of(context)
      //                           .textTheme
      //                           .displayMedium!
      //                           .copyWith(
      //                             fontSize: 16,
      //                             color: Colors.white,
      //                           ),
      //                     ),
      //                     Icon(
      //                       Icons.monetization_on_rounded,
      //                       size: 30,
      //                       color: Colors.white,
      //                     )
      //                   ],
      //                 ),
      //                 Text(
      //                   "Poin Anda",
      //                   style:
      //                       Theme.of(context).textTheme.displayMedium!.copyWith(
      //                             fontSize: 12,
      //                             color: Colors.white,
      //                           ),
      //                 ),
      //                 const SizedBox(height: 2),
      //                 Text(
      //                   "Rp. 0",
      //                   style: Theme.of(context)
      //                       .textTheme
      //                       .displayMedium!
      //                       .copyWith(
      //                           fontSize: 26,
      //                           color: Colors.white,
      //                           fontWeight: FontWeight.bold),
      //                 )
      //               ],
      //             ),
      //           ),
      //           HeaderSeksi(judul: "Menu Utama"),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 16),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 IconMenu(
      //                   judul: "Katalog",
      //                   lokasiGambar: 'assets/katalog.png',
      //                   height: 55,
      //                 ),
      //                 IconMenu(
      //                   judul: "Rekomendasi",
      //                   lokasiGambar: 'assets/rekomendasi.png',
      //                   height: 65,
      //                 ),
      //                 IconMenu(
      //                   judul: "FAQ",
      //                   lokasiGambar: 'assets/FAQ.png',
      //                   height: 60,
      //                 ),
      //               ],
      //             ),
      //           ),
      //           HeaderSeksi(judul: "Katalog"),
      //           KartuKatalog(),
      //           KartuKatalog(),
      //           KartuKatalog(),
      //           Center(
      //             child: Container(
      //               margin: const EdgeInsets.only(top: 8),
      //               child: ElevatedButton(
      //                 style: ElevatedButton.styleFrom(
      //                     backgroundColor: Colors.blue),
      //                 onPressed: () {},
      //                 child: Text(
      //                   "Lihat Katalog Lengkap",
      //                   style:
      //                       Theme.of(context).textTheme.displayMedium!.copyWith(
      //                             fontSize: 16,
      //                             color: Colors.white,
      //                           ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           const SizedBox(height: 10),
      //         ],
      //       ),
      //     );
      //   },
      // ),