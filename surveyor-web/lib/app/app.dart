import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/app/data_utama.dart';
import 'package:hei_survei/app/error_page.dart';
import 'package:hei_survei/app/routing/router.dart';
import 'package:hei_survei/features/auth/controller/auth_controller.dart';
import 'package:hei_survei/features/auth/controller/auth_state.dart';
import 'package:hei_survei/features/form/screens/halaman_form_kartu.dart';
import 'package:hei_survei/features/form/screens/halaman_form_klasik.dart';
import 'package:hei_survei/features/laporan/laporan_kartu/laporan_kartu.dart';
import 'package:hei_survei/features/laporan/laporan_klasik/laporan_klasik.dart';
import 'package:hei_survei/features/publish_survei/publish_baru.dart';
import 'package:hei_survei/percobaan_midtrans.dart';

class HeiSurveiApp extends ConsumerStatefulWidget {
  const HeiSurveiApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeiSurveiAppState();
}

class _HeiSurveiAppState extends ConsumerState<HeiSurveiApp> {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   theme: ThemeData(
    //     scaffoldBackgroundColor: ref.watch(dataUtamaProvider).warnaBg,
    //     useMaterial3: true,
    //     fontFamily: 'Merriweather',
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: const Color.fromARGB(255, 0, 140, 255),
    //     ),
    //   ),
    //   // home: PercobaanExcel(),
    //   // home: HalamanLaporanKlasik(idSurvei: "HSV - 0136a7d"),
    //   // home: Scaffold(
    //   //   // body: HalamanLaporanKartu(idSurvei: "HSV - 16ba051"),
    //   //   body: HalamanLaporanKlasik(idSurvei: "HSV - e3bee11"),
    //   // ),
    //   // home: HalamanLaporanKartu(idSurvei: "HSV - 0136a7d"),
    //   // home: ContainerLaporanKartu(idSurvei: "HSV - 41d40d0"),
    //   // home: HalamanFormKartu(idForm: "HSV 41d40d0"),
    //   // home: HalamanFormKartu(idForm: "c9d78e31"),
    //   // home: HalamanFormKlasik(idForm: "e7b87ff2"),
    //   // home: const PublishSurveiBaru(),
    //   // home: Scaffold(
    //   //   body: SelesaiOrder(),
    //   // ),
    //   // home: const ErrorPage(),
    // );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Hey Survei",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Merriweather',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 52, 64, 73),
        ),
      ),
      routerConfig: AppRouter().router,
    );
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

final dataUtamaProvider = StateNotifierProvider<DataUtamaNotifier, DataUtama>(
    (ref) => DataUtamaNotifier());

final indexUtamaProvider = StateProvider<int>((ref) => 9);
//harusnya 2

final jumlahKeranjangProvider = StateProvider<int>((ref) => -1);

final adaOrderProvider = StateProvider<bool>((ref) => false);
