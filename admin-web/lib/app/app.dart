// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplikasi_admin/app/data_utama.dart';
import 'package:aplikasi_admin/app/routing/router.dart';
import 'package:aplikasi_admin/features/formV2/screens/halaman_form_kartu.dart';
import 'package:aplikasi_admin/features/formV2/screens/halaman_form_klasik.dart';
import 'package:aplikasi_admin/features/laporan_survei/laporan_order.dart';
import 'package:aplikasi_admin/features/laporan_survei/laporan_survei.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: "bagian pertama",
    //   theme: ThemeData(
    //     useMaterial3: true,
    //     scaffoldBackgroundColor: Color.fromARGB(255, 236, 236, 236),
    //     fontFamily: 'Merriweather',
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: Colors.greenAccent.shade700,
    //     ),
    //   ),
    //   // home: PercobaanListView(),
    //   // home: PercobaanLaporan(),
    //   home: const HalamanFormKlasik(idForm: "ac5b5a9a"),
    //   // home: const HalamanFormKartu(idForm: "63d78b1e"),
    //   // home: HalamanFormKartu(idForm: "b0892c7f"),
    //   // home: HalamanLaporanKlasik(idSurvei: "HSV - afa2df5"),
    //   // home: HalamanLaporanKartu(idSurvei: "HSV - 41d40d0"),
    //   // home: PercobaanRealTimeDB(),
    //   // home: Scaffold(
    //   //   body: LayoutBuilder(
    //   //     builder: (context, constraints) =>
    //   //         // HalamanReportSurvei(constraints: constraints),
    //   //         HalamanReportOrder(constraints: constraints),
    //   //   ),
    //   // ),
    // );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Admin",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Merriweather',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent.shade700,
        ),
      ),
      routerConfig: AppRouter().router,
    );
  }
}

final dataUtamaProvider = StateNotifierProvider<DataUtamaNotifier, DataUtama>(
    (ref) => DataUtamaNotifier());

// class PercobaanLaporan extends StatelessWidget {
//   PercobaanLaporan({super.key});
//   final _controller = SidebarXController(selectedIndex: 0, extended: true);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(235, 243, 243, 243),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Row(
//             children: [
//               SideNavigation(
//                 controller: _controller,
//                 items: [
//                   SidebarXItem(
//                     icon: Icons.home,
//                     label: 'Home',
//                     onTap: () {
//                       debugPrint('Home');
//                     },
//                   ),
//                   SidebarXItem(
//                     icon: Icons.question_answer_rounded,
//                     label: 'Halaman Master',
//                     onTap: () {},
//                   ),
//                   SidebarXItem(
//                     icon: Icons.receipt_long,
//                     label: 'laporan Survei',
//                     onTap: () {
//                       debugPrint('Survei');
//                     },
//                   ),
//                   SidebarXItem(
//                     icon: Icons.book,
//                     label: 'Buat Form',
//                     onTap: () {
//                       debugPrint('Survei');
//                     },
//                   ),
//                   SidebarXItem(
//                     icon: Icons.drive_file_rename_outline,
//                     label: 'Draft Form',
//                     onTap: () {},
//                   ),
//                   SidebarXItem(
//                     icon: Icons.check,
//                     label: 'Survei Aktif',
//                     onTap: () {},
//                   ),
//                 ],
//               ),
//               Expanded(
//                   child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 14, horizontal: 25),
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     width: 3, color: Colors.grey.shade800))),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 18, vertical: 12),
//                               decoration: BoxDecoration(
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.circular(16)),
//                               child: Text(
//                                 "Administaris Hei-Survei",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayLarge!
//                                     .copyWith(
//                                       color: Colors.white,
//                                       fontSize: (constraints.maxWidth) > 1090
//                                           ? 40
//                                           : 24,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                               ),
//                             ),
//                             const Spacer(),
//                             badges.Badge(
//                               badgeStyle: badges.BadgeStyle(
//                                   padding: const EdgeInsets.all(7)),
//                               badgeContent: Text("2",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayLarge!
//                                       .copyWith(
//                                           color: Colors.white, fontSize: 20)),
//                               child: InkWell(
//                                 onTap: () {},
//                                 child: const Icon(Icons.email, size: 44),
//                               ),
//                             ),
//                             const SizedBox(width: 34),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 4),
//                               decoration: BoxDecoration(
//                                   color: Colors.blue.shade50,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                       width: 2, color: Colors.black)),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Admin-1",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .displayLarge!
//                                         .copyWith(
//                                             color: Colors.black, fontSize: 28),
//                                   ),
//                                   SizedBox(width: 12),
//                                   IconButton(
//                                       onPressed: () {},
//                                       icon: Icon(
//                                         Icons.logout,
//                                         size: 30,
//                                         color: Colors.red,
//                                       ))
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       HalamanReportOrder(constraints: constraints),
//                       // HalamanReportSurvei(constraints: constraints)
//                     ],
//                   ),
//                 ),
//               ))
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
