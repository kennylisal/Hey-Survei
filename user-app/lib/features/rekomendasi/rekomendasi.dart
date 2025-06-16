import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/profile/profile_controller.dart';
import 'package:survei_aplikasi/features/profile/user_data.dart';
import 'package:survei_aplikasi/features/rekomendasi/rekomendasi_controller.dart';
import 'package:survei_aplikasi/features/rekomendasi/widgets/header_rekomen.dart';
import 'package:survei_aplikasi/features/rekomendasi/widgets/kartu_katalog.dart';
import 'package:survei_aplikasi/features/rekomendasi/widgets/mohon_lengkapi_data.dart';
import 'package:survei_aplikasi/features/search/search_controller.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';

class HalamanRekomendasi extends StatefulWidget {
  const HalamanRekomendasi({super.key});

  @override
  State<HalamanRekomendasi> createState() => _HalamanRekomendasiState();
}

class _HalamanRekomendasiState extends State<HalamanRekomendasi> {
  List<String> daftarIdPengecualian = [];
  UserData? userData;
  List<SurveiDemo>? listSurvei;
  // List<SurveiDemo> listTampilan = [];
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    userData = await ProfileController().getUserData();
    //dibawah ini untuk percobaan
    // userData = UserData(
    //   email: "lisal",
    //   waktu_pendaftaran: DateTime.fromMillisecondsSinceEpoch(660762000000),
    //   kota: "",
    //   interest: [],
    //   url_gambar: "",
    //   poin: 10000,
    //   isAuthenticated: true,
    //   tglLahir: DateTime.fromMillisecondsSinceEpoch(660762000000),
    // );
    // userData!.tglLahir = DateTime.fromMillisecondsSinceEpoch(660762000000);
    // userData!.isAuthenticated = true;
    // userData!.kota = "KOTA MAKASSAR";
    // userData!.interest = ['anime', 'aktivisme'];
    //
    setState(() {});
    print(userData);
    if (userData != null) {
      daftarIdPengecualian = await SearchControllerX().getSurveiPengecualian();
      // daftarIdPengecualian = [];

      listSurvei = await RekomendasiController().getSurveiDemo();
      print(daftarIdPengecualian);
    }
    if (listSurvei != null) {
      eliminasiPengecualian();
      eliminasiSurvei();
    }
    setState(() {});
  }

  eliminasiPengecualian() async {
    for (var i = 0; i < daftarIdPengecualian.length; i++) {
      listSurvei!.removeWhere(
          (element) => element.id_survei == daftarIdPengecualian[i]);
    }
    setState(() {});
  }

  eliminasiSurvei() {
    final umurUser = AgeCalculator.age(userData!.tglLahir);
    print(listSurvei);
    print("awal ${listSurvei!.length}");
    listSurvei!.removeWhere((element) {
      if (element.demoUsia != -1) {
        return element.demoUsia > umurUser.years;
      } else
        return false;
    });
    print("eliminiasi umur ${listSurvei!.length}");
    listSurvei!.removeWhere((element) {
      if (element.demoKota.isNotEmpty) {
        return !element.demoKota.contains(userData!.kota);
      } else
        return false;
    });
    print("eliminiasi kota ${listSurvei!.length}");
    listSurvei!.removeWhere((element) {
      if (element.demoInterest.isNotEmpty) {
        final setInterSurvei = element.demoInterest.toSet();
        final setInterUser = userData!.interest.toSet();
        final hasil = setInterSurvei.intersection(setInterUser);
        return hasil.isEmpty;
      } else
        return false;
    });
    print("eliminiasi interest ${listSurvei!.length}");
    setState(() {});
  }

  contentGenerator(BoxConstraints constraints) {
    if (userData == null) {
      return Center(
        child: LoadingBiasa(
          textLoading: "Memuat Data Profile",
        ),
      );
    } else if (!userData!.isAuthenticated) {
      return LengkapiDataDemo(
        size: 29,
        text1: "Lengkapi Nomor HP Anda",
        text2: "di Halaman Profile",
        text3: "Terlebih Dahulu",
      );
    } else if (userData!.kota == "") {
      return LengkapiDataDemo(
        size: 29,
        text1: "Lengkapi Data Demografi",
        text2: "di Halaman Profile",
        text3: "Terlebih Dahulu",
      );
    } else if (listSurvei == null) {
      return Center(
        child: LoadingBiasa(
          textLoading: "Memuat Survei Untuk Anda",
        ),
      );
    } else if (listSurvei!.isEmpty) {
      return LengkapiDataDemo(
        size: 29,
        text1: "Mohon Maaf",
        text2: "Belum Ada Survei",
        text3: "yang tersedia",
      );
    } else if (userData!.tglLahirTerisi()) {
      return LengkapiDataDemo(
        size: 29,
        text1: "Lengkapi Data Demografi",
        text2: "di Halaman Profile",
        text3: "Terlebih Dahulu",
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Daftar Survei",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          SizedBox(height: 2),
          ...List.generate(
              listSurvei!.length,
              (index) => KartuKatalogDemo(
                    dataKatalog: listSurvei![index],
                    constraints: constraints,
                  ))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Survei Rekomendasi",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          backgroundColor: Colors.deepOrangeAccent.shade400,
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              )),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderRekomen(),
                const SizedBox(height: 5),
                contentGenerator(constraints),
              ],
            ),
          ),
        ));
  }
}

  // initData() async {
  //   if (userData != null) {
  //     daftarIdPengecualian = await SearchControllerX().getSurveiPengecualian();
  //     // print(daftarIdPengecualian);
  //     listSurvei = await RekomendasiController().getSurveiDemo();
  //     // print(listSurvei);
  //   }
  //   setState(() {});
  // }

    // var firstList = ['a', 'w', 'e', 'r'];
    // var secondList = ['b', 'e', 'x', 'd', 'd'];

    // var firstListSet = firstList.toSet();
    // var secondListSet = secondList.toSet();

    // print(firstListSet.intersection(secondListSet));
    // listTampilan = listSurvei!;

    // Future(() async {
    //   userData = await ProfileController().getUserData();
    //   if (userData != null) {
    //     // listSurvei = await RekomendasiController().getSurveiDemo();
    //     await initData();
    //   }
    //   //proses eliminasi data survei berdasarkan demografi
    //   if (listSurvei != null) {
    //     eliminasiSurvei();
    //   }

    //   setState(() {});
    // });