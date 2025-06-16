import 'dart:developer';

import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/constants.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/detail_survei/detail_controller.dart';
import 'package:survei_aplikasi/features/detail_survei/widgets/error_demografi.dart';
import 'package:survei_aplikasi/features/detail_survei/widgets/kotak_logo.dart';
import 'package:survei_aplikasi/features/detail_survei/widgets/survei_tidak_ditemukan.dart';
import 'package:survei_aplikasi/features/dynamic_link/demografi_survei.dart';
import 'package:survei_aplikasi/features/dynamic_link/sudah_dikerjakan.dart';
import 'package:survei_aplikasi/features/profile/profile_controller.dart';
import 'package:survei_aplikasi/features/profile/user_data.dart';
import 'package:survei_aplikasi/utils/currency_formatter.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';
import 'package:survei_aplikasi/utils/shared_pref.dart';

enum LayarDynamic {
  loading,
  noSurvei,
  sudahKerjaSurvei,
  detailSurvei,
  errorDemografi
}

class DetailSurveiDynamic extends StatefulWidget {
  DetailSurveiDynamic({
    super.key,
    required this.idSurvei,
  });
  String idSurvei;
  @override
  State<DetailSurveiDynamic> createState() => _DetailSurveiDynamicState();
}

class _DetailSurveiDynamicState extends State<DetailSurveiDynamic> {
  DataDetailSurvei? dataKatalog;
  bool loadingDataSurvei = true;
  bool isSurveiAda = false;
  bool bisaDikerjakan = false;
  LayarDynamic layar = LayarDynamic.loading;

  bool isSurveiDemografi = false;

  DemografiSurvei? demografiSurvei;

  UserData? user;

  String pesanErrorDemografi = "";

  @override
  void initState() {
    try {
      initData();
    } catch (e) {
      context.goNamed(RouteConstant.auth);
    }

    super.initState();
  }

  initData() async {
    print("masuk initData");
    bool cekAwal = await pengecekanAwal();

    if (cekAwal) {
      dataKatalog = await DetailController().getDetailSurvei(widget.idSurvei);
      if (dataKatalog != null) {
        layar = LayarDynamic.detailSurvei;
      }
    }
    setState(() {});
  }

  Future<bool> cekSurveiAdaTidak() async {
    bool hasil = false;
    final surveiRef =
        FirebaseFirestore.instance.collection('h_survei').doc(widget.idSurvei);
    await surveiRef.get().then((doc) {
      if (doc.exists) {
        hasil = true;
        Map<String, dynamic> dataFormJson = doc.data()!;
        if (dataFormJson['pakaiDemografi']) {
          isSurveiDemografi = true;
          demografiSurvei = DemografiSurvei.fromMap(dataFormJson);
          print(demografiSurvei);
        }
      }
    }).onError((error, stackTrace) {
      log(error.toString());
    });

    return hasil;
  }

  Future<bool> cekBisaDikerjakan() async {
    bool hasil = false;
    final idUser = SharedPrefs.getString(prefUserid) ?? "8c6639a";
    final surveiRef = FirebaseFirestore.instance
        .collection('jawaban-survei-v3')
        .where('idUser', isEqualTo: idUser)
        .where('idSurvei', isEqualTo: widget.idSurvei);
    await surveiRef.get().then((doc) {
      if (doc.docs.isEmpty) {
        hasil = true;
      }
    }).onError((error, stackTrace) {
      log(error.toString());
    });
    return hasil;
  }

