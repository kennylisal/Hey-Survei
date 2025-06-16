import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survei_aplikasi/features/app/router/router.dart';
import 'package:survei_aplikasi/features/auth/controller/auth_controller.dart';
import 'package:survei_aplikasi/features/auth/state/auth_state.dart';
import 'package:survei_aplikasi/features/dynamic_link/detail_dynamic.dart';
import 'package:survei_aplikasi/features/form_kartu/form_kartu.dart';
import 'package:survei_aplikasi/features/form_klasik/form_klasik.dart';
import 'package:survei_aplikasi/features/home/model/data_katalog.dart';

class HeiSurveiApp extends StatefulWidget {
  const HeiSurveiApp({super.key});

  @override
  State<HeiSurveiApp> createState() => _HeiSurveiAppState();
}

class _HeiSurveiAppState extends State<HeiSurveiApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     title: "Hey Survei",
    //     theme: ThemeData(
    //       scaffoldBackgroundColor: Colors.blue.shade50,
    //       useMaterial3: true,
    //       fontFamily: 'Merriweather',
    //       colorScheme: ColorScheme.fromSeed(
    //         seedColor: const Color.fromARGB(255, 0, 140, 255),
    //       ),
    //     ),
    //     home: DetailSurveiDynamic(idSurvei: 'HSV - 1afddd3')
    //     // home: DetailSejarah(
    //     //   idSurvei: "HSV - 16ba051",
    //     //   tglPengisian: DateTime.now(),
    //     // ),
    //     // home: SejarahKontribusiHome(
    //     //     emailUser: "Kennylisal5@gmail.com", pointUser: 10000),
    //     // home: ContainerKartuPercobaan(
    //     //     idForm: 'd4dc0c57', idSurvei: 'HSV - 16ba051'),
    //     // home: ContainerKlasikPercobaan(
    //     //   idForm: "285ff988",
    //     //   idSurvei: "HSV - e3bee11",
    //     // ),
    //     // home: HomePage(),
    //     // home: HalamanSearch(),
    //     // home: SearchKatalog(doCarikan: true),
    //     // home: HalamanProfile(),
    //     );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Hey Survei",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue.shade50,
        useMaterial3: true,
        fontFamily: 'Merriweather',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 140, 255),
        ),
      ),
      routerConfig: AppRouter().router,
    );
  }
}

final indexUtamaProvider = StateProvider<int>((ref) => 0);

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

final dataKatalogProvider = StateProvider((ref) => DataKatalog(
    tanggalPenerbitan: DateTime.now(),
    judul: "",
    kategori: "",
    insentif: 0,
    namaPencipta: "",
    durasi: 0,
    deskripsi: "",
    idForm: "",
    idSurvei: "",
    isKlasik: true));

final idKatalogProvider = StateProvider((ref) => "");

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: "bagian pertama",
  //     theme: ThemeData(
  //       scaffoldBackgroundColor: Colors.blue.shade50,
  //       useMaterial3: true,
  //       fontFamily: 'Merriweather',
  //       colorScheme: ColorScheme.fromSeed(
  //         seedColor: const Color.fromARGB(255, 0, 140, 255),
  //       ),
  //     ),
  //     // home: ContainerFormKlasik(idForm: "b78f39db", idSurvei: "HSV - 6adc863"),
  //     // home: ContainerFormKartu(idForm: "b0892c7f", idSurvei: "HSV - 41d40d0"),
  //     // home: DetailSurveiDynamic(idSurvei: "HSV - 16ba051"),
  //     // home: Scaffold(
  //     //   body: PenarikanDana(poin: 15000, email: "lisal@gmail.com"),
  //     //   // body: TampilanHistory(),
  //     //   // body: HalamanUtama(),
  //     //   // body: TerimaKasihPengisianForm(insentif: 900),
  //     // ),
  //     // home: HalamanSearch(doCarikan: false),
  //     // home: HalamanProfile(),
  //     // home: HalamanFAQ(),
  //     // home: HalamanPenilaian(
  //     //     email: "lsal@gmail.com", idSurvei: "HSV - Percobaan"),
  //     home: HalamanOTP(),
  //   );
  //   // return MaterialApp.router(
  //   //   debugShowCheckedModeBanner: false,
  //   //   title: "bagian pertama",
  //   //   theme: ThemeData(
  //   //     scaffoldBackgroundColor: Colors.blue.shade50,
  //   //     useMaterial3: true,
  //   //     fontFamily: 'Merriweather',
  //   //     colorScheme: ColorScheme.fromSeed(
  //   //       seedColor: const Color.fromARGB(255, 0, 140, 255),
  //   //     ),
  //   //   ),
  //   //   routerConfig: AppRouter().router,
  //   // );
  // }