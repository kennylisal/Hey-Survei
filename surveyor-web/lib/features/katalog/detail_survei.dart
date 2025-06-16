import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/app/routing/route_constant.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/katalog/katalog_controller.dart';
import 'package:hei_survei/features/publish_survei/model/survei.dart';
import 'package:hei_survei/features/publish_survei/survei_controller.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:hei_survei/utils/kriptografi.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:hei_survei/utils/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailSurvei extends ConsumerStatefulWidget {
  DetailSurvei({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailSurveiState();
}

class _DetailSurveiState extends ConsumerState<DetailSurvei> {
  SurveiX? surveiTemp;
  late String idSurvei;
  bool punyaSendiri = true;
  bool sudahPunya = true;
  bool isTambahLoading = false;

  Future<bool> cekKeranjang() async {
    final idUser = SharedPrefs.getString(prefUserId) ?? "";
    bool hasil = true;
    if (idUser != "") {
      final keranjangRef = FirebaseFirestore.instance
          .collection('cart')
          .where('idUser', isEqualTo: idUser)
          .where('idSurvei', isEqualTo: idSurvei);
      await keranjangRef.get().then((value) {
        if (value.docs.isEmpty) {
          hasil = false;
        }
      });
    }
    return hasil;
  }

  @override
  void initState() {
    Future(() async {
      idSurvei = ref.read(dataUtamaProvider.notifier).getIdSurvei();
      print("ini id Survei target => $idSurvei");
      surveiTemp = await SurveiController().getSurveiData(idSurvei);

      final idUser = SharedPrefs.getString(prefUserId) ?? "";
      if (surveiTemp!.headerSurvei.idPemilik != idUser) {
        punyaSendiri = false;
      }
      sudahPunya = await cekKeranjang();

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String temp =
    //     "Greek myths are amoral for our current standarts. Heroes are savage and cruel, many times criminals. Gods are like kids and make their will no matter what. Sometimes they are good, noble, sometimes... well not. The stories don't try to say it is ok, neither try to make the reader feel disgust. Do not reward or punish the same things we will want to reward or punish nowadays.";
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 15),
          child: Row(
            children: [
              IconButton.filled(
                  onPressed: () {
                    ref.read(indexUtamaProvider.notifier).update((state) => 2);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              const SizedBox(width: 6),
              Text(
                "Kembali",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
        (surveiTemp != null)
            ? TampilanDetail(
                constraints: widget.constraints,
                dataSurvei: surveiTemp!,
                punyaSendiri: punyaSendiri,
                sudahPunya: sudahPunya,
                onPressed: () async {
                  if (!isTambahLoading) {
                    setState(() {
                      isTambahLoading = true;
                    });
                    bool hasil = await KatalogController().masukkanCart(
                        surveiTemp!.headerSurvei.id_survei, context);
                    if (hasil == true) {
                      sudahPunya = true;
                      int temp = ref.read(jumlahKeranjangProvider);
                      ref
                          .read(jumlahKeranjangProvider.notifier)
                          .update((state) => temp + 1);
                    }
                    setState(() {
                      isTambahLoading = false;
                    });
                  }
                },
                isLoadingTambah: isTambahLoading,
              )
            : LoadingBiasa(
                text: "Memuat Data Survei",
                pakaiKembali: false,
              )
      ],
    );
  }
}

class TampilanDetail extends StatelessWidget {
  TampilanDetail({
    super.key,
    required this.constraints,
    required this.dataSurvei,
    required this.punyaSendiri,
    required this.sudahPunya,
    required this.onPressed,
    required this.isLoadingTambah,
  });
  BoxConstraints constraints;
  SurveiX dataSurvei;
  bool punyaSendiri;
  bool sudahPunya;
  Function() onPressed;
  bool isLoadingTambah;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 45),
      padding: const EdgeInsets.only(left: 45, right: 75),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: constraints.maxWidth * 0.42,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataSurvei.headerSurvei.judul,
                  // "Judul survei Loremp Ipsum yang akan tampil disini saya berharapp akan tampil dengan baik dan rapi 2023",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  JumlahPartisipanDetail(
                    jumlahPartisipan: dataSurvei.headerSurvei.jumlahPartisipan,
                    batasPartisipan: dataSurvei.headerSurvei.batasPartisipan,
                  ),
                  const SizedBox(width: 30),
                  PerkiraanWaktu(durasi: 20)
                ]),
                const SizedBox(height: 30),
                Text(
                  CurrencyFormat.convertToIdr(
                      dataSurvei.detailSurvei.hargaJual, 2),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 36,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Text(
                  "Detail Survei",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.grey,
                  height: 20,
                  thickness: 2,
                ),
                RichText(
                    text: TextSpan(
                        text: "Tipe Form : ",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black),
                        children: [
                      TextSpan(
                        text: (dataSurvei.headerSurvei.isKlasik)
                            ? "Form Klasik"
                            : "Form Kartu",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 16, color: Colors.black),
                      )
                    ])),
                const SizedBox(height: 16),
                Text(
                  "Deskripsi : ",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  dataSurvei.headerSurvei.deskripsi,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 25),
                Text(
                  "Pembatasan Demografi",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                RichText(
                    text: TextSpan(
                        text: "Minimal Umur : ",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black),
                        children: [
                      TextSpan(
                        text: (dataSurvei.detailSurvei.demografiUsia == -1)
                            ? "Tidak Ada"
                            : "${dataSurvei.detailSurvei.demografiUsia} Tahun",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 18, color: Colors.black),
                      )
                    ])),
                const SizedBox(height: 16),
                RichText(
                    text: TextSpan(
                        text: "Lokasi Kota : ",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black),
                        children: [
                      TextSpan(
                        text: (dataSurvei.detailSurvei.demografiLokasi.isEmpty)
                            ? "Tidak Ada"
                            : dataSurvei.detailSurvei.demografiLokasi
                                .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 18, color: Colors.black),
                      )
                    ])),
                const SizedBox(height: 16),
                RichText(
                    text: TextSpan(
                        text: "Interest Pengguna : ",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black),
                        children: [
                      TextSpan(
                        text:
                            (dataSurvei.detailSurvei.demografiInterest.isEmpty)
                                ? "Tidak Ada"
                                : dataSurvei.detailSurvei.demografiInterest
                                    .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 18, color: Colors.black),
                      )
                    ])),
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(12),
            width: constraints.maxWidth * 0.24,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Pilihan Aksi",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    height: 50,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ElevatedButton(
                        onPressed: () {
                          print(dataSurvei.detailSurvei.idForm);
                          if (dataSurvei.headerSurvei.isKlasik) {
                            context.pushNamed(RouteConstant.previewKlasik,
                                pathParameters: {
                                  // 'idForm': '1aa3afa9',
                                  // 'idForm': dataSurvei.detailSurvei.idForm,
                                  'idForm': Kriptografi.encrypt(
                                      dataSurvei.detailSurvei.idForm),
                                });
                          } else {
                            context.pushNamed(RouteConstant.previewKartu,
                                pathParameters: {
                                  // 'idForm': dataSurvei.detailSurvei.idForm,
                                  'idForm': Kriptografi.encrypt(
                                      dataSurvei.detailSurvei.idForm),
                                  // 'idForm': '057ea35c',
                                });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Preview Form",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 18.25,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ))),
                if (!punyaSendiri && !sudahPunya)
                  Column(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: ElevatedButton(
                            onPressed: onPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: (isLoadingTambah)
                                  ? Container(
                                      height: 32,
                                      width: 32,
                                      child: FittedBox(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "Masukkan Keranjang",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                            color: Colors.white,
                                            fontSize: 18.25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                            ),
                          )),
                      Divider(color: Colors.grey.shade800, thickness: 5),
                      // Container(
                      //     width: double.infinity,
                      //     height: 50,
                      //     margin: const EdgeInsets.symmetric(
                      //         horizontal: 12, vertical: 8),
                      //     child: ElevatedButton(
                      //         onPressed: () {},
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: Colors.blue.shade900,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceEvenly,
                      //           children: [
                      //             Text(
                      //               "Beli Survei",
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .displayLarge!
                      //                   .copyWith(
                      //                     color: Colors.white,
                      //                     fontSize: 20,
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //             ),
                      //           ],
                      //         ))),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GagalMemuatData extends StatelessWidget {
  const GagalMemuatData({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Image.asset(
          'assets/gagal-memuat.png',
          scale: 1,
        ),
      ),
    ));
  }
}

