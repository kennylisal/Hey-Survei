import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/transaksi/model/oder_data.dart';
import 'package:hei_survei/features/transaksi/model/sejarah_order.dart';
import 'package:hei_survei/features/transaksi/transaksi_controller.dart';
import 'package:hei_survei/features/transaksi/widget_order.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:hei_survei/utils/shared_pref.dart';
import 'package:intl/intl.dart';

// class HalamanOrderBaru extends StatefulWidget {
//   HalamanOrderBaru({
//     super.key,
//     required this.constraints,
//   });
//   BoxConstraints constraints;
//   @override
//   State<HalamanOrderBaru> createState() => _HalamanOrderBaruState();
// }

// class _HalamanOrderBaruState extends State<HalamanOrderBaru> {
//   Order? orderAktif;
//   bool selesaiLoading = false;
//   bool adaPesanan = false;
//   List<OrderHeader> sejarah = [];
//   List<Widget> listSejarah = [];
//   Widget kontenUtama = const TidakAdaOrder();
//   Widget kontenPesananSejarah = SizedBox();
//   //data order dan VA
//   String idOrder = "";
//   String nomorVA = "";
//   String nomorInvoice = "";
//   bool cekPesananAktif = true;
//   String idOrderSejarah = "";
//   @override
//   void initState() {
//     listenFromDB();
//     initDataSejarah();
//     super.initState();
//     // listenFromDBV1();
//   }

//   listenFromDB() async {
//     try {
//       final userId = SharedPrefs.getString(prefUserId) ?? "";
//       if (userId != "") {
//         DatabaseReference dbRef =
//             FirebaseDatabase.instance.ref('tagihanPembelian/$userId');
//         dbRef.onValue.listen((event) async {
//           if (event.snapshot.exists) {
//             print("ada data");
//             adaPesanan = true;
//             final data = event.snapshot.value as Map<String, dynamic>;
//             nomorVA = data["nomorVA"];
//             idOrder = data["idOrder"];
//             nomorInvoice = data['invoice'];

//             await initDataOrderAktif(idOrder);
//             setState(() {
//               adaPesanan = true;
//               selesaiLoading = true;
//             });
//           } else {
//             print("Tidak ada data");
//             setState(() {
//               orderAktif = null;
//               kontenUtama = const TidakAdaOrder();
//               adaPesanan = false;
//               selesaiLoading = true;
//             });
//           }
//         });
//       }
//     } catch (e) {
//       print("Tidak ada data");
//       orderAktif = null;
//       kontenUtama = const TidakAdaOrder();
//       setState(() {
//         selesaiLoading = true;
//         adaPesanan = false;
//       });
//       initDataSejarah();
//     }
//   }

//   initDataOrderAktif(String idOrder) async {
//     // orderAktif = await TransaksiController().getUserOrder();
//     orderAktif = await TransaksiController().getOrderPilihan(idOrder);
//     print("ini order aktif $orderAktif");
//     if (orderAktif != null) {
//       kontenUtama = KotakKontenOrder(
//         order: orderAktif!,
//         nomorVA: nomorVA,
//         invoice: nomorInvoice,
//       );
//     }
//   }

//   initDataSejarah() async {
//     sejarah = await TransaksiController().getSejarahOrder();
//     // print(sejarah);
//     if (sejarah.isNotEmpty) {
//       listSejarah = List.generate(
//           sejarah.length,
//           (index) => KotakSejarah(
//                 hargaTotal: sejarah[index].hargaTotal,
//                 invoice: sejarah[index].invoice,
//                 tanggal: DateFormat('dd-MMMM-yyyy').format(
//                   sejarah[index].tangal,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     idOrderSejarah = sejarah[index].idOrder;
//                     kontenPesananSejarah =
//                         KotakKontenSejarah(header: sejarah[index]);
//                     cekPesananAktif = false;
//                     print("ganti konten dong");
//                   });
//                 },
//               ));
//     }
//     setState(() {});
//   }

