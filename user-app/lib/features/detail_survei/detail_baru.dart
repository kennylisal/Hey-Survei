// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:survei_aplikasi/features/app/app.dart';
import 'package:survei_aplikasi/features/app/router/router_constant.dart';
import 'package:survei_aplikasi/features/detail_survei/detail_controller.dart';
import 'package:survei_aplikasi/features/detail_survei/widgets/kotak_logo.dart';
import 'package:survei_aplikasi/utils/currency_formatter.dart';
import 'package:survei_aplikasi/utils/loading_biasa.dart';

class DetailSurveiX extends ConsumerStatefulWidget {
  const DetailSurveiX({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailSurveiState();
}

class _DetailSurveiState extends ConsumerState<DetailSurveiX> {
  DataDetailSurvei? dataKatalog;
  bool loadingDataSurvei = false;
  @override
  void initState() {
    super.initState();
    try {
      String temp = ref.read(idKatalogProvider);
      // String temp = "Lmao";
      Future(() async {
        log("ini $temp yang dicari");
        dataKatalog = await DetailController().getDetailSurvei(temp);
        setState(() {});
      });
    } catch (e) {
      log(e.toString());
      context.goNamed(RouteConstant.auth);
    }
  }

  Widget contentGenerator() {
    if (loadingDataSurvei) {
      return Center(child: LoadingBiasa(textLoading: "Memuat Data Survei"));
    } else if (dataKatalog == null) {
      return Center(child: LoadingBiasa());
    } else {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        children: [
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
              maxLines: 2,
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
          const SizedBox(height: 20),
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
                setState(() {
                  loadingDataSurvei = true;
                });
                String hasil = "xxx";
                hasil = await DetailController()
                    .cekIjinPengisian(dataKatalog!.hSurvei.id_survei);
                print("Hasil -> $hasil");
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
                    // print("masuk form kartu");
                    context.goNamed(RouteConstant.formKartu, pathParameters: {
                      'idForm': hasil,
                      'idSurvei': dataKatalog!.hSurvei.id_survei,
                    });
                  }
                } else {
                  setState(() {
                    loadingDataSurvei = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Survei Sudah Tidak Tersedia")));
                }
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
              context.pop();
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              ))
        ],
      ),
      body: contentGenerator(),
    );
  }
}