  Future<bool> pengecekanAwal() async {
    print("Masuk pengecekan awal");
    bool surveiAda = await cekSurveiAdaTidak();
    if (!surveiAda) {
      layar = LayarDynamic.noSurvei;
      return false;
    }
    print("Selesai survei ada tidak");
    bool cekBisa = await cekBisaDikerjakan();
    if (!cekBisa) {
      layar = LayarDynamic.sudahKerjaSurvei;
      return false;
    }
    print("Selesai bisa dikerjakan");
    if (isSurveiDemografi) {
      print("Masuk pengecekan demo");
      //ambil demografi survei VVV
      //ambil demografi user
      user = await ProfileController().getUserData();
      //pengecekan data demografi user lengkap tidak
      if (user != null) {
        print("user tidak null");
        if (!user!.isAuthenticated) {
          layar = LayarDynamic.errorDemografi;
          pesanErrorDemografi = "Autentikasi Nonmor HP Anda";
          return false;
        } else if (user!.kota == "") {
          layar = LayarDynamic.errorDemografi;
          pesanErrorDemografi = "Lengkapi data demografi anda dahulu";
          return false;
        }
        //pembandingan demo
        print("masuk cek demo");
        if (demografiSurvei!.usiaMinimal != -1) {
          print("masuk cek umur");
          final umurUser = AgeCalculator.age(user!.tglLahir);
          if (demografiSurvei!.usiaMinimal > umurUser.years) {
            print("Usia tidak mencukupi");
            layar = LayarDynamic.errorDemografi;
            pesanErrorDemografi =
                "Umur anda dibawah kebutuhan demografi Survei";
            return false;
          }
        }
        if (demografiSurvei!.demografiKota.isNotEmpty) {
          print("Masuk pengecekan demo kota");
          if (!demografiSurvei!.demografiKota.contains(user!.kota)) {
            print("Kota tidak termasuk");
            layar = LayarDynamic.errorDemografi;
            pesanErrorDemografi =
                "Tempat tinggal anda tidak termasuk di demografi survei";
            return false;
          }
        }
        if (demografiSurvei!.demografiInterest.isNotEmpty) {
          final setDemoSurvei = demografiSurvei!.demografiInterest.toSet();
          final setInterestUser = user!.interest.toSet();
          final hasil = setDemoSurvei.intersection(setInterestUser);
          print(hasil);
          if (hasil.isEmpty) {
            print("Interest tidak intersek");
            layar = LayarDynamic.errorDemografi;
            pesanErrorDemografi =
                "Interest anda tidak termasuk di demografi survei";
            return false;
          }
        }
      } else {
        layar = LayarDynamic.errorDemografi;
        pesanErrorDemografi = "Terjadi kesalah verifikasi akun";
        return false;
      }
    }
    return true;
  }

  bool pengecekanDemoDynamicLink() {
    if (!user!.isAuthenticated) {
      layar = LayarDynamic.errorDemografi;
      pesanErrorDemografi = "Autentikasi Nonmor HP Anda";
      return false;
    } else if (user!.kota == "") {
      layar = LayarDynamic.errorDemografi;
      pesanErrorDemografi = "Lengkapi data demografi anda dahulu";
      return false;
    }
    if (demografiSurvei!.usiaMinimal != -1) {
      final umurUser = AgeCalculator.age(user!.tglLahir);
      if (demografiSurvei!.usiaMinimal > umurUser.years) {
        layar = LayarDynamic.errorDemografi;
        pesanErrorDemografi = "Umur anda dibawah kebutuhan demografi Survei";
        return false;
      }
    }
    if (demografiSurvei!.demografiKota.isNotEmpty) {
      if (!demografiSurvei!.demografiKota.contains(user!.kota)) {
        layar = LayarDynamic.errorDemografi;
        pesanErrorDemografi =
            "Tempat tinggal anda tidak termasuk di demografi survei";
        return false;
      }
    }
    if (demografiSurvei!.demografiInterest.isNotEmpty) {
      final setDemoSurvei = demografiSurvei!.demografiInterest.toSet();
      final setInterestUser = user!.interest.toSet();
      final hasil = setDemoSurvei.intersection(setInterestUser);
      if (hasil.isEmpty) {
        layar = LayarDynamic.errorDemografi;
        pesanErrorDemografi =
            "Interest anda tidak termasuk di demografi survei";
        return false;
      }
    }
    return true;
  }