class PerkiraanWaktu extends StatelessWidget {
  PerkiraanWaktu({super.key, required this.durasi});
  int durasi;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.timelapse,
          size: 30,
          color: Colors.blue,
        ),
        SizedBox(width: 4),
        Text(
          "${durasi} menit",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 18,
                color: Colors.black,
              ),
        ),
      ],
    );
  }
}

class JumlahPartisipanDetail extends StatelessWidget {
  JumlahPartisipanDetail({
    super.key,
    required this.jumlahPartisipan,
    required this.batasPartisipan,
  });
  int jumlahPartisipan;
  int batasPartisipan;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.person,
          size: 34,
          color: Colors.green,
        ),
        const SizedBox(width: 4),
        RichText(
            text: TextSpan(
                text: jumlahPartisipan.toString(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
                children: [
              TextSpan(text: ' / '),
              TextSpan(text: batasPartisipan.toString())
            ]))
      ],
    );
  }
}

// Container(
//           width: double.infinity,
//           margin: const EdgeInsets.only(top: 45),
//           padding: const EdgeInsets.only(left: 45, right: 75),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 width: widget.constraints.maxWidth * 0.42,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Judul survei Loremp Ipsum yang akan tampil disini saya berharapp akan tampil dengan baik dan rapi 2023",
//                       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           fontSize: 23,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(children: [
//                       JumlahPartisipanDetail(
//                           jumlahPartisipan: 10, batasPartisipan: 30),
//                       const SizedBox(width: 30),
//                       PerkiraanWaktu(durasi: 20)
//                     ]),
//                     const SizedBox(height: 30),
//                     Text(
//                       "Rp 300.000",
//                       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           fontSize: 32,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 50),
//                     Text(
//                       "Detail Survei",
//                       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           fontSize: 19,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Divider(
//                       color: Colors.grey,
//                       height: 20,
//                       thickness: 2,
//                     ),
//                     RichText(
//                         text: TextSpan(
//                             text: "Tipe Form : ",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displaySmall!
//                                 .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     color: Colors.black),
//                             children: [
//                           TextSpan(
//                             text: "Form Klasik",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displaySmall!
//                                 .copyWith(fontSize: 16, color: Colors.black),
//                           )
//                         ])),
//                     const SizedBox(height: 16),
//                     Text(
//                       "Deskripsi : ",
//                       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           fontSize: 18,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       temp,
//                       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                             fontSize: 16,
//                             color: Colors.black,
//                           ),
//                     ),
//                   ],
//                 ),
//               ),
//               Spacer(),
//               Container(
//                 margin: const EdgeInsets.only(top: 20),
//                 padding: const EdgeInsets.all(12),
//                 width: widget.constraints.maxWidth * 0.24,
//                 decoration: BoxDecoration(
//                   border: Border.all(width: 2, color: Colors.black),
//                   borderRadius: BorderRadius.circular(14),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Pilihan Aksi",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleLarge!
//                           .copyWith(fontSize: 20, color: Colors.black),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                         width: double.infinity,
//                         height: 50,
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         child: ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.amber.shade700,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Text(
//                                   "Preview Form",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayLarge!
//                                       .copyWith(
//                                         color: Colors.white,
//                                         fontSize: 19,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                               ],
//                             ))),
//                     Container(
//                         width: double.infinity,
//                         height: 50,
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         child: ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.amber.shade700,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Text(
//                                   "Beli Form",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayLarge!
//                                       .copyWith(
//                                         color: Colors.white,
//                                         fontSize: 19,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                               ],
//                             ))),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );