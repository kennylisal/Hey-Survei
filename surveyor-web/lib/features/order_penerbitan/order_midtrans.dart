// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/order_penerbitan/models/data_transaksi.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:hei_survei/utils/loading_biasa.dart';
import 'package:hei_survei/utils/shared_pref.dart';

class OrderMidTrans extends StatefulWidget {
  OrderMidTrans({
    super.key,
    required this.constraints,
  });
  BoxConstraints constraints;

  @override
  State<OrderMidTrans> createState() => _OrderMidTransState();
}

class _OrderMidTransState extends State<OrderMidTrans> {
  bool adaPesanan = false;
  bool selesaiLoading = false;
  DataTransaksi dataTransaksi = DataTransaksi(
    nomorVA: "",
    namaBank: "",
    totalPembayaran: -1,
    judulSurvei: "",
  );
  @override
  void initState() {
    super.initState();
    listenFromDB();
  }

  void listenFromDB() {
    try {
      final userId = SharedPrefs.getString(prefUserId) ?? "";
      print(userId);
      if (userId != "") {
        DatabaseReference dbRef =
            FirebaseDatabase.instance.ref('tagihan/$userId');
        dbRef.onValue.listen((event) {
          if (event.snapshot.exists) {
            adaPesanan = true;
            final data = event.snapshot.value as Map<String, dynamic>;
            dataTransaksi = DataTransaksi(
              nomorVA: data['nomorVA'],
              namaBank: data['namaBank'],
              totalPembayaran: data['totalPembayaran'],
              judulSurvei: data['judul'],
            );
            print(data);
            setState(() {
              selesaiLoading = true;
            });
            // print(adaPesanan);
          } else {
            adaPesanan = false;
            print("Tidak ada data");
            setState(() {
              selesaiLoading = true;
            });
          }
        });
      }
    } catch (e) {
      adaPesanan = false;
      print("Tidak ada data");
      setState(() {
        selesaiLoading = true;
      });
    }
    print("ini pilihan cabang -> $adaPesanan");
  }

  Widget contentGenerator() {
    // return TampilanPembayaran();
    if (!selesaiLoading) {
      return LoadingBiasa(
        text: "Memuat Data",
        pakaiKembali: false,
      );
    } else {
      if (adaPesanan) {
        return TampilanPembayaran(dataTransaksi: dataTransaksi);
      } else {
        return const TidakAdaTransaksi();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "Pembayaran Survei",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
        ),
        const SizedBox(height: 14),
        // ElevatedButton(
        //     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        //     onPressed: () async {
        //       // Clipboard.setData(new ClipboardData(text: "ayay got ya"));
        //       // ScaffoldMessenger.of(context).showSnackBar(
        //       //     SnackBar(content: Text("Nomor VA telah terjiplak")));
        //       DatabaseReference dbRef =
        //           FirebaseDatabase.instance.ref('tagihan/70fc9a56');

        //       await dbRef.set({
        //         "judul": "Survei pertama lewat aplikasi",
        //         "totalPembayaran": 200000,
        //         "namaBank": "BNI",
        //         "nomorVA": "7845784034790"
        //       });
        //     },
        //     child: Text("Jiplak nomor VA",
        //         style: Theme.of(context).textTheme.displayLarge!.copyWith(
        //               color: Colors.white,
        //               fontSize: 18,
        //             ))),
        contentGenerator(),
      ],
    );
  }
}

class TampilanPembayaran extends StatelessWidget {
  TampilanPembayaran({
    super.key,
    required this.dataTransaksi,
  });
  DataTransaksi dataTransaksi;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 850,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(12)),
            child: Text(
              "Menunggu Pembayaran",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade900, thickness: 2),
          ContainerText(
            textJudul: "Judul Survei",
            // text: "Survei pengamatan hasil pemilu",
            text: dataTransaksi.judulSurvei,
            width: 450,
            pakaiUkuran: false,
          ),
          const SizedBox(height: 10),
          ContainerText(
            textJudul: "Harga",
            text: CurrencyFormat.convertToIdr(dataTransaksi.totalPembayaran, 2),
            // text: "Rp 200.000",
            width: 250,
            pakaiUkuran: true,
          ),
          const SizedBox(height: 10),
          ContainerText(
            textJudul: "Bank",
            // text: "BNI",
            text: dataTransaksi.namaBank,
            width: 250,
            pakaiUkuran: true,
          ),
          const SizedBox(height: 10),
          ContainerText(
            textJudul: "Nomor Virtual Account",
            text: dataTransaksi.nomorVA,
            // text: "234875023752057203948",
            width: 375,
            pakaiUkuran: false,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    Clipboard.setData(
                        ClipboardData(text: dataTransaksi.nomorVA));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Nomor VA telah terjiplak")));
                  },
                  child: Text("Jiplak nomor VA",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ))),
              ElevatedButton.icon(
                  onPressed: () {
                    final userId = SharedPrefs.getString(prefUserId) ?? "";
                    print(userId);
                    if (userId != "") {
                      FirebaseDatabase.instance
                          .ref('tagihan/$userId')
                          .remove()
                          .then((value) {
                        print("berhasil");
                      }).onError((error, stackTrace) {
                        print(error);
                      });
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  label: Text("Batalkan",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 19,
                          )))
            ],
          )
        ],
      ),
    );
  }
}

class ContainerText extends StatelessWidget {
  ContainerText({
    super.key,
    required this.textJudul,
    required this.text,
    required this.width,
    required this.pakaiUkuran,
  });
  String textJudul;
  String text;
  double width;
  bool pakaiUkuran;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 250,
          padding: const EdgeInsets.only(left: 11),
          child: SelectableText(
            textJudul,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          width: (pakaiUkuran) ? width : null,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                ),
          ),
        )
      ],
    );
  }
}

class TidakAdaTransaksi extends StatelessWidget {
  const TidakAdaTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Center(
          child: Image.asset(
            'assets/no-trans-midtrans.png',
            height: 450,
          ),
        ),
        Text(
          "Belum Ada Tagihan",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: 38, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