  kerjaSurvei() async {
    setState(() {
      loadingDataSurvei = true;
    });
    String hasil = "xxx";
    hasil = await DetailController()
        .cekIjinPengisian(dataKatalog!.hSurvei.id_survei);

    if (hasil != "xxx") {
      setState(() {
        loadingDataSurvei = false;
      });
      if (dataKatalog!.hSurvei.isKlasik) {
        if (!context.mounted) return;
        context.goNamed(RouteConstant.formKlasik, pathParameters: {
          'idForm': hasil,
          'idSurvei': dataKatalog!.hSurvei.id_survei,
        });
      } else {
        if (!context.mounted) return;
        context.goNamed(RouteConstant.formKartu, pathParameters: {
          'idForm': hasil,
          'idSurvei': dataKatalog!.hSurvei.id_survei,
        });
      }
    } else {
      setState(() {
        loadingDataSurvei = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Survei Sudah Tidak Tersedia")));
    }
  }

  Widget cekContent(bool bisaDikerjakan) {
    if (bisaDikerjakan) {
      return contentGenerator();
    } else {
      return ListView(
        children: const [
          SudahDikerjakan(),
        ],
      );
    }
  }

  Widget contentGenerator() {
    if (layar == LayarDynamic.sudahKerjaSurvei) {
      return ListView(
        children: const [
          SudahDikerjakan(),
        ],
      );
    } else if (layar == LayarDynamic.loading) {
      return Center(child: LoadingBiasa(textLoading: "Memuat Data Survei"));
    } else if (layar == LayarDynamic.noSurvei) {
      return const Center(child: SurveiTidakDitemukan());
    } else if (layar == LayarDynamic.errorDemografi) {
      return Center(
        child: ErrorDemografi(pesan: pesanErrorDemografi),
      );
    } else {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        children: [
          //LoadingBiasa(),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.indigo.shade200.withOpacity(0.5),
            ),
            child: Image.asset('assets/kerja-survei.png', height: 110),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 300,
              child: Text(
                dataKatalog!.hSurvei.judul,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.925),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Center(
            child: Text(
              (dataKatalog!.hSurvei.isKlasik) ? 'Form Klasik' : "Form Kartu",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 14,
                  color: Colors.black,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KotakLogoKeterangan(
                  icons: Icons.monetization_on_rounded,
                  text: CurrencyFormat.convertToIdr(
                      dataKatalog!.hSurvei.insentif, 2),
                ),
                Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        //Icons.monetization_on_rounded,
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 120,
                      child: Text(
                        dataKatalog!.user.email,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.65),
                                ),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
                KotakLogoKeterangan(
                  icons: Icons.timelapse_rounded,
                  text: "${dataKatalog!.hSurvei.durasi} menit",
                )
              ],
            ),
          ),

          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Deskripsi",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.25,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 190,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 3,
                  color: Colors.blue,
                )),
            child: SingleChildScrollView(
              child: Text(
                dataKatalog!.hSurvei.deskripsi,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 15,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 26),
            child: ElevatedButton(
              onPressed: () async {
                kerjaSurvei();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
              ),
              child: Text(
                "Isi Survei",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.25,
                    ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          "Detail Survei",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.blue.shade400,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              context.pushNamed(RouteConstant.home);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            )),
      ),
      body: contentGenerator(),
    );
  }
}

  // initData() async {
  //   if (SharedPrefs.getString(prefUserid) != null) {
  //     final hasil = await cekBisaDikerjakan();
  //     bisaDikerjakan = hasil;
  //     if (hasil) {
  //     } else {
  //       final idValid = await cekSurveiAdaTidak();
  //       if (idValid) {
  //         dataKatalog =
  //             await DetailController().getDetailSurvei(widget.idSurvei);
  //         isSurveiAda = true;
  //       } else {
  //         if (!context.mounted) return;
  //         context.goNamed(RouteConstant.auth);
  //       }
  //     }

  //     setState(() {
  //       loadingDataSurvei = false;
  //     });
  //   } else {
  //     context.goNamed(RouteConstant.auth);
  //   }
  // }
  
  // Widget contentGenerator() {
  //   if (!bisaDikerjakan) {
  //     return ListView(
  //       children: const [
  //         SudahDikerjakan(),
  //       ],
  //     );
  //   } else if (loadingDataSurvei) {
  //     return Center(child: LoadingBiasa(textLoading: "Memuat Data Survei"));
  //   } else if (!isSurveiAda) {
  //     return const Center(child: SurveiTidakDitemukan());
  //   } else if (dataKatalog == null) {
  //     return Center(
  //         child: LoadingBiasa(textLoading: "Terjadi Kesalahan Server"));
  //   } else {
  //     return ListView(
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  //       children: [
  //         //LoadingBiasa(),
  //         Container(
  //           padding: const EdgeInsets.all(18),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: Colors.indigo.shade200.withOpacity(0.5),
  //           ),
  //           child: Image.asset('assets/kerja-survei.png', height: 110),
  //         ),
  //         const SizedBox(height: 10),
  //         Center(
  //           child: Container(
  //             width: 300,
  //             child: Text(
  //               dataKatalog!.hSurvei.judul,
  //               style: Theme.of(context).textTheme.displayMedium!.copyWith(
  //                   fontSize: 22,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.bold,
  //                   letterSpacing: 0.925),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 7),
  //         Center(
  //           child: Text(
  //             (dataKatalog!.hSurvei.isKlasik) ? 'Form Klasik' : "Form Kartu",
  //             style: Theme.of(context).textTheme.displayMedium!.copyWith(
  //                 fontSize: 14,
  //                 color: Colors.black,
  //                 letterSpacing: 1.5,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 14),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               KotakLogoKeterangan(
  //                 icons: Icons.monetization_on_rounded,
  //                 text: CurrencyFormat.convertToIdr(
  //                     dataKatalog!.hSurvei.insentif, 2),
  //               ),
  //               Column(
  //                 children: [
  //                   Container(
  //                     width: 56,
  //                     height: 56,
  //                     decoration: BoxDecoration(
  //                       color: Colors.blue.shade400,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: Icon(
  //                       //Icons.monetization_on_rounded,
  //                       Icons.person_outline_rounded,
  //                       color: Colors.white,
  //                       size: 44,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Container(
  //                     width: 120,
  //                     child: Text(
  //                       dataKatalog!.user.email,
  //                       textAlign: TextAlign.center,
  //                       style:
  //                           Theme.of(context).textTheme.displayMedium!.copyWith(
  //                                 fontSize: 16,
  //                                 color: Colors.black.withOpacity(0.65),
  //                               ),
  //                       maxLines: 2,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               KotakLogoKeterangan(
  //                 icons: Icons.timelapse_rounded,
  //                 text: "${dataKatalog!.hSurvei.durasi} menit",
  //               )
  //             ],
  //           ),
  //         ),

  //         const SizedBox(height: 16),
  //         Align(
  //           alignment: Alignment.centerLeft,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
  //             decoration: BoxDecoration(
  //               color: Colors.blueAccent.shade400,
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: Text(
  //               "Deskripsi",
  //               style: Theme.of(context).textTheme.displayMedium!.copyWith(
  //                     fontSize: 18,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     letterSpacing: 1.25,
  //                   ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         Container(
  //           height: 190,
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //               color: Colors.grey.shade100,
  //               borderRadius: BorderRadius.circular(16),
  //               border: Border.all(
  //                 width: 3,
  //                 color: Colors.blue,
  //               )),
  //           child: SingleChildScrollView(
  //             child: Text(
  //               dataKatalog!.hSurvei.deskripsi,
  //               style: Theme.of(context).textTheme.displayMedium!.copyWith(
  //                     fontSize: 15,
  //                     color: Colors.black,
  //                     letterSpacing: 1,
  //                   ),
  //               textAlign: TextAlign.justify,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Container(
  //           height: 50,
  //           margin: const EdgeInsets.symmetric(horizontal: 26),
  //           child: ElevatedButton(
  //             onPressed: () async {
  //               kerjaSurvei();
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.greenAccent.shade400,
  //             ),
  //             child: Text(
  //               "Isi Survei",
  //               style: Theme.of(context).textTheme.displayMedium!.copyWith(
  //                     fontSize: 24,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     letterSpacing: 1.25,
  //                   ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  // }