//   tampilkanPesananAktif() {
//     // if (!adaPesanan) {
//     //   kontenUtama = const TidakAdaOrder();
//     // } else {
//     //   kontenUtama = KotakKontenOrder(
//     //     order: orderAktif!,
//     //     nomorVA: nomorVA,
//     //     invoice: nomorInvoice,
//     //   );
//     // }
//     setState(() {
//       cekPesananAktif = true;
//     });
//   }

//   lebarKotakUtama() {
//     if (widget.constraints.maxWidth > 1400) {
//       return widget.constraints.maxWidth * 0.5;
//     } else if (widget.constraints.maxWidth <= 1400 &&
//         widget.constraints.maxWidth > 1260) {
//       return widget.constraints.maxWidth * 0.445;
//     } else {
//       return widget.constraints.maxWidth * 0.5;
//     }
//   }

//   isTampilanSmall() {
//     return (widget.constraints.maxWidth < 1400);
//   }

//   Widget kontenOrderGenerator() {
//     if (cekPesananAktif) {
//       return kontenUtama;
//     } else {
//       return kontenPesananSejarah;
//     }
//   }

//   contentGenerator(double marginKiri) {
//     if (!selesaiLoading) {
//       return LoadingBiasa(
//         text: "Memuat Data Keranjang",
//         pakaiKembali: false,
//       );
//     } else {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: lebarKotakUtama(),
//             child: kontenOrderGenerator(),
//             // child: kontenUtama,
//           ),
//           if (widget.constraints.maxWidth > 1260)
//             KotakSamping(
//               marginKiri: marginKiri,
//               onPressed: () => tampilkanPesananAktif(),
//               listSejarah: listSejarah,
//             )
//         ],
//       );
//     }
//   }

//   DecorationImage gambarKlasik = const DecorationImage(
//     image: AssetImage('assets/logo-klasik.png'),
//     fit: BoxFit.fill,
//   );

//   DecorationImage gambarKartu = const DecorationImage(
//     image: AssetImage('assets/logo-kartu.png'),
//     fit: BoxFit.fill,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 14),
//           Text(
//             "Halaman Pesanan",
//             style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                 fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
//           ),
//           const SizedBox(height: 12),
//           Container(
//               // margin: EdgeInsets.symmetric(vertical: 30),
//               width: double.infinity,
//               child: contentGenerator(14)),
//           const SizedBox(height: 20),
//           if (widget.constraints.maxWidth < 1260)
//             KotakSamping(
//               marginKiri: 14,
//               onPressed: () => tampilkanPesananAktif(),
//               listSejarah: listSejarah,
//             )
//         ],
//       ),
//     );
//   }
// }

class HalamanOrderBaru extends ConsumerStatefulWidget {
  HalamanOrderBaru({super.key, required this.constraints});
  BoxConstraints constraints;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HalamanOrderBaruState();
}

class _HalamanOrderBaruState extends ConsumerState<HalamanOrderBaru> {
  Order? orderAktif;
  bool selesaiLoading = false;
  bool adaPesanan = false;
  List<OrderHeader> sejarah = [];
  List<Widget> listSejarah = [];
  Widget kontenUtama = const TidakAdaOrder();
  Widget kontenPesananSejarah = SizedBox();
  //data order dan VA
  String idOrder = "";
  String nomorVA = "";
  String nomorInvoice = "";
  bool cekPesananAktif = true;
  String idOrderSejarah = "";
  @override
  void initState() {
    listenFromDB();
    initDataSejarah();
    super.initState();
    // listenFromDBV1();
  }

  eksekusiCatch() async {}

  listenFromDB() async {
    try {
      final userId = SharedPrefs.getString(prefUserId) ?? "";
      if (userId != "") {
        DatabaseReference dbRef =
            FirebaseDatabase.instance.ref('tagihanPembelian/$userId');
        dbRef.onValue.listen((event) async {
          if (event.snapshot.exists) {
            print("ada data");
            adaPesanan = true;
            final data = event.snapshot.value as Map<String, dynamic>;
            nomorVA = data["nomorVA"];
            idOrder = data["idOrder"];
            nomorInvoice = data['invoice'];
            print(data);

            await initDataOrderAktif(idOrder);
            setState(() {
              adaPesanan = true;
              selesaiLoading = true;
            });
          } else {
            print("Tidak ada data => masuk else");
            ref.read(adaOrderProvider.notifier).update((state) => false);
            initDataSejarah();
            setState(() {
              orderAktif = null;
              kontenUtama = const TidakAdaOrder();
              adaPesanan = false;
              selesaiLoading = true;
            });
          }
        });
      }
    } catch (e) {
      print("Tidak ada data => cat error");
      ref.read(adaOrderProvider.notifier).update((state) => false);
      print("false-kan ada order");
      orderAktif = null;
      kontenUtama = const TidakAdaOrder();
      setState(() {
        selesaiLoading = true;
        adaPesanan = false;
      });
      initDataSejarah();
    }
  }

  initDataOrderAktif(String idOrder) async {
    // orderAktif = await TransaksiController().getUserOrder();
    orderAktif = await TransaksiController().getOrderPilihan(idOrder);
    print("ini order aktif $orderAktif");
    if (orderAktif != null) {
      kontenUtama = KotakKontenOrder(
        order: orderAktif!,
        nomorVA: nomorVA,
        invoice: nomorInvoice,
      );
    }
  }

  initDataSejarah() async {
    sejarah = await TransaksiController().getSejarahOrder();
    // print(sejarah);
    if (sejarah.isNotEmpty) {
      listSejarah = List.generate(
          sejarah.length,
          (index) => KotakSejarah(
                hargaTotal: sejarah[index].hargaTotal,
                invoice: sejarah[index].invoice,
                tanggal: DateFormat('dd-MMMM-yyyy').format(
                  sejarah[index].tangal,
                ),
                onPressed: () {
                  setState(() {
                    idOrderSejarah = sejarah[index].idOrder;
                    kontenPesananSejarah =
                        KotakKontenSejarah(header: sejarah[index]);
                    cekPesananAktif = false;
                    print("ganti konten dong");
                  });
                },
              ));
    }
    setState(() {});
  }

  tampilkanPesananAktif() {
    // if (!adaPesanan) {
    //   kontenUtama = const TidakAdaOrder();
    // } else {
    //   kontenUtama = KotakKontenOrder(
    //     order: orderAktif!,
    //     nomorVA: nomorVA,
    //     invoice: nomorInvoice,
    //   );
    // }
    setState(() {
      cekPesananAktif = true;
    });
  }

  lebarKotakUtama() {
    if (widget.constraints.maxWidth > 1400) {
      return widget.constraints.maxWidth * 0.5;
    } else if (widget.constraints.maxWidth <= 1400 &&
        widget.constraints.maxWidth > 1260) {
      return widget.constraints.maxWidth * 0.445;
    } else {
      return widget.constraints.maxWidth * 0.5;
    }
  }

  isTampilanSmall() {
    return (widget.constraints.maxWidth < 1400);
  }

  Widget kontenOrderGenerator() {
    if (cekPesananAktif) {
      return kontenUtama;
    } else {
      return kontenPesananSejarah;
    }
  }

  contentGenerator(double marginKiri) {
    if (!selesaiLoading) {
      return LoadingBiasa(
        text: "Memuat Data Keranjang",
        pakaiKembali: false,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: lebarKotakUtama(),
            child: kontenOrderGenerator(),
            // child: kontenUtama,
          ),
          if (widget.constraints.maxWidth > 1260)
            KotakSamping(
              marginKiri: marginKiri,
              onPressed: () => tampilkanPesananAktif(),
              listSejarah: listSejarah,
            )
        ],
      );
    }
  }

  DecorationImage gambarKlasik = const DecorationImage(
    image: AssetImage('assets/logo-klasik.png'),
    fit: BoxFit.fill,
  );

  DecorationImage gambarKartu = const DecorationImage(
    image: AssetImage('assets/logo-kartu.png'),
    fit: BoxFit.fill,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Text(
            "Halaman Pesanan",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Container(
              // margin: EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              child: contentGenerator(14)),
          const SizedBox(height: 20),
          if (widget.constraints.maxWidth < 1260)
            KotakSamping(
              marginKiri: 14,
              onPressed: () => tampilkanPesananAktif(),
              listSejarah: listSejarah,
            )
        ],
      ),
    );
  }
}
