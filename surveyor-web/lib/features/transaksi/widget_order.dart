import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/katalog/widgets/gambar_survei_kartu.dart';
import 'package:hei_survei/features/transaksi/model/oder_data.dart';
import 'package:hei_survei/features/transaksi/model/sejarah_order.dart';
import 'package:hei_survei/features/transaksi/model/transaksi.dart';
import 'package:hei_survei/features/transaksi/transaksi_controller.dart';
import 'package:hei_survei/utils/currency.dart';
import 'package:intl/intl.dart';

// class KotakKontenTrans extends StatelessWidget {
//   KotakKontenTrans({
//     super.key,
//     required this.transaksi,
//     required this.constraints,
//   });
//   Transaksi transaksi;
//   BoxConstraints constraints;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(20)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
//                 decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Text(
//                   "Pesanan Selesai",
//                   style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                         color: Colors.white,
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             CurrencyFormat.convertToIdr(100000, 2),
//             style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: Colors.black,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 20),
//           ContainerText(
//             textJudul: "Invoice",
//             text: transaksi.invoice,
//             width: 300,
//           ),
//           const SizedBox(height: 20),
//           ContainerText(
//             textJudul: "Tanggal Pemesanan",
//             text: DateFormat('dd-MMMM-yyyy').format(transaksi.tanggalTransaksi),
//             width: 250,
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.only(left: 16),
//             child: Text(
//               "Daftar Survei",
//               style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                     color: Colors.black,
//                     fontSize: 19,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ),
//           for (var e in transaksi.detail.listSurvei)
//             KotakSurveiPesanan(
//               surveiData: e,
//               constraints: constraints,
//             )
//         ],
//       ),
//     );
//   }
// }

class KotakKontenSejarah extends StatefulWidget {
  KotakKontenSejarah({
    super.key,
    required this.header,
  });
  OrderHeader header;
  @override
  State<KotakKontenSejarah> createState() => _KotakKontenSejarahState();
}

class _KotakKontenSejarahState extends State<KotakKontenSejarah> {
  Order? dataOrder;

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    try {
      dataOrder =
          await TransaksiController().getOrderPilihan(widget.header.idOrder);
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Widget generateListSurvei(BoxConstraints constraints) {
    if (dataOrder == null) {
      return const Center(
        child: SizedBox(
          width: 75,
          height: 75,
          child: FittedBox(
              child: CircularProgressIndicator(
            strokeWidth: 5,
            color: Colors.blue,
          )),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var e in dataOrder!.listSurvei)
            KotakSurveiPesanan(
              surveiData: e,
              isSmall: constraints.maxWidth < 700,
            )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            border: Border.all(width: 1.5),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "Pesanan Selesai",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.header.invoice,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                CurrencyFormat.convertToIdr(widget.header.hargaTotal, 2),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            ContainerText(
              textJudul: "Tanggal Pemesanan",
              text: DateFormat('dd-MMMM-yyyy').format(widget.header.tangal),
              width: 250,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Daftar Survei",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            generateListSurvei(constraints),
          ],
        ),
      );
    });
  }
}

//pesanan berlangsung
class KotakKontenOrder extends StatelessWidget {
  KotakKontenOrder({
    super.key,
    required this.order,
    required this.nomorVA,
    required this.invoice,
  });
  Order order;
  String nomorVA;
  String invoice;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            border: Border.all(width: 1.5),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "Pesanan Berlangsung",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (constraints.maxWidth > 700)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(text: nomorVA));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Nomor VA telah terjiplak")));
                      },
                      child: Text("Jiplak nomor VA",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ))),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                invoice,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                CurrencyFormat.convertToIdr(order.getTotalharga(), 2),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            ContainerText(
              textJudul: "Nomor Virtual Account",
              // text: order.idOrder,
              text: nomorVA,
              width: 250,
            ),
            const SizedBox(height: 4),
            if (constraints.maxWidth < 700)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    Clipboard.setData(ClipboardData(text: nomorVA));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Nomor VA telah terjiplak")));
                  },
                  child: Text("Jiplak nomor VA",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ))),
            const SizedBox(height: 18),
            ContainerText(
              textJudul: "Bank",
              text: "BNI",
              width: 250,
            ),
            const SizedBox(height: 20),
            ContainerText(
              textJudul: "Tanggal Pemesanan",
              text: DateFormat('dd-MMMM-yyyy').format(order.tanggal),
              width: 250,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Daftar Survei",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            for (var e in order.listSurvei)
              KotakSurveiPesanan(
                surveiData: e,
                isSmall: constraints.maxWidth < 700,
              )
          ],
        ),
      );
    });
  }
}

class KotakSurveiPesanan extends StatelessWidget {
  KotakSurveiPesanan({
    super.key,
    required this.surveiData,
    // required this.constraints,
    required this.isSmall,
  });
  SurveiData surveiData;
  // BoxConstraints constraints;
  bool isSmall;
  DecorationImage gambarKlasik = const DecorationImage(
    image: AssetImage('assets/logo-klasik.png'),
    fit: BoxFit.fill,
  );

  DecorationImage gambarKartu = const DecorationImage(
    image: AssetImage('assets/logo-kartu.png'),
    fit: BoxFit.fill,
  );

  Widget generateFoto() {
    if (surveiData.gambarSurvei == "") {
      return Container(
        height: 80,
        width: 100,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2.75,
            color:
                (surveiData.isKlasik) ? Colors.redAccent : Colors.greenAccent,
          ),
          image: (surveiData.isKlasik) ? gambarKlasik : gambarKartu,
        ),
      );
    } else {
      return Container(
        height: 80,
        width: 100,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2.75,
            color: Colors.black,
          ),
        ),
        child: GambarSurveiKartu(urlGamabr: surveiData.gambarSurvei),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 10),
      // height: 100,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 247, 247),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: Colors.black,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                surveiData.judul,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              if (!isSmall)
                Text(
                  CurrencyFormat.convertToIdr(surveiData.harga, 2),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                )
            ],
          ),
          Row(
            children: [
              // Container(
              //   height: 80,
              //   width: 100,
              //   margin: const EdgeInsets.symmetric(vertical: 10),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       width: 2.75,
              //       color: (surveiData.isKlasik)
              //           ? Colors.redAccent
              //           : Colors.greenAccent,
              //     ),
              //     image: (surveiData.isKlasik) ? gambarKlasik : gambarKartu,
              //   ),
              // ),
              generateFoto(),
              const SizedBox(width: 12),
              Container(
                height: 90,
                width: 265,
                child: Text(
                  surveiData.deskripsi,
                  // "sdjkhfsleufhdjsjefb;seoufbs; eofubwp;o fspoefhsepfuhspe fusefugsefigsefi sdfbse;oucvbsosdsdsdasdawdawdawd adawdawdefbesfib",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 15,
                      ),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          if (isSmall)
            Text(
              CurrencyFormat.convertToIdr(surveiData.harga, 2),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            )
        ],
      ),
    );
  }
}

class ContainerText extends StatelessWidget {
  ContainerText(
      {super.key,
      required this.textJudul,
      required this.text,
      required this.width});
  String textJudul;
  String text;
  double width;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7.5),
          child: Text(
            textJudul,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          // width: 250,
          width: width,
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

class KotakCart extends StatelessWidget {
  KotakCart({
    super.key,
    required this.isCentang,
    required this.onChanged,
    required this.data,
  });
  Function(bool?) onChanged;
  bool isCentang;
  SurveiData data;
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.judul,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
          Row(
            children: [
              Container(
                height: 80,
                width: 100,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2.75,
                    color:
                        (data.isKlasik) ? Colors.redAccent : Colors.greenAccent,
                  ),
                  image: (data.isKlasik) ? gambarKlasik : gambarKartu,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 90,
                width: 215,
                child: Text(
                  data.deskripsi,
                  // "sdjkhfsleufhdjsjefb;seoufbs; eofubwp;o fspoefhsepfuhspe fusefugsefigsefi sdfbse;oucvbsosdsdsdasdawdawdawd adawdawdefbesfib",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                ),
              ),
              Spacer(),
              Checkbox(
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                checkColor: Colors.green,
                value: isCentang,
                onChanged: onChanged,
              )
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Text(
            CurrencyFormat.convertToIdr(data.harga, 2),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          )
        ],
      ),
    );
  }
}

class KotakSamping extends StatelessWidget {
  KotakSamping({
    super.key,
    required this.marginKiri,
    required this.onPressed,
    required this.listSejarah,
  });
  double marginKiri;
  Function() onPressed;
  List<Widget> listSejarah;
  // List<Transaksi> listTrans;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: marginKiri),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 280,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Cek Pesanan Aktif",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                  ))),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 2, color: Colors.black),
            ),
            width: 375,
            height: 550,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Sejarah Transaksi",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: listSejarah,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class TidakAdaOrder extends StatelessWidget {
  const TidakAdaOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
          border: Border.all(width: 1.5),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tidak ada pesanan berlangsung",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.indigoAccent.shade100),
            child: Image.asset(
              'assets/no-trans.png',
              height: 220,
            ),
          ),
        ],
      ),
    );
  }
}

class KotakSejarah extends StatelessWidget {
  KotakSejarah({
    super.key,
    required this.hargaTotal,
    required this.invoice,
    required this.onPressed,
    required this.tanggal,
  });
  String invoice;
  String tanggal;
  int hargaTotal;
  Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                invoice,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton.filled(onPressed: onPressed, icon: Icon(Icons.search)),
            ],
          ),
          Text(
            tanggal,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            CurrencyFormat.convertToIdr(hargaTotal, 2),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
