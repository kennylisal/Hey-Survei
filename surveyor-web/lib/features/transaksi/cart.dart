import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hei_survei/app/app.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/transaksi/model/order_survei.dart';
import 'package:hei_survei/features/transaksi/transaksi_controller.dart';
import 'package:hei_survei/features/transaksi/widgets/kartu_cart.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:hei_survei/utils/loading_biasa.dart';

class HalamanCart extends ConsumerStatefulWidget {
  HalamanCart({super.key, required this.constraints});
  BoxConstraints constraints;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HalamanCartState();
}

class _HalamanCartState extends ConsumerState<HalamanCart> {
  bool isCentang = false;
  bool isKecil() => widget.constraints.maxWidth > 1280;
  List<SurveiData>? tempList;
  List<String>? listIdCart;
  List<bool> listBool = [];
  int hargaTotal = 0;
  //data untuk buat order
  List<String> listSurvei = [];
  List<String> listCart = [];
  String emailUser = "";
  //
  bool loadingTombol = false;
  @override
  void initState() {
    Future(() {
      emailUser = ref.read(authProvider).user.email;
      setState(() {});
    });
    initData();
    super.initState();
  }

  initData() async {
    DataCart dataCart = await TransaksiController().getUserCart();
    // if(dataCart == null) print("datacart null brah")
    print("data cart -> $dataCart");
    tempList = dataCart.hSurvei;
    listIdCart = dataCart.idCart;
    listBool = List.generate(tempList!.length, (index) => false);
    setState(() {});
  }

  buatOrderKeranjang() async {
    try {
      if (!loadingTombol) {
        setState(() {
          loadingTombol = true;
        });

        bool logic = await buatOrder();

        if (logic) {
          int jumlah = await TransaksiController().getJumlahKeranjang();
          ref.read(jumlahKeranjangProvider.notifier).update((state) => jumlah);
          ref.read(adaOrderProvider.notifier).update((state) => true);
          setState(() {
            loadingTombol = false;
          });

          ref.read(indexUtamaProvider.notifier).update((state) => 8);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Gagal Proses Pesanan")));
        }
      }
      setState(() {
        loadingTombol = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        loadingTombol = false;
      });
    }
  }

  updateHarga() {
    hargaTotal = 0;
    listSurvei = [];
    listCart = [];
    for (var i = 0; i < listBool.length; i++) {
      if (listBool[i]) {
        hargaTotal += tempList![i].harga;
        listSurvei.add(tempList![i].id_survei);
        listCart.add(listIdCart![i]);
      }
    }
  }

  hapusCart(String idCart) async {
    final hasil = await TransaksiController().hapusCart(idCart);
    if (hasil) {
      final index = listIdCart!.indexWhere((element) => element == idCart);
      tempList!.removeAt(index);
      listIdCart!.removeAt(index);
      resetTampilan();
      int temp = ref.read(jumlahKeranjangProvider);
      ref.read(jumlahKeranjangProvider.notifier).update((state) => temp - 1);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal Hapus Keranjang")));
    }
  }

  resetTampilan() {
    for (var i = 0; i < listBool.length; i++) {
      listBool[i] = false;
    }
    updateHarga();
    setState(() {});
  }

  Future<bool> buatOrder() async {
    if (hargaTotal == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Belum ada survei yang dipilih")));
      return false;
    } else {
      bool request = await TransaksiController().buatOrder(
        listSurvei: listSurvei,
        listCart: listCart,
        harga: hargaTotal,
        email: emailUser,
      );
      // bool request = true;
      if (request) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Pesanan berhasil dibuat")));
        return true;
      } else {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Pesanan gagal dibuat")));
        return false;
      }
    }
  }

  Widget cartGenerator() {
    //print(listBool.length);
    List<KotakCart> hasil = List.generate(
      tempList!.length,
      (index) => KotakCart(
        isCentang: listBool[index],
        onChanged: (value) {
          setState(() {
            listBool[index] = value!;
            // print("$index jadi $value");
            updateHarga();
          });
        },
        data: tempList![index],
        onTapHapus: () => hapusCart(listIdCart![index]),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HeaderCentang(
          width: panjangContainer(),
          isCentang: isCentang,
          onChanged: (value) {
            setState(() {
              isCentang = value!;
              for (var i = 0; i < listBool.length; i++) {
                listBool[i] = value;
              }
              updateHarga();
            });
          },
        ),
        if (tempList!.isEmpty)
          const TidakAdaCart()
        else if (tempList!.isNotEmpty)
          ...hasil
      ],
    );
  }

  double panjangContainer() {
    return (isKecil() ? 660 : 400);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Halaman Keranjang",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  width: panjangContainer(),
                  child: (tempList == null)
                      ? LoadingBiasa(
                          text: "Memuat Data Keranjang",
                          pakaiKembali: false,
                        )
                      : cartGenerator()),
              if (widget.constraints.maxWidth > 1025)
                KotakSamping(
                  isLoading: loadingTombol,
                  marginKiri: (widget.constraints.maxWidth < 1430) ? 0 : 140,
                  harga: hargaTotal,
                  onPressed: () async {
                    await buatOrderKeranjang();
                  },
                )
            ],
          ),
        ),
        if (widget.constraints.maxWidth < 1024)
          KotakSamping(
            isLoading: loadingTombol,
            marginKiri: (widget.constraints.maxWidth < 1430) ? 0 : 140,
            harga: hargaTotal,
            onPressed: () async {
              await buatOrderKeranjang();
            },
          )
      ],
    ));
  }
}
// KotakSamping(
//   isLoading: loadingTombol,
//   marginKiri: (widget.constraints.maxWidth < 1430) ? 0 : 140,
//   harga: hargaTotal,
//   onPressed: () async {
//     bool logic = await buatOrder();
//     if (logic) {
//       ref.read(indexUtamaProvider.notifier).update((state) => 8);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Gagal Proses Pesanan")));
//     }
//   },
// )

class KotakSamping extends StatelessWidget {
  KotakSamping({
    super.key,
    required this.marginKiri,
    required this.harga,
    required this.onPressed,
    required this.isLoading,
  });
  double marginKiri;
  int harga;
  Function() onPressed;
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: marginKiri),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // margin: EdgeInsets.only(left: marginKiri),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 2, color: Colors.black),
            ),
            width: 320,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(
                  "Total Harga Pesanan",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black),
                ),
                SizedBox(height: 12),
                Text(CurrencyFormat.convertToIdr(harga, 2),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: 250,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: (isLoading)
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          child: const FittedBox(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          "Buat Pesanan",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                        ))),
        ],
      ),
    );
  }
}

class HeaderCentang extends StatelessWidget {
  HeaderCentang({
    super.key,
    required this.width,
    required this.isCentang,
    required this.onChanged,
  });
  double width;
  bool isCentang;
  Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1.5),
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Center(
        child: Row(
          children: [
            Checkbox(
              side: const BorderSide(width: 2),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              checkColor: Colors.green,
              value: isCentang,
              onChanged: onChanged,
            ),
            const SizedBox(width: 6),
            Text(
              "Centang Semua",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